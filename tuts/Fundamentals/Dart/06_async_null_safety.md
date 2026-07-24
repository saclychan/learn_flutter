# Bài 6: Bất đồng bộ (Async) & An toàn Null (Null Safety)

Đây là 2 kiến thức quan trọng bậc nhất. App Flutter liên tục phải lấy data từ Internet (tốn thời gian) và nếu không quản lý tốt giá trị Null (trống), app sẽ crash (màn hình đỏ).

## 1. Null Safety
Kể từ Dart 2.12, Dart áp dụng **Sound Null Safety**. Trình biên dịch mặc định hiểu rằng một biến KHÔNG THỂ có giá trị Null.
- Nếu cố tình gán null cho biến thông thường -> Báo lỗi ngay khi code.

### Khai báo biến có thể Null (Nullable)
Để báo cho Dart biết: "Biến này có thể rỗng đấy", ta thêm dấu `?` vào sau kiểu dữ liệu.
```dart
String name = 'Vader'; // Không bao giờ được phép null
String? nickname;      // Có thể là chuỗi, có thể null
```

### Xử lý biến Nullable
Để dùng biến `?`, bạn phải kiểm tra trước hoặc xử lý nó:
- **Toán tử `??` (Cung cấp giá trị mặc định)**
  ```dart
  String displayName = nickname ?? 'Unknown User'; 
  // Nếu nickname != null thì lấy nickname, nếu null thì lấy chuỗi sau ??
  ```
- **Toán tử `!` (Ép buộc - Bang operator)**
  Chỉ dùng khi bạn CHẮC CHẮN 100% nó không null. (Tránh lạm dụng).
  ```dart
  int length = nickname!.length; // Nếu nhỡ nickname null, app sẽ crash tại dòng này!
  ```

> 🧠 **Senior Detail - `late` keyword**: Đôi khi bạn muốn khai báo một biến không null, nhưng bạn chưa có giá trị để gán ngay (ví dụ đợi init trong initState của Flutter). Từ khóa `late` dặn compiler: "Cứ yên tâm, tôi hứa sẽ gán giá trị cho nó trước khi tôi gọi đến nó". Nếu bạn thất hứa (gọi nó trước khi gán), nó sẽ quăng lỗi `LateInitializationError` ở runtime.

## 2. Bất đồng bộ (Asynchronous Programming)
Gọi API cần thời gian. Nếu bắt ứng dụng chờ (đứng im), màn hình sẽ bị "đơ" (freeze). Bất đồng bộ giải quyết việc đó: "Anh cứ làm việc khác đi, khi nào tôi lấy xong data tôi sẽ báo".

### Future
`Future` đại diện cho một kết quả có thể xảy ra ở tương lai.
```dart
Future<String> fetchUserData() {
  // Giả lập việc gọi API mất 2 giây
  return Future.delayed(Duration(seconds: 2), () {
    return 'Dữ liệu User: Yoda';
  });
}
```

### async / await
Thay vì dùng hàm `.then()` truyền thống phức tạp, `async/await` giúp code bất đồng bộ trông giống như code đồng bộ (tuần tự).
```dart
// Thêm chữ async vào cuối khai báo hàm
void showUser() async {
  print('1. Bắt đầu lấy data...');
  
  // Dùng await để đợi Future trả kết quả. Dòng lệnh ở dưới sẽ không chạy cho đến khi data về.
  String data = await fetchUserData(); 
  
  print('2. Xong: $data');
}
```

> 💡 **Fun Fact - Event Loop**: Dart chạy trên duy nhất 1 luồng (Single Thread). Vậy sao nó làm được nhiều việc cùng lúc? Nó dùng Event Loop. Có 2 hàng đợi: **Microtask Queue** và **Event Queue**. Microtask được ưu tiên cực độ. `Future` chạy trên Event Queue, nghĩa là nó nhường đường cho các tác vụ vẽ UI quan trọng chạy trước, giữ cho app mượt 60fps!

---
### 🛠 Bài tập cho bạn
1. Khai báo một class `User` với thuộc tính `id` (bắt buộc) và `avatarUrl` (có thể null `?`).
2. Viết một hàm `getUserInfo()` có kiểu trả về `Future<User>`, sử dụng `Future.delayed` delay 3 giây rồi trả về 1 object `User`.
3. Viết hàm `main() async`, in ra "Đang tải...", gọi `await getUserInfo()`, sau đó dùng toán tử `??` để in ra `avatarUrl` (nếu null thì in ra "No Avatar").
4. Trải nghiệm cảm giác code chờ 3 giây mà không làm đơ chương trình.

*Gõ và chạy hết 6 bài này là bạn đã có một bộ "nội công" Dart cực kỳ vững chắc để nhảy vào múa Flutter rồi đấy. Báo lại cho mình sau khi trải nghiệm xong nhé!*
