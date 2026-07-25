# Bài 2: Tối ưu hiệu năng và Hiểu sâu về Flutter Engine

Senior Developer không đoán bừa xem app bị giật lag vì lý do gì. Họ dùng Profiler, DevTools và hiểu rõ cách Flutter vẽ lên màn hình.

## 1. Ba cái cây của Flutter
Để vẽ một giao diện, Flutter dùng 3 cái cây (Trees):
1. **Widget Tree**: Là code bạn viết. Nó rẽ nhánh rất nhanh và nhẹ, thực chất chỉ là "bản phác thảo cấu hình". Việc rebuild Widget tree tốn RẤT ÍT tài nguyên.
2. **Element Tree**: Đại diện cho cấu trúc UI thực tế đang hiển thị trên màn hình. Nó giữ vai trò "quản lý" (nắm giữ State).
3. **RenderObject Tree**: Cây xịn nhất, trực tiếp chịu trách nhiệm tính toán kích thước (Layout) và vẽ (Paint) pixel lên màn hình. Đây mới là nơi tiêu tốn tài nguyên nhất.

> 🧠 **Senior Detail**: Tại sao dùng `const` lại quan trọng? Khi bạn dùng `const Widget()`, Flutter sẽ nhận ra Widget này không bao giờ thay đổi, nó sẽ dùng lại trực tiếp Element và RenderObject cũ, bỏ qua hoàn toàn bước so sánh và tính toán lại cho nhánh đó. Tăng FPS rõ rệt!

## 2. Các nguyên nhân gây rớt FPS (Jank)
1. **Làm quá nhiều việc ở Main Isolate (UI Thread):** Parse chuỗi JSON khổng lồ (10MB) ngay trên UI Thread sẽ làm app đứng hình mất vài giây.
   *Khắc phục:* Dùng hàm `compute()` hoặc `Isolate.spawn()` để đẩy các tác vụ tính toán nặng sang một luồng (thread) khác.
2. **Rebuild toàn bộ màn hình vô ích:** Hàm `build` của màn hình gốc được gọi lại chỉ vì một icon nhỏ nhấp nháy.
   *Khắc phục:* Chia nhỏ Widget (Extract Widget) hoặc dùng `Consumer` (nếu dùng Riverpod) bọc riêng lẻ component đó.
3. **SaveLayer (Cực tốn kém):** Sử dụng các hiệu ứng như `Opacity`, bóng đổ (`BoxShadow`), bo góc (`ClipRRect`) không đúng cách trên một list lớn.
   *Khắc phục:* Hạn chế `Opacity` trong Animation. Thay vào đó dùng `AnimatedOpacity`.

## 3. Sử dụng Flutter DevTools
Đây là vũ khí hạng nặng của Senior.
- **Flutter Inspector:** Xem cây Widget. Bật tính năng **"Highlight Repaints"** để xem phần nào trên màn hình đang bị vẽ lại liên tục. Vùng bị vẽ lại sẽ có khung màu ngẫu nhiên.
- **Performance View:** Xem biểu đồ FPS. Các vạch màu đỏ vọt lên báo hiệu khung hình (frame) đó mất hơn 16ms để vẽ (gây giật lag). Bạn có thể click vào để xem hàm Dart nào ngốn thời gian nhất.
- **Memory View:** Theo dõi RAM. Bấm liên tục vào một màn hình, nếu biểu đồ RAM cứ tăng vút lên mà không giảm đi khi back lại (nhấn biểu tượng thùng rác - GC), ứng dụng của bạn đã bị Memory Leak.

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Sợ hàm `build` chạy lại:** Junior rất sợ khi thấy hàm `build` gọi nhiều lần (do hay in `print` ra xem). Thực tế, hàm `build` của Widget Tree chạy siêu nhanh. Cái gây lag là cái Element và RenderObject bên dưới cơ. **Cách phòng tránh:** Hiểu đúng bản chất. Đừng cố gắng dùng các thủ thuật phức tạp để ngăn `build` chạy, trừ khi bạn đo bằng DevTools và xác nhận nó thực sự gây lag.
- **Nhét Logic vào `build`:** Parse thời gian, sắp xếp mảng (sort array 10,000 items) lù lù trong hàm `build`. **Cách phòng tránh:** Hàm `build` sinh ra CHỈ ĐỂ VẼ. Mọi logic tính toán phải được xử lý ở ViewModel/Controller trước đó và chỉ truyền output (dữ liệu đã xử lý) vào UI.
- **Sử dụng Isolate bừa bãi:** Nghe nói Isolate chạy nhanh, lôi Isolate ra dùng cho hàm tính toán `a + b`. **Cách phòng tránh:** Khởi tạo một Isolate cực kỳ tốn tài nguyên và thời gian (vì nó phải copy dữ liệu qua lại, Isolate không chia sẻ chung vùng nhớ RAM). Chỉ dùng nó khi file, json hoặc phép toán tính toán tốn quá 16ms (1 khung hình).

---
---
### 🚀 Mini Pet Project: Thợ săn Cổ chai (Performance Bottleneck Hunter)

**Yêu cầu:**
1. Tạo một UI có nút "Parse 10,000 Users".
2. Trong hàm `onPressed`, dùng một vòng lặp `for` tạo ra 10.000 chuỗi JSON giả và parse chúng bằng `jsonDecode` trực tiếp trên Main Thread. Kéo màn hình xem có bị giật/đơ không.
3. Tạo một hàm tĩnh (static function) hoặc top-level function để chuyển logic parse kia vào.
4. Sửa `onPressed` để dùng `compute(parseUsers, data)`. Kéo lại màn hình để thấy sự mượt mà kỳ diệu khi tính toán nặng được đẩy sang Isolate khác.

> 🔗 **Tài liệu tham khảo (Ref Docs):**
> - [Flutter Performance Profiling](https://docs.flutter.dev/perf/ui-performance)
> - [Concurrency in Dart (Isolates & Compute)](https://dart.dev/language/concurrency)

*Phân biệt được lúc nào dùng Future (bất đồng bộ) và lúc nào dùng Isolate (song song) là tiêu chuẩn bắt buộc của Senior.*
