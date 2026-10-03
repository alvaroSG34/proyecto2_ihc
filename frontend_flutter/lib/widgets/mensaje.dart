import 'package:flutter/material.dart';

void mostrarMensaje(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(mensaje.replaceFirst('Exception: ', ''))),
  );
}
