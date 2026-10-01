class Usuario {
  final int id;
  final String correoElectronico;
  final DateTime fechaNacimiento;
  final String? telefono;


  Usuario({
    required this.id,
    required this.correoElectronico,
    required this.fechaNacimiento,
    this.telefono,

  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int,
      correoElectronico: json['correo_electronico'] as String,
      fechaNacimiento: DateTime.parse(json['fecha_nacimiento'] as String),
      telefono: json['telefono'] as String?,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'correo_electronico': correoElectronico,
      'fecha_nacimiento': fechaNacimiento.toIso8601String(),
      'telefono': telefono,
    };
  }
}

class LoginRequest {
  final String correoElectronico;
  final String contrasena;

  LoginRequest({required this.correoElectronico, required this.contrasena});

  Map<String, dynamic> toJson() {
    return {'correo_electronico': correoElectronico, 'contrasena': contrasena};
  }
}

class RegistroRequest {
  final String correoElectronico;
  final String contrasena;
  final DateTime fechaNacimiento;
  final String? telefono;


  RegistroRequest({
    required this.correoElectronico,
    required this.contrasena,
    required this.fechaNacimiento,
    this.telefono,
  });

  Map<String, dynamic> toJson() {
    return {
      'correo_electronico': correoElectronico,
      'contrasena': contrasena,
      'fecha_nacimiento': fechaNacimiento.toIso8601String().split('T').first,
      'telefono': telefono,
    };
  }
}

class AuthResponse {
  final String accessToken;
  final String tokenType;
  final Usuario usuario;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.usuario,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      usuario: Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
    );
  }
}