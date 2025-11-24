import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор ускорения свободного падения',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GravityCalculatorFirstScreen(),
    );
  }
}

class GravityCalculatorFirstScreen extends StatefulWidget {
  const GravityCalculatorFirstScreen({super.key});

  @override
  _GravityCalculatorFirstScreenState createState() => _GravityCalculatorFirstScreenState();
}

class _GravityCalculatorFirstScreenState extends State<GravityCalculatorFirstScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _massController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  bool _isAgreed = false;
  bool _isValidating = false;

  static const double G = 6.67430e-11;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор ускорения свободного падения'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Поле ввода массы
            TextFormField(
              controller: _massController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Масса небесного тела (кг)',
                hintText: 'Например: 5.972e24',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите массу';
                }
                final normalizedValue = value.replaceAll(',', '.');
                final mass = double.tryParse(normalizedValue);
                if (mass == null) {
                  return 'Пожалуйста, введите корректное число';
                }
                if (mass <= 0) {
                  return 'Масса должна быть больше 0';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Поле ввода радиуса
            TextFormField(
              controller: _radiusController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Радиус небесного тела (м)',
                hintText: 'Например: 6371000',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите радиус';
                }
                final normalizedValue = value.replaceAll(',', '.');
                final radius = double.tryParse(normalizedValue);
                if (radius == null) {
                  return 'Пожалуйста, введите корректное число';
                }
                if (radius <= 0) {
                  return 'Радиус должен быть больше 0';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Чекбокс согласия
            Row(
              children: [
                Checkbox(
                  value: _isAgreed,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAgreed = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAgreed = !_isAgreed;
                      });
                    },
                    child: Text(
                      'Я согласен на обработку данных',
                      style: TextStyle(
                        color: _isValidating && !_isAgreed ? Colors.red : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_isValidating && !_isAgreed)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                child: Text(
                  'Необходимо согласие на обработку данных',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),

            SizedBox(height: 24),

            // Кнопка расчета
            Center(
              child: ElevatedButton(
                onPressed: _calculateGravity,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text('Рассчитать ускорение свободного падения'),
              ),
            ),
            
            // Добавляем отступ внизу для удобства скролла
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _calculateGravity() {
    setState(() {
      _isValidating = true;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isAgreed) {
      return;
    }

    final normalizedMass = _massController.text.replaceAll(',', '.');
    final normalizedRadius = _radiusController.text.replaceAll(',', '.');
    
    final mass = double.tryParse(normalizedMass);
    final radius = double.tryParse(normalizedRadius);

    if (mass == null || radius == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при преобразовании чисел'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GravityResultScreen(
          mass: mass,
          radius: radius,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _massController.dispose();
    _radiusController.dispose();
    super.dispose();
  }
}

class GravityResultScreen extends StatelessWidget {
  final double mass;
  final double radius;
  static const double G = 6.67430e-11;

  const GravityResultScreen({super.key, 
    required this.mass,
    required this.radius,
  });

  double _calculateGravity() {
    try {
      return (G * mass) / (radius * radius);
    } catch (e) {
      return double.infinity;
    }
  }

  String _getGravityDescription(double gravity) {
    if (gravity.isInfinite) {
      return 'Ошибка расчета';
    }
    if (gravity < 1) {
      return 'Очень слабая гравитация (меньше Луны)';
    } else if (gravity < 5) {
      return 'Слабая гравитация (как на Марсе)';
    } else if (gravity < 9) {
      return 'Умеренная гравитация';
    } else if (gravity >= 9 && gravity <= 11) {
      return 'Сильная гравитация (как на Земле)';
    } else {
      return 'Очень сильная гравитация (больше Земли)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final gravity = _calculateGravity();
    final description = _getGravityDescription(gravity);

    return Scaffold(
      appBar: AppBar(
        title: Text('Результаты расчета'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Результат расчета
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Ускорение свободного падения',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    gravity.isInfinite 
                        ? 'Ошибка'
                        : '${gravity.toStringAsFixed(2)} м/с²',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: gravity.isInfinite ? Colors.red : Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),

          // Исходные данные
          Text(
            'Исходные данные:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          DataTable(
            columns: [
              DataColumn(label: Text('Параметр')),
              DataColumn(label: Text('Значение')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('Масса')),
                DataCell(Text('${mass.toStringAsExponential(2)} кг')),
              ]),
              DataRow(cells: [
                DataCell(Text('Радиус')),
                DataCell(Text('${radius.toStringAsExponential(2)} м')),
              ]),
              DataRow(cells: [
                DataCell(Text('Гравитационная постоянная')),
                DataCell(Text('${G.toStringAsExponential(5)} м³/кг·с²')),
              ]),
            ],
          ),
          
          // Большой отступ внизу для удобства скролла
          SizedBox(height: 100),
        ],
      ),
    );
  }
}