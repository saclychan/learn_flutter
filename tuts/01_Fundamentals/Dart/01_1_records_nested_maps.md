# Bài 1.1: Records, Destructuring & Nested Maps (Vũ khí Dart 3)

> 💡 *Bài học này ra đời từ chính sự mày mò thực tế của một học viên xuất sắc. Những tính năng này là "đặc sản" của Dart 3, giúp code của bạn an toàn và ngắn gọn hơn gấp nhiều lần.*

## 1. Nested Maps (Map lồng nhau)
Trong thực tế, khi gọi API, dữ liệu trả về thường ở dạng JSON (Map lồng trong Map).
```dart
// Map lồng nhau: Key là String, Value lại là một Map khác!
Map<String, Map<String, double>> students = {
  "Luke": {"height": 1.70, "weight": 65.0},
  "Vader": {"height": 2.02, "weight": 120.0},
};

// Duyệt qua (Loop) các phần tử của Map bằng .entries
for (var student in students.entries) {
  String name = student.key;
  Map<String, double> metrics = student.value;
  
  // Dùng dấu ! (Bang operator) vì Dart biết lấy value từ Map có thể bị Null
  double h = metrics["height"]!; 
  print('$name cao $h m');
}
```

## 2. Records `()` - Kẻ thay thế Data Class
Trích xuất dữ liệu từ Map rườm rà và nguy hiểm (nếu gõ sai key `"height"` thành `"heigh"`, app sẽ crash). 
Từ Dart 3, nếu bạn muốn nhóm vài biến lại với nhau mà "lười" tạo Class, hãy dùng **Records**!

Records được bọc trong cặp ngoặc đơn `()`.
```dart
// 1. Record theo vị trí (Positional)
var hero = ('Batman', 35);
print(hero.$1); // Lấy 'Batman'
print(hero.$2); // Lấy 35

// 2. Record có tên (Named) - Khuyên dùng!
var jedi = (name: 'Yoda', age: 900);
print(jedi.name); // Yoda
print(jedi.age);  // 900
```
> 💡 **So sánh Map vs Record:** 
> - `Map` linh hoạt (thêm bớt key lúc app đang chạy được) nhưng **không an toàn** (không gợi ý code, dễ gõ sai key).
> - `Record` cố định, an toàn tuyệt đối, trình biên dịch gợi ý tên biến luôn cho bạn! Senior cực kỳ thích dùng Record thay cho Map khi truyền dữ liệu.

## 3. Record Destructuring (Bóc tách dữ liệu)
Đây là trò ảo thuật! Bạn có một Record, và bạn muốn "bóc" nó ra thành các biến riêng lẻ ngay lập tức.
```dart
var data = (title: 'Dart 3', rating: 5.0);

// Bóc tách! (Tự động tạo ra 2 biến title và rating)
final (:title, :rating) = data;

print('Khóa học $title được $rating sao'); 
```

Bạn còn có thể dùng Record để trả về **nhiều giá trị** từ một hàm!
```dart
// Hàm trả về 2 giá trị cùng lúc!
(String, int) getTopPlayer() {
  return ('Faker', 27);
}

void main() {
  // Bóc tách ngay khi nhận kết quả
  final (name, age) = getTopPlayer(); 
}
```

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Nhầm lẫn Record và Map:** Nhiều bạn nghĩ `(name: 'A')` là Map. Sai! Map dùng `{name: 'A'}`. Record cố định kiểu dữ liệu và không thể thay đổi giá trị (Immutable) sau khi tạo.
- **Cố gắng sửa giá trị của Record:** Bạn không thể gán lại `jedi.name = 'Luke';` nếu `jedi` là một Record. **Cách phòng tránh:** Nếu muốn thay đổi giá trị liên tục, hãy dùng Class truyền thống. Record sinh ra để "gom và chở" dữ liệu một cách an toàn, không phải để chỉnh sửa.
- **Lạm dụng Map quá sâu:** Việc tạo `Map<String, Map<String, List<int>>>` khiến code thành một đống bùi nhùi, lúc bóc dữ liệu ra toàn dấu `!`. **Cách phòng tránh:** Dùng Record hoặc tạo Data Class.

## 🛡️ Lời khuyên từ Dart/Google Style Guide
- Sử dụng Records thay vì tạo các Class nhỏ xíu chỉ chứa 2-3 biến mà không có logic hàm nào đi kèm.
- Khi hàm cần trả về từ 2 giá trị trở lên (vd: `success` và `errorMessage`), hãy dùng Record thay vì nhét chúng vào 1 cái mảng `List` hoặc `Map`.

---
### 🐛 Thử Thách Gỡ Lỗi (Intentional Bugs)

> 💡 **Tình huống:** Một đoạn code dưới đây cố gắng cập nhật tuổi cho một Record và bóc tách dữ liệu sai cú pháp. Chạy file `buggy_records.dart` và sửa lỗi.

```dart
void main() {
  var user = (name: 'Alice', age: 20);
  
  // Bug 1: Cố gắng sửa đổi giá trị của Record
  user.age = 21; 
  
  // Bug 2: Bóc tách Record sai cú pháp
  final (name, age) = user; 
  
  print('Happy birthday \$name, you are now \$age');
}
```
**Gợi ý sửa lỗi:**
1. Records là *Immutable* (Bất biến). Không thể gán `user.age = 21`. Hãy tạo ra một Record MỚI và gán đè lại cho biến `user`: `user = (name: user.name, age: 21);`.
2. Vì `user` là Named Record (có tên biến bên trong), nên khi Destructuring bạn phải có dấu hai chấm: `final (:name, :age) = user;`.

---
### 🚀 Mini Pet Project: Phân tích Dữ liệu API (API Data Parser)

Chúng ta sẽ mô phỏng việc bóc tách một cục JSON rối rắm thành những Records gọn gàng!

**Yêu cầu:**
1. Tạo file `api_parser.dart`.
2. Khai báo một Nested Map mô phỏng dữ liệu API:
```dart
Map<String, dynamic> apiResponse = {
  "status": 200,
  "data": {
    "server1": {"cpu": 80.5, "ram": 16.0},
    "server2": {"cpu": 45.0, "ram": 32.0}
  }
};
```
3. Viết hàm `parseServerData` nhận vào cục `apiResponse` kia, và trả về một List các Records dạng: `List<({String name, double cpu, double ram})>`.
4. Trong hàm `main()`, gọi hàm `parseServerData`, sau đó dùng vòng lặp `for-in` kết hợp với **Record Destructuring** để in ra màn hình cảnh báo nếu server nào có `cpu > 80.0`.

> 🎓 **Bài giải mẫu (Sample Solution):**
> [api_parser.sample.dart](../../../../pets/tuts/01_Fundamentals/Dart/01_1_records_nested_maps.md/api_parser.sample.dart) (Chỉ xem khi đã thực sự bí nhé!)
