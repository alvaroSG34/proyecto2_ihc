class usuario {
  final int id;
  final String nombre;
  final String email;

  usuario({required this.id, required this.nombre, required this.email});

  factory usuario.fromjson(Map<String, dynamic> json) {
    return usuario(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> tojson() {
    return {'id': id, 'nombre': nombre, 'email': email};
  }
}

class AuthResponse {
  final String accessToken;
  final String tokenType;
  final usuario usuarioAutenticado;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.usuarioAutenticado,
  });

  factory AuthResponse.fromjson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      usuarioAutenticado: usuario.fromjson(
        json['usuario'] as Map<String, dynamic>,
      ),
    );
  }
}

class login_request {
  final String email;
  final String password;

  login_request({required this.email, required this.password});

  Map<String, dynamic> tojson() {
    return {'email': email, 'password': password};
  }
}

class registro_request {
  final String nombre;
  final String email;
  final String password;
  final String? telefono;

  registro_request({
    required this.nombre,
    required this.email,
    required this.password,
    this.telefono,
  });

  Map<String, dynamic> tojson() {
    return {
      'nombre': nombre,
      'email': email,
      'password': password,
      'telefono': telefono,
    };
  }
}
