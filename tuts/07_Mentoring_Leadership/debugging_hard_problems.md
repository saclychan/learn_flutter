# Debugging Hard Problems: Gỡ Rối Những Ca Khó Nhằn

## 1. Giới thiệu: Phép Màu của Kỹ Năng Debug
Ai cũng có thể gõ code khi mọi thứ suôn sẻ. Nhưng khi app crash liên tục trên máy khách hàng, không hiện lỗi trên log, và không thể tái hiện trên máy dev — đó là lúc trình độ của Senior lên tiếng.
Debugging không phải là đoán mò. Nó là khoa học. Kỹ năng chia để trị (Divide and Conquer), đọc Stacktrace, hiểu cơ chế GC (Garbage Collection) và Threading là những vũ khí tối thượng.

**Senior Detail:** Đừng bao giờ in ra lỗi bằng `print(e)`. Hãy dùng `log()` từ `dart:developer` hoặc Firebase Crashlytics để đính kèm toàn bộ Stacktrace. Nếu không có Stacktrace, bạn đang mò kim đáy bể.

---

## 2. Lời khuyên Google/Dart Style Guide
> "AVOID catching `Error` or types that implement it."
Trong Dart, `Exception` là những ngoại lệ mà bạn dự tính trước (VD: Lỗi mạng `SocketException`), bạn CÓ THỂ catch và xử lý. Còn `Error` (như `RangeError`, `OutOfMemoryError`) là những lỗi nghiêm trọng do code sai (bug), bạn KHÔNG NÊN catch nó mà hãy để app crash rồi vào log sửa tận gốc bug đó.

---

## 3. Nỗi đau Junior: Code ❌ SAI và ✅ ĐÚNG

### Nỗi đau: Bắt mọi lỗi và... ỉm đi (Swallowing Exceptions)
**Ngộ nhận:** Newbie rất sợ app bị văng (crash) nên thường bọc `try...catch` ở mọi nơi, và chừa phần catch... trống trơn!

❌ **SAI (Junior Pitfall):**
```dart
Future<void> syncData() async {
  try {
    await database.updateRecords();
    await api.pushToServer();
  } catch (e) {
    // Không làm gì cả! Hoặc chỉ print nhẹ.
    // Hậu quả: Dữ liệu hỏng nhưng app vẫn chạy như không có chuyện gì, không ai biết để fix.
  }
}
```

✅ **ĐÚNG (Senior Way):**
Xử lý đúng loại Exception cần thiết. Nếu không xử lý được, hãy rethrow (ném lại) hoặc log lên Crashlytics.
```dart
Future<void> syncData() async {
  try {
    await database.updateRecords();
    await api.pushToServer();
  } on SocketException catch (e) {
    // Chỉ xử lý lỗi mạng (Báo UI hiện snackbar mất mạng)
    emit(SyncOfflineState());
  } catch (e, stackTrace) {
    // Các lỗi không lường trước: Báo cáo Crashlytics và ném tiếp
    FirebaseCrashlytics.instance.recordError(e, stackTrace);
    rethrow; 
  }
}
```

---

## 4. 🐛 Thử Thách Gỡ Lỗi (Debugging Challenge)

Bạn nhận được một ticket khẩn: "Màn hình Chat đôi khi bị đơ cứng, không thể cuộn, cũng không thể ấn nút". Bạn vào check log không thấy app báo crash gì. 
Bạn nhìn vào đoạn code parse JSON từ Socket trả về:

```dart
void onMessageReceived(String payload) {
  // Payload này rất lớn, chứa danh sách hàng ngàn tin nhắn
  final Map<String, dynamic> data = jsonDecode(payload); 
  
  // Update state UI
  setState(() {
    messages.addAll(parseMessages(data));
  });
}
```
**Vấn đề ở đâu?** Nếu app không crash mà bị đơ (Freeze), thủ phạm thường là gì? `jsonDecode` là hàm đồng bộ (synchronous). Khi parse string rất lớn, nó sẽ block (chặn) điều gì? Làm sao để sửa lỗi này mà không cần thư viện ngoài?

---

## 5. 🚀 System Design Challenge

**Yêu cầu:** Thiết lập một cơ chế "Global Error Handler" (Bắt mọi lỗi của app) trong hàm `main()`.
Thay vì để app hiện màn hình xám xịt báo lỗi (Red Screen of Death) khi có exception chưa được catch, hãy cấu hình `FlutterError.onError` và `PlatformDispatcher.instance.onError` để:
1. Ghi log lỗi ra console đẹp đẽ.
2. Hiển thị một giao diện tự thiết kế (Fallback UI) thân thiện thông báo "Đã có lỗi bất ngờ, xin thử lại sau" thay vì màn hình đỏ chữ vàng doạ người dùng.
3. Thử nghiệm bằng cách quăng một `Exception('Test')` ngẫu nhiên trong 1 button.

---

## Tham khảo
- [Flutter: Error handling](https://docs.flutter.dev/testing/errors)
- [dart:developer log function](https://api.flutter.dev/flutter/dart-developer/log.html)
