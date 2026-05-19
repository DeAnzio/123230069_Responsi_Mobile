import 'package:get/get.dart';

import '../services/tvmaze_service.dart';

class HomeController extends GetxController {
  final games = <dynamic>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGames();
  }

  Future<void> fetchGames() async {
    try {
      isLoading.value = true;
      games.assignAll(await TvMazeService.fetchGames());
      errorMessage.value = '';
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
