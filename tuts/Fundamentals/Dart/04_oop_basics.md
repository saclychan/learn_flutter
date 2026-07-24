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

---
### 🛠 Bài tập cho bạn
1. Tạo một class `Product` với thuộc tính `id`, `name`, và `price`.
2. Viết constructor cho class đó sử dụng Named Parameters.
3. Dấu giá trị `price` thành private (thêm `_` phía trước) và viết một Getter để lấy giá trị `price`, một Setter để set `price` (nhưng chỉ cho phép set nếu giá trị > 0).
4. Thử khởi tạo Object và sử dụng thử getter/setter như một thuộc tính bình thường (VD: `product.price = 10;`).
