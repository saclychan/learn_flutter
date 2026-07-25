# Debugging: Giải quyết những ca "Bệnh Hiểm Nghèo"

Junior thường hỏi: "Tại sao lỗi?". Senior hỏi: "Bằng chứng ở đâu?".
Kỹ năng debug phân định đẳng cấp của một lập trình viên.

## 1. Phương pháp "Chia để trị" (Binary Search Debugging)
Khi màn hình bị trắng xóa hoặc báo một lỗi cực kỳ vô nghĩa (như lỗi engine C++), đừng hoảng.
- **Comment Code:** Comment 50% số lượng widget trên màn hình lại. Chạy thử.
- Nếu hết lỗi -> Lỗi nằm trong 50% vừa bị comment.
- Tiếp tục mở 25%, rồi 12.5%... Bạn sẽ khoanh vùng chính xác dòng code gây lỗi chỉ trong vòng 3 phút, thay vì ngồi nhìn màn hình hàng giờ.

## 2. Nghệ thuật đọc Stack Trace (Dòng chữ đỏ còi)
- Đừng bao giờ đọc từ trên xuống dưới (đỉnh thường là lỗi hệ thống `framework.dart`).
- **Hãy tìm dòng chữ xanh / tên file CỦA BẠN** gần nhất. Đó là điểm bắt nguồn của thảm họa.
- Nếu lỗi là `LateInitializationError`: Chắc chắn bạn đã gọi một biến `late` trước khi gán cho nó giá trị.
- Nếu lỗi là `RenderBox was not laid out`: Lỗi bố cục kinh điển, thường do nhét một `ListView` vào trong một `Column` mà quên bọc bằng `Expanded`.

## 3. "Con bọ" (Breakpoints) trong IDE
Đừng dùng `print()` nữa.
- Bấm vào lề trái của VSCode/Android Studio để đặt chấm đỏ (Breakpoint).
- Chạy app chế độ Debug (F5). Code sẽ "dừng hình" ngay tại dòng đó.
- Bạn có thể rê chuột vào từng biến để xem giá trị chính xác của chúng, danh sách mảng có bao nhiêu phần tử tại TÍCH TẮC ĐÓ. Thậm chí dùng Debug Console để chạy thử code nháp bằng giá trị hiện tại.

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Hội chứng "Đoán mò":** Thay vì đọc dòng lỗi màu đỏ, Junior nhìn chằm chằm vào code rồi đoán "Chắc là do dòng này" và sửa bừa, hy vọng nó chạy lại. Đoán sai lại sửa tiếp. **Cách phòng tránh:** Dừng lại! Đọc thật kỹ dòng đầu tiên và dòng cuối cùng của Stack Trace. Tìm tên file do chính mình tạo ra trong đống màu đỏ đó.
- **Nghĩ rằng Debugger chỉ dành cho siêu nhân:** Nhiều bạn code cả năm trời nhưng không biết đặt Breakpoint là gì, suốt ngày `print("1")`, `print("2")`. Khi gặp biến Map lồng Map thì bất lực. **Cách phòng tránh:** Bắt buộc phải học cách dùng công cụ Debug (F5) của IDE.

---
### 🚀 Mini Pet Project: Thợ Săn Lỗi (Bug Hunter)

**Yêu cầu:**
1. Viết một đoạn code có lỗi cực kỳ thâm độc: Tạo một biến `late String name;`.
2. Trong hàm `build`, hiển thị `Text(name)` nhưng lại KHÔNG khởi tạo giá trị cho `name` trong `initState`.
3. Chạy app (nó sẽ văng màn hình đỏ).
4. Không dùng lệnh `print`. Hãy sử dụng thanh Debug, tìm đọc bảng **Stack Trace**, truy vết đúng dòng code gọi biến `name` trước khi nó được gán giá trị.

> 🔗 **Tài liệu tham khảo (Ref Docs):**
> - [Flutter Debugging Guide](https://docs.flutter.dev/testing/debugging)
> - [VS Code Debugging Features](https://code.visualstudio.com/docs/editor/debugging)

*Một khi đã biết xài Breakpoint, bạn sẽ thấy `print()` thật sự là đồ đá!*
