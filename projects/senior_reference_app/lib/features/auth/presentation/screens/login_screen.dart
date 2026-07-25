import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';

// Provider cho Repository (Dependency Injection)
final authRepositoryProvider = Provider((ref) => AuthRepositoryImpl());

// StateNotifier để quản lý state của màn hình Login
class AuthNotifier extends StateNotifier<AsyncValue<String?>> {
  final AuthRepositoryImpl repository;

  AuthNotifier(this.repository) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final token = await repository.login(email, password);
      state = AsyncValue.data(token);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<String?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    // Lắng nghe sự kiện (side-effects) như hiển thị Snackbar khi lỗi
    ref.listen<AsyncValue<String?>>(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
        data: (token) {
          if (token != null) {
             ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đăng nhập thành công! 🎉')),
             );
          }
        }
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Senior Login')),
      body: Center(
        child: authState.isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).login('senior@flutter.dev', 'password123');
                },
                child: const Text('Login as Senior'),
              ),
      ),
    );
  }
}
