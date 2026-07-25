# Bài 1: Quản lý trạng thái với Riverpod (Masterclass)

Là một Senior, bạn sẽ đối mặt với các bài toán quản lý state cực kỳ phức tạp: caching, retry khi lỗi, phân trang (pagination), và kết hợp nhiều state với nhau. Riverpod là công cụ hoàn hảo để giải quyết những việc này.

## 1. Tại sao lại là Riverpod?
Riverpod được sinh ra để khắc phục điểm yếu của Provider (ví dụ: `ProviderNotFoundException`). Nó cung cấp sự an toàn tại thời điểm biên dịch (Compile-safe) và hiệu năng tuyệt vời.

## 2. Các loại Provider thông dụng
- **Provider**: Cung cấp một giá trị không đổi (VD: Cấu hình, Repository, HttpClient).
- **StateProvider**: (Sắp bị thay thế bởi Notifier, nhưng vẫn thông dụng cho các state đơn giản như số nguyên, boolean).
- **FutureProvider**: Quản lý state của một tác vụ bất đồng bộ (Gọi API). Cực kỳ mạnh mẽ với thuộc tính `.when(data:, loading:, error:)`.
- **NotifierProvider / AsyncNotifierProvider**: (Chuẩn mới từ Riverpod 2.0). Quản lý state phức tạp cần logic thay đổi state nằm bên trong class Notifier.

## 3. Code Senior: AsyncNotifierProvider
Đừng dùng `FutureProvider` nếu bạn cần *thay đổi* (mutate) data sau khi load (VD: Thêm item vào danh sách). Hãy dùng `AsyncNotifierProvider`.

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Tạo Class Notifier
class TodoListNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    // Trạng thái initial loading
    return await fetchTodosFromApi();
  }

  Future<void> addTodo(String todo) async {
    // Chuyển sang loading state tạm thời
    state = const AsyncValue.loading();
    
    // Gọi API lưu data
    state = await AsyncValue.guard(() async {
      await saveTodoToApi(todo);
      // Lấy danh sách cũ
      final currentList = state.value ?? [];
      // Trả về danh sách mới
      return [...currentList, todo];
    });
  }
}

// 2. Tạo Provider
final todoListProvider = AsyncNotifierProvider<TodoListNotifier, List<String>>(
  () => TodoListNotifier(),
);
```

> 🧠 **Senior Detail - `AsyncValue.guard`**: Thay vì viết khối `try-catch` nhàm chán và tự gán `AsyncValue.error` khi có lỗi, hãy dùng hàm `guard`. Nó giúp rút ngắn 10 dòng code xuống còn 3 dòng!

## 4. Lắng nghe Provider trong UI
Sử dụng `ConsumerWidget` thay vì `StatelessWidget`.

```dart
class TodoScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch tự động rebuild widget khi state thay đổi
    final todoState = ref.watch(todoListProvider);

    return Scaffold(
      body: todoState.when(
        data: (todos) => ListView.builder(
          itemCount: todos.length,
          itemBuilder: (c, i) => Text(todos[i]),
        ),
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Dùng ref.read khi xử lý event (click button)
          ref.read(todoListProvider.notifier).addTodo('New Task');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Dùng `ref.read` bên trong hàm `build`:** Rất nhiều Junior lấy lý do "Em chỉ cần đọc 1 lần nên dùng `ref.read` trong hàm build". **Hậu quả:** App không cập nhật UI khi data thay đổi. **Cách phòng tránh:** Mặc định luôn dùng `ref.watch` trong hàm `build`. Chỉ dùng `ref.read` trong các callback (onPressed, onTap...).
- **Cơn ác mộng Memory Leak:** Khởi tạo provider nhưng quên giải phóng data. Nếu user ra vào màn hình 10 lần, API gọi 10 lần và lưu 10 mảng data trong RAM. **Cách phòng tránh:** Sử dụng `.autoDispose` (VD: `FutureProvider.autoDispose`). Riverpod sẽ tự động dọn rác khi không còn ai lắng nghe.
- **Render nguyên cái màn hình bự:** Đặt `ref.watch` ở cấp cao nhất của màn hình, dù chỉ 1 dòng chữ thay đổi thì toàn bộ màn hình bị rebuild (thụt FPS). **Cách phòng tránh:** Hãy dùng widget `Consumer` bọc quanh đúng cái Text/Widget cần thay đổi, hoặc tách component nhỏ ra thành `ConsumerWidget` riêng.

---
---
### 🚀 Mini Pet Project: App Quản lý To-do List (Riverpod AsyncNotifier)

**Yêu cầu:**
1. Tạo một `AsyncNotifierProvider` quản lý danh sách việc cần làm (List<String>).
2. Viết hàm `fetchTodos` giả lập gọi API (dùng `Future.delayed` 2 giây) trả về 3 công việc mẫu.
3. Viết UI hiển thị danh sách sử dụng `todoState.when()`. Khi đang load, hiển thị vòng xoay.
4. Thêm nút "Xóa", khi bấm gọi hàm `removeTodo()` trong Notifier, giả lập gọi API xóa 1 giây, sau đó dùng `AsyncValue.guard` update lại state mới.

> 🔗 **Tài liệu tham khảo (Ref Docs):**
> - [Riverpod Official Documentation - AsyncNotifier](https://riverpod.dev/docs/providers/notifier_provider)
> - [Riverpod Architecture & Best Practices](https://riverpod.dev/docs/concepts/architecture)

*Làm chủ được AsyncNotifierProvider là bạn đã chính thức bước một chân vào hàng ngũ Senior Flutter rồi đó!*
