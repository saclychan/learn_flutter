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
> 💡 **So sánh:** Dùng `extends` khi class B thực sự LÀ class A. Dùng `implements` khi class B HỨA sẽ làm những việc class A bắt buộc. Dùng `with` (Mixin) khi class B CHỈ MUỐN XÀI CHUNG HÀM của class A mà không muốn mang quan hệ cha - con.
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

## 4. Extension Methods (Mở rộng phương thức)
> 💡 **Fun Fact & Senior Trick**: Nếu bạn muốn thêm một hàm vào class `String` hoặc `int` của hệ thống thì sao? Bạn không thể sửa mã nguồn của Dart, nhưng bạn có thể dùng `extension`!
```dart
extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
}

void main() {
  print('vader'.toCapitalized()); // In ra: Vader
}
```
Các senior dev dùng Extension Methods rất nhiều để format chuỗi, ngày tháng, hay tùy biến giao diện mà không phải viết những file `Utils` cồng kềnh.

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Lạm dụng kế thừa (Over-Inheritance):** Dấu hiệu của newbie là cố gắng ép mọi thứ vào cấu trúc kế thừa (Class A extends B extends C). Hậu quả là tạo ra một "gia phả" class khổng lồ, rối rắm, khi sửa class cha thì toàn bộ class con "vỡ trận". **Cách phòng tránh:** Ghi nhớ quy tắc vàng "Favor Composition over Inheritance". Dùng Interface và Mixin để chia sẻ hành vi thay vì bó buộc vào cây kế thừa.
  ```dart
  // ❌ SAI: Ép kế thừa khiên cưỡng
  class Bird extends Animal {}
  class Duck extends Bird {} // Nếu Bird thay đổi, Duck lãnh đủ
  
  // ✅ ĐÚNG: Mixin (Lắp ráp năng lực)
  class Duck extends Animal with Flyable, Swimmable {}
  ```
- **Hiểu lầm về Interface:** Dart không có từ khóa `interface`, khiến nhiều bạn lúng túng khi muốn định nghĩa một "hợp đồng". Đừng quên rằng `implements` có thể dùng với bất kỳ class nào.
- **Hoang mang khi bị trùng tên hàm với Mixin:** Khi mixin nhiều tính năng (Diamond Problem), bạn dễ bối rối không biết hàm nào sẽ chạy. **Cách phòng tránh:** Luôn nhớ quy tắc Linearization của Dart: Thằng nào đứng cuối cùng bên phải từ khóa `with` sẽ nắm quyền ưu tiên cao nhất.

## 🛡️ Lời khuyên từ Dart/Google Style Guide
- Ưu tiên dùng `mixin` thay vì `extends` nhiều tầng phức tạp nếu bạn chỉ muốn chia sẻ code.
- Dùng `implements` khi bạn thực sự muốn tạo ra một Interface bắt buộc phải tuân thủ.
- Luôn đặt tên mixin giống như một Tính từ (Adjective) hoặc Hành vi (vd: `Flyable`, `Movable`) thay vì một Danh từ.

---
### 🐛 Thử Thách Gỡ Lỗi (Intentional Bugs)

> 💡 **Tình huống:** Một bạn Junior cố gắng tạo ra lớp `Bat` (Con Dơi) vừa là chim (biết bay) vừa là thú (có vú). Do hiểu sai về kế thừa nên đã gây ra lỗi "Đa kế thừa" (Multiple Inheritance) bị trình biên dịch cấm cản. Chạy thử file `buggy_mixin.dart` và áp dụng Mixin để sửa lỗi.

```dart
class Bird {
  void fly() => print('Flying');
}

class Mammal {
  void feedMilk() => print('Feeding milk');
}

// Bug: Dart KHÔNG hỗ trợ đa kế thừa bằng dấu phẩy!
class Bat extends Bird, Mammal {
  
}

void main() {
  var batman = Bat();
  batman.fly();
  batman.feedMilk();
}
```
**Gợi ý sửa lỗi:**
1. Hãy đổi `class Bird` và `class Mammal` thành `mixin Bird` và `mixin Mammal`.
2. Cho lớp `Bat` kế thừa (extends) từ một lớp cha chung (vd: `class Animal`), sau đó nối thêm từ khóa `with Bird, Mammal`. (💡 *So sánh: Kế thừa `extends` giống như "Là một", còn `with` mixin giống như "Có khả năng"*).

---
### 🚀 Mini Pet Project: Hệ thống Nhà thông minh (Smart Home System)

Dùng sức mạnh của OOP Nâng cao để thiết kế các thiết bị điện tử trong nhà thông minh!

**Yêu cầu:**
1. Tạo file `smart_home.dart`.
2. Viết một `abstract class SmartDevice` có hàm bắt buộc `turnOn()` và `turnOff()`.
3. Tạo các Mixin: `WifiConnected` (có hàm `connectWifi()`), `BluetoothEnabled` (có hàm `pairBluetooth()`).
4. Khởi tạo 2 class: `SmartTV` và `SmartBulb` kế thừa từ `SmartDevice`.
5. Cho `SmartTV` "mix" thêm cả Wifi và Bluetooth, còn `SmartBulb` thì chỉ mix Bluetooth.
6. **Bonus Senior**: Tự viết một Extension Method cho class `String` có tên `toDeviceID()` để biến một tên chuỗi bất kỳ thành một mã ID viết hoa toàn bộ và có thêm đuôi `_DEV` (Vd: "tv" -> "TV_DEV").

> 🔗 **Tài liệu tham khảo (Ref Docs):** 
> - [Dart Mixins Official Docs](https://dart.dev/language/mixins)
> - [Dart Extension Methods](https://dart.dev/language/extension-methods)

*Bạn thấy đấy, Mixins sinh ra là để làm những trò này! Viết code và test xem nào!*
