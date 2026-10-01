import 'package:flutter/material.dart';

import '../consts/color.dart';

class Input extends StatelessWidget {
  const Input({
    super.key,
    required this.etiqueta,
    required this.controlador,
    this.placeholder,
    this.tipoTeclado,
    this.soloLectura = false,
    this.mensajeError,
    this.nodoFoco,
    this.alTocar,
    this.alCambiar,
    this.ocultarTexto = false,
  });

  final String etiqueta;
  final TextEditingController controlador;
  final String? placeholder;
  final TextInputType? tipoTeclado;
  final bool soloLectura;
  final String? mensajeError;
  final FocusNode? nodoFoco;
  final VoidCallback? alTocar;
  final ValueChanged<String>? alCambiar;
  final bool ocultarTexto;

  @override
  Widget build(BuildContext context) {
    final tieneError = mensajeError?.isNotEmpty ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(etiqueta),
        const SizedBox(height: 7),
        SizedBox(
          height: 52,
          child: TextField(
            controller: controlador,
            focusNode: nodoFoco,
            keyboardType: tipoTeclado,
            readOnly: soloLectura,
            obscureText: ocultarTexto,
            enableSuggestions: !ocultarTexto,
            autocorrect: !ocultarTexto,
            onTap: alTocar,
            onChanged: alCambiar,
            decoration: InputDecoration(
              hintText: placeholder,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 52,
              ),

              isDense: true,
              filled: true,
              fillColor: white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
            ),
          ),
        ),
        if (tieneError) ...[const SizedBox(height: 8), Text(mensajeError!)],
      ],
    );
  }
}
