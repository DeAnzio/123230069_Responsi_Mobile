import 'package:get/get.dart';

import 'auth_controller.dart';
import '../services/favorite_service.dart';

class FavoriteController extends GetxController {
  final favorites = <Map<String, dynamic>>[].obs;
  AuthController get _authController => Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    refreshFavorites();
    ever(_authController.username, (_) => refreshFavorites());
  }

  void refreshFavorites() {
    final username = _authController.username.value;
    if (username.isEmpty) {
      favorites.clear();
      return;
    }

    favorites.assignAll(FavoriteService.getFavorites(username));
  }

  bool isFavorite(int id) => favorites.any((game) => game['id'] == id);

  Future<void> addFavorite(Map<String, dynamic> game) async {
    await FavoriteService.addFavorite(_authController.username.value, game);
    refreshFavorites();
  }

  Future<void> removeFavorite(int id) async {
    await FavoriteService.removeFavorite(_authController.username.value, id);
    refreshFavorites();
  }
}
