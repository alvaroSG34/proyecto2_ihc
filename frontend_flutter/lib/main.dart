import 'package:flutter/material.dart';
<<<<<<< Updated upstream
=======

import 'models/usuario.dart';
import 'services/auth_service.dart';
import 'views/home_view/home_view.dart';
>>>>>>> Stashed changes
import 'views/autenticacion/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
<<<<<<< Updated upstream
  const MyApp({super.key});
=======
  const MyApp({super.key, this.authService});

  final auth_service? authService;
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inicio',
<<<<<<< Updated upstream
      home: const LoginView(),
    );
  }
}
=======
      home: SessionGate(authService: authService),
    );
  }
}

class SessionGate extends StatefulWidget {
  const SessionGate({super.key, this.authService});

  final auth_service? authService;

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  late final auth_service _authService;
  late final Future<usuario?> _userFuture;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? auth_service();
    _userFuture = _authService.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<usuario?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (snapshot.hasError || user == null) return const LoginView();
        return HomeView(user: user, authService: _authService);
      },
    );
  }
}
>>>>>>> Stashed changes
