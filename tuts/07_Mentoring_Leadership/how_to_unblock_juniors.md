# Bài 3: Nghệ thuật Gỡ rối cho Junior (How to unblock Juniors)

Lãnh đạo không phải là người làm thay tất cả mọi việc. Lãnh đạo là người tạo ra môi trường để người khác tự giải quyết được việc của họ. Khi một Junior/Middle "bị kẹt" (blocked), cách bạn gỡ rối sẽ quyết định họ có trưởng thành hay không.

## 1. Nguyên tắc tối thượng: KHÔNG CODE HỘ!
Khi Junior chạy đến: "Anh ơi, màn hình này bị trắng", phản xạ tự nhiên của một Dev giỏi là cầm lấy chuột và gõ rào rào 3 dòng code để fix xong trong 10 giây.
**Hậu quả:** Bạn trở thành "Cái phao cứu sinh" độc hại. Lần sau gặp lỗi y hệt, họ lại đến tìm bạn. Họ không học được gì cả.

## 2. Kỹ thuật "Vịt cao su" (Rubber Duck Debugging)
Bắt Junior phải giải thích lại toàn bộ luồng chạy của code thành tiếng, dòng này làm gì, dòng kia làm gì.
Rất nhiều trường hợp, trong lúc cố gắng giải thích cho bạn nghe, họ sẽ tự thốt lên: "Á, chỗ này gọi hàm mà quên `await`!". Bạn chưa cần nói một chữ nào, vấn đề đã được giải quyết.

## 3. Hỏi ngược (Socratic Method)
Đừng đưa ra câu trả lời. Hãy đưa ra câu hỏi.
- Junior: "Anh ơi, cái danh sách này cuộn bị giật quá."
- Senior: "Em đang dùng widget gì để tạo danh sách?"
- Junior: "Em dùng `SingleChildScrollView` bọc `Column` chứa 1000 items ạ."
- Senior: "Em thử tìm hiểu xem sự khác nhau giữa cách render của `SingleChildScrollView` và `ListView.builder` là gì không?"
- Junior: (Google 5 phút) -> "À, ListView.builder nó chỉ render những cái trên màn hình (lazy load). Em hiểu rồi để em sửa!"

## 4. Xây dựng văn hóa "Bằng chứng đâu?"
Trước khi cho phép Junior hỏi một câu, hãy yêu cầu họ chuẩn bị sẵn 3 thứ:
1. Lỗi là gì? (Log / Màn hình chụp).
2. Em đã thử những cách nào rồi? (Tránh việc cứ lỗi là hỏi mà không chịu suy nghĩ).
3. Em nghĩ nguyên nhân cốt lõi là do phần nào?

## 🛑 Những nỗi đau và ngộ nhận của Senior mới nhậm chức
- **Thiếu kiên nhẫn:** Senior thường bực mình vì "cái lỗi bé tí thế mà cũng hỏi". **Cách phòng tránh:** Hãy nhớ lại 3 năm trước, lúc bạn mới vào nghề, bạn cũng đã từng hỏi những câu ngớ ngẩn như vậy. Hãy bao dung.
- **Micro-management (Quản lý vi mô):** Ép Junior phải code y chang từng ký tự, từng cách đặt tên biến như phong cách của mình. **Cách phòng tránh:** Code review chỉ nên tập trung vào Kiến trúc, Hiệu năng và Lỗi logic. Về phong cách (Style), hãy cấu hình `flutter analyze` hoặc `lints` để máy móc tự động "mắng" Junior, thay vì bạn làm điều đó.

---
---
### 🚀 Mini Pet Project: Tình huống Giả định (Role-play Mentoring)

**Yêu cầu:**
Hãy tưởng tượng bạn đang là Tech Lead. Một Junior chạy ra báo cáo: "Anh ơi, cái ListView của em thỉnh thoảng giật lag kinh khủng, em không biết tại sao".
1. Đóng vai người đàn anh, viết ra 3 câu hỏi Socratic (hỏi gợi mở) bạn sẽ đặt ra cho Junior đó thay vì đưa ngay câu trả lời.
2. Vận dụng kỹ thuật Vịt Cao Su: Bạn bảo Junior đọc lại cấu trúc cây UI của họ xem có đang bọc sai widget không.
3. Lập ra một Checklist "Bằng chứng" buộc Junior phải chuẩn bị trước khi báo cáo lỗi trong tương lai.

> 🔗 **Tài liệu tham khảo (Ref Docs):**
> - [Rubber Duck Debugging Concept](https://rubberduckdebugging.com/)
> - [How to ask for programming help](https://stackoverflow.com/help/how-to-ask)

*Dẫn dắt người khác giải quyết vấn đề cũng là một cách để củng cố lại kiến thức của chính mình. Giữ vững tinh thần Mentor nhé!*
