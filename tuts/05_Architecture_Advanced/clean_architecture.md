# Bài 1: Clean Architecture - Trái tim của Ứng dụng quy mô lớn

Khi app có trên 20 màn hình và được bảo trì bởi nhiều team, nếu không có kiến trúc rõ ràng, app sẽ trở thành một "bát phở trộn" (Spaghetti code) không thể gỡ nổi. Clean Architecture (Robert C. Martin) là giải pháp tối thượng.

## 1. Clean Architecture là gì?
Nguyên tắc cốt lõi: **Sự phụ thuộc (Dependency) chỉ được trỏ vào trong**. Lớp bên trong không bao giờ được biết về sự tồn tại của lớp bên ngoài.
Nó chia app thành 3 lớp chính:
- **Presentation (UI)**: Chứa Widget, State Management (Riverpod/BLoC). (Bên ngoài cùng)
- **Domain**: Chứa Business Logic cốt lõi (Entities, Use Cases, Repository Interfaces). (Bên trong cùng - Độc lập hoàn toàn với Flutter).
- **Data**: Chứa việc gọi API, Data Models, Database cục bộ.

## 2. Lớp Domain (Trái tim)
Hoàn toàn thuần Dart, không có bất kỳ import nào từ `flutter/material.dart`. 
Bạn sẽ định nghĩa các **Entities** (ví dụ `User`, `Post`) và các **Repository Interfaces**.

```dart
// domain/entities/user.dart
class User {
  final String id;
  final String name;
  User({required this.id, required this.name});
}

// domain/repositories/user_repository.dart
// Lưu ý: Chỉ là Interface (abstract class), không có logic gọi API ở đây!
abstract class UserRepository {
  Future<User> getUserProfile();
}
```

## 3. Lớp Data (Cơ bắp)
Lớp này thực hiện (implements) cái hợp đồng mà Domain yêu cầu.
Nó chứa các **Models** (có extends từ Entities để lấy các hàm `fromJson`) và các **Data Sources** (Dio, Hive).

```dart
// data/repositories/user_repository_impl.dart
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource; // API
  final UserLocalDataSource localDataSource;   // Cache

  UserRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<User> getUserProfile() async {
    if (await isNetworkConnected()) {
      final userModel = await remoteDataSource.fetchUser();
      // Cache lại
      localDataSource.cacheUser(userModel);
      return userModel; // UserModel kế thừa từ User Entity
    } else {
      return localDataSource.getCachedUser();
    }
  }
}
```
> 🧠 **Senior Detail - Single Source of Truth (SSOT)**: Repository Pattern ở đây đóng vai trò che giấu hoàn toàn việc lấy data từ API hay từ Local Cache. Tầng UI chỉ gọi `getUserProfile()`, nó không cần (và không được phép) biết data đến từ đâu.

## 4. Lớp Presentation (Gương mặt)
Sử dụng Riverpod (hoặc BLoC) để lấy data từ UseCases/Repository (thông qua Dependency Injection) và đẩy ra UI. UI hoàn toàn ngu ngốc (Dumb UI), nó chỉ nhận State và vẽ.

## 🛑 Những nỗi đau và ngộ nhận khi còn Junior
- **Nhầm lẫn Model và Entity:** Nhiều bạn lười nên dùng thẳng cái Model chứa hàm `fromJson` (của lớp Data) ném thẳng lên giao diện và gọi nó là Entity. **Hậu quả:** Nếu API đổi tên trường (ví dụ `user_name` thành `fullName`), bạn phải sửa lại toàn bộ giao diện! **Cách phòng tránh:** Entity ở lớp Domain mới là thứ giao diện sử dụng, nó độc lập với cấu trúc JSON của API. Lớp Data có trách nhiệm map từ Model sang Entity.
- **Để logic kinh doanh ở UI:** Tính toán thuế, giỏ hàng ngay trong hàm `onPressed`. **Cách phòng tránh:** Chuyển tất cả logic tính toán này vào các **Use Cases** ở lớp Domain. UI chỉ gọi `ExecuteCheckoutUseCase`.
- **Over-engineering (Làm quá lố):** Áp dụng Clean Architecture cho cái app Todo 1 màn hình. Điều này khiến mất 3 ngày tạo file mà code thực tế chỉ mất 2 tiếng. **Cách phòng tránh:** Chỉ áp dụng Clean Architecture khi dự án có quy mô từ vừa đến lớn, cần maintain lâu dài và làm việc nhóm. App nhỏ chỉ cần chia thư mục theo Features (Feature-first) kết hợp Repository pattern là đủ.

---
---
### 🚀 Mini Pet Project: Bộ khung Clean Architecture (Đăng nhập)

**Yêu cầu:**
1. Tạo cấu trúc thư mục Feature-first: `features/auth/domain`, `features/auth/data`, `features/auth/presentation`.
2. **Domain:** Tạo file `user_entity.dart` (chứa `User` class đơn giản). Tạo file `auth_repository.dart` (chỉ là abstract class có hàm `login()`).
3. **Data:** Tạo file `auth_repository_impl.dart` implement `AuthRepository`. Viết code hardcode trả về `User("admin", "Admin Token")` nếu user nhập đúng "admin/123", sai quăng exception.
4. **Presentation:** Tạo UI Đăng nhập, truyền class Repository trên vào và gọi hàm `login`.

> 🔗 **Tài liệu tham khảo (Ref Docs):**
> - [Clean Architecture - Resocoder Guide](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)
> - [Very Good Ventures - Flutter Architecture](https://verygood.ventures/blog/very-good-flutter-architecture)

*Đừng để bộ khung đe dọa bạn. Hiểu nguyên lý luân chuyển Data -> Domain -> UI là bạn đã làm chủ nó rồi!*
