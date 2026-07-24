# Bài 5: Lập trình Hướng đối tượng - Nâng cao (Inheritance, Mixins, Interfaces)

Khả năng tái sử dụng code là mấu chốt để dự án scale (mở rộng). Dart cung cấp 3 công cụ sắc bén: Kế thừa, Interface, và Mixin.

## 1. Kế thừa (Inheritance - `extends`)
Cho phép một Class con hưởng mọi đặc tính của Class cha.
- Dùng từ khóa `extends`.
- Một Class con chỉ có thể extends **MỘT** Class cha duy nhất (Đơn kế thừa).

```dart
class Character {
  String name;
  Character(this.name);
  
  void speak() => print('Hello, I am $name');
}

class Sith extends Character {
  // Gọi constructor của lớp cha thông qua super
  Sith(String name) : super(name);

  // Ghi đè phương thức của lớp cha
  @override
  void speak() {
    print('Join the Dark Side, $name commands you.');
  }
}
```

## 2. Giao diện (Interfaces - `implements`)
Khi bạn muốn bắt buộc một class phải có những hàm/thuộc tính cụ thể nào đó (như một bản hợp đồng), bạn dùng interface.
> 💡 **Fun Fact**: Dart **không có từ khóa `interface`**! Mọi `class` trong Dart đều ẩn chứa một interface bên trong. Bạn có thể `implements` bất kỳ class nào!

- Khi `implements`, bạn phải viết lại **toàn bộ** các thuộc tính và hàm của class bị implements.
- Một class có thể implements **NHIỀU** class cùng lúc.

```dart
abstract class Flyable {
  void fly();
}

abstract class Swimmable {
  void swim();
}

class Duck implements Flyable, Swimmable {
  @override
  void fly() => print('Duck is flying');

  @override
  void swim() => print('Duck is swimming');
}
```

## 3. Mixins (`with`) - "Cây đũa phép" của Dart
Đây là tính năng senior dev dùng liên tục trong Flutter (VD: `SingleTickerProviderStateMixin` dùng làm Animation).
- Mixin cho phép bạn chia sẻ, "cắm" thêm tính năng vào các class khác nhau mà không cần cấu trúc phân cấp (kế thừa) lằng nhằng.
- Khắc phục nhược điểm "không thể đa kế thừa" của `extends`.

```dart
mixin Agility {
  int speed = 100;
  void runFast() {
    print('Running at speed $speed!');
  }
}

mixin Strength {
  void punch() => print('Punching hard!');
}

// Lớp Ninja kế thừa Character, đồng thời "mix" thêm Agility và Strength
class Ninja extends Character with Agility, Strength {
  Ninja(String name) : super(name);
}

void main() {
  var ninja = Ninja('Naruto');
  ninja.runFast(); // Kế thừa từ mixin Agility
  ninja.punch();   // Kế thừa từ mixin Strength
}
```

> 🧠 **Senior Detail - Diamond Problem**: Điều gì xảy ra nếu cả 2 mixin `Agility` và `Strength` đều có hàm tên là `action()`? Dart xử lý bằng **Linearization (tuyến tính hóa)**. Mixin được khai báo **sau cùng** (bên phải nhất) sẽ ghi đè lên các mixin trước đó. Ở ví dụ trên, hàm của `Strength` sẽ ghi đè `Agility` nếu chúng trùng tên.

---
### 🛠 Bài tập cho bạn
1. Viết một `abstract class Vehicle` có hàm `startEngine()`.
2. Tạo 2 mixin `ElectricMotor` và `PetrolMotor`, mỗi cái in ra một câu lệnh khởi động khác nhau.
3. Tạo class `Tesla` extends `Vehicle` và implements/with sao cho hợp lý.
4. Thử đặt 2 hàm cùng tên trong 2 mixin, rồi gán cho `Tesla` bằng từ khóa `with`, sau đó gọi hàm xem hàm của mixin nào chạy để tự kiểm chứng Linearization.
