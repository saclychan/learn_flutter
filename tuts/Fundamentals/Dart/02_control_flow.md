# Bài 2: Luồng điều khiển (Control Flow)

Để chương trình có thể "suy nghĩ" và "ra quyết định", chúng ta cần Control Flow.

## 1. if / else
Rất quen thuộc nếu bạn đã học bất kỳ ngôn ngữ nào.
```dart
int forceLevel = 8000;

if (forceLevel > 9000) {
  print("It's over 9000!");
} else if (forceLevel > 5000) {
  print("Strong, you are.");
} else {
  print("Much to learn, you still have.");
}
```

> 🧠 **Senior Detail - "if-case" (Từ Dart 3.0)**: Dart 3 giới thiệu Pattern Matching. Bạn có thể dùng `if` kết hợp với `case` để kiểm tra cấu trúc dữ liệu cực kỳ mạnh mẽ.
```dart
final json = {'user': 'Vader', 'role': 'Sith'};
if (json case {'role': 'Sith'}) {
  print('Welcome to the Dark Side');
}
```

## 2. Vòng lặp for
Dùng khi bạn biết trước số lần lặp.
```dart
// Vòng lặp truyền thống
for (int i = 0; i < 5; i++) {
  print('Đang lặp lần thứ $i');
}

// Vòng lặp for-in (RẤT hay dùng với List)
List<String> planets = ['Tatooine', 'Naboo', 'Coruscant'];
for (var planet in planets) {
  print('Du hành tới $planet');
}
```

## 3. Vòng lặp while & do-while
- `while`: Kiểm tra điều kiện trước, rồi mới chạy code.
- `do-while`: Chạy code ít nhất 1 lần, rồi mới kiểm tra điều kiện.

```dart
int stamina = 5;
while (stamina > 0) {
  print('Training... Stamina: $stamina');
  stamina--; // Trừ 1
}
```

## 4. switch / case
Khi có nhiều nhánh điều kiện phụ thuộc vào MỘT biến duy nhất. Từ Dart 3, `switch` đã trở nên cực kỳ bá đạo.
```dart
String rank = 'Master';

switch (rank) {
  case 'Padawan':
    print('Học việc');
    break;
  case 'Knight':
    print('Hiệp sĩ');
    break;
  case 'Master':
    print('Bậc thầy');
    break;
  default:
    print('Không rõ cấp bậc');
}
```

> 💡 **Fun Fact**: Trước Dart 3, bạn bắt buộc phải có `break;` ở mỗi case (nếu không sẽ báo lỗi). Nhưng từ Dart 3, Dart đã bỏ yêu cầu `break;` vì lỗi quên `break` gây ra quá nhiều đau thương. Hơn nữa, bạn có thể trả về giá trị trực tiếp từ switch (gọi là switch expression)!
```dart
// Switch Expression (Dart 3)
String status = switch (rank) {
  'Padawan' => 'Vẫn đang học',
  'Master' => 'Trùm cuối',
  _ => 'Unknown' // _ đại diện cho default
};
```

---
### 🛠 Bài tập cho bạn
1. Khai báo một List điểm số (số nguyên).
2. Dùng `for-in` để duyệt qua mảng, nếu điểm >= 8 in ra "Giỏi", >= 5 in ra "Khá", còn lại in ra "Yếu".
3. Dùng vòng lặp `while` để mô phỏng đếm ngược từ 10 về 0, khi bằng 0 in ra "Happy New Year!".
4. Thử tính năng Switch Expression của Dart 3 (nếu bạn đang dùng Dart >= 3.0).

*Thực hành và cảm nhận sự "mượt mà" của Dart nhé! Gõ xong đưa mình review.*
