abstract class AuthRepository {
  /// Đăng nhập bằng email và password, trả về token nếu thành công.
  Future<String> login(String email, String password);
  
  /// Đăng xuất khỏi hệ thống
  Future<void> logout();
}
