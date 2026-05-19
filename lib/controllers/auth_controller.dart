import 'package:get/get.dart';

import '../pages/login_page.dart';
import '../pages/main_navigation_page.dart';
import '../pages/register_page.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final username = ''.obs;

  Future<bool> checkSession() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) {
      await loadUsername();
    }
    return loggedIn;
  }

  Future<void> login(String usernameInput, String passwordInput) async {
    if (usernameInput.trim().isEmpty || passwordInput.trim().isEmpty) {
      Get.snackbar('Login gagal', 'Username dan password wajib diisi');
      return;
    }

    isLoading.value = true;
    final success = await AuthService.login(usernameInput, passwordInput);
    isLoading.value = false;

    if (!success) {
      Get.snackbar('Login gagal', 'Username atau password salah');
      return;
    }

    username.value = usernameInput.trim();
    Get.offAll(() => const MainNavigationPage());
  }

  Future<void> register(String usernameInput, String passwordInput) async {
    if (usernameInput.trim().isEmpty || passwordInput.trim().isEmpty) {
      Get.snackbar('Register gagal', 'Username dan password wajib diisi');
      return;
    }

    isLoading.value = true;
    final success = await AuthService.register(usernameInput, passwordInput);
    isLoading.value = false;

    if (!success) {
      Get.snackbar('Register gagal', 'Username sudah digunakan');
      return;
    }

    Get.snackbar('Register berhasil', 'Silakan login dengan akun baru');
    Get.off(() => const LoginPage());
  }

  Future<void> loadUsername() async {
    username.value = await AuthService.getUsername();
  }

  Future<void> logout() async {
    await AuthService.logout();
    username.value = '';
    Get.offAll(() => const LoginPage());
  }

  void goToRegister() {
    Get.to(() => const RegisterPage());
  }
}
