import 'package:flutter/material.dart';

import '../../consts/color.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: white,
        foregroundColor: Jetblack,
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
                  '¡Bienvenido!',
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(color: Jetblack, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ya estás en el inicio.',
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
