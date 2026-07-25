# Review Bài 2: Vòng quay Nga ngẫu nhiên (Control Flow)

**Mentor đánh giá:** Xuất sắc! Bạn đã áp dụng được rất nhiều kiến thức Senior ngay trong những bài đầu tiên.

## Điểm cộng cực lớn (Senior vibes):
1. **Dart 3.0 Features:** Dùng `switch expression` (dòng 6) và `if-case` (dòng 29) cực kỳ mượt mà. Rất ít Junior biết dùng tính năng này ngay từ đầu.
2. **Collection For:** Khởi tạo danh sách bằng `[for (var i = ...) 'Year $i']` rất chính xác và hiện đại, thể hiện bạn hiểu sâu về cách build list động trong Dart.
3. **Logic chặt chẽ:** Sử dụng `if-else if-else` và `do-while` đúng chuẩn mực. Việc sinh số ngẫu nhiên từ 1-6 bằng `diceNumber = random.nextInt(6); diceNumber++;` là hoàn toàn chính xác.

## Mẹo nhỏ từ Senior (Junior Pitfalls & Tips):
- **Dart Core:** Dòng `import 'dart:core';` là không cần thiết. Dart tự động import thư viện này vào mọi file, nên bạn có thể xóa nó đi cho sạch code.
- **Khai báo Map:** Ở dòng 28 `final json = {'name': "sacly", "age": 1};`, Dart sẽ suy luận kiểu là `Map<String, Object>`. Tuy nhiên trong thực tế khi gọi API, Senior thường ép kiểu tường minh là `Map<String, dynamic>` để tránh rắc rối khi cast kiểu.
- **In danh sách lớn:** Code `years.join(', ')` in ra 1000 phần tử ra console. Mặc dù ở đây là bài tập, nhưng trong môi trường thực tế (Flutter UI), ta không bao giờ load/hiển thị 1000 item cùng lúc mà sẽ dùng `ListView.builder` (Lazy load) để tránh giật lag.
- **Lỗi nhỏ:** Ở `switch expression`, `"Understood"` có vẻ là bạn muốn gõ "Unknown" (Không xác định), và "Bậc thấy" chắc là "Bậc thầy". Chú ý lỗi chính tả nhé!

## Đánh giá chung: **Passed! ✅**
Bạn đã hoàn toàn làm chủ Control Flow của Dart. Khả năng tìm tòi áp dụng kiến thức mới (Dart 3) rất tuyệt vời. Hãy tự tin chuyển sang Bài 3 (Functions) nhé!
