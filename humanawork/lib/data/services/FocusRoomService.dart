import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:humanawork/models/SalaFoco.dart';

class FocusRoomService {
  static const baseUrl = 'http://localhost:8080/api/salas';

  static Future<List<SalaFoco>> listarSalas() async {
    final resp = await http.get(Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'});
    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return data.map((e) => SalaFoco.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao listar salas: ${resp.statusCode}');
    }
  }

  static Future<SalaFoco> buscarSala(int id) async {
    final resp = await http.get(Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'});
    if (resp.statusCode == 200) {
      return SalaFoco.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception('Erro ao buscar sala: ${resp.statusCode}');
    }
  }
}
