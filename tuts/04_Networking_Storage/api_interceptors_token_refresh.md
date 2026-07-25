# Bài 2: Networking Nâng cao (API Interceptors & Token Refresh)

Một Senior Developer không bao giờ gọi API trực tiếp bằng `http.get` một cách lỏng lẻo. Họ xây dựng một hệ thống mạng (Networking layer) mạnh mẽ, tự động gắn token, tự động bắt lỗi và quan trọng nhất là tự động làm mới token (Refresh Token) khi hết hạn.

## 1. Sử dụng thư viện Dio
Mặc dù `http` cơ bản, nhưng `dio` là chân ái của Senior Flutter. Nó hỗ trợ Interceptor, form-data, cancel request cực kỳ tốt.

## 2. API Interceptor là gì?
Interceptor (Kẻ đánh chặn) đứng ở giữa Client (App của bạn) và Server. 
- **Request Interceptor**: Can thiệp trước khi gửi API (VD: Gắn thêm `Authorization: Bearer <token>`).
- **Response Interceptor**: Can thiệp trước khi trả kết quả về cho UI (VD: Log data để debug).
- **Error Interceptor**: Can thiệp khi API lỗi (VD: Báo lỗi "Mất mạng" hoặc xử lý Refresh Token).

## 3. Code Senior: Xử lý Refresh Token tự động
Đây là bài toán kinh điển: Token hết hạn (Lỗi 401). App không được phép văng ra màn hình Login bắt user đăng nhập lại. Nó phải âm thầm gọi API Refresh Token, lấy token mới, rồi chạy lại cái API vừa bị lỗi!

```dart
import 'package:dio/dio.dio';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorage storage; // Nơi lưu token an toàn

  AuthInterceptor(this.dio, this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Tự động lấy token từ bộ nhớ và gắn vào Header
    final token = await storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options); // Tiếp tục gửi request
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Bắt lỗi 401 Unauthorized
    if (err.response?.statusCode == 401) {
      // Bắt đầu quá trình refresh token
      final refreshToken = await storage.getRefreshToken();
      
      try {
        // Gọi API cấp lại token (Dùng một instance dio khác để tránh loop)
        final response = await Dio().post(
          'https://api.example.com/refresh',
          data: {'refreshToken': refreshToken},
        );
        
        final newAccessToken = response.data['accessToken'];
        await storage.saveAccessToken(newAccessToken);
        
        // Cập nhật lại request cũ với token mới
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        
        // Gửi lại request vừa bị fail!
        final cloneReq = await dio.fetch(err.requestOptions);
        return handler.resolve(cloneReq); // Trả về kết quả thành công cho UI như chưa hề có cuộc chia ly
        
      } catch (e) {
        // Refresh token cũng hết hạn -> Bắt user đăng nhập lại
        await storage.clearAll();
        // Bắn event để đẩy ra màn hình Login
      }
    }
    
    return handler.next(err);
  }
}
```

## 4. Xử lý Json an toàn
Đừng bao giờ parse JSON bằng tay kiểu `data['user']['name']`. Nếu `user` bị null, app sẽ crash ngay.
Sử dụng **Freezed** và **JsonSerializable** để tự động sinh code model an toàn.

```dart
@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    @Default('') String avatar, // Giá trị mặc định nếu null
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Nhồi nhét API Call vào UI:** Chuyện gì xảy ra nếu bạn gọi `http.get` ngay trong hàm `onPressed` của Button? Bạn đang phá vỡ Clean Architecture. UI chỉ nên làm nhiệm vụ "Hiển thị", còn gọi API phải nằm ở lớp `Repository`. **Cách phòng tránh:** Trừu tượng hóa API thành các Repository và gọi chúng thông qua State Management (như Riverpod Notifier).
- **Bắt lỗi theo cảm tính:** Dùng `try-catch` bọc quanh hàm gọi API, nhưng trong `catch` chỉ biết in ra `print(e)`. Người dùng bị lỗi mà màn hình vẫn đứng im. **Cách phòng tránh:** Error Interceptor phải quy chuẩn hóa lỗi (VD: `NetworkException`, `ServerException`) và đẩy một thông báo rõ ràng lên cho State Management báo UI hiển thị Toast/Dialog.
- **Lưu Token ở SharedPreferences:** SharedPreferences không được mã hóa. Lấy máy root cắm vào máy tính là đọc được hết token. **Cách phòng tránh:** LUÔN LUÔN dùng `flutter_secure_storage` để lưu Token/Password.

---
---
### 🚀 Mini Pet Project: Hệ thống Mock Token Refresh (Dio Interceptor)

**Yêu cầu:**
1. Tạo một instance `Dio`. Gắn vào nó một `LogInterceptor` (có sẵn) để in log request ra console.
2. Viết một class `AuthInterceptor extends Interceptor`. Bắt lỗi 401 ở `onError`.
3. Khi gặp lỗi 401, hãy in ra màn hình "Đang refresh token...", dùng `Future.delayed(1s)` để giả lập lấy token mới, sau đó in ra "Đã lấy token mới thành công, gửi lại request cũ!".
4. Viết code test: Gọi một cái fake API ném thẳng status code 401 và xem console log hoạt động mượt mà không.

> 🔗 **Tài liệu tham khảo (Ref Docs):**
> - [Dio Interceptors Documentation](https://pub.dev/packages/dio#interceptors)
> - [Freezed Package (Safe JSON Model)](https://pub.dev/packages/freezed)

*Cái logic Refresh Token này đi phỏng vấn 10 công ty thì 9 công ty sẽ hỏi bạn đấy! Hãy luyện kỹ nhé.*
