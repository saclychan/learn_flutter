# Bài 4: Lập trình Hướng đối tượng - Cơ bản (OOP Basics)

Dart là ngôn ngữ thuần Hướng đối tượng. Trong Dart, mọi thứ đều là Object, kể cả số (`int`) hay chuỗi (`String`).

## 1. Class và Object
- **Class (Lớp):** Bản thiết kế, khuôn đúc.
- **Object (Đối tượng):** Sản phẩm thực tế được đúc ra từ khuôn đó.

```dart
class Spaceship {
  // Instance variables (Thuộc tính)
  String name;
  int fuel;

  // Constructor (Hàm khởi tạo)
  Spaceship(this.name, this.fuel);

  // Method (Phương thức)
  void fly() {
    print('$name is flying with $fuel fuel.');
  }
}

void main() {
  // Tạo object
  var falcon = Spaceship('Millennium Falcon', 100);
  falcon.fly();
}
```

> 🧠 **Senior Detail - Cascade Notation (`..`)**: Khi bạn muốn gọi nhiều hàm hoặc gán nhiều biến liên tiếp trên cùng MỘT object, hãy dùng toán tử `..`. Nó trả về chính object đó sau khi gọi hàm, giúp bạn tiết kiệm rất nhiều dòng code lặp lại tên biến.
```dart
// Cách thông thường:
var ship = Spaceship('X-Wing', 0);
ship.fuel = 50;
ship.fly();

// Cách Senior với Cascade:
var ship2 = Spaceship('X-Wing', 0)
  ..fuel = 50
  ..fly();
```


## 2. Constructors (Hàm khởi tạo)
Dart hỗ trợ nhiều loại Constructor thú vị hơn Java/C++.

### Named Constructors
Cho phép bạn tạo ra nhiều cách khác nhau để khởi tạo một Object.
```dart
class User {
  String name;
  String role;

  // Default constructor
  User(this.name, this.role);

  // Named constructor
  User.guest() : name = 'Guest', role = 'Viewer'; 
  // Dấu : gọi là Initializer List
}

var u1 = User('Vader', 'Admin');
var u2 = User.guest(); // Code siêu tự minh!
```

> 🧠 **Senior Detail - Initializer List (`:`)**: Tại sao lại có đoạn `: name = 'Guest'`? Trình biên dịch Dart yêu cầu các biến non-nullable (không được null) phải được khởi tạo giá trị *trước khi* khối lệnh `{}` của constructor chạy. Dùng Initializer List là cách duy nhất để setup giá trị cho các biến `final` khi khởi tạo.

### Factory Constructors
`factory` cho phép bạn viết logic bên trong constructor và tuỳ ý quyết định xem sẽ trả về instance (đối tượng) mới hay dùng lại đối tượng cũ (áp dụng mẫu thiết kế Singleton), hoặc trả về một lớp con.
> 💡 **So sánh:** Constructor thường mặc định LUÔN LUÔN đẻ ra một đối tượng hoàn toàn mới trên RAM. Còn `factory` constructor giống như một hàm bình thường, nó có quyền dùng từ khóa `return` để kiểm tra và trả về một object ĐÃ CÓ SẴN trên RAM.
```dart
class Logger {
  static final Logger _cache = Logger._internal(); // Biến static nội bộ
  
  // Factory sẽ không tạo object mới mà trả về cache cũ
  factory Logger() {
    return _cache;
  }
  
  // Named constructor bí mật
  Logger._internal(); 
}
```

## 3. Getters & Setters
Dùng để kiểm soát việc đọc/ghi thuộc tính, giúp bảo vệ dữ liệu (Encapsulation).
```dart
class Jedi {
  int _midiChlorianCount = 0; // Thêm dấu _ phía trước tên biến để biến nó thành private

  // Getter
  int get powerLevel => _midiChlorianCount * 10;

  // Setter
  set train(int hours) {
    if (hours < 0) throw Exception("Thời gian không được âm!");
    _midiChlorianCount += hours;
  }
}
```
> 💡 **Fun Fact**: Ở Dart, tính đóng gói (private) hoạt động ở cấp độ **thư viện (library/file)** chứ không phải cấp độ class! Tức là nếu 2 class viết chung trong 1 file `lesson4.dart`, chúng vẫn truy cập được biến `_private` của nhau. Phải tách file thì nó mới thực sự ẩn đi.

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Phơi bày mọi thứ (Thiếu Encapsulation):** Quên dùng dấu `_` để bảo vệ các biến nội bộ là một lỗi rất phổ biến. Hậu quả là các class khác thoải mái sửa đổi trạng thái của class hiện tại, gây ra những bug dữ liệu cực kỳ khó dò ("Ai đã đổi giá trị của biến này vậy?"). **Cách phòng tránh:** Luôn mặc định biến là private (`_`). Chỉ khi nào bên ngoài thực sự cần đọc/ghi, mới mở ra bằng Getter/Setter.
  ```dart
  // ❌ SAI: Phơi bày dữ liệu
  class Wallet {
    double money = 1000; 
  }
  
  // ✅ ĐÚNG: Đóng gói dữ liệu
  class Wallet {
    double _money = 1000;
    double get money => _money; // Chỉ cho đọc, cấm ghi đè
  }
  ```
- **Ngộ nhận Constructor:** Nhiều bạn nghĩ Constructor chỉ để khởi tạo giá trị. Thực tế với Dart, Factory Constructors còn giúp quản lý caching, trả về các instance đã tạo (Singleton), hoặc quyết định trả về subtype nào. Đừng bó hẹp tư duy Constructor = Khởi tạo biến.
- **Quên dùng Cascade (`..`):** Khởi tạo object và gọi liên tiếp 4-5 hàm của object đó bằng cách gõ tên biến nhiều lần (vd: `ship.fuel = 10; ship.color = 'red';`). Nó không sai nhưng nhìn rất "Junior". **Cách phòng tránh:** Tập thói quen dùng `..` để code mượt và ngắn gọn hơn.
  ```dart
  // ❌ SAI: Khởi tạo lặp lại tên biến
  var p = Player();
  p.name = 'Vader';
  p.hp = 100;
  
  // ✅ ĐÚNG: Cascade siêu mượt
  var p = Player()
    ..name = 'Vader'
    ..hp = 100;
  ```

## 🛡️ Lời khuyên từ Dart/Google Style Guide
- Đặt tên Class là `UpperCamelCase` (VD: `Spaceship`, `BankAccount`).
- Dùng từ khóa `this.propertyName` trực tiếp trong tham số của constructor thay vì gán thủ công bên trong khối `{}`.
- Đừng lạm dụng Getter/Setter nếu biến đó không có logic gì đặc biệt. Cứ để nó là biến public.

---
### 🐛 Thử Thách Gỡ Lỗi (Intentional Bugs)

> 💡 **Tình huống:** Lớp `BankAccount` dưới đây lỡ để public biến số dư `balance` khiến ai cũng có thể tự do thay đổi tiền trong tài khoản của mình. Chạy thử file `buggy_bank.dart` và áp dụng tính đóng gói (Encapsulation) để sửa lỗi.

```dart
class BankAccount {
  // Bug 1: Biến này quá hớ hênh, ai cũng sửa được
  double balance;
  
  BankAccount(this.balance);
}

void main() {
  var myAccount = BankAccount(1000);
  print('Số dư ban đầu: \${myAccount.balance}');
  
  // Bug 2: Hacker dễ dàng hack tiền!
  myAccount.balance = 999999999; 
  
  print('Số dư sau khi hack: \${myAccount.balance}');
}
```
**Gợi ý sửa lỗi:**
1. Thêm dấu gạch dưới `_` trước `balance` để biến nó thành private (đóng gói).
2. Tạo một **Getter** để cho phép bên ngoài ĐỌC số dư (nhưng không được ghi đè bằng dấu `=`).
3. Tạo một hàm `deposit(double amount)` để nạp tiền, trong đó có kiểm tra `if (amount > 0)` mới cho nạp.

---
### 🚀 Mini Pet Project: App Quản lý Chi tiêu (Expense Tracker Core)

Đây là nền tảng (core logic) cho một App Quản lý Chi tiêu rất phổ biến. Bạn sẽ dựng khung dữ liệu cho nó!

**Yêu cầu:**
1. Tạo file `expense_tracker.dart`.
2. Định nghĩa class `Expense` gồm các thuộc tính: `_id` (private), `title` (String), `amount` (double), `date` (DateTime).
3. Viết Constructor dùng Named Parameters để khởi tạo.
4. Thêm một biến static đếm tổng số Expense đã tạo.
5. Viết một hàm (method) `printDetails()` dùng Cascade Notation `..` lúc khởi tạo object để in thông tin ra một cách gọn gàng.
6. Thử ép giá trị `amount` âm (qua setter) và quăng ra lỗi (Throw Exception) để chặn người dùng nhập sai.

> 🔗 **Tài liệu tham khảo (Ref Docs):** 
> - [Dart Classes & Objects Official Docs](https://dart.dev/language/classes)
> - [Dart Constructors](https://dart.dev/language/constructors)

*Khi nào code xong, nhớ quăng lên đây để Mentor "soi" lỗi giúp bạn nhé!*
