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

> 💡 **Fun Fact**: Dart Lexically Scoped, nghĩa là phạm vi biến tĩnh (tính từ vị trí viết code). Một Closure có thể "nhớ" và sử dụng các biến ở phạm vi bên ngoài nó ngay cả khi hàm bên ngoài đã chạy xong! (Rất lợi hại trong các callback bất đồng bộ).

---
### 🛠 Bài tập cho bạn
1. Viết một hàm `calculateBMI` nhận vào chiều cao và cân nặng dạng Named Parameters (`required`), trả về số `double`.
2. Viết một Arrow function nhận vào số nguyên và trả về `true` nếu là số chẵn.
3. Tạo một List các số nguyên. Dùng `.map()` kết hợp với Anonymous function để nhân đôi tất cả các số trong mảng và in ra.

*Tự code lại các loại function này để tay quen với cú pháp ngoặc nhọn `{}` nhé. Sẽ dùng cực nhiều trong Flutter!*
