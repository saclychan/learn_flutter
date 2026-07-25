# Hiệu Năng Flutter Engine: Dưới Mái Hiên Của Một Senior

## 1. Giới thiệu: Không chỉ là UI, hãy hiểu cả Engine!
Khi làm quen với Flutter, ai cũng bị mê hoặc bởi việc tạo UI quá nhanh và đẹp. Tuy nhiên, khi app của bạn có hàng nghìn phần tử list, animations phức tạp, tự nhiên app bị "giật lag" (Jank).
Đến lúc này, việc chỉ biết gõ Widget là không đủ. Bạn cần hiểu Flutter Engine hoạt động như thế nào: từ Skia/Impeller, Render Object, Element Tree cho đến các Thread (UI Thread, Raster Thread).

**Senior Detail:** Flutter 3.x đã bắt đầu chuyển từ Skia sang Impeller (đặc biệt trên iOS) để loại bỏ Shader Compilation Jank (hiện tượng khựng khung hình khi load animation lần đầu).

---

## 2. Lời khuyên Google/Dart Style Guide
> "Use `const` constructors where possible."
Đây là lời khuyên kinh điển. Bằng cách dùng `const`, widget của bạn được compile lúc gõ code (compile-time) và không bao giờ bị rebuild (re-instantiated) khi cây widget cha thay đổi. Điều này giúp giảm tải đáng kể cho Garbage Collector và Element Tree.

---

## 3. Nỗi đau Junior: Code ❌ SAI và ✅ ĐÚNG

### Nỗi đau 1: Quên "const" ở những widget tĩnh
**Ngộ nhận:** Newbie nghĩ rằng Dart sẽ tự tối ưu các widget không có tham số truyền vào.
**Hậu quả:** Khi setState gọi ở widget cha, toàn bộ widget con bị khởi tạo lại dù chúng chỉ là các Text tĩnh.

❌ **SAI (Junior Pitfall):**
```dart
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Title'), // Không có const!
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.star), // Không const nốt!
      ),
      ElevatedButton(
        onPressed: () => setState(() => count++),
        child: Text('Count: $count'),
      )
    ],
  );
}
```

✅ **ĐÚNG (Senior Way):**
```dart
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      const Text('Title'), 
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.star),
      ),
      ElevatedButton(
        onPressed: () => setState(() => count++),
        child: Text('Count: $count'), // Cái này thay đổi thì không const được, chuẩn rồi!
      )
    ],
  );
}
```

### Nỗi đau 2: Chặn UI Thread (Main Isolate) bằng tác vụ nặng
❌ **SAI:**
```dart
Future<void> processData() async {
  // Parse một file JSON 10MB ngay trên UI thread!
  final data = jsonDecode(hugeJsonString); 
}
```
✅ **ĐÚNG:**
Sử dụng `compute` hoặc `Isolate.run` để đẩy việc nặng sang Isolate khác, tránh rớt khung hình (Jank).
```dart
Future<void> processData() async {
  final data = await compute(jsonDecode, hugeJsonString); 
}
```

---

## 4. 🐛 Thử Thách Gỡ Lỗi (Debugging Challenge)

Đoạn code sau đây sử dụng `ListView.builder` nhưng lại gặp vấn đề về hiệu năng bộ nhớ khi cuộn. Bạn có biết tại sao không?

```dart
Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: 1000,
    itemBuilder: (context, index) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: Image.network(
            'https://example.com/high_res_image_$index.jpg',
            // Quên gì ở đây nhỉ?
          ),
        ),
      );
    },
  );
}
```
**Gợi ý:** Ảnh độ phân giải cao sẽ ngốn RAM như thế nào nếu Flutter phải decode nguyên kích thước gốc? Hãy tìm hiểu về tham số `cacheWidth` hoặc `cacheHeight` của `Image.network`! Thêm vào đó, `ClipRRect` rất đắt về mặt render (saveLayer), có cách nào dùng `BoxDecoration` để bo tròn ảnh không?

---

## 5. 🚀 Mini Pet Project

**Yêu cầu:** Viết một màn hình có một danh sách 10,000 phần tử. 
1. Sử dụng Flutter DevTools (Performance tab) để đo số khung hình.
2. Cố tình gây lag bằng cách parse JSON nặng mỗi khi cuộn, quan sát Raster thread và UI thread bị nghẽn.
3. Fix lag bằng `compute` và `const`, chụp lại biểu đồ Performance trước và sau khi tối ưu.

---

## Tham khảo
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Impeller Rendering Engine](https://docs.flutter.dev/perf/impeller)
