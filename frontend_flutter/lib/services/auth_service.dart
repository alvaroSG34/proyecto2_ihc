import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../consts/api_url.dart';
import '../models/usuario.dart';

abstract interface class TokenStorage {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> delete();
}

class SecureTokenStorage implements TokenStorage {
  static const _storageKey = 'access_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<String?> read() => _storage.read(key: _storageKey);

  @override
  Future<void> write(String token) =>
      _storage.write(key: _storageKey, value: token);

  @override
  Future<void> delete() => _storage.delete(key: _storageKey);
}

class auth_service {
  auth_service({http.Client? client, TokenStorage? storage, String? baseUrl})
    : _client = client ?? http.Client(),
      _storage = storage ?? SecureTokenStorage(),
      _baseUrl = (baseUrl ?? apiBaseUrl).replaceFirst(RegExp(r'/$'), '');

  final http.Client _client;
  final TokenStorage _storage;
  final String _baseUrl;

  Future<usuario> login(String email, String password) async {
    final body = login_request(email: email, password: password).tojson();
    return _authenticate('login', body, expectedStatus: 200);
  }

  Future<usuario> registro(
    String nombre,
    String email,
    String password,
    String? telefono,
  ) async {
    final body = registro_request(
      nombre: nombre,
      email: email,
      password: password,
      telefono: telefono,
    ).tojson();
    return _authenticate('registro', body, expectedStatus: 201);
  }

  Future<usuario> _authenticate(
    String path,
    Map<String, dynamic> body, {
    required int expectedStatus,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/auth/$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != expectedStatus) {
      throw Exception(obtener_mensaje_error(response.body));
    }

    final authResponse = AuthResponse.fromjson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    await _storage.write(authResponse.accessToken);
    return authResponse.usuarioAutenticado;
  }

  Future<String> recuperarPassword(String email) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/auth/recuperar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception(obtener_mensaje_error(response.body));
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['token'] as String;
  }

  Future<void> cambiarPassword(String token, String nuevaPassword) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/auth/cambiar-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'nueva_password': nuevaPassword}),
    );

    if (response.statusCode != 200) {
      throw Exception(obtener_mensaje_error(response.body));
    }
  }

  Future<void> cambiarPasswordAutenticado(
    String contrasenaActual,
    String nuevaPassword,
  ) async {
    final token = await _storage.read();
    if (token == null || token.isEmpty) {
      throw Exception('La sesión ha expirado');
    }

    final response = await _client.post(
      Uri.parse('$_baseUrl/api/auth/cambiar-password-auth'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'contrasena_actual': contrasenaActual,
        'nueva_password': nuevaPassword,
      }),
    );

    if (response.statusCode == 401) {
      await _storage.delete();
    }
    if (response.statusCode != 200) {
      throw Exception(obtener_mensaje_error(response.body));
    }
  }

  Future<usuario?> currentUser() async {
    final token = await _storage.read();
    if (token == null || token.isEmpty) return null;

    final response = await _client.get(
      Uri.parse('$_baseUrl/api/auth/yo'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 401) {
      await _storage.delete();
      return null;
    }
    if (response.statusCode != 200) {
      throw Exception(obtener_mensaje_error(response.body));
    }

    return usuario.fromjson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> logout() => _storage.delete();

  String obtener_mensaje_error(String cuerpo) {
    try {
      final json = jsonDecode(cuerpo) as Map<String, dynamic>;
      return json['detail']?.toString() ?? 'Ocurrió un error';
    } catch (_) {
      return 'Ocurrió un error';
    }
  }
}
