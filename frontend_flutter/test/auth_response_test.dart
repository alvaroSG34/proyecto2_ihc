import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/models/usuario.dart';

void main() {
  test('parses the backend authentication response envelope', () {
    final response = AuthResponse.fromJson({
      'access_token': 'jwt-token',
      'token_type': 'bearer',
      'usuario': {'id': 7, 'nombre': 'Ada', 'email': 'ada@example.com'},
    });

    expect(response.accessToken, 'jwt-token');
    expect(response.tokenType, 'bearer');
    expect(response.usuario.id, 7);
    expect(response.usuario.nombre, 'Ada');
    expect(response.usuario.email, 'ada@example.com');
  });
}
