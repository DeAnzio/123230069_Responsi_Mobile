import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../controllers/game_detail_controller.dart';

class GameDetailPage extends StatelessWidget {
  const GameDetailPage({super.key, required this.gameId});

  final int gameId;

  String _stripHtml(String value) {
    return value.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&amp;', '&');
  }

  Future<void> _toggleFavorite(
    Map<String, dynamic> game,
    FavoriteController favoriteController,
  ) async {
    final id = game['id'] as int;
    if (favoriteController.isFavorite(id)) {
      await favoriteController.removeFavorite(id);
    } else {
      await favoriteController.addFavorite(game);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailController = Get.put(
      GameDetailController(gameId),
      tag: gameId.toString(),
    );
    final favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Game')),
      body: Obx(() {
        if (detailController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (detailController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              'Terjadi kesalahan: ${detailController.errorMessage.value}',
            ),
          );
        }

        final game = detailController.game;
        final imageUrl = game['thumbnail'] as String?;
        final date = game['release_date'] as String? ?? '-';
        final genres = (game['genre'] as String?)?.split(',').join(', ') ?? '-';
        final dev = (game['developer'] as String?)?.split(',').join(', ') ?? '-';
        final pub = (game['publisher'] as String?)?.split(',').join(', ') ?? '-';
        final summary =
            _stripHtml(game['short_description'] as String? ?? 'Belum ada ringkasan.');
        final isFavorite = favoriteController.isFavorite(game['id'] as int);

        return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 0.72,
                    child: imageUrl == null
                        ? const ColoredBox(
                            color: Colors.black12,
                            child: Icon(Icons.image_not_supported_outlined),
                          )
                        : Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        game['title'] as String,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => _toggleFavorite(game, favoriteController),
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Text('release date'),
                    const SizedBox(width: 10),
                    Text('publisher'),
                    const SizedBox(width: 10),
                    Text('Developer')
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 6),
                    Text('$date'),
                    const SizedBox(width: 6),
                    Text('$dev'),
                    const SizedBox(width: 6),
                    Text('$pub')
                  ],
                ),
                const SizedBox(height: 8),
                Text('Genre: ${genres.isEmpty ? '-' : genres}'),
                const SizedBox(height: 20),
                Text('Overview', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(summary),
              ],
            ),
        );
      }),
    );
  }
}
