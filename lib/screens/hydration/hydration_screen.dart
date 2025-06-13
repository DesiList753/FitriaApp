import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HydrationScreen extends StatefulWidget {
  const HydrationScreen({super.key});

  @override
  State<HydrationScreen> createState() => _HydrationScreenState();
}

class _HydrationScreenState extends State<HydrationScreen> {
  int _waterGlasses = 0;
  final int _dailyGoal = 8;
  bool _loading = true;
  Map<String, int> _weekData = {};

  @override
  void initState() {
    super.initState();
    _loadTodayData();
    _loadWeekData();
  }

  Future<void> _loadTodayData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('hidratacion')
        .doc(today)
        .get();
    setState(() {
      _waterGlasses = doc.data()?['vasos'] ?? 0;
      _loading = false;
    });
  }

  Future<void> _updateGlasses(int value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setState(() {
      _waterGlasses = value;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('hidratacion')
        .doc(today)
        .set({'date': today, 'vasos': value});
    _loadWeekData();
  }

  Future<void> _loadWeekData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final now = DateTime.now();
    Map<String, int> week = {};
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = DateFormat('yyyy-MM-dd').format(date);
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('hidratacion')
          .doc(key)
          .get();
      week[key] = doc.data()?['vasos'] ?? 0;
    }
    setState(() {
      _weekData = week;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progressValue = _waterGlasses / _dailyGoal;
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
                      _updateGlasses(_waterGlasses - 1);
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
                    if (_waterGlasses < _dailyGoal + 8) {
                      _updateGlasses(_waterGlasses + 1);
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
                    children: _buildWeekBarChart(),
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
    final cappedValue = value.clamp(0.0, 1.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 25,
          height: 120 * cappedValue,
          decoration: BoxDecoration(
            color: cappedValue < 0.6 ? Colors.red.shade300 : 
                   cappedValue < 0.8 ? Colors.yellow.shade600 : 
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

  List<Widget> _buildWeekBarChart() {
    final now = DateTime.now();
    final days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    List<Widget> bars = [];
    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: 6 - i));
      final key = DateFormat('yyyy-MM-dd').format(date);
      final value = (_weekData[key] ?? 0) / _dailyGoal;
      bars.add(_buildBarChart(i == 6 ? 'Hoy' : days[date.weekday - 1], value));
    }
    return bars;
  }
}
