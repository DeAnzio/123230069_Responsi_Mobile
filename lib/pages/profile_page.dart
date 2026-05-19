import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>()..loadUsername();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 34,
                        child: Icon(Icons.person, size: 36),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.username.value.isEmpty
                            ? '...'
                            : controller.username.value,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Card(
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Kesan & pesan: Praktikum nya seru bat mas , banyak ilmu yang saya & temen temen dapet dari praktikum ini , semoga kedepannya bisa lebih seru lagi dan bisa dapet nilai A amin',
                  ),
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: controller.logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
