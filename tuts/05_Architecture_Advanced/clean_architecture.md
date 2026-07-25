# Kiến Trúc Flutter: Từ Số 0 Đến Clean Architecture

## 1. Giới thiệu: Tại sao MVC lại "chết" ở Flutter?
Khi mới học lập trình, bạn có thể đã nghe rất nhiều về MVC (Model - View - Controller). Vậy tại sao trong Flutter, MVC lại hiếm khi được sử dụng?
Flutter là một framework **declarative UI**. Bạn không thể thay đổi UI bằng cách lấy tham chiếu của một widget và gọi method cập nhật trạng thái (giống như `textView.setText()` trong Android hay `document.getElementById` trong DOM). Thay vào đó, bạn phải rebuild lại toàn bộ widget tree với state mới.
MVC thường dựa vào Controller để điều khiển View, nhưng trong Flutter, View phản ứng lại State. Việc cố gắng ép MVC vào Flutter thường dẫn đến các Controller khổng lồ, logic dính chặt vào vòng đời của UI, khó test và khó bảo trì.

Thay vào đó, các kiến trúc dựa trên State Management (như BLoC, Riverpod, hay MVVM) ra đời. Tuy nhiên, khi dự án lớn lên, chỉ State Management là không đủ, chúng ta cần **Clean Architecture**.

### Tại sao Clean Architecture lại cần thiết nhưng lại "cồng kềnh"?
Clean Architecture chia app thành các layer (thường là Domain, Data, Presentation) độc lập với nhau, giao tiếp qua interface.
- **Cần thiết:** Giúp thay đổi Database, API hay State Management mà không ảnh hưởng tới Business Logic. Giúp code dễ test hơn bao giờ hết.
- **Cồng kềnh:** Để in ra một dòng chữ từ API, bạn phải tạo Model, Entity, Mapper, Repository Interface, Repository Implementation, UseCase, và State/BLoC. 

**Senior Detail:** Đừng dùng Clean Architecture cho các dự án nhỏ, prototype hay MVP có thời gian ngắn. Clean Architecture tỏa sáng khi bạn làm việc trong team lớn, dự án kéo dài nhiều năm, và logic nghiệp vụ phức tạp.

---

## 2. Lời khuyên Google/Dart Style Guide
> "Use `final` for variables that are not reassigned."
Trong Clean Architecture, các UseCase, Repository, và State của bạn luôn nên là immutable. Việc dùng `final` giúp tránh những bug do mutate state không kiểm soát được.
> "Do prefer starting function or method comments with third-person verbs." (VD: Returns the current user...)

---

## 3. Nỗi đau Junior: Code ❌ SAI và ✅ ĐÚNG

### Nỗi đau 1: Để Business Logic trong UI
**Ngộ nhận:** Newbie thường viết thẳng logic gọi API hoặc tính toán vào trong `onPressed` của button.
**Hậu quả:** Không thể tái sử dụng logic, UI giật lag khi xử lý nặng, không thể viết unit test.

❌ **SAI (Junior Pitfall):**
```dart
ElevatedButton(
  onPressed: () async {
    // Gọi API trực tiếp trong UI
    setState(() => isLoading = true);
    final response = await http.get(Uri.parse('https://api.example.com/user'));
    final user = User.fromJson(jsonDecode(response.body));
    if (user.age > 18) {
      // Business logic
      Navigator.pushNamed(context, '/home');
    }
    setState(() => isLoading = false);
  },
  child: Text('Login'),
)
```

✅ **ĐÚNG (Senior Way - Clean Architecture):**
Tách logic ra UseCase và gọi qua Presentation Layer (ví dụ BLoC).
```dart
// Domain Layer - UseCase
class LoginUseCase {
  final UserRepository repository;
  LoginUseCase(this.repository);

  Future<bool> execute(String token) async {
    final user = await repository.getUser(token);
    return user.age > 18; // Business logic cô lập, hoàn toàn testable
  }
}

// Presentation Layer
ElevatedButton(
  onPressed: () {
    context.read<LoginBloc>().add(LoginSubmittedEvent());
  },
  child: Text('Login'),
)
```

### Nỗi đau 2: Nhầm lẫn giữa Model và Entity
❌ **SAI:** Dùng chung Data Model (có chứa logic parse JSON) cho toàn bộ app, kể cả truyền vào UI.
✅ **ĐÚNG:** `Model` ở Data layer (parse JSON), `Entity` ở Domain layer (chỉ chứa data thuần, không biết JSON là gì). Dùng Mapper để chuyển đổi.

---

## 4. 🐛 Thử Thách Gỡ Lỗi (Debugging Challenge)

Dưới đây là một đoạn code Repository Implementation. Nó chạy được nhưng có một lỗi ngầm về thiết kế kiến trúc. Bạn hãy tìm và sửa nó!

```dart
// Data Layer
class UserRepositoryImpl implements UserRepository {
  final http.Client client;
  final SharedPreferences prefs;

  UserRepositoryImpl(this.client, this.prefs);

  @override
  Future<UserEntity> getUser() async {
    final response = await client.get(Uri.parse('https://api.com/user'));
    final userModel = UserModel.fromJson(response.body);
    
    // Ghi đè token thẳng vào DB ở đây?
    await prefs.setString('token', userModel.token); 
    
    return userModel.toEntity();
  }
}
```
**Gợi ý:** Repository nên có trách nhiệm gì? Việc lưu token nên nằm ở Repository hay ở UseCase quản lý luồng đăng nhập?

---

## 5. 🚀 System Design Challenge

**Yêu cầu:** Thiết kế sơ đồ (Flow) cho tính năng "Giỏ hàng offline-first" sử dụng Clean Architecture.
1. Khi có mạng: Lấy giỏ hàng từ API, lưu vào Local DB (SQflite/Hive).
2. Khi mất mạng: Lấy giỏ hàng từ Local DB.
3. Khi thêm vào giỏ offline: Lưu Local DB, đánh dấu cờ `sync = false`. Khi có mạng tự động sync lên Server.

Bạn sẽ chia các Model, Entity, UseCase như thế nào? Repository interface của bạn sẽ trông ra sao? Hãy code nháp thử file `CartRepository.dart` và `SyncCartUseCase.dart`!

---

## Tham khảo
- [ResoCoder Clean Architecture TDD](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
