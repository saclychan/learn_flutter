# Unit, Widget & Integration Tests: Kim Tự Tháp Testing

## 1. Giới thiệu: Không Test Không Phải Là Code!
Rất nhiều Junior dev cảm thấy sợ viết Test vì "mất thời gian" và "chỉ chạy code thấy app lên là được". Nhưng khi dự án lớn, bạn sửa một dòng code ở màn hình Profile, màn hình Giỏ Hàng bỗng dưng crash. Đó là lúc bạn ước mình có viết Test.
Testing trong Flutter được chia thành 3 mức độ (Kim tự tháp Testing):
1. **Unit Test:** Rất nhanh, test 1 hàm, 1 class độc lập (Logic, UseCase). Số lượng nhiều nhất.
2. **Widget Test:** Tốc độ trung bình, test UI của 1 hoặc nhiều widget mà không cần chạy app thật trên máy. (Test nút bấm có hiển thị đúng màu, có nhấn được không).
3. **Integration Test:** Chậm nhất, test toàn bộ app trên máy ảo/máy thật, mô phỏng như người dùng đang bấm bấm vuốt vuốt. Số lượng ít nhất.

**Senior Detail:** Ở môi trường production, Integration Test thường được chạy trên các farm device (AWS Device Farm, Firebase Test Lab) để đảm bảo app không bị vỡ giao diện trên các kích thước màn hình khác nhau.

---

## 2. Lời khuyên Google/Dart Style Guide
> "DO structure tests using `group` to group related tests."
Sử dụng `group` giúp kết quả test in ra rõ ràng, dễ đọc hơn khi số lượng test case tăng lên.
> "PREFER strict asserts in tests."

---

## 3. Nỗi đau Junior: Code ❌ SAI và ✅ ĐÚNG

### Nỗi đau: Bơm quá nhiều thứ vào Widget Test
**Ngộ nhận:** Newbie khi viết Widget Test thường gọi luôn `runApp(MyApp())` tức là test nguyên một cục to đùng chứa cả Route, BLoC, DB... dẫn đến lỗi ngập mặt vì thiếu dependencies.

❌ **SAI (Junior Pitfall):**
```dart
testWidgets('Test nút login', (WidgetTester tester) async {
  // Lỗi! MyApp cần rất nhiều Provider, Route, Theme mà ta chưa thiết lập
  await tester.pumpWidget(MyApp()); 
  await tester.tap(find.text('Login'));
});
```

✅ **ĐÚNG (Senior Way - Bơm widget cô lập):**
Chỉ test đúng widget cần test, bọc nó bằng `MaterialApp` để cung cấp đủ môi trường UI cơ bản (Theme, Direction).
```dart
testWidgets('Test nút login chỉ hiển thị đúng', (WidgetTester tester) async {
  // Bọc vào MaterialApp để chạy độc lập
  await tester.pumpWidget(const MaterialApp(
    home: Scaffold(
      body: LoginButton(),
    ),
  ));
  
  expect(find.text('Login'), findsOneWidget);
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle(); // Chờ animation kết thúc
});
```

---

## 4. 🐛 Thử Thách Gỡ Lỗi (Debugging Challenge)

Một bạn Junior viết Widget test kiểm tra Loading Indicator sau khi bấm nút submit, nhưng test cứ báo lỗi: `A Timer is still pending even after the widget tree was disposed.`

```dart
testWidgets('Test loading state', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: AsyncButton()));
  
  await tester.tap(find.byType(ElevatedButton));
  
  // Kiểm tra thấy CircularProgressIndicator
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  
  // Test dừng ở đây và sinh lỗi!
});
```
**Gợi ý:** Khi một widget đang hiển thị loading (thường có một Future hoặc Animation đang chạy ngầm), bạn không thể cứ thế mà kết thúc Test. Flutter đòi hỏi Test phải clean up sạch sẽ mọi trạng thái đang lơ lửng. Hàm `tester.pumpAndSettle()` có tác dụng gì? Hoặc bạn cần đợi Future hoàn thành?

---

## 5. 🚀 Mini Pet Project

**Yêu cầu:** 
Tạo một app "Todo" siêu nhỏ gọn.
1. Viết **Unit Test** cho class `TodoBloc` hoặc `TodoViewModel`: Thêm 1 item, đếm số lượng trả về 1.
2. Viết **Widget Test** cho `TodoListScreen`: Cung cấp mảng có 3 todos giả, verify rằng giao diện hiển thị đúng 3 cái thẻ `ListTile` trên màn hình.
3. Viết **Integration Test** (sử dụng thư viện `integration_test`): Chạy app, nhập vào TextField chữ "Ăn sáng", bấm nút Add, verify cuộn màn hình và thấy chữ "Ăn sáng".

---

## Tham khảo
- [Flutter Testing](https://flutter.dev/docs/testing)
- [integration_test package](https://docs.flutter.dev/testing/integration-tests)
