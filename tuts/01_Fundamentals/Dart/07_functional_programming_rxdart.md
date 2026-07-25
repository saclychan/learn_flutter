# Bài 7: Functional Programming & RxDart (Lập trình Phản ứng)

Dart là một ngôn ngữ hướng đối tượng (OOP), nhưng nó mang trong mình sức mạnh cực lớn của Lập trình Hàm (Functional Programming). Khi bạn kết hợp nó với các luồng dữ liệu bất đồng bộ (Stream) thông qua `RxDart`, bạn sẽ có một cỗ máy xử lý dữ liệu mạnh nhất thế giới.

> 💡 **Fun Fact:** Các hàm `map`, `reduce`, `fold`, `where` trong Dart đều trả về một Iterable mới chứ không thay đổi mảng gốc. Đây là tính chất Bất biến (Immutability) - cốt lõi của Lập trình Hàm!

## 1. Functional Programming cơ bản
Thay vì viết vòng lặp `for` dài ngoằng để lọc ra những user trên 18 tuổi và lấy tên của họ, Senior sẽ viết thế này:

```dart
final users = [
  User(name: 'Alice', age: 16),
  User(name: 'Bob', age: 22),
  User(name: 'Charlie', age: 19),
];

// Dùng where để lọc, map để biến đổi data, và toList để xuất ra mảng
final adultNames = users
    .where((u) => u.age >= 18)
    .map((u) => u.name.toUpperCase())
    .toList();

print(adultNames); // ['BOB', 'CHARLIE']
```

## 2. Giới thiệu RxDart (ReactiveX cho Dart)
Flutter có `Stream`, nhưng nó khá cơ bản. `RxDart` mở rộng `Stream` bằng cách cung cấp `Subject` (tương đương với StreamController có khả năng ghi nhớ state) và hàng tá toán tử thao tác luồng (Operators).

### BehaviorSubject
Nó lưu lại giá trị MỚI NHẤT. Bất cứ ai lắng nghe (listen) nó kể cả sau khi giá trị đã được phát ra, đều nhận được giá trị đó ngay lập tức.
> 💡 **So sánh:** `PublishSubject` giống như Đài phát thanh trực tiếp - Nếu bạn bật đài trễ, bạn sẽ KHÔNG nghe được bài hát vừa phát. `BehaviorSubject` giống như Spotify - Bật đài trễ nó vẫn nhớ và phát lại bài hát GẦN NHẤT cho bạn nghe.
```dart
final subject = BehaviorSubject<int>();
subject.add(100); // Phát ra số 100

// Đăng ký nghe SAU KHI số 100 đã phát
subject.listen((value) => print('Nhận được: $value')); // Vẫn in ra 100!
```

### Các toán tử thao tác dữ liệu (Operators)
- **DebounceTime:** Cực kỳ hữu dụng cho tính năng Tìm kiếm. Tránh gọi API liên tục khi user đang gõ.
```dart
searchSubject.stream
  .debounceTime(const Duration(milliseconds: 500))
  .listen((query) => searchApi(query));
```
- **CombineLatest:** Gộp nhiều luồng lại. Ví dụ: Form có ô Email, Password. Gộp 2 luồng này lại để bật sáng nút Login nếu cả 2 đều hợp lệ.

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Sửa mảng gốc trong quá trình lặp:** Junior hay dùng `forEach` rồi `.remove()` phần tử trong chính cái mảng đó. Gây ra lỗi `ConcurrentModificationError`. **Cách phòng tránh:** Dùng hàm `where` để tạo ra một mảng mới (Immutability).
  ```dart
  // ❌ SAI: Sửa mảng gốc khi đang lặp
  List<int> nums = [1, 2, 3];
  nums.forEach((n) {
    if (n == 2) nums.remove(n); // CRASH!
  });
  
  // ✅ ĐÚNG: Tạo mảng mới bằng where
  List<int> validNums = nums.where((n) => n != 2).toList();
  ```
- **Quên đóng (close) Subject:** Stream mở mãi mãi dẫn tới tràn RAM. **Cách phòng tránh:** LUÔN gọi `subject.close()` trong hàm `dispose()` của StatefulWidget hoặc BLoC.
  ```dart
  // ❌ SAI: Khai báo Subject nhưng bỏ con giữa chợ
  final dataSubject = BehaviorSubject<int>();
  
  // ✅ ĐÚNG: Luôn dọn dẹp
  final dataSubject = BehaviorSubject<int>();
  void dispose() {
    dataSubject.close();
  }
  ```

## 🛡️ Lời khuyên từ Dart/Google Style Guide
- Khuyến khích xâu chuỗi (Chaining) các hàm Functional (`.map`, `.where`, `.toList()`) thành một hàng dọc thay vì tạo nhiều biến tạm trung gian lắt nhắt.
- Hạn chế tối đa việc dùng vòng lặp `for` với các mảng nếu có thể thay thế bằng các hàm của Iterable.

---
### 🐛 Thử Thách Gỡ Lỗi (Intentional Bugs)

> 💡 **Tình huống:** Code lắng nghe thanh tìm kiếm dưới đây đang bị lỗi "ConcurrentModificationError" do sửa mảng gốc, và thiếu `debounceTime` làm API bị gọi hàng trăm lần, cộng thêm việc quên đóng luồng. Chạy thử file `buggy_rxdart.dart` và sửa lỗi.

```dart
final searchSubject = PublishSubject<String>();
List<String> names = ['Luke', 'Leia', 'Han', 'Vader'];

void main() {
  // Bug 1: Không có debounceTime, gọi API vô tội vạ
  searchSubject.stream.listen((query) {
    print('Gọi API tìm kiếm: $query');
  });

  // Bug 2: Sửa mảng gốc lúc đang lặp
  names.forEach((name) {
    if (name == 'Vader') {
      names.remove(name); // CRASH!
    }
  });
  
  searchSubject.add('V');
  searchSubject.add('Va');
  searchSubject.add('Vad');
  
  // Bug 3: Quên searchSubject.close();
}
```
**Gợi ý sửa lỗi:**
1. Thêm `.debounceTime(Duration(milliseconds: 500))` trước `.listen()`.
2. Dùng `.where((name) => name != 'Vader').toList()` để tạo ra một mảng mới thay vì `.remove()` trực tiếp.
3. Luôn gọi `.close()` ở cuối cùng.

---
### 🚀 Mini Pet Project: Thanh Tìm Kiếm Của Ninja (Ninja Search)

**Yêu cầu:**
1. Cài đặt package `rxdart`.
2. Tạo một ô `TextField` cho phép người dùng nhập từ khóa tìm kiếm.
3. Khai báo một `PublishSubject<String>` (Một loại Subject của RxDart). Bắn chữ mà user gõ vào Subject này qua thuộc tính `onChanged`.
4. Lắng nghe Subject, sử dụng toán tử `.debounceTime(Duration(milliseconds: 500))` và in từ khóa ra màn hình console.
5. Chạy app: Thử gõ nhanh chữ "Flutter" trong vòng chưa tới nửa giây. Bạn sẽ thấy Console CHỈ in ra chữ "Flutter" ĐÚNG 1 LẦN sau khi bạn dừng tay gõ, thay vì in ra từng chữ "F", "Fl", "Flu"...

> 🔗 **Tài liệu tham khảo (Ref Docs):**
> - [Iterable collections (map, where...)](https://dart.dev/language/collections#iterable)
> - [RxDart Package](https://pub.dev/packages/rxdart)

*Làm chủ RxDart, xử lý logic phức tạp đến mấy cũng chỉ như xếp hình Lego.*
