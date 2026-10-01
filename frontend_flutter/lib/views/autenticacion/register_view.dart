import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import '../../consts/color.dart';
import '../../models/usuario.dart';
=======

import '../../consts/color.dart';
import '../../services/auth_service.dart';
>>>>>>> Stashed changes
import '../../widgets/boton_guardar.dart';
import '../../widgets/input.dart';
import '../home_view/home_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
<<<<<<< Updated upstream
  final _correoControlador = TextEditingController();
  final _contrasenaControlador = TextEditingController();
  final _fechaNacimientoControlador = TextEditingController();
  final _telefonoControlador = TextEditingController();
  DateTime? _fechaNacimiento;
  bool _estaCargando = false;

  @override
  void dispose() {
    _correoControlador.dispose();
    _contrasenaControlador.dispose();
    _fechaNacimientoControlador.dispose();
    _telefonoControlador.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (fecha == null) return;

    setState(() {
      _fechaNacimiento = fecha;
      _fechaNacimientoControlador.text =
          '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
    });
  }

  Future<void> _registrar() async {
    final correo = _correoControlador.text.trim();
    final contrasena = _contrasenaControlador.text;

    if (correo.isEmpty ||
        contrasena.isEmpty ||
        _fechaNacimiento == null) {
=======
  final _nombre_controlador = TextEditingController();
  final _email_controlador = TextEditingController();
  final _password_controlador = TextEditingController();
  final _telefono_controlador = TextEditingController();
  final _auth_service = auth_service();
  bool _esta_cargando = false;

  @override
  void dispose() {
    _nombre_controlador.dispose();
    _email_controlador.dispose();
    _password_controlador.dispose();
    _telefono_controlador.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    final nombre = _nombre_controlador.text.trim();
    final email = _email_controlador.text.trim();
    final password = _password_controlador.text;
    final telefono = _telefono_controlador.text.trim();

    if (nombre.isEmpty || email.isEmpty || password.isEmpty) {
>>>>>>> Stashed changes
      _mostrarMensaje('Completa los campos obligatorios.');
      return;
    }

<<<<<<< Updated upstream
    
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
=======
    setState(() => _esta_cargando = true);

    try {
      final user = await _auth_service.registro(
        nombre,
        email,
        password,
        telefono.isEmpty ? null : telefono,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeView(user: user, authService: _auth_service),
        ),
      );
    } catch (error) {
      _mostrarMensaje(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _esta_cargando = false);
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
>>>>>>> Stashed changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      Input(
<<<<<<< Updated upstream
                        etiqueta: 'Email',
                        controlador: _correoControlador,
                        placeholder: 'correo@ejemplo.com',
                        tipoTeclado: TextInputType.emailAddress,
                      ),
           
                      Input(
                        etiqueta: 'Contraseña',
                        controlador: _contrasenaControlador,
                        placeholder: '••••••••',
                        ocultarTexto: true,
                      ),
                 
                      Input(
                        etiqueta: 'Fecha de nacimiento',
                        controlador: _fechaNacimientoControlador,
                        placeholder: 'Selecciona una fecha',
                        soloLectura: true,
                        alTocar: _seleccionarFecha,
                      ),
                  
                      Input(
                        etiqueta: 'Teléfono',
                        controlador: _telefonoControlador,
=======
                        etiqueta: 'Nombre',
                        controlador: _nombre_controlador,
                        placeholder: 'Tu nombre',
                      ),

                      Input(
                        etiqueta: 'Email',
                        controlador: _email_controlador,
                        placeholder: 'correo@ejemplo.com',
                        tipoTeclado: TextInputType.emailAddress,
                      ),

                      Input(
                        etiqueta: 'Contraseña',
                        controlador: _password_controlador,
                        placeholder: '••••••••',
                        ocultarTexto: true,
                      ),

                      Input(
                        etiqueta: 'Teléfono',
                        controlador: _telefono_controlador,
>>>>>>> Stashed changes
                        placeholder: '00000000',
                        tipoTeclado: TextInputType.phone,
                      ),
                      const SizedBox(height: 33),
                      Center(
                        child: BotonGuardar(
                          texto: 'Registrarme',
<<<<<<< Updated upstream
                          estaCargando: _estaCargando,
                          alPresionar: _registrar,
                        ),
                      ),
               
                      Center(
                        child: Wrap(
                          children: [
                            Text(
                              'Ya tienes Cuenta? ',
                         
                            ),
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text(
                                'Inicia Sesion',
                             
                              ),
=======
                          estaCargando: _esta_cargando,
                          alPresionar: _registrar,
                        ),
                      ),

                      Center(
                        child: Wrap(
                          children: [
                            Text('Ya tienes Cuenta? '),
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text('Inicia Sesion'),
>>>>>>> Stashed changes
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
<<<<<<< Updated upstream
}
=======
}
>>>>>>> Stashed changes
