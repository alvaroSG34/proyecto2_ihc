import 'package:flutter/material.dart';

import '../../consts/color.dart';
<<<<<<< Updated upstream

class HomeView extends StatelessWidget {
  const HomeView({super.key});
=======
import '../../models/usuario.dart';
import '../../services/auth_service.dart';
import '../autenticacion/cambiar_contraseña.dart';
import '../autenticacion/login_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.user, required this.authService});

  final usuario user;
  final auth_service authService;
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: white,
        foregroundColor: Jetblack,
<<<<<<< Updated upstream
=======
        actions: [
          IconButton(
            tooltip: 'Cambiar contraseña',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => cambiarContraView(authService: authService),
              ),
            ),
            icon: const Icon(Icons.key),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await authService.logout();
              if (!context.mounted) return;
              await Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginView()),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
>>>>>>> Stashed changes
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/futbol.png',
                  width: 144,
                  height: 144,
                  semanticLabel: 'Ilustración de fútbol',
                ),
                const SizedBox(height: 24),
                Text(
<<<<<<< Updated upstream
                  '¡Bienvenido!',
=======
                  '¡Bienvenido, ${user.nombre}!',
>>>>>>> Stashed changes
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(color: Jetblack, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
<<<<<<< Updated upstream
                  'Ya estás en el inicio.',
=======
                  user.email,
>>>>>>> Stashed changes
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: Blueslate),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
