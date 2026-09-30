import 'package:flutter/material.dart';

import '../../consts/color.dart';
import '../../widgets/boton_guardar.dart';
import '../../widgets/input.dart';
import 'cambiar_contraseña.dart';

class OlvideContrasenaView extends StatefulWidget {
  const OlvideContrasenaView({super.key});

  @override
  State<OlvideContrasenaView> createState() => _OlvideContrasenaViewState();
}

class _OlvideContrasenaViewState extends State<OlvideContrasenaView> {
  static const _codigoDemo = '123456';

  final _correoControlador = TextEditingController();
  final _codigoControlador = TextEditingController();
  bool _codigoEnviado = false;

  @override
  void dispose() {
    _correoControlador.dispose();
    _codigoControlador.dispose();
    super.dispose();
  }

  Future<void> _continuar() async {
    final correo = _correoControlador.text.trim();

    if (!_codigoEnviado) {
      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(correo)) {
        _mostrarMensaje('Ingresa un correo electrónico válido.');
        return;
      }

      setState(() => _codigoEnviado = true);
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Código de demostración'),
          content: const Text(
            'No se envió un correo. Usa este código para continuar: 123456',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
      return;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(_codigoControlador.text.trim())) {
      _mostrarMensaje('Ingresa el codigo de seis dígitos.');
      return;
    }

    if (_codigoControlador.text.trim() != _codigoDemo) {
      _mostrarMensaje('El codigo ingresado no es correcto.');
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => cambiarContraView(
          modoRecuperacion: true,
          correoRecuperacion: correo,
        ),
      ),
    );
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text('Recuperar contraseña'),
        backgroundColor: white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [


                Center(
                        child: Image.asset(
                          'assets/icons/llave.png',
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
                soloLectura: _codigoEnviado,
              ),
              if (_codigoEnviado)
                Input(
                  etiqueta: 'Codigo de verificacion',
                  controlador: _codigoControlador,
                  placeholder: '123456',
                  tipoTeclado: TextInputType.number,
                ),
              const SizedBox(height: 17),
              Center(
                child: BotonGuardar(
                  texto: _codigoEnviado ? 'Verificar codigo' : 'Continuar',
                  alPresionar: _continuar,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
