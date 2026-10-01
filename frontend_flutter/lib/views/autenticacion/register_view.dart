import 'package:flutter/material.dart';
import '../../consts/color.dart';
import '../../models/usuario.dart';
import '../../widgets/boton_guardar.dart';
import '../../widgets/input.dart';
import '../home_view/home_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _correoControlador = TextEditingController();
  final _contrasenaControlador = TextEditingController();
  final _fechaNacimientoControlador = TextEditingController();
  final _telefonoControlador = TextEditingController();
  DateTime? _fechaNacimiento;
  bool _estaCargando = false;

  @override
  void dispose() {
    _correoControlador.dispose();
    _contrasenaControlador.dispose();
    _fechaNacimientoControlador.dispose();
    _telefonoControlador.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (fecha == null) return;

    setState(() {
      _fechaNacimiento = fecha;
      _fechaNacimientoControlador.text =
          '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
    });
  }

  Future<void> _registrar() async {
    final correo = _correoControlador.text.trim();
    final contrasena = _contrasenaControlador.text;

    if (correo.isEmpty ||
        contrasena.isEmpty ||
        _fechaNacimiento == null) {
      _mostrarMensaje('Completa los campos obligatorios.');
      return;
    }

    
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
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
                      Input(
                        etiqueta: 'Email',
                        controlador: _correoControlador,
                        placeholder: 'correo@ejemplo.com',
                        tipoTeclado: TextInputType.emailAddress,
                      ),
           
                      Input(
                        etiqueta: 'Contraseña',
                        controlador: _contrasenaControlador,
                        placeholder: '••••••••',
                        ocultarTexto: true,
                      ),
                 
                      Input(
                        etiqueta: 'Fecha de nacimiento',
                        controlador: _fechaNacimientoControlador,
                        placeholder: 'Selecciona una fecha',
                        soloLectura: true,
                        alTocar: _seleccionarFecha,
                      ),
                  
                      Input(
                        etiqueta: 'Teléfono',
                        controlador: _telefonoControlador,
                        placeholder: '00000000',
                        tipoTeclado: TextInputType.phone,
                      ),
                      const SizedBox(height: 33),
                      Center(
                        child: BotonGuardar(
                          texto: 'Registrarme',
                          estaCargando: _estaCargando,
                          alPresionar: _registrar,
                        ),
                      ),
               
                      Center(
                        child: Wrap(
                          children: [
                            Text(
                              'Ya tienes Cuenta? ',
                         
                            ),
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text(
                                'Inicia Sesion',
                             
                              ),
                            ),
                          ],
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