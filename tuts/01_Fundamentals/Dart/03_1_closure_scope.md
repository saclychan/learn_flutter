# Bài 3.1: Lexical Scope & Closure (Phạm vi biến và Bao đóng)

> 💡 *Dành riêng cho Newbie: Khái niệm này hơi "hại não" lúc đầu, nhưng nếu bạn không hiểu nó, bạn sẽ không thể code Flutter mượt mà được!*

Khi bạn khai báo một biến, biến đó không "sống" vĩnh viễn ở mọi nơi. Nó có một "lãnh thổ" riêng.

## 1. Scope (Phạm vi) là gì?
Hãy tưởng tượng Scope giống như các căn phòng lồng vào nhau.
- **Global Scope (Toàn cục):** Biến nằm ngoài cùng, ai cũng có thể gọi.
- **Local Scope (Cục bộ):** Biến khai báo bên trong một cặp ngoặc nhọn `{}` (của hàm, vòng lặp, if-else). Chỉ những ai ở TRONG cùng căn phòng đó mới nhìn thấy biến đó.

Dart sử dụng **Lexical Scope**, nghĩa là bạn hoàn toàn có thể "nhìn bằng mắt thường" để biết biến đó có thể được dùng ở đâu. Cứ nhìn theo các dấu ngoặc nhọn `{}`!

```dart
String galaxy = 'Milky Way'; // Global - Ai cũng xài được

void main() {
  String planet = 'Earth'; // Local của main()
  
  if (true) {
    String city = 'Hanoi'; // Local của if
    print(city);   // OK!
    print(planet); // OK! (Vì if nằm TRONG main)
    print(galaxy); // OK!
  }
  
  // print(city); // ❌ LỖI! Vì main() đứng ngoài phòng của if, không thể nhìn thấy city.
}
```

## 2. Closure (Bao đóng) là gì?
Đây là phần "ma thuật" nhất!
**Định nghĩa chuẩn:** Closure là một hàm (function) có khả năng **"nhớ"** và truy cập được vào các biến ở phạm vi bên ngoài của nó, **NGAY CẢ KHI** hàm bên ngoài đã chạy xong và bị hủy!

**Định nghĩa cho Newbie (Ví dụ chiếc Balo):**
Khi bạn tạo một hàm con (Inner function) bên trong một hàm cha (Outer function), hàm con sẽ "nhặt" tất cả các biến mà nó cần từ hàm cha, nhét vào một cái **Balo (Closure)** và đeo lên lưng.
Khi hàm cha chạy xong và biến mất, hàm con vẫn có thể sử dụng các biến đó vì chúng đã nằm gọn trong Balo của nó!

```dart
// Hàm cha trả về một hàm con (Function)
Function createCounter() {
  int count = 0; // Biến ở hàm cha
  
  // Hàm con (Anonymous function)
  return () { 
    count++; // Hàm con sử dụng biến của hàm cha
    print('Giá trị: $count');
  };
}

void main() {
  // 1. Gọi hàm cha. Nó trả về hàm con.
  // Lúc này hàm createCounter đã chạy XONG và biến 'count' lẽ ra phải bị xóa khỏi RAM.
  var myCounter = createCounter(); 
  
  // 2. NHƯNG KHÔNG! Hàm con đã lưu 'count' vào Balo (Closure) của nó.
  myCounter(); // In ra 1
  myCounter(); // In ra 2
  myCounter(); // In ra 3
}
```
*Bạn thấy đấy, biến `count` vẫn sống dai dẳng và tiếp tục tăng lên! Đó chính là sức mạnh của Closure.*

## 3. Tại sao Closure lại quan trọng trong Flutter?
Trong Flutter, bạn thao tác với giao diện (UI) và Callbacks (những hàm chạy sau khi bấm nút) liên tục.
```dart
Widget buildButton() {
  int tapCount = 0;
  
  return ElevatedButton(
    // Sự kiện onPressed chính là một Closure!
    // Nó "nhớ" biến tapCount dù hàm buildButton đã chạy xong từ lâu.
    onPressed: () {
      tapCount++;
      print('Bạn đã bấm $tapCount lần');
    }
  );
}
```

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Bóng đè (Variable Shadowing):** Khi bạn khai báo một biến ở hàm con CÙNG TÊN với biến ở hàm cha, trình biên dịch sẽ ưu tiên biến ở hàm con. Gây ra lỗi logic ngớ ngẩn (cập nhật nhầm biến).
  ```dart
  // ❌ SAI: Bóng đè
  int money = 100;
  void earnMoney() {
    int money = 50; // Tạo ra 1 biến mới toanh che lấp biến cũ
    money += 10;    // Chỉ biến mới tăng, biến cũ vẫn 100
  }
  
  // ✅ ĐÚNG: Không khai báo lại kiểu dữ liệu
  int money = 100;
  void earnMoney() {
    money += 10; // Cập nhật đúng biến gốc
  }
  ```

## 🛡️ Lời khuyên từ Dart/Google Style Guide
- Hạn chế tối đa các biến **Global** (Toàn cục) nếu không thực sự cần thiết, vì chúng có thể bị Closure ở bất kỳ đâu thay đổi giá trị, dẫn tới việc fix bug như mò kim đáy bể.
- Cẩn thận khi đặt tên biến trong các vòng lặp hoặc callback để tránh lỗi "Variable Shadowing".

---
### 🐛 Thử Thách Gỡ Lỗi (Intentional Bugs)

> 💡 **Tình huống:** Một đoạn code tính tiền lãi suất bị sai nghiêm trọng do lỗi "Shadowing" và hiểu sai về phạm vi biến. Hãy chạy file `buggy_scope.dart` và sửa lỗi!

```dart
double totalBalance = 1000;

Function calculateInterest() {
  double interestRate = 0.05;
  
  return (double deposit) {
    // Bug 1: Khai báo đè lên biến toàn cục (Shadowing)
    double totalBalance = totalBalance + deposit;
    totalBalance = totalBalance + (totalBalance * interestRate);
    print('Số dư hiện tại: $totalBalance');
  };
}

void main() {
  var addMoney = calculateInterest();
  addMoney(500); 
  // Bug 2: Sau khi nạp tiền, số dư tổng ở ngoài vẫn là 1000!
  print('Số dư tổng trên hệ thống: $totalBalance'); 
}
```
**Gợi ý sửa lỗi:**
Trong hàm con (chỗ `return (double deposit)`), không được khai báo lại kiểu dữ liệu `double` trước chữ `totalBalance`. Hãy xóa chữ `double` đi để nó truy xuất đúng vào biến `totalBalance` của Global Scope! (Chú ý: biến `totalBalance` ở trong hàm con lấy giá trị từ Global, bạn chỉ cần sửa dấu `=` bằng dấu `+=` hoặc dùng công thức hợp lý).

---
### 🚀 Mini Pet Project: Nhà máy tạo thẻ ID (ID Card Factory)

Chúng ta sẽ ứng dụng Closure để tạo ra một "nhà máy" sinh mã ID tự động tăng cho nhân viên.

**Yêu cầu:**
1. Tạo file `id_factory.dart`.
2. Viết một hàm `Function createIDGenerator(String prefix)`.
3. Trong hàm đó, khai báo một biến `int counter = 1`.
4. Hàm này trả về một hàm con không có tham số (Closure). Hàm con này có nhiệm vụ: nối chuỗi `prefix` với `counter`, in ra kết quả, sau đó tăng `counter` lên 1 đơn vị.
5. Trong `main()`, hãy tạo ra 2 generator riêng biệt:
   - `var devIdGen = createIDGenerator('DEV_');`
   - `var qaIdGen = createIDGenerator('QA_');`
6. Gọi `devIdGen()` 3 lần và `qaIdGen()` 2 lần. Bạn sẽ thấy 2 bộ đếm này chạy hoàn toàn độc lập với nhau nhờ ma thuật của Closure! Mỗi Balo Closure đang giữ một biến `counter` riêng biệt!

> 🔗 **Tài liệu tham khảo:**
> - [Dart Lexical Scope & Closures](https://dart.dev/language/functions#lexical-scope)

*Thử code và in ra kết quả xem nào, bạn sẽ thấy ma thuật của Closure!*
