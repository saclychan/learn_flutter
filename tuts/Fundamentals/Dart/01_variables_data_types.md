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
> ⚠️ **Junior Pitfalls (Vấp váp thường gặp)**: Các bạn mới chuyển từ Python hoặc JavaScript sang thường hay viết code gán biến hoặc `print` "lơ lửng" bên ngoài hàm. Ở Dart, nếu code thực thi không nằm trong (hoặc được gọi từ) hàm `main()`, nó sẽ báo lỗi ngay lập tức.

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

> ⚠️ **Junior Pitfalls (Vấp váp thường gặp)**: Rất nhiều bạn mới học thường lạm dụng `dynamic` hoặc `var` vô tội vạ. Hãy nhớ: Code của bạn sẽ được người khác (hoặc chính bạn sau 3 tháng) đọc lại. Dùng `final` hoặc định nghĩa rõ kiểu (như `String`, `int`) ngay từ đầu sẽ cứu bạn khỏi hàng tá lỗi "không hiểu tại sao crash" lúc ứng dụng đang chạy.

---
### 🛠 Bài tập cho bạn (Typing & Trải nghiệm)

> 💡 **Fun Fact - Cách chạy code**: Dart đi kèm với công cụ CLI rất mạnh. Bạn không cần setup IDE phức tạp để test logic. Chỉ cần mở terminal và gõ `dart lesson1.dart`, code sẽ chạy ngay lập tức!

1. Hãy tạo một file `lesson1.dart` trên máy của bạn (hoặc dùng [DartPad](https://dartpad.dev)).
2. Tạo các biến giới thiệu về bản thân (Tên, tuổi, sở thích dưới dạng List).
3. In ra console một chuỗi giới thiệu sử dụng String Interpolation.
4. Thử thay đổi giá trị của một biến `final` xem trình biên dịch báo lỗi gì.

*Khi bạn gõ xong và thử nghiệm, hãy gửi code hoặc mô tả trải nghiệm để mình review nhé!*
