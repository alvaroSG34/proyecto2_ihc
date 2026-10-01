import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:frontend_flutter/services/auth_service.dart';

class MemoryTokenStorage implements TokenStorage {
  String? token;

  @override
  Future<String?> read() async => token;

  @override
  Future<void> write(String value) async {
    token = value;
  }

  @override
  Future<void> delete() async {
    token = null;
  }
}

void main() {
  const authResponse = {
    'access_token': 'jwt-token',
    'token_type': 'bearer',
    'usuario': {'id': 7, 'nombre': 'Ada', 'email': 'ada@example.com'},
  };

  test('login stores the access token and returns the nested user', () async {
    final storage = MemoryTokenStorage();
    final client = MockClient((request) async {
      expect(request.url.path, '/api/auth/login');
      expect(jsonDecode(request.body), {
        'email': 'ada@example.com',
        'password': 'secret',
      });
      return http.Response(jsonEncode(authResponse), 200);
    });
    final service = AuthService(
      client: client,
      storage: storage,
      baseUrl: 'http://localhost:8000/',
    );

    final user = await service.login('ada@example.com', 'secret');

    expect(storage.token, 'jwt-token');
    expect(user.nombre, 'Ada');
  });

  test('registration accepts status 201 and stores token', () async {
    final storage = MemoryTokenStorage();
    final client = MockClient((request) async {
      expect(request.url.path, '/api/auth/registro');
      return http.Response(jsonEncode(authResponse), 201);
    });
    final service = AuthService(client: client, storage: storage);

    await service.registro('Ada', 'ada@example.com', 'secret', null);

    expect(storage.token, 'jwt-token');
  });

  test('currentUser sends bearer token and parses the user response', () async {
    final storage = MemoryTokenStorage()..token = 'jwt-token';
    final client = MockClient((request) async {
      expect(request.url.path, '/api/auth/yo');
      expect(request.headers['Authorization'], 'Bearer jwt-token');
      return http.Response(
        jsonEncode({'id': 7, 'nombre': 'Ada', 'email': 'ada@example.com'}),
        200,
      );
    });
    final service = AuthService(client: client, storage: storage);

    final user = await service.currentUser();

    expect(user?.email, 'ada@example.com');
  });

  test('currentUser clears a token rejected by the backend', () async {
    final storage = MemoryTokenStorage()..token = 'expired-token';
    final service = AuthService(
      client: MockClient((_) async => http.Response('{}', 401)),
      storage: storage,
    );

    expect(await service.currentUser(), isNull);
    expect(storage.token, isNull);
  });

  test('logout removes the locally stored token', () async {
    final storage = MemoryTokenStorage()..token = 'jwt-token';
    final service = AuthService(storage: storage);

    await service.logout();

    expect(storage.token, isNull);
  });

  test('requests a recovery token from the backend', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/auth/recuperar');
      expect(jsonDecode(request.body), {'email': 'ada@example.com'});
      return http.Response(
        jsonEncode({'mensaje': 'Token generado', 'token': '123456'}),
        200,
      );
    });
    final service = AuthService(client: client);

    expect(await service.recuperarPassword('ada@example.com'), '123456');
  });

  test('changes password through the recovery endpoint', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/auth/cambiar-password');
      expect(jsonDecode(request.body), {
        'token': '123456',
        'nueva_password': 'new-password',
      });
      return http.Response(
        jsonEncode({'mensaje': 'Contraseña actualizada'}),
        200,
      );
    });
    final service = AuthService(client: client);

    await service.cambiarPassword('123456', 'new-password');
  });

  test('propagates recovery endpoint errors', () async {
    final service = AuthService(
      client: MockClient(
        (_) async =>
            http.Response(jsonEncode({'detail': 'Usuario no encontrado'}), 404),
      ),
    );

    expect(
      () => service.recuperarPassword('missing@example.com'),
      throwsA(isA<Exception>()),
    );
  });

  test('propagates invalid recovery token errors', () async {
    final service = AuthService(
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({'detail': 'Token inválido o vencido'}),
          400,
        ),
      ),
    );

    expect(
      () => service.cambiarPassword('bad-token', 'new-password'),
      throwsA(isA<Exception>()),
    );
  });

  test(
    'changes password for the authenticated user with bearer token',
    () async {
      final storage = MemoryTokenStorage()..token = 'jwt-token';
      final client = MockClient((request) async {
        expect(request.url.path, '/api/auth/cambiar-password-auth');
        expect(request.headers['Authorization'], 'Bearer jwt-token');
        expect(jsonDecode(request.body), {
          'contrasena_actual': 'old-password',
          'nueva_password': 'new-password',
        });
        return http.Response(
          jsonEncode({'mensaje': 'Contraseña actualizada'}),
          200,
        );
      });
      final service = AuthService(client: client, storage: storage);

      await service.cambiarPasswordAutenticado('old-password', 'new-password');
    },
  );

  test(
    'clears the session when authenticated password change returns 401',
    () async {
      final storage = MemoryTokenStorage()..token = 'expired-token';
      final service = AuthService(
        client: MockClient(
          (_) async =>
              http.Response(jsonEncode({'detail': 'Token inválido'}), 401),
        ),
        storage: storage,
      );

      expect(
        () =>
            service.cambiarPasswordAutenticado('old-password', 'new-password'),
        throwsA(isA<Exception>()),
      );
      await Future<void>.delayed(Duration.zero);
      expect(storage.token, isNull);
    },
  );
}
