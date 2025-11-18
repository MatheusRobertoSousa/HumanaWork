import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String? _token;
  static int? _userId;
  static String? _userName; // Variável estática para armazenar o nome
  static const String baseUrl = 'http://10.0.2.2:8080';

  // Getters para uso nas telas
  static String? get userName => _userName;
  static int? get userId => _userId;

  // ----------------- Auth -----------------
  static Future<bool> login(String email, String senha) async {
    final uri = Uri.parse('$baseUrl/api/auth/login');
    final resp = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}));

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      
      // ✅ ATUALIZAÇÃO CRÍTICA: Captura todos os campos
      _token = data['token'] as String?;
      _userId = data['userId'] != null ? (data['userId'] as num).toInt() : null;
      _userName = data['userName'] as String?; // 👈 Chave 'userName' deve ser exata!

      return true;
    } else {
      return false;
    }
  }

  static Map<String, String> _authHeaders() {
    if (_token == null) return {'Content-Type': 'application/json'};
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'};
  }

  // ----------------- Checkin -----------------
  static Future<bool> enviarCheckin({
    required int humor,
    required double energia,
    required String focoDia,
  }) async {
    final uri = Uri.parse('$baseUrl/api/checkins');
    final body = {
      'humor': humor,
      'energia': energia.toInt(),
      'focoDia': focoDia,
    };
    final resp = await http.post(uri, headers: _authHeaders(), body: jsonEncode(body));
    return resp.statusCode == 200;
  }

  // ----------------- Start session -----------------
static Future<int?> iniciarSessaoFoco({
  required int idSala,
  required String objetivo,
}) async {
  final uri = Uri.parse('$baseUrl/api/sessoes/iniciar');

  final body = {
    'idUsuario': _userId,
    'idSala': idSala,
    'objetivo': objetivo,
  };

  final resp = await http.post(
    uri,
    headers: _authHeaders(),
    body: jsonEncode(body),
  );

  if (resp.statusCode == 200) {
    return (jsonDecode(resp.body) as num).toInt();
  }

  print('Erro ao iniciar sessão: ${resp.statusCode} - ${resp.body}');
  return null;
}

static Future<bool> encerrarSessaoFoco(int idSessao) async {
  final uri = Uri.parse('$baseUrl/api/sessoes/encerrar/$idSessao');

  final resp = await http.post(uri, headers: _authHeaders());

  return resp.statusCode == 200 || resp.statusCode == 204;
}

  // ----------------- Focus rooms -----------------
static Future<List<Map<String, dynamic>>> listarSalas() async {
  final uri = Uri.parse('$baseUrl/api/salas');
  final resp = await http.get(uri, headers: _authHeaders());

  if (resp.statusCode == 200) {
    final list = jsonDecode(resp.body);
    return List<Map<String, dynamic>>.from(list);
  }

  return [];
}

static Future<Map<String, dynamic>?> criarSala({
  required String nomeSala,
  required String descricao,
  required String tema,
}) async {
  final uri = Uri.parse('$baseUrl/api/salas');
  final body = {
    'nomeSala': nomeSala,
    'descricao': descricao,
    'tema': tema,
    // 'criadaPor' é geralmente setado automaticamente
  };

  final resp = await http.post(
    uri,
    headers: _authHeaders(), 
    body: jsonEncode(body),
  );

  if (resp.statusCode == 200 || resp.statusCode == 201) {
    return jsonDecode(resp.body) as Map<String, dynamic>; 
  }

  print('Erro ao criar sala: Status ${resp.statusCode}, Corpo: ${resp.body}');
  return null;
}


  // ----------------- Metrics (example) -----------------
  static Future<List<dynamic>> relatorioMetricas(int usuarioId, DateTime from, DateTime to) async {
    final isoFrom = from.toIso8601String();
    final isoTo = to.toIso8601String();
    final uri = Uri.parse('$baseUrl/api/metrics/report?usuarioId=$usuarioId&from=$isoFrom&to=$isoTo');
    final resp = await http.get(uri, headers: _authHeaders());
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as List<dynamic>;
    }
    return [];
  }

static Future<List<dynamic>> obterMetricas({
  required int usuarioId,
  required DateTime dataIni,
  required DateTime dataFim,
}) async {

  final iniMs = dataIni.millisecondsSinceEpoch;
  final fimMs = dataFim.millisecondsSinceEpoch;

  final uri = Uri.parse(
    '$baseUrl/api/metrics/minhas'
    '?usuarioId=$usuarioId'
    '&dataIni=$iniMs'
    '&dataFim=$fimMs',
  );

  final response = await http.get(uri, headers: _authHeaders());

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  } else {
    throw Exception('Erro ao obter métricas: ${response.statusCode}');
  }
}

  // ----------------- Utility -----------------
  static void setTokenForTests(String token) {
    _token = token;
  }
}