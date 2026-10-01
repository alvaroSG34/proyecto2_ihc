import 'package:flutter/material.dart';

import '../../consts/color.dart';
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

                      const SizedBox(height: 33),

                      Center(
                        child: BotonGuardar(
                          texto: 'Ingresar',
                          alPresionar: _iniciarSesion,
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
