import 'package:get/get.dart';

import '../services/games_service.dart';

class GameDetailController extends GetxController {
  GameDetailController(this.gameId);

  final int gameId;
  final game = <String, dynamic>{}.obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      isLoading.value = true;
      game.assignAll(await GamesService.fetchGameDetail(gameId));
      errorMessage.value = '';
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
