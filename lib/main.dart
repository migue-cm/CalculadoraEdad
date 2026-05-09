import 'package:flutter/material.dart';

void main() => runApp(const AppEdad());

// StatelessWidget: solo configura la app, no tiene estado propio
class AppEdad extends StatelessWidget {
  const AppEdad({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Edad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // Activa Material 3
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const PantallaEdad(),
    );
  }
}

// StatefulWidget: la pantalla tiene estado (edad, error, controller)
class PantallaEdad extends StatefulWidget {
  const PantallaEdad({super.key});

  @override
  State<PantallaEdad> createState() => _PantallaEdadState();
}

class _PantallaEdadState extends State<PantallaEdad> {
  // Controller captura el texto del TextField
  final _controller = TextEditingController();

  // Estado: edad calculada (null = no calculada aún)
  int? _edad;

  // Estado: mensaje de error (null = sin error)
  String? _error;

  // Lógica de cálculo y validación
  void _calcular() {
    final texto = _controller.text.trim();
    final anio = int.tryParse(texto); // null si no es número
    final anioActual = DateTime.now().year;

    // setState() reconstruye el widget con el nuevo estado
    setState(() {
      if (anio == null) {
        // Caso 1: no ingresó un número
        _error = 'Ingresa un año válido';
        _edad = null;
      } else if (anio < 1900 || anio > anioActual) {
        // Caso 2: número fuera del rango permitido
        _error = 'El año debe estar entre 1900 y $anioActual';
        _edad = null;
      } else {
        // Caso 3: válido → calcula edad y limpia el error
        _error = null;
        _edad = anioActual - anio;
      }
    });
  }

  @override
  void dispose() {
    // Libera el controller al destruir el widget (buena práctica)
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Edad'),
        // El color del AppBar toma el colorScheme de Material 3
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Campo de texto ──────────────────────────────────────
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number, // teclado numérico
              maxLength: 4, // máximo 4 dígitos (ej. 1995)
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Año de nacimiento',
                errorText: _error, // muestra el error debajo del campo
                prefixIcon: const Icon(Icons.cake),
              ),
            ),

            const SizedBox(height: 16),

            // ── Botón Material 3 ────────────────────────────────────
            FilledButton.icon(
              onPressed: _calcular,
              icon: const Icon(Icons.calculate),
              label: const Text('Calcular edad'),
            ),

            const SizedBox(height: 24),

            // ── Resultado (solo visible cuando _edad != null) ───────
            // Uso de colección "if" dentro de la lista de widgets
            if (_edad != null)
              Card(
                // Card de Material 3: bordes redondeados y elevación suave
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.celebration,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tu edad es de',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '$_edad años',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}