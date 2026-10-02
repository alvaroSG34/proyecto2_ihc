import 'package:flutter/material.dart';

import '../../models/partido.dart';
import '../../services/partido.dart';

class ListPartidoView extends StatefulWidget {
  const ListPartidoView({super.key, this.partidoService});

  final PartidoService? partidoService;

  @override
  State<ListPartidoView> createState() => _ListPartidoViewState();
}

class _ListPartidoViewState extends State<ListPartidoView> {
  late final PartidoService partidoService;
  List<Partido> partidos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    partidoService = widget.partidoService ?? PartidoService();
    cargarPartidos();
  }

  Future<void> cargarPartidos() async {
    setState(() {
      cargando = true;
    });

    try {
      final resultado = await partidoService.listar();
      setState(() {
        partidos = resultado;
      });
    } catch (error) {
      mostrarMensaje(error.toString());
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  void mostrarMensaje(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje.replaceFirst('Exception: ', ''))),
    );
  }

  Future<void> abrirFormulario({Partido? partido}) async {
    final datos = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => FormularioPartido(partido: partido),
    );

    if (datos == null) return;

    try {
      if (partido == null) {
        await partidoService.crear(
          PartidoCreateRequest(
            nombre: datos['nombre'],
            cantidadJugadores: datos['cantidadJugadores'],
            ubicacion: datos['ubicacion'],
            tiempoMin: datos['tiempoMin'],
            fecha: datos['fecha'],
          ),
        );
      } else {
        await partidoService.actualizar(
          partido.id,
          PartidoUpdateRequest(
            nombre: datos['nombre'],
            cantidadJugadores: datos['cantidadJugadores'],
            ubicacion: datos['ubicacion'],
            tiempoMin: datos['tiempoMin'],
            fecha: datos['fecha'],
          ),
        );
      }

      await cargarPartidos();
      mostrarMensaje('Partido guardado');
    } catch (error) {
      mostrarMensaje(error.toString());
    }
  }

  Future<void> borrarPartido(Partido partido) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar partido'),
        content: const Text('¿Quieres eliminar este partido?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sí'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await partidoService.eliminar(partido.id);
      await cargarPartidos();
      mostrarMensaje('Partido eliminado');
    } catch (error) {
      mostrarMensaje(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis partidos')),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : partidos.isEmpty
          ? const Center(child: Text('No tienes partidos todavía'))
          : RefreshIndicator(
              onRefresh: cargarPartidos,
              child: ListView.builder(
                itemCount: partidos.length,
                itemBuilder: (context, index) {
                  final partido = partidos[index];

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(partido.nombre),
                      subtitle: Text(
                        '${partido.ubicacion}\n'
                        'Jugadores: ${partido.cantidadJugadores}\n'
                        'Duración: ${partido.tiempoMin ?? 'No definida'}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => abrirFormulario(partido: partido),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => borrarPartido(partido),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

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
      setState(() {
        fecha = fechaSeleccionada;
      });
    }
  }

  void guardar() {
    final cantidadJugadores = int.tryParse(
      cantidadJugadoresController.text.trim(),
    );

    if (nombreController.text.isEmpty ||
        ubicacionController.text.isEmpty ||
        cantidadJugadores == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Completa el nombre, la ubicación y la cantidad de jugadores',
          ),
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'nombre': nombreController.text,
      'cantidadJugadores': cantidadJugadores,
      'ubicacion': ubicacionController.text,
      'tiempoMin': tiempoController.text.isEmpty ? null : tiempoController.text,
      'fecha': fecha,
    });
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.partido != null;

    return AlertDialog(
      title: Text(editando ? 'Editar partido' : 'Nuevo partido'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: ubicacionController,
              decoration: const InputDecoration(labelText: 'Ubicación'),
            ),
            TextField(
              controller: cantidadJugadoresController,
              decoration: const InputDecoration(
                labelText: 'Cantidad de jugadores',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: tiempoController,
              decoration: const InputDecoration(labelText: 'Tiempo en minutos'),
              keyboardType: TextInputType.number,
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: guardar, child: const Text('Guardar')),
      ],
    );
  }
}
