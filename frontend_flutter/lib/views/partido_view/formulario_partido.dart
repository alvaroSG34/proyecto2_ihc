import 'package:flutter/material.dart';

import '../../models/partido.dart';
import '../../widgets/boton_guardar.dart';
import '../../widgets/input.dart';

class FormularioPartido extends StatefulWidget {
  const FormularioPartido({super.key, this.partido});

  final Partido? partido;

  @override
  State<FormularioPartido> createState() => _FormularioPartidoState();
}

class _FormularioPartidoState extends State<FormularioPartido> {
  late final TextEditingController nombreController;
  late final TextEditingController ubicacionController;
  late final TextEditingController cantidadJugadoresController;
  late final TextEditingController tiempoController;
  final formularioKey = GlobalKey<FormState>();
  DateTime? fecha;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.partido?.nombre);
    ubicacionController = TextEditingController(
      text: widget.partido?.ubicacion,
    );
    cantidadJugadoresController = TextEditingController(
      text: widget.partido?.cantidadJugadores.toString(),
    );
    tiempoController = TextEditingController(text: widget.partido?.tiempoMin);
    fecha = widget.partido?.fecha;
  }

  @override
  void dispose() {
    nombreController.dispose();
    ubicacionController.dispose();
    cantidadJugadoresController.dispose();
    tiempoController.dispose();
    super.dispose();
  }

  Future<void> seleccionarFecha() async {
    final fechaSeleccionada = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDate: fecha ?? DateTime.now(),
    );

    if (fechaSeleccionada != null) {
      setState(() => fecha = fechaSeleccionada);
    }
  }

  String? validarTexto(String? valor) {
    if (valor == null || valor.trim().isEmpty) return 'Campo obligatorio';
    return null;
  }

  String? validarCantidad(String? valor) {
    final cantidad = int.tryParse(valor?.trim() ?? '');
    if (cantidad == null || cantidad < 1 || cantidad > 100) {
      return 'Usa un numero entre 1 y 100';
    }
    return null;
  }

  void guardar() {
    if (!formularioKey.currentState!.validate()) return;

    Navigator.pop(context, {
      'nombre': nombreController.text.trim(),
      'cantidadJugadores': int.parse(cantidadJugadoresController.text.trim()),
      'ubicacion': ubicacionController.text.trim(),
      'tiempoMin': tiempoController.text.trim().isEmpty
          ? null
          : tiempoController.text.trim(),
      'fecha': fecha,
    });
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.partido != null;

    return AlertDialog(
      title: Text(editando ? 'Editar partido' : 'Nuevo partido'),
      content: SingleChildScrollView(
        child: Form(
          key: formularioKey,
          child: Column(
            children: [
              Input(
                controlador: nombreController,
                etiqueta: 'Nombre',
                validator: validarTexto,
              ),
              Input(
                controlador: ubicacionController,
                etiqueta: 'Ubicacion',
                validator: validarTexto,
              ),
              Input(
                controlador: cantidadJugadoresController,
                etiqueta: 'Cantidad de jugadores',
                tipoTeclado: TextInputType.number,
                validator: validarCantidad,
              ),
              Input(
                controlador: tiempoController,
                etiqueta: 'Tiempo en minutos',
                tipoTeclado: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      fecha == null
                          ? 'Sin fecha'
                          : '${fecha!.day}/${fecha!.month}/${fecha!.year}',
                    ),
                  ),
                  TextButton(
                    onPressed: seleccionarFecha,
                    child: const Text('Elegir fecha'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        BotonGuardar(texto: 'Guardar', alPresionar: guardar),
      ],
    );
  }
}
