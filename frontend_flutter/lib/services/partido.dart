import 'dart:convert';

import 'package:http/http.dart' as http;

import '../consts/api_url.dart';
import '../models/partido.dart';
import 'auth_service.dart';

class PartidoService {
  final http.Client client = http.Client();
  final TokenStorage storage = SecureTokenStorage();

  Future<Map<String, String>> headers() async {
    final token = await storage.read();

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Partido>> listar() async {
    final response = await client.get(
      Uri.parse('$apiBaseUrl/api/partidos'),
      headers: await headers(),
    );

    if (response.statusCode != 200) {
      throw Exception('No se pudieron cargar los partidos');
    }

    final lista = jsonDecode(response.body) as List;

    return lista.map((partido) => Partido.fromJson(partido)).toList();
  }

  Future<Partido> obtener(int id) async {
    final response = await client.get(
      Uri.parse('$apiBaseUrl/api/partidos/$id'),
      headers: await headers(),
    );

    if (response.statusCode != 200) {
      throw Exception('No se pudo encontrar el partido');
    }

    return Partido.fromJson(jsonDecode(response.body));
  }

  Future<Partido> crear(PartidoCreateRequest datos) async {
    final response = await client.post(
      Uri.parse('$apiBaseUrl/api/partidos'),
      headers: await headers(),
      body: jsonEncode(datos.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('No se pudo crear el partido');
    }

    return Partido.fromJson(jsonDecode(response.body));
  }

  Future<Partido> actualizar(int id, PartidoUpdateRequest datos) async {
    final response = await client.put(
      Uri.parse('$apiBaseUrl/api/partidos/$id'),
      headers: await headers(),
      body: jsonEncode(datos.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('No se pudo actualizar el partido');
    }

    return Partido.fromJson(jsonDecode(response.body));
  }

  Future<void> eliminar(int id) async {
    final response = await client.delete(
      Uri.parse('$apiBaseUrl/api/partidos/$id'),
      headers: await headers(),
    );

    if (response.statusCode != 204) {
      throw Exception('No se pudo eliminar el partido');
    }
  }
}
