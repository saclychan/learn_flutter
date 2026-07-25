# Code Review Checklist: Nghệ Thuật Review Dành Cho Senior

## 1. Giới thiệu: Review Code Không Phải Là Bắt Lỗi
Khi bạn từ Junior lên Mid/Senior, trách nhiệm của bạn mở rộng ra việc đảm bảo chất lượng code của cả team. Một trong những công cụ mạnh mẽ nhất là Code Review (Pull Request Review).
Nhưng lưu ý: Code review không phải để thể hiện cái tôi hay chê bai người khác. Code review là một cuộc hội thoại, nhằm tìm ra giải pháp tốt nhất và là cơ hội tuyệt vời để chia sẻ kiến thức, hướng dẫn Junior phát triển.

**Senior Detail:** Thay vì nói "Đoạn này viết sai rồi, sửa lại thành XYZ đi", hãy nói: "Nếu chúng ta dùng XYZ ở đây, nó có thể cải thiện hiệu năng khi list dài ra, em nghĩ sao?". Tạo môi trường Psychological Safety là chìa khóa của một team mạnh.

---

## 2. Lời khuyên Google/Dart Style Guide
> "DO comment on WHY, not WHAT."
Trong Code Review, nếu bạn thấy một logic kỳ lạ, hãy hỏi "Tại sao" thay vì kết luận ngay lập tức. Có thể Junior đang giải quyết một edge case mà bạn chưa biết.
> "PREFER positive phrasing."

---

## 3. Nỗi đau Junior: Code ❌ SAI và ✅ ĐÚNG (Khi Review)

### Nỗi đau: Comment quá gắt gao về Format (Nitpicking)
**Ngộ nhận:** Newbie khi mới bắt đầu review PR thường săm soi từng khoảng trắng, dấu phẩy, tên biến. Việc này làm mất thời gian và gây ức chế.

❌ **SAI (Junior Reviewer):**
`"Thừa 1 dấu cách ở dòng 45 kìa. Xoá đi!"`
`"Sao lại đặt tên biến là isCheck? Đổi thành isChecked!"`

✅ **ĐÚNG (Senior Reviewer):**
Sử dụng công cụ tự động. Cấu hình `dart format` và `flutter analyze` chạy trên CI/CD (GitHub Actions). Bất cứ PR nào sai format sẽ tự động fail. Con người KHÔNG NÊN review những thứ máy có thể làm. Hãy dành sức lực để review Logic và Kiến Trúc!
Về tên biến, nếu cần thiết hãy gợi ý nhẹ nhàng: `"Anh nghĩ tên biến 'isVerified' sẽ phản ánh đúng nghiệp vụ (business) hơn là 'isChecked', em thấy sao?"`

### Nỗi đau 2: Bỏ qua việc kiểm tra Side Effects
❌ **SAI:** Chỉ đọc lướt qua xem code có compile được không.
✅ **ĐÚNG:** Senior đọc code và tưởng tượng State sẽ biến đổi thế nào. Đặt các câu hỏi: "Nếu mạng lỗi ở dòng này thì state app đang bị kẹt ở Loading à?", "Cái Stream này lắng nghe xong có bị leak bộ nhớ do chưa close không?"

---

## 4. 🐛 Thử Thách Gỡ Lỗi (Debugging Challenge trong Code Review)

Bạn đang review PR của một bạn Junior. Bạn ấy viết hàm sau để load danh sách User từ API và gán vào list hiển thị.

```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repo;
  
  UserBloc(this.repo) : super(UserInitial()) {
    on<LoadUsersEvent>((event, emit) async {
      emit(UserLoading());
      try {
        List<User> list = await repo.fetchUsers();
        // Bạn Junior sort list trực tiếp
        list.sort((a, b) => a.name.compareTo(b.name));
        emit(UserLoaded(list));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
```
**Nhận xét của bạn là gì?** Đoạn code này nhìn rất bình thường và chạy đúng. Nhưng nó tiềm ẩn một rủi ro về State Immutability (tính bất biến của trạng thái) nếu `repo.fetchUsers()` trả về một List được cache (cùng reference). Gợi ý: Tại sao chúng ta nên làm gì trước khi sort một List nhận từ Repository?

---

## 5. 🚀 System Design Challenge (Dành cho Reviewer)

**Yêu cầu:** Hãy tự xây dựng một `PULL_REQUEST_TEMPLATE.md` cho repository GitHub của dự án hiện tại. 
Trong template, hãy bao gồm các mục (Checklist) để tác giả tự tick trước khi xin review:
- [ ] Code đã được tự test trên máy (iOS & Android).
- [ ] Không có Warning nào từ Linter.
- [ ] Đã thêm Unit Test cho logic mới (nếu có).
- [ ] Hình ảnh chụp màn hình UI thay đổi (nếu có).

---

## Tham khảo
- [Google Engineering Practices - Code Review](https://google.github.io/eng-practices/review/reviewer/)
- [Effective Dart: Usage](https://dart.dev/guides/language/effective-dart/usage)
