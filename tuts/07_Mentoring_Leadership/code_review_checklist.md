# Danh sách kiểm tra khi Review Code (Code Review Checklist)

Là một Senior, công việc hàng ngày của bạn không chỉ là gõ phím, mà là định hướng và kiểm soát chất lượng code của cả team. Review code cho Junior không phải là tìm cách "bắt lỗi chửi bới", mà là cơ hội để nâng cao kỹ năng cho họ.

Dưới đây là Checklist tiêu chuẩn khi thực hiện Pull Request (PR) Review.

## 1. Kiến trúc và Thiết kế (Architecture & Design)
- [ ] Code có đặt đúng lớp không? (Data models không được lọt lên lớp UI, API calls không nằm trong Widget).
- [ ] Hàm/Class này có đang vi phạm nguyên tắc Single Responsibility (SRP) không? Có đang ôm đồm quá nhiều việc?
- [ ] Hardcode: Có chuỗi String, màu sắc (Colors), hay kích thước (Sizes) nào bị viết cứng vào UI thay vì lấy từ Theme/Config không?

## 2. Hiệu năng (Performance)
- [ ] Có dùng `const` constructor ở mọi nơi có thể trên cây Widget chưa? (Rất quan trọng cho Flutter rendering).
- [ ] Có lạm dụng `setState` bừa bãi không? (Dùng Riverpod/Bloc đúng chuẩn chưa).
- [ ] Danh sách dài có đang dùng `ListView.builder` thay vì `ListView` thường không?
- [ ] Ảnh có được cache đúng cách và nén dung lượng phù hợp không (`cached_network_image`)?

## 3. An toàn và Xử lý lỗi (Safety & Error Handling)
- [ ] Có lạm dụng toán tử ép buộc Null (`!`) không? Phải đảm bảo biến không thể null, hoặc dùng `??` để fallback.
- [ ] API Call có được bọc trong khối `try-catch` và bắt lỗi cụ thể chưa?
- [ ] Người dùng có nhận được phản hồi (Snackbars, Dialogs) khi xảy ra lỗi không, hay là ứng dụng bị crash im lặng?

## 4. Khả năng đọc hiểu và Clean Code (Readability)
- [ ] Đặt tên biến/hàm có ý nghĩa không? (Không dùng `var a, b, c`, `void check()`).
- [ ] Code có quá nhiều Nested If/Else không? Yêu cầu Early Return để làm phẳng code.
- [ ] Có xóa bỏ toàn bộ `print()` và code bị comment lại (dead code) trước khi push không? (Chỉ nên dùng `log()` hoặc thư viện logger chuyên nghiệp).

## 5. Testing
- [ ] Chức năng mới cốt lõi có đi kèm Unit Test không?
- [ ] Test có Pass toàn bộ trên CI không?

---
## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Tự ái khi bị chê code lởm:** Khi nhận được hàng tá comment review đỏ chót, Junior thường có xu hướng chống chế (defensive) hoặc tự ái nghĩ rằng Senior đang ghét mình. **Cách phòng tránh:** Code không phải là con của bạn. Người ta chê code, không phải chê bạn. Fix lỗi là để giỏi lên.
- **Merge PR nhắm mắt:** Nhiều bạn được giao review code, nhưng chỉ lướt qua xem có dòng nào syntax error không rồi bấm "Approve" (LGTM - Looks Good To Me). **Hậu quả:** Bug lên Production, và người bị lôi ra chém đầu đầu tiên chính là người Review Code.

---
### 🚀 Mini Pet Project: Đóng vai Người Phán Xử (Code Reviewer)

**Yêu cầu:**
1. Hãy mở một file code bất kỳ trong dự án cũ của bạn (hoặc xin một đoạn code của bạn bè).
2. Áp dụng đúng 5 tiêu chí trong danh sách trên để tự săm soi lại code đó.
3. Tập viết comment review: Sử dụng phương pháp Socratic (Hỏi gợi mở) thay vì ra lệnh.
   - *Thay vì viết:* "Dùng const chỗ này ngay!"
   - *Hãy viết:* "Widget này không có trạng thái thay đổi, em nghĩ sao nếu chúng ta thêm `const` để tiết kiệm RAM?"

> 🔗 **Tài liệu tham khảo (Ref Docs):**
> - [Google's Code Review Developer Guide](https://google.github.io/eng-practices/review/reviewer/)
> - [Effective Dart: Usage](https://dart.dev/effective-dart/usage)

*Review code là nghệ thuật, và người Review là một nghệ sĩ kiêm giáo viên tâm lý!*
