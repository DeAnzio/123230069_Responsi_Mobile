import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import 'show_detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: Obx(() {
        final controller = Get.find<FavoriteController>();
        final favorites = controller.favorites;

        if (favorites.isEmpty) {
          return const Center(child: Text('Belum ada show favorit.'));
        }

        return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final game = favorites[index];
              final imageUrl = game['image']?['medium'] as String?;
              final rating = game['rating']?['average']?.toString() ?? '-';

              return Card(
                elevation: 0,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 56,
                      height: 76,
                      child: imageUrl == null
                          ? const ColoredBox(
                              color: Colors.black12,
                              child: Icon(Icons.image_not_supported_outlined),
                            )
                          : Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  title: Text(game['name'] as String),
                  subtitle: Text('Rating: $rating'),
                  onTap: () {
                    Get.to(() => GameDetailPage(gameId: game['id'] as int));
                  },
                  trailing: IconButton(
                    onPressed: () =>
                        controller.removeFavorite(game['id'] as int),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ),
              );
            },
        );
      }),
    );
  }
}
