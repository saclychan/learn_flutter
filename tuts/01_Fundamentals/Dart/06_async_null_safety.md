# Bài 6: Bất đồng bộ (Async) & An toàn Null (Null Safety)

Đây là 2 kiến thức quan trọng bậc nhất. App Flutter liên tục phải lấy data từ Internet (tốn thời gian) và nếu không quản lý tốt giá trị Null (trống), app sẽ crash (màn hình đỏ).

## 1. Null Safety
Kể từ Dart 2.12, Dart áp dụng **Sound Null Safety**. Trình biên dịch mặc định hiểu rằng một biến KHÔNG THỂ có giá trị Null.
- Nếu cố tình gán null cho biến thông thường -> Báo lỗi ngay khi code.

### Khai báo biến có thể Null (Nullable)
Để báo cho Dart biết: "Biến này có thể rỗng đấy", ta thêm dấu `?` vào sau kiểu dữ liệu.
```dart
String name = 'Vader'; // Không bao giờ được phép null
String? nickname;      // Có thể là chuỗi, có thể null
```

### Xử lý biến Nullable
Để dùng biến `?`, bạn phải kiểm tra trước hoặc xử lý nó:
- **Toán tử `??` (Cung cấp giá trị mặc định)**
  ```dart
  String displayName = nickname ?? 'Unknown User'; 
  // Nếu nickname != null thì lấy nickname, nếu null thì lấy chuỗi sau ??
  ```
- **Toán tử `!` (Ép buộc - Bang operator)**
  Chỉ dùng khi bạn CHẮC CHẮN 100% nó không null. (Tránh lạm dụng).
  ```dart
  int length = nickname!.length; // Nếu nhỡ nickname null, app sẽ crash tại dòng này!
  ```

> 🧠 **Senior Detail - `late` keyword**: Đôi khi bạn muốn khai báo một biến không null, nhưng bạn chưa có giá trị để gán ngay (ví dụ đợi init trong initState của Flutter). Từ khóa `late` dặn compiler: "Cứ yên tâm, tôi hứa sẽ gán giá trị cho nó trước khi tôi gọi đến nó". Nếu bạn thất hứa (gọi nó trước khi gán), nó sẽ quăng lỗi `LateInitializationError` ở runtime.

## 2. Bất đồng bộ (Asynchronous Programming)
Gọi API cần thời gian. Nếu bắt ứng dụng chờ (đứng im), màn hình sẽ bị "đơ" (freeze). Bất đồng bộ giải quyết việc đó: "Anh cứ làm việc khác đi, khi nào tôi lấy xong data tôi sẽ báo".

### Future
`Future` đại diện cho một kết quả có thể xảy ra ở tương lai.
```dart
Future<String> fetchUserData() {
  // Giả lập việc gọi API mất 2 giây
  return Future.delayed(Duration(seconds: 2), () {
    return 'Dữ liệu User: Yoda';
  });
}
```

### async / await
Thay vì dùng hàm `.then()` truyền thống phức tạp, `async/await` giúp code bất đồng bộ trông giống như code đồng bộ (tuần tự).
```dart
// Thêm chữ async vào cuối khai báo hàm
void showUser() async {
  print('1. Bắt đầu lấy data...');
  
  // Dùng await để đợi Future trả kết quả. Dòng lệnh ở dưới sẽ không chạy cho đến khi data về.
  String data = await fetchUserData(); 
  
  print('2. Xong: $data');
}
```

> 💡 **Fun Fact - Event Loop**: Dart chạy trên duy nhất 1 luồng (Single Thread). Vậy sao nó làm được nhiều việc cùng lúc? Nó dùng Event Loop. Có 2 hàng đợi: **Microtask Queue** và **Event Queue**. Microtask được ưu tiên cực độ. `Future` chạy trên Event Queue, nghĩa là nó nhường đường cho các tác vụ vẽ UI quan trọng chạy trước, giữ cho app mượt 60fps!

> 🧠 **Senior Detail - Tối ưu hóa với `Future.wait`**: Nếu bạn có 3 API cần gọi (ví dụ lấy Profile, lấy Settings, lấy Friends) và chúng KHÔNG phụ thuộc vào nhau. Đừng `await` từng cái một (sẽ cộng dồn thời gian chờ). Hãy dùng `Future.wait` để gọi chúng song song!
```dart
// Thay vì mất 6 giây:
// var p = await getProfile(); // mất 2s
// var s = await getSettings(); // mất 2s
// var f = await getFriends(); // mất 2s

// Hãy chạy song song, chỉ mất 2 giây tổng cộng:
var results = await Future.wait([getProfile(), getSettings(), getFriends()]);
```

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Quên `await` khi gọi API (Lỗi kinh điển):** Gọi hàm trả về `Future` mà quên `await`, kết quả là bạn nhận được một hộp quà (Future) chứ không phải món đồ bên trong (Data). UI sẽ hiện lỗi kiểu báo không tương thích hoặc trắng xóa. **Cách phòng tránh:** Luôn rà soát cẩn thận các hàm có chữ `async`. Nếu thấy gọi API, phải có `await` đằng trước.
- **Vung vẩy "Búa tạ" (Toán tử `!`):** Thấy báo lỗi Null Safety, Junior thường "tiện tay" ném dấu `!` vào để ép compiler im lặng. Đây là mầm mống của thảm họa `NullThrownError` lúc app đang chạy. **Cách phòng tránh:** Chỉ dùng `!` khi 100% tự tin biến không thể null. Luôn ưu tiên dùng `??` hoặc `if (var != null)` để xử lý luồng an toàn.
- **Nghẽn cổ chai API:** Gọi tuần tự 3 API mất 3x thời gian, thay vì dùng `Future.wait` để chạy song song. **Cách phòng tránh:** Nhận diện các task bất đồng bộ không phụ thuộc lẫn nhau, và gộp chúng vào `Future.wait`.

---
### 🚀 Mini Pet Project: Mô phỏng Gọi API Thời tiết (Weather API Mock)

App nào cũng phải gọi API. Ở bài này, bạn sẽ giả lập quá trình lấy dữ liệu từ máy chủ mạng!

**Yêu cầu:**
1. Tạo file `weather_api.dart`.
2. Khai báo một model `Weather` với biến `cityName` (bắt buộc) và `temperature` (có thể null `?` trong trường hợp sensor hỏng).
3. Viết 2 hàm bất đồng bộ: `fetchWeatherHanoi()` và `fetchWeatherSaigon()`. Cả 2 đều dùng `Future.delayed` (khoảng 2-3 giây) để mô phỏng mạng chậm, sau đó trả về object `Weather`.
4. Trong hàm `main() async`, không dùng `await` tuần tự, mà hãy dùng `Future.wait()` để lấy dữ liệu thời tiết của cả 2 thành phố cùng MỘT LÚC!
5. In kết quả ra màn hình. Nếu `temperature` bị null, hãy dùng toán tử `??` để in ra "Không có dữ liệu nhiệt độ".

> 🔗 **Tài liệu tham khảo (Ref Docs):** 
> - [Dart Asynchrony Support (Future, async, await)](https://dart.dev/language/async)
> - [Dart Sound Null Safety](https://dart.dev/null-safety)
> - [Dart Future.wait API reference](https://api.dart.dev/stable/dart-async/Future/wait.html)

*Hoàn thành xuất sắc bài này là bạn đã đủ trình độ thao tác API thực tế trong Flutter rồi đó. Chiến thôi!*
