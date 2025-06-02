import 'package:flutter/material.dart';

class HydrationScreen extends StatefulWidget {
  const HydrationScreen({super.key});

  @override
  State<HydrationScreen> createState() => _HydrationScreenState();
}

class _HydrationScreenState extends State<HydrationScreen> {
  int _waterGlasses = 4;
  final int _dailyGoal = 8;
  
  @override
  Widget build(BuildContext context) {
    double progressValue = _waterGlasses / _dailyGoal;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidratación'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Control de agua diario',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 250,
                  width: 250,
                  child: CircularProgressIndicator(
                    value: progressValue,
                    strokeWidth: 15,
                    backgroundColor: Colors.blue.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
                  ),
                ),
                Column(
                  children: [
                    Icon(
                      Icons.water_drop,
                      size: 60,
                      color: Colors.blue.shade400,
                    ),
                    Text(
                      '$_waterGlasses / $_dailyGoal',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'vasos',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_waterGlasses > 0) {
                      setState(() {
                        _waterGlasses--;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Colors.red.shade400,
                  ),
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_waterGlasses < _dailyGoal * 2) {
                      setState(() {
                        _waterGlasses++;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Colors.blue.shade400,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Beber suficiente agua ayuda a mejorar la digestión, '
                        'la piel y mantiene tus órganos funcionando adecuadamente.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Historial semanal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 200,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBarChart('Lun', 0.6),
                      _buildBarChart('Mar', 0.9),
                      _buildBarChart('Mié', 0.7),
                      _buildBarChart('Jue', 0.5),
                      _buildBarChart('Vie', 0.8),
                      _buildBarChart('Sáb', 0.3),
                      _buildBarChart('Hoy', progressValue),
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

  Widget _buildBarChart(String label, double value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 25,
          height: 120 * value,
          decoration: BoxDecoration(
            color: value < 0.6 ? Colors.red.shade300 : 
                   value < 0.8 ? Colors.yellow.shade600 : 
                   Colors.green.shade400,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: label == 'Hoy' ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
