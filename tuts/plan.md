# Kế hoạch Học tập Flutter Từ Đầu (Theo roadmap.sh)

Dưới đây là lộ trình chi tiết để học Flutter từ con số không đến mức chuyên nghiệp, dựa trên cấu trúc chuẩn của [roadmap.sh/flutter](https://roadmap.sh/flutter). Lộ trình này được chia thành các giai đoạn để bạn có thể học một cách có hệ thống.

---

## 🚀 Giai đoạn 1: Nền tảng (Fundamentals)

Trước khi đi sâu vào Flutter, bạn cần nắm vững ngôn ngữ Dart và cách thiết lập môi trường.

### 1. Học ngôn ngữ Dart
- **Biến và Kiểu dữ liệu (Variables & Data Types):** `int`, `double`, `String`, `bool`, `List`, `Map`.
- **Luồng điều khiển (Control Flow):** `if/else`, `switch`, `for`, `while`.
- **Hàm (Functions):** Hàm ẩn danh (anonymous functions), arrow functions, tham số tùy chọn/bắt buộc.
- **Lập trình Hướng đối tượng (OOP):** Classes, Objects, Inheritance, Mixins, Interfaces (implements), Abstract classes.
- **Xử lý Bất đồng bộ (Asynchrony):** `Future`, `async/await`, `Stream`.
- **Null Safety:** Hiểu cách Dart xử lý null để tránh lỗi (Sound Null Safety).

### 2. Thiết lập Môi trường (Environment Setup)
- Cài đặt Flutter SDK.
- Cài đặt IDE (VS Code hoặc Android Studio).
- Thiết lập Android Emulator hoặc iOS Simulator.
- Sử dụng Flutter CLI: `flutter create`, `flutter run`, `flutter doctor`, `flutter pub get`.

---

## 🎨 Giai đoạn 2: Cơ bản về UI & Widgets

Widgets là thành phần cốt lõi của Flutter. Mọi thứ trên màn hình đều là Widget.

### 1. Hiểu về Widgets
- **StatelessWidget:** Các widget không thay đổi trạng thái (Text, Icon, v.v.).
- **StatefulWidget:** Các widget có thể thay đổi trạng thái khi tương tác (Checkbox, Slider, Form, v.v.).

### 2. Layouts (Bố cục)
- **Cơ bản:** `Container`, `Row`, `Column`, `Stack`, `Wrap`.
- **Mở rộng & Cuộn:** `Expanded`, `Flexible`, `ListView`, `GridView`, `SingleChildScrollView`.
- **Responsive Design:** Sử dụng `LayoutBuilder`, `MediaQuery` để thiết kế app đa màn hình.

### 3. Design Systems
- **Material Design:** Các widget chuẩn của Android (`Scaffold`, `AppBar`, `FloatingActionButton`, v.v.).
- **Cupertino:** Các widget theo phong cách iOS.

---

## 🧠 Giai đoạn 3: Quản lý Trạng thái (State Management)

Khi ứng dụng lớn lên, việc truyền dữ liệu qua lại giữa các màn hình bằng tham số trở nên khó khăn. Đây là lúc cần State Management.

### 1. Cơ bản
- `setState()`: Dùng cho trạng thái cục bộ đơn giản.
- `InheritedWidget`: Hiểu cách dữ liệu được truyền xuống cây Widget.

### 2. Các thư viện phổ biến (Chọn 1 hoặc 2 để học sâu)
- **Provider:** Lựa chọn tốt cho người mới bắt đầu (được Google khuyên dùng trước đây).
- **Riverpod:** Phiên bản cải tiến của Provider, an toàn hơn và linh hoạt hơn. (Rất được ưa chuộng hiện nay)
- **BLoC (Business Logic Component):** Phù hợp cho các dự án lớn, kiến trúc rõ ràng.
- **GetX:** Cực kỳ dễ học, bao gồm cả quản lý trạng thái, route và dependency injection. Tuy nhiên cần cẩn thận vì nó có thể phá vỡ kiến trúc nếu lạm dụng.

---

## 🌐 Giai đoạn 4: Networking & Lưu trữ Dữ liệu (Data & Storage)

### 1. Làm việc với API
- Gọi REST APIs bằng thư viện `http` hoặc `dio`.
- Xử lý JSON: Sử dụng `json_serializable` hoặc `freezed` để chuyển JSON thành Dart Models.
- Làm việc với WebSockets (nếu cần realtime).

### 2. Lưu trữ cục bộ (Local Storage)
- **Key-Value Store:** `shared_preferences` cho các cài đặt đơn giản (theme, ngôn ngữ, token).
- **Database (SQL & NoSQL):** 
  - `sqflite` (SQLite cho Flutter)
  - `Hive` hoặc `Isar` (NoSQL cực nhanh, dễ dùng).

---

## 🏗️ Giai đoạn 5: Kiến trúc & Các chủ đề Nâng cao (Advanced Topics)

### 1. Kiến trúc ứng dụng (App Architecture)
- Clean Architecture.
- MVVM (Model-View-ViewModel).
- Dependency Injection (sử dụng `get_it`).

### 2. Animation (Chuyển động)
- **Implicit Animations:** `AnimatedContainer`, `AnimatedOpacity`, v.v.
- **Explicit Animations:** `AnimationController`, `Tween`.
- Sử dụng thư viện ngoài như **Lottie** hoặc **Rive** cho các animation phức tạp.

### 3. Flutter Internals
- Hiểu cách Flutter render: Widget Tree, Element Tree, RenderObject Tree.
- Tối ưu hóa hiệu năng (Performance Optimization).

---

## 🧪 Giai đoạn 6: Testing & CI/CD

### 1. Testing
- **Unit Testing:** Kiểm thử các hàm logic, models (không liên quan đến UI).
- **Widget Testing:** Kiểm thử một widget riêng lẻ.
- **Integration Testing:** Kiểm thử toàn bộ luồng ứng dụng trên máy ảo/thiết bị thật.

### 2. CI/CD (Continuous Integration / Continuous Deployment)
- Tự động hóa quá trình test và build sử dụng GitHub Actions, Codemagic, hoặc Bitrise.
- Phân phối ứng dụng qua TestFlight (iOS) hoặc Google Play Console (Android).

---

## 📈 Giai đoạn 7: Analytics & Release

### 1. Analytics & Monitoring
- Tích hợp Firebase Analytics để theo dõi hành vi người dùng.
- Crash Reporting: Sử dụng Firebase Crashlytics hoặc Sentry để theo dõi lỗi khi app đã release.

### 2. Release App
- Chuẩn bị icons, splash screen (sử dụng `flutter_launcher_icons`, `flutter_native_splash`).
- Build file APK/AAB cho Android và IPA cho iOS.
- Public ứng dụng lên Google Play Store và Apple App Store.

---

## 💡 Lời khuyên
- **Thực hành liên tục:** Đừng chỉ đọc/xem tài liệu. Hãy tự xây dựng các mini-project sau mỗi giai đoạn (Ví dụ: App Todo, App Thời tiết, App Quản lý chi tiêu).
- **Đọc code người khác:** Khám phá các open-source Flutter project trên GitHub.
- **Tham gia cộng đồng:** Đặt câu hỏi trên StackOverflow, tham gia Reddit `r/FlutterDev` hoặc các group Flutter trên Facebook/Discord.
