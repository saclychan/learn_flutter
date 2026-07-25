# Bài 1: Biến và Các Kiểu Dữ Liệu Cơ Bản (Variables & Data Types)

Chào mừng bạn đến với bài học đầu tiên! Để làm chủ Dart và Flutter, chúng ta cần hiểu cách Dart lưu trữ và quản lý dữ liệu.

## 0. Hàm main() - Nơi bắt đầu tất cả
Trước khi đi vào cú pháp, bạn cần biết một quy tắc sống còn: Mọi chương trình Dart đều **bắt buộc** phải bắt đầu chạy từ một hàm có tên là `main()`. Nếu không có hàm này, trình biên dịch sẽ không biết ứng dụng của bạn bắt đầu từ đâu!

```dart
void main() {
  // Mọi dòng code thực thi của bạn sẽ được viết ở trong này
  print('Hello Dart!');
}
```

## 1. Khai báo biến
Trong Dart, bạn có nhiều cách để khai báo một biến.

### Khai báo rõ kiểu (Explicit Typing)
Bạn nói rõ cho trình biên dịch biết biến này chứa loại dữ liệu gì.
```dart
int age = 25;
String name = 'Darth Vader';
bool isSith = true;
```

### Suy luận kiểu (Type Inference)
Sử dụng từ khóa `var`, Dart sẽ tự đoán kiểu dữ liệu thông qua giá trị bạn gán cho nó.
```dart
var galaxy = 'Milky Way'; // Dart hiểu đây là String
// galaxy = 123; // LỖI! Vì galaxy đã được chốt là String.
```

## 2. final vs const (Hằng số)
Khi một giá trị không bao giờ thay đổi, hãy dùng `final` hoặc `const`.
- **`final`**: Được gán giá trị **một lần duy nhất** (có thể tính toán lúc runtime - khi chạy app).
- **`const`**: Là hằng số **thực sự** từ lúc viết code (compile-time constant).

```dart
final currentTime = DateTime.now(); // Hợp lệ vì giá trị được lấy lúc chạy.
// const compileTime = DateTime.now(); // LỖI! const yêu cầu giá trị phải biết trước khi chạy.
const double pi = 3.14159;
```
> 🧠 **Senior Detail**: Dùng `const` bất cứ khi nào có thể, vì nó giúp Flutter tối ưu hóa bộ nhớ và tăng FPS. Nếu một Widget là `const`, Flutter sẽ không bao giờ vẽ lại (rebuild) nó nếu không cần thiết.

## 3. Các kiểu dữ liệu cốt lõi
- **Numbers**: `int` (số nguyên), `double` (số thực). Cả hai đều kế thừa từ `num`.
  > 💡 **Fun Fact**: Trong Dart KHÔNG CÓ kiểu `float` như C++ hay Java. Mọi số thập phân đều được biểu diễn bằng `double` (chuẩn IEEE 754 64-bit) để đảm bảo độ chính xác cao nhất.
- **Strings**: Dùng nháy đơn `''` hoặc nháy kép `""`.
  *String Interpolation (Nối chuỗi)* cực xịn trong Dart:
  ```dart
  int darkSidePower = 1000;
  print('Your power level is $darkSidePower');
  print('Next level is ${darkSidePower * 2}');
  ```
- **Booleans**: `bool` (chỉ nhận `true` hoặc `false`).
- **Lists** (Mảng):
  ```dart
  List<String> jedi = ['Yoda', 'Obi-Wan', 'Luke'];
  // Cú pháp Spread operator cực hữu ích:
  List<String> moreJedi = ['Rey', ...jedi];
  ```
- **Maps** (Từ điển - Key/Value):
  ```dart
  Map<String, String> lightsaberColors = {
    'Vader': 'Red',
    'Luke': 'Green',
  };
  ```

## 4. dynamic vs Object
Nếu bạn thực sự không biết kiểu dữ liệu là gì (ví dụ nhận data từ API), bạn có thể dùng `dynamic`.
```dart
dynamic mysteriousVariable = 'I am a string';
mysteriousVariable = 42; // Hợp lệ, đổi thành số nguyên
mysteriousVariable.doSomethingCrazy(); // Code vẫn build được, nhưng sẽ sập lúc chạy!
```
> 💡 **Fun Fact**: `dynamic` tắt hoàn toàn kiểm tra kiểu (type checking). Còn nếu bạn dùng `Object?`, trình biên dịch vẫn bắt bạn ép kiểu trước khi gọi hàm. Senior dev rất "ghét" `dynamic` và hạn chế dùng tối đa để tránh runtime error.

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Ngộ nhận về khai báo biến:** Các bạn mới chuyển từ Python hoặc JavaScript sang thường hay viết code gán biến hoặc `print` "lơ lửng" bên ngoài hàm. Ở Dart, nếu code thực thi không nằm trong (hoặc được gọi từ) hàm `main()`, nó sẽ báo lỗi ngay lập tức. **Cách phòng tránh:** Luôn nhớ `main()` là trái tim của ứng dụng. Mọi logic thực thi đều bắt nguồn từ đây.
  ```dart
  // ❌ SAI: Code lơ lửng ngoài main()
  var name = 'Yoda';
  print(name); // Lỗi ngay lập tức!
  
  // ✅ ĐÚNG: Đặt vào main()
  void main() {
    var name = 'Yoda';
    print(name);
  }
  ```
- **Lạm dụng `dynamic` và `var` vô tội vạ:** Code chạy được là một chuyện, đọc hiểu và bảo trì lại là chuyện khác. Rất nhiều bạn cứ `var` hoặc `dynamic` khi gọi API vì lười định nghĩa kiểu. Sau 3 tháng đọc lại code, bạn sẽ không biết biến đó chứa data gì, có những thuộc tính nào. **Cách phòng tránh:** Khai báo rõ ràng kiểu dữ liệu (`String`, `int`, hoặc tự định nghĩa Class). Dùng `final` ngay từ đầu sẽ cứu bạn khỏi hàng tá lỗi "không hiểu tại sao crash".
  ```dart
  // ❌ SAI: Dùng dynamic bừa bãi
  dynamic userData = fetchApi(); 
  userData.sayHello(); // Không báo lỗi lúc code, nhưng crash lúc chạy
  
  // ✅ ĐÚNG: Định nghĩa rõ kiểu
  User userData = fetchApi();
  userData.sayHello(); // An toàn tuyệt đối, có gợi ý code
  ```

## 🛡️ Lời khuyên từ Dart/Google Style Guide
- Đặt tên biến, hàm theo quy tắc `lowerCamelCase` (VD: `myVariableName`).
- Tên Class dùng `UpperCamelCase` (VD: `MyClassName`).
- Không sử dụng `SCREAMING_CAPS` cho các biến `const` như Java/C. Ở Dart, biến const vẫn dùng `lowerCamelCase` (VD: `const pi = 3.14` thay vì `PI`).

---
### 🐛 Thử Thách Gỡ Lỗi (Intentional Bugs)

> 💡 **Tình huống:** Một bạn Junior vừa đẩy đoạn code sau lên GitHub. Code này chứa 3 lỗi nghiêm trọng. Nhiệm vụ của bạn là copy code này vào file `buggy_vars.dart`, chạy thử để thấy lỗi và tìm cách fix nó.

```dart
const currentTime = DateTime.now();
var username = 'Luke';

void main() {
  int age = 20;
  String message = "Hello " + username + ", next year you will be " + age;
  
  username = 123; // Chuyển đổi ID tạm thời
  
  print(message);
}
```
**Gợi ý sửa lỗi:**
1. Biến `currentTime` có lỗi gì với từ khóa `const`? (💡 *So sánh `const` và `final`*)
2. Có thể cộng thẳng String với int (`+ age`) được không? Hãy dùng String Interpolation `\${}`.
3. Biến `username` dùng `var` có gán lại thành số `123` được không?

---
### 🚀 Mini Pet Project: Hồ sơ Nhân vật RPG (RPG Character Profile)

Học phải đi đôi với hành! Đừng gõ mấy ví dụ `a`, `b`, `c` nhàm chán nữa, hãy viết một script tạo ra hồ sơ cho một nhân vật game nhập vai.

**Yêu cầu:**
1. Tạo file `rpg_profile.dart`.
2. Khai báo các biến lưu trữ thông tin: Tên (String), Tuổi (int), Chiều cao (double), Nghề nghiệp (String - dùng `final`), Các kỹ năng (List), Chỉ số sức mạnh (Map).
3. In ra console một bảng thông tin đẹp mắt sử dụng String Interpolation.

> 🔗 **Tài liệu tham khảo (Ref Docs):** 
> - [Dart Variables Official Docs](https://dart.dev/language/variables)
> - [Dart Built-in Types](https://dart.dev/language/built-in-types)

*Gợi ý: Mở terminal, chạy lệnh `dart rpg_profile.dart` để xem kết quả. Nếu bí, gửi code lên đây mình sẽ gợi ý (chứ không đưa giải pháp ngay đâu nha)!*
