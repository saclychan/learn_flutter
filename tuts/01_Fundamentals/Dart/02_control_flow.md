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

> 🧠 **Senior Detail - Collection `if` và Collection `for`**: Đây là "vũ khí bí mật" của Dart khiến việc viết UI Flutter cực kỳ sướng. Bạn có thể chèn `if` và `for` **TRỰC TIẾP** vào bên trong một khai báo List/Set/Map!
```dart
bool isPremium = true;
List<String> features = [
  'Basic Feature',
  if (isPremium) 'Pro Feature', // Không cần dấu {}
  for (var i = 1; i <= 3; i++) 'Bonus $i'
];
// Kết quả: ['Basic Feature', 'Pro Feature', 'Bonus 1', 'Bonus 2', 'Bonus 3']
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

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Vòng lặp vô tận (Infinite loop):** Lỗi kinh điển khi dùng `while` là quên cập nhật biến điều kiện bên trong vòng lặp, dẫn đến app treo cứng, nóng máy và crash do tràn bộ nhớ (Out of Memory). **Cách phòng tránh:** Luôn nhẩm lại logic tăng/giảm điều kiện trước khi chạy code vòng lặp.
- **Mê cung If-Else (Nested If-Else):** Junior thường lồng 3, 4 tầng `if-else` khiến code trông như một cái phễu khổng lồ (Arrow anti-pattern), cực kỳ khó đọc. **Cách phòng tránh:** Học cách **Early Return** (Return sớm). Kiểm tra trường hợp lỗi/ngoại lệ và `return` ngay lập tức, để luồng code chính trở nên "phẳng" (không bị thụt lề quá nhiều).
- **Ngộ nhận về `switch-case`:** Nhiều bạn nghĩ `switch` cũ kỹ và cồng kềnh. Ở Dart 3, `switch` đã trở thành một biểu thức vô cùng mạnh mẽ với Pattern Matching. Hãy cố gắng tận dụng nó để thay thế `if-else` dài dòng.

---
### 🚀 Mini Pet Project: Trò chơi Vòng quay Nga ngẫu nhiên (Russian Roulette / Dice Roller)

Ứng dụng vòng lặp và câu lệnh rẽ nhánh để làm một trò chơi mô phỏng đổ xúc xắc!

**Yêu cầu:**
1. Tạo file `dice_roller.dart`.
2. Sử dụng thư viện `math` của Dart (`import 'dart:math';`) để tạo một số ngẫu nhiên từ 1 đến 6.
3. Dùng vòng lặp `while` để mô phỏng việc người chơi đổ xúc xắc liên tục.
4. Nếu đổ ra số 6: In ra "🎉 Chúc mừng! Bạn đã quay trúng ô Jackpot!" và kết thúc vòng lặp (`break`).
5. Nếu ra số khác: Dùng `if-else` hoặc `switch` để in ra các câu an ủi khác nhau (VD: "Trượt rồi, thử lại nhé!") và tiếp tục lặp.

> 🔗 **Tài liệu tham khảo (Ref Docs):** 
> - [Dart Control Flow Official Docs](https://dart.dev/language/control-flow)
> - [StackOverflow: How to generate random numbers in Dart?](https://stackoverflow.com/questions/43441588/how-to-generate-a-random-number-in-dart)

*Tự code và chạy thử nhé. Bug ở đâu cứ réo mình!*
