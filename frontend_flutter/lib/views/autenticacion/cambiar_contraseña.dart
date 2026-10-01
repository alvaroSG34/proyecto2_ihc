import 'package:flutter/material.dart';

import '../../consts/color.dart';
import '../../widgets/boton_guardar.dart';
import '../../widgets/input.dart';

class cambiarContraView extends StatefulWidget {
  const cambiarContraView({
    super.key,
    this.modoRecuperacion = false,
    this.correoRecuperacion,
  });

  final bool modoRecuperacion;
  final String? correoRecuperacion;

  @override
  State<cambiarContraView> createState() => _cambiarContraViewState();
}

class _cambiarContraViewState extends State<cambiarContraView> {
  final _contrasenaActualControlador = TextEditingController();
  final _contrasenaNuevaControlador = TextEditingController();
  final _contrasenaCofirmarControlador = TextEditingController();

  @override
  void dispose() {
    _contrasenaActualControlador.dispose();
    _contrasenaNuevaControlador.dispose();
    _contrasenaCofirmarControlador.dispose();
    super.dispose();
  }

  void _cambiarContrasena() {
    final contrasenaActual = _contrasenaActualControlador.text;
    final contrasenaNueva = _contrasenaNuevaControlador.text;
    final contrasenaConfirmar = _contrasenaCofirmarControlador.text;

    if ((!widget.modoRecuperacion && contrasenaActual.isEmpty) ||
        contrasenaNueva.isEmpty ||
        contrasenaConfirmar.isEmpty) {
      _mostrarMensaje('Completa los campos obligatorios.');
      return;
    }

    if (contrasenaNueva.length < 8) {
      _mostrarMensaje('La nueva contraseña debe tener al menos 8 caracteres.');
      return;
    }

    if (contrasenaNueva != contrasenaConfirmar) {
      _mostrarMensaje('Las contraseñas nuevas no coinciden.');
      return;
    }

    if (!widget.modoRecuperacion && contrasenaNueva == contrasenaActual) {
      _mostrarMensaje('La nueva contraseña debe ser distinta a la actual.');
      return;
    }

    _mostrarMensaje(
      'Demostración: la contraseña se validó, pero no se guardó.',
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
        title: Text(
          widget.modoRecuperacion
              ? 'Restablecer contraseña'
              : 'Cambiar contraseña',
        ),
        backgroundColor: white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      if (widget.modoRecuperacion)
                        Text('Cuenta: ${widget.correoRecuperacion ?? ''}')
                      else
                        Input(
                          etiqueta: 'Contraseña actual',
                          controlador: _contrasenaActualControlador,
                          placeholder: '••••••••',
                          ocultarTexto: true,
                        ),
                      Input(
                        etiqueta: 'Nueva contraseña',
                        controlador: _contrasenaNuevaControlador,
                        placeholder: '••••••••',
                        ocultarTexto: true,
                      ),
                      Input(
                        etiqueta: 'Confirmar nueva contraseña',
                        controlador: _contrasenaCofirmarControlador,
                        placeholder: '••••••••',
                        ocultarTexto: true,
                      ),
                      const SizedBox(height: 33),
                      Center(
                        child: BotonGuardar(
                          texto: widget.modoRecuperacion
                              ? 'Restablecer contraseña'
                              : 'Cambiar contraseña',
                          alPresionar: _cambiarContrasena,
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
