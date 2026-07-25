import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> login(String email, String password) async {
    // Giả lập gọi API mất 2 giây
    await Future.delayed(const Duration(seconds: 2));
    
    if (email == 'senior@flutter.dev' && password == 'password123') {
      return 'fake-jwt-token-12345';
    } else {
      throw Exception('Sai email hoặc mật khẩu!');
    }
  }

  @override
  Future<void> logout() async {
    // Xóa token ở Local Storage
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
