import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({
    super.key,
    required this.etiqueta,
    required this.controlador,
    this.placeholder,
    this.tipoTeclado,
    this.soloLectura = false,
    this.ocultarTexto = false,
    this.validator,
  });

  final String etiqueta;
  final TextEditingController controlador;
  final String? placeholder;
  final TextInputType? tipoTeclado;
  final bool soloLectura;
  final bool ocultarTexto;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(etiqueta, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 7),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: TextFormField(
            controller: controlador,
            keyboardType: tipoTeclado,
            readOnly: soloLectura,
            obscureText: ocultarTexto,
            enableSuggestions: !ocultarTexto,
            autocorrect: !ocultarTexto,
            validator: validator,
            decoration: InputDecoration(hintText: placeholder),
          ),
        ),
      ],
    );
  }
}
