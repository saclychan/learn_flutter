# Bài 3: Hàm (Functions) - Trái tim của Logic

Trong Dart, Functions là "công dân hạng nhất" (First-class citizens). Điều này có nghĩa là bạn có thể gán hàm cho một biến, truyền hàm vào làm tham số cho hàm khác, hoặc trả về một hàm từ một hàm khác.

## 1. Khai báo Hàm cơ bản
Một hàm bao gồm: `Kiểu_trả_về tên_hàm(các_tham_số) { logic }`.
```dart
int calculateForce(int mass, int acceleration) {
  return mass * acceleration;
}
```
*Lưu ý: Nếu không định nghĩa kiểu trả về, Dart sẽ ngầm định là `dynamic`. Nhưng tốt nhất hãy luôn viết rõ kiểu trả về để code an toàn hơn.*

## 2. Arrow Function (Hàm mũi tên)
Nếu hàm của bạn chỉ có **DUY NHẤT một dòng code**, hãy dùng `=>` cho gọn.
```dart
// Thay vì viết thế này:
bool isJedi(String name) {
  return name == 'Luke';
}

// Hãy viết thế này:
bool isSith(String name) => name == 'Vader';
```

## 3. Các loại Tham số (Parameters)
Đây là phần tinh túy nhất của Dart khi viết UI Flutter.

### a. Positional Parameters (Tham số theo vị trí)
Cách truyền thống. Vị trí tham số quyết định giá trị của nó.
```dart
void attack(String weapon, int damage) { ... }
attack('Lightsaber', 100); 
```

### b. Named Parameters (Tham số được đặt tên) - Rất quan trọng!
Bọc các tham số bằng ngoặc nhọn `{}`. Khi gọi hàm, bạn phải gọi tên của chúng. Nó giúp code cực kỳ dễ đọc khi hàm có nhiều tham số. Mặc định Named Parameters là tham số tùy chọn (có thể null).
> 💡 **So sánh**: Positional Parameters bắt buộc bạn phải nhớ THỨ TỰ truyền vào. Named Parameters cho phép truyền KHÔNG CẦN THỨ TỰ vì đã gọi đích danh, cực kỳ an toàn!
```dart
void buildDroid({String? name, int? memory}) {
  print('Building $name with $memory GB');
}

buildDroid(memory: 512, name: 'R2-D2'); // Không cần nhớ thứ tự!
```

> 🧠 **Senior Detail**: Nếu một Named parameter là bắt buộc, hãy dùng từ khóa `required`. Điều này ngăn chặn việc dev khác gọi hàm mà quên truyền biến quan trọng.
```dart
void createPlanet({required String name, int size = 1000}) { ... }
// createPlanet(); // BÁO LỖI: Thiếu name!
```

## 4. Anonymous Functions (Hàm ẩn danh / Closures)
Là hàm không có tên. Rất hay dùng để truyền vào List, Map hoặc các widget sự kiện trong Flutter (như `onPressed`).
```dart
List<String> ships = ['X-Wing', 'Tie Fighter', 'Falcon'];

// Tham số truyền vào .forEach() chính là một Anonymous function
ships.forEach((ship) {
  print('Flying $ship');
});
```

> 💡 **Fun Fact**: [Dart Lexically Scoped](03_1_closure_scope.md), nghĩa là phạm vi biến tĩnh (tính từ vị trí viết code). Một Closure có thể "nhớ" và sử dụng các biến ở phạm vi bên ngoài nó ngay cả khi hàm bên ngoài đã chạy xong! (Rất lợi hại trong các callback bất đồng bộ).

> 🧠 **Senior Detail - Tear-offs**: Thay vì viết một hàm ẩn danh chỉ để gọi một hàm khác có cùng tham số, bạn có thể truyền thẳng tên hàm! Cách này gọi là Tear-off. Nó giúp code gọn gàng và trông vô cùng chuyên nghiệp.
```dart
// Cách thông thường (Hơi dài dòng):
ships.forEach((ship) => print(ship));

// Cách Senior viết (Tear-off):
ships.forEach(print); // Truyền hàm print trực tiếp!
```

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Quên ngoặc `{}` với Named Parameters:** Khi gọi hàm có tham số được đặt tên, nhiều bạn quên truyền tên tham số và truyền luôn giá trị, khiến trình biên dịch chửi bới. **Cách phòng tránh:** Luôn nhớ dấu hiệu nhận biết Named Parameter là tên biến đi kèm dấu `:` (vd: `name: 'Yoda'`).
  ```dart
  // ❌ SAI: Quên gọi đích danh
  void login({required String email}) {}
  login('luke@jedi.com'); // Lỗi cú pháp
  
  // ✅ ĐÚNG:
  login(email: 'luke@jedi.com');
  ```
- **Hàm ôm đồm quá nhiều việc (God Function):** Đây là căn bệnh trầm kha. Hàm vừa fetch API, vừa xử lý logic, vừa update UI... Code phình to hàng trăm dòng, rất dễ sinh bug. **Cách phòng tránh:** Áp dụng nguyên tắc Single Responsibility (Đơn trách nhiệm). Một hàm chỉ làm ĐÚNG 1 việc. Nếu hàm quá 30 dòng, hãy cân nhắc tách nó ra.
  ```dart
  // ❌ SAI: Hàm làm 3 việc
  void processData() {
    // 1. Fetch API
    // 2. Format JSON
    // 3. Update DB
  }
  ```
- **Truyền quá nhiều tham số:** Một hàm nhận tới 5-6 tham số là một "red flag" (dấu hiệu code bốc mùi). **Cách phòng tránh:** Bọc các tham số đó vào một Class riêng.
  ```dart
  // ❌ SAI: Tham số dài dằng dặc
  void register(String name, int age, String email, String phone) {}
  
  // ✅ ĐÚNG: Bọc vào Object
  class RegisterData {
    String name; int age; String email; String phone;
    RegisterData(this.name, this.age, this.email, this.phone);
  }
  void register(RegisterData data) {}
  ```

## 🛡️ Lời khuyên từ Dart/Google Style Guide
- Luôn ưu tiên dùng **Arrow Function `=>`** cho các hàm chỉ có MỘT CÂU LỆNH duy nhất.
- Luôn ghi rõ kiểu dữ liệu trả về của hàm (kể cả `void`).
- Đặt tên hàm theo quy tắc `lowerCamelCase` và phải là một Cụm Động Từ (Verb phrase), ví dụ: `calculateTotal`, `fetchData`.

---
### 🐛 Thử Thách Gỡ Lỗi (Intentional Bugs)

> 💡 **Tình huống:** Hàm tính lương dưới đây được thiết kế cho nhân viên, nhưng do truyền sai thứ tự tham số Positional, giám đốc bị tính nhầm lương thành 5 ngàn đồng còn nhân viên lao công thì lãnh 50 triệu! Chạy thử file `buggy_functions.dart` và sửa lỗi.

```dart
// Bug 1: Hàm này quên không ghi kiểu trả về
calculateSalary(int baseSalary, int bonus, int tax) {
  // Bug 2: Quên return
  baseSalary + bonus - tax;
}

void main() {
  // Lỗi truyền nhầm thứ tự nhưng trình biên dịch không hề báo lỗi!
  int salary = calculateSalary(5000, 50000000, 0); 
  print('Lương của bạn là: $salary');
}
```
**Gợi ý sửa lỗi:**
1. Hãy sửa đổi hàm `calculateSalary` để sử dụng **Named Parameters** (bọc trong `{}`) và thêm từ khóa `required`. Điều này sẽ ngăn chặn vĩnh viễn lỗi truyền sai thứ tự! (💡 *So sánh: Named Parameter an toàn hơn Positional Parameter khi hàm có nhiều hơn 2 tham số*).
2. Bổ sung từ khóa `int` vào trước tên hàm và từ khóa `return` vào trong hàm. Hoặc gộp lại thành Arrow function `=>`.

---
### 🚀 Mini Pet Project: Máy tính BMI thông minh (Smart BMI Calculator)

Viết một chương trình nhỏ chuyên tính toán và đánh giá chỉ số khối cơ thể (BMI).

**Yêu cầu:**
1. Tạo file `bmi_calculator.dart`.
2. Viết một hàm `calculateBMI` nhận vào chiều cao (m) và cân nặng (kg) dạng Named Parameters (`required`). Hàm này trả về số `double`.
3. Viết một hàm khác tên là `evaluateBMI` nhận vào kết quả BMI, dùng Arrow Function `=>` kết hợp với toán tử 3 ngôi (hoặc if-else) để trả về chuỗi đánh giá: "Thiếu cân", "Bình thường", "Thừa cân".
4. Trong hàm `main()`, tạo một List chứa thông tin của 3 người (dùng Map). Dùng vòng lặp `.forEach()` (hoặc Tear-off nếu có thể) để gọi hàm tính toán và in kết quả ra màn hình cho từng người.

> 🔗 **Tài liệu tham khảo (Ref Docs):** 
> - [Dart Functions Official Docs](https://dart.dev/language/functions)
> - [Dart Anonymous functions & Tear-offs](https://dart.dev/language/functions#anonymous-functions)
> 
> 🎓 **Bài giải mẫu (Sample Solution):**
> Nếu bạn bí ý tưởng hoặc muốn xem code chuẩn Senior viết như thế nào, hãy tham khảo [bmi_calculator.sample.dart](../../../../pets/tuts/01_Fundamentals/Dart/03_functions.md/bmi_calculator.sample.dart).

*Tính năng này cực kỳ sát với thực tế khi bạn làm các App sức khỏe. Bắt tay vào làm thôi!*
