import 'package:flutter/material.dart';

import '../../consts/color.dart';
<<<<<<< Updated upstream
=======
import '../../services/auth_service.dart';
>>>>>>> Stashed changes
import '../../widgets/boton_guardar.dart';
import '../../widgets/input.dart';
import '../home_view/home_view.dart';
import 'olvide_contraseña.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
<<<<<<< Updated upstream
  final _correoControlador = TextEditingController();
  final _contrasenaControlador = TextEditingController();

  @override
  void dispose() {
    _correoControlador.dispose();
    _contrasenaControlador.dispose();
    super.dispose();
  }

  void _iniciarSesion() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const HomeView()));
=======
  final _email_controlador = TextEditingController();
  final _password_controlador = TextEditingController();
  final _auth_service = auth_service();
  bool _esta_cargando = false;

  @override
  void dispose() {
    _email_controlador.dispose();
    _password_controlador.dispose();
    super.dispose();
  }

  Future<void> _iniciar_sesion() async {
    final email = _email_controlador.text.trim();
    final password = _password_controlador.text;

    if (email.isEmpty || password.isEmpty) {
      _mostrar_mensaje('completa el email y la contraseña.');
      return;
    }

    setState(() => _esta_cargando = true);

    try {
      final user = await _auth_service.login(email, password);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeView(user: user, authService: _auth_service),
        ),
      );
    } catch (error) {
      _mostrar_mensaje(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _esta_cargando = false);
    }
  }

  void _mostrar_mensaje(String mensaje) {
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
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/icons/futbol.png',
                          width: 166,
                          height: 216,
                          semanticLabel: 'Ilustración de usuario',
                        ),
                      ),
                      Input(
                        etiqueta: 'Email',
<<<<<<< Updated upstream
                        controlador: _correoControlador,
=======
                        controlador: _email_controlador,
>>>>>>> Stashed changes
                        placeholder: 'correo@ejemplo.com',
                        tipoTeclado: TextInputType.emailAddress,
                      ),

                      Input(
                        etiqueta: 'Contraseña',
<<<<<<< Updated upstream
                        controlador: _contrasenaControlador,
=======
                        controlador: _password_controlador,
>>>>>>> Stashed changes
                        placeholder: '••••••••',
                        ocultarTexto: true,
                      ),

                      const SizedBox(height: 33),

                      Center(
                        child: BotonGuardar(
                          texto: 'Ingresar',
<<<<<<< Updated upstream
                          alPresionar: _iniciarSesion,
=======
                          estaCargando: _esta_cargando,
                          alPresionar: _iniciar_sesion,
>>>>>>> Stashed changes
                        ),
                      ),

                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const OlvideContrasenaView(),
                            ),
                          ),
                          child: const Text('¿Olvidaste tu contraseña?'),
                        ),
                      ),

                      Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text('¿No tienes cuenta? '),
                            InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const RegisterView(),
                                ),
                              ),
                              child: Text('Registrate'),
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
}
