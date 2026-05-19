import 'dart:convert';

import 'package:http/http.dart' as http;

class TvMazeService {
  static const _baseUrl = 'https://www.freetogame.com/api';

  static Future<List<dynamic>> fetchGames() async {
    final response = await http.get(Uri.parse('$_baseUrl/games'));

    if (response.statusCode != 200) {
       throw Exception('Gagal mengambil daftar game');
    }

    return jsonDecode(response.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> fetchGameDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/games/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil detail game');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
