import 'package:hive/hive.dart';

class FavoriteService {
  static Box get _box => Hive.box('favorites');

  static String _favoriteKey(String username, int id) => '$username:$id';

  static List<Map<String, dynamic>> getFavorites(String username) {
    return _box.values
        .map((item) => Map<String, dynamic>.from(item as Map))
        .where((item) => item['username'] == username)
        .toList();
  }

  static bool isFavorite(String username, int id) {
    return _box.containsKey(_favoriteKey(username, id));
  }

  static Future<void> addFavorite(
    String username,
    Map<String, dynamic> show,
  ) async {
    await _box.put(_favoriteKey(username, show['id'] as int), {
      'username': username,
      'id': show['id'],
      'name': show['name'],
      'image': show['image'],
      'rating': show['rating'],
    });
  }

  static Future<void> removeFavorite(String username, int id) async {
    await _box.delete(_favoriteKey(username, id));
  }
}
