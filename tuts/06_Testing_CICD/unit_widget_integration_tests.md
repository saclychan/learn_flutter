# Bài 1: Kiểm thử (Testing) & CI/CD - Vũ khí của Senior

Code chạy được chưa phải là code tốt. Code tốt là code chạy được và không bị hỏng khi thằng khác sửa! Để đạt được điều đó, ứng dụng bắt buộc phải có Automated Tests (Kiểm thử tự động).

## 1. Unit Test (Kiểm thử đơn vị)
Test logic của những hàm nhỏ nhất (ví dụ: Validate email, tính tổng tiền, UseCase). Không dính dáng đến UI. Chạy cực kỳ nhanh.

```dart
// file: test/utils/email_validator_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email Validator Tests', () {
    test('Email đúng định dạng phải trả về true', () {
      final result = isValidEmail('luke@jedi.com');
      expect(result, true);
    });

    test('Email sai định dạng phải trả về false', () {
      final result = isValidEmail('darthvader.com');
      expect(result, false);
    });
  });
}
```
> 🧠 **Senior Detail - Mocks (Mocking)**: Khi test một UseCase có gọi API, bạn KHÔNG ĐƯỢC PHÉP gọi API thật. Hãy dùng thư viện `mockito` hoặc `mocktail` để tạo ra một Repository giả (MockRepository), lập trình cho nó trả về data giả và kiểm tra xem UseCase có xử lý đúng data đó không.

## 2. Widget Test (Kiểm thử UI)
Thay vì bấm tay trên máy ảo, Flutter cung cấp Widget Test để tạo ra một môi trường giả lập render UI ngay trong terminal. Rất nhanh và nhẹ.

```dart
testWidgets('Bấm nút tăng số lượng giỏ hàng', (WidgetTester tester) async {
  // Bơm widget vào môi trường test
  await tester.pumpWidget(const MyApp());

  // Tìm nút Add và verify số lượng ban đầu là 0
  expect(find.text('0'), findsOneWidget);
  
  // Giả lập thao tác bấm nút
  await tester.tap(find.byIcon(Icons.add));
  
  // Bắt buộc phải gọi pump để UI render lại frame mới
  await tester.pump(); 

  // Verify số đã tăng lên 1
  expect(find.text('1'), findsOneWidget);
});
```

## 3. Integration Test (Kiểm thử tích hợp)
Kiểm thử toàn bộ luồng (flow) như một người dùng thật trên thiết bị thực (Simulator/Emulator). Rất chậm, nhưng cực kỳ chính xác. Thường chạy vào ban đêm qua CI/CD.

## 4. CI/CD với GitHub Actions
Senior không bao giờ tự build file APK và gửi qua Zalo/Slack cho sếp. Họ cấu hình CI/CD. Cứ mỗi lần push code lên nhánh `main`:
1. CI tự động chạy `flutter analyze` để kiểm tra lỗi cú pháp.
2. Tự động chạy toàn bộ Unit Test.
3. Nếu tất cả đều xanh (Pass), tự động build APK và đẩy lên Firebase App Distribution hoặc TestFlight cho Tester tải về.

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **"Test tốn thời gian, code cho nhanh còn kịp deadline":** Hậu quả là sau 3 tháng, số lượng bug sinh ra còn tốn nhiều thời gian fix hơn cả việc viết test. **Cách phòng tránh:** Tập thói quen viết Unit Test cho những logic kinh doanh lõi, phức tạp (như giỏ hàng, thanh toán).
- **Hardcode kết quả test:** Sửa code test sao cho nó Pass thay vì sửa code thật bị lỗi. Đây là tự lừa dối bản thân!
- **Sợ Mocking:** Mới học test thường rất sợ khái niệm Dependency Injection và Mocking vì nó rối. Nhưng nếu không dùng Mock, khi API sập, Unit Test của bạn cũng fail theo dù code bạn không sai. **Cách phòng tránh:** Ép bản thân học sử dụng `mocktail`. Nó dễ hơn bạn tưởng.

---
---
### 🚀 Mini Pet Project: Bộ Test-Suite Validation (TDD Basic)

**Yêu cầu:**
1. Tạo file `password_validator.dart`. Viết hàm `isValidPassword` TRỐNG (chỉ return false).
2. Viết file `password_validator_test.dart` áp dụng **Test-Driven Development (TDD)**:
   - Test 1: Mật khẩu dưới 8 ký tự -> Phải fail (trả về false).
   - Test 2: Mật khẩu không có chữ hoa -> Phải fail.
   - Test 3: Mật khẩu không có số -> Phải fail.
   - Test 4: Mật khẩu "SuperSecret123" -> Phải pass (trả về true).
3. Chạy test -> Test sẽ fail toàn tập (Red).
4. Quay lại file code thật, viết logic xử lý Regex để thỏa mãn toàn bộ rules.
5. Chạy lại test -> Xanh mướt (Green).

> 🔗 **Tài liệu tham khảo (Ref Docs):**
> - [Flutter Testing Documentation](https://docs.flutter.dev/testing/overview)
> - [Unit Testing Fundamentals](https://docs.flutter.dev/cookbook/testing/unit/introduction)

*TDD (Test-Driven Development) là một cảnh giới cao mà ít Developer dám bước vào. Nhưng một khi quen, bạn sẽ nghiện cảm giác "Màu xanh hi vọng" của Console!*
