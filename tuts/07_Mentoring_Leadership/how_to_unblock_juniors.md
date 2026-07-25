# Unblocking Juniors: Nghệ Thuật Dẫn Dắt Đội Ngũ

## 1. Giới thiệu: Từ Thợ Code Sang Người Trưng Bày
Làm Senior không chỉ là việc code giỏi. Sức mạnh thực sự của một Senior/Mentor là khả năng làm cho những người xung quanh giỏi lên (Force Multiplier). Khi một Junior bị "kẹt" (blocked) cả ngày trời ở một bug, việc bạn bay vào gõ rào rào fix trong 5 phút và đi ra KHÔNG GIÚP ÍCH gì cho họ. Lần sau họ sẽ lại kẹt.
Nhiệm vụ của bạn là **Unblock**: Khai thông bế tắc bằng cách đặt câu hỏi, hướng dẫn họ cách tự tư duy tìm ra giải pháp.

**Senior Detail:** Khái niệm "Rubber Duck Debugging" (Giải thích code cho con vịt cao su). Thường khi Junior đang kẹt, chỉ cần bạn ngồi im nghe họ giải thích từng dòng code họ đang viết, họ sẽ TỰ ĐỘNG nhận ra chỗ sai mà bạn chưa cần nói chữ nào!

---

## 2. Lời khuyên Google/Dart Style Guide (Về Document)
> "DO format comments like sentences."
Khi bạn viết tài liệu hoặc comment giải thích thuật toán cho Junior, hãy viết như một câu văn đàng hoàng, có chủ ngữ vị ngữ, viết hoa đầu dòng, chấm cuối câu. Điều này rèn luyện sự chuyên nghiệp và minh bạch trong giao tiếp.

---

## 3. Nỗi đau Junior: Code ❌ SAI và ✅ ĐÚNG (Dành cho Mentor)

### Nỗi đau: Đưa ra đáp án ngay lập tức (Spoon-feeding)
**Ngộ nhận:** Mentor nghĩ rằng giải quyết nhanh bug cho Junior sẽ giúp dự án đi nhanh hơn.

❌ **SAI (Bad Mentor):**
Junior: "Anh ơi, cái list của em tự dưng bị RenderFlex Overflow, tràn màn hình dưới đáy."
Mentor: "À, em bọc cái ListView vào trong `Expanded` là xong, làm đi." (Junior làm theo, fix được, nhưng không hiểu tại sao).

✅ **ĐÚNG (Good Mentor - Socratic Method):**
Junior: "Anh ơi, cái list bị Overflow..."
Mentor: "Em dùng Widget Inspector chưa? Em thấy ListView đang nằm trong Widget nào?"
Junior: "Nằm trong Column anh ạ."
Mentor: "Ok, Column yêu cầu các con của nó có kích thước nhất định. Nhưng ListView mặc định lại muốn kéo dài vô hạn. Vậy 2 đứa này đánh nhau. Theo em làm sao để báo cho ListView biết nó chỉ được chiếm phần không gian *còn lại* của Column?"
Junior: "À, em thử dùng Expanded nhé!" 

### Nỗi đau 2: Bỏ mặc Junior tự bơi quá lâu
❌ **SAI:** Quẳng một task quá khó và nói "Tự search Google đi".
✅ **ĐÚNG:** Time-boxing. Giao task kèm theo quy định: "Em hãy tự tìm hiểu trong tối đa 2 tiếng. Nếu quá 2 tiếng không ra giải pháp nào khả thi, phải báo anh ngay để cùng tháo gỡ, không được ngồi kẹt mãi."

---

## 4. 🐛 Thử Thách Gỡ Lỗi (Debugging Challenge)

Một bạn Junior hỏi bạn: "Em gọi setState() rồi mà biến số đếm trên màn hình không chịu cập nhật, em in `print` thì biến vẫn tăng". Bạn vào xem code:

```dart
class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int count = 0;

  void increment() {
    count++;
    setState(() {
      // Gọi setState ở đây
    });
  }

  @override
  Widget build(BuildContext context) {
    return CounterDisplay(count: count);
  }
}

// Widget hiển thị
class CounterDisplay extends StatelessWidget {
  CounterDisplay({this.count = 0}); // 🚨 Cảnh báo!
  
  final int count;
  
  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}
```
**Câu hỏi Unblock:** Bạn sẽ hỏi bạn Junior câu hỏi gì để bạn ấy nhận ra lỗi sai ở constructor của `CounterDisplay`? (Gợi ý liên quan đến biến final và cách Dart gán giá trị mặc định / truyền tham số).

---

## 5. 🚀 System Design Challenge (Dành cho Mentorship)

**Yêu cầu:** Lên kế hoạch cho buổi "Pair Programming" tuần tới với Junior.
Hãy soạn một document ngắn 1 trang:
1. Chủ đề buổi Pair: Refactor một màn hình cũ từ setState sang dùng BLoC.
2. Mục tiêu: Junior hiểu luồng Event -> State.
3. Phân chia vai trò: Ai làm Driver (người gõ phím), ai làm Navigator (người hướng dẫn). 
*Gợi ý:* Hãy để Junior làm Driver, bạn làm Navigator chỉ dẫn đường, tuyệt đối không giằng lấy bàn phím!

---

## Tham khảo
- [Pair Programming Guide](https://martinfowler.com/articles/on-pair-programming.html)
- [Psychological Safety in Tech Teams](https://rework.withgoogle.com/print/guides/5721312655835136/)
