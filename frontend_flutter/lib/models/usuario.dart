<<<<<<< Updated upstream
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
=======
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
>>>>>>> Stashed changes
  }
}

class AuthResponse {
  final String accessToken;
  final String tokenType;
<<<<<<< Updated upstream
  final Usuario usuario;
=======
  final usuario usuarioAutenticado;
>>>>>>> Stashed changes

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
<<<<<<< Updated upstream
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
=======
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
>>>>>>> Stashed changes
