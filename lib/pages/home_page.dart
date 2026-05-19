import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'show_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Games')),
      body: Obx(() {
        final controller = Get.find<HomeController>();

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text('Terjadi kesalahan: ${controller.errorMessage.value}'),
          );
        }

        final games = controller.games;

                return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: games.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final game = games[index];
              final imageUrl = game['thumbnail'] as String?;
              final genre = game['genre'] as String?;
              final platform = game['platform'] as String?;

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
                  title: Text(game['title'] as String),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Genre: $genre'),
                      Text('Platform: $platform'),
                    ],
                  ),
                  onTap: () {
                    Get.to(() => GameDetailPage(gameId: game['id'] as int));
                  },
                ),
              );
            },
        );
      }),
    );
  }
}
