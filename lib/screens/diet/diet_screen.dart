import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/meal.dart';
import '../../services/meal_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Plan Alimenticio'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CaloriesSummary(),
            const SizedBox(height: 14),
            DailyGoalCard(),
            const SizedBox(height: 20),
            const Text(
              'Progreso Diario',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            NutrientSummaryBars(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Comidas de Hoy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Registrar Comida'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddMealDialog(),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            MealsList(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Sugerencias para tu Dieta',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
                minimumSize: const Size(double.infinity, 50),
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              child: const Text(
                'Generar Plan Semanal',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyGoalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: Colors.amber,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Meta diaria',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '75% completado',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.75,
                backgroundColor: Colors.grey.shade300,
                minHeight: 10,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CaloriesSummary extends StatelessWidget {
  final MealService _mealService = MealService();
  final int dailyGoal = 2000; // Puedes hacer esto dinámico según el usuario

  @override
  Widget build(BuildContext context) {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return StreamBuilder<List<Meal>>(
      stream: _mealService.getMealsForDate(today),
      builder: (context, snapshot) {
        int totalCalories = 0;
        if (snapshot.hasData) {
          totalCalories = snapshot.data!.fold(0, (sum, meal) => sum + meal.calories);
        }
        int remaining = dailyGoal - totalCalories;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Calorías Restantes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        '$remaining cal',
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Meta',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '$dailyGoal cal',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Consumidas',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '$totalCalories cal',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NutrientProgressBar extends StatelessWidget {
  final String title;
  final int consumed;
  final int goal;
  final Color color;

  const NutrientProgressBar({
    super.key,
    required this.title,
    required this.consumed,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = consumed / goal;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$consumed / $goal${title == 'Calorías' ? ' cal' : 'g'}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: color.withOpacity(0.2),
              minHeight: 10,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class NutrientSummaryBars extends StatelessWidget {
  final MealService _mealService = MealService();

  @override
  Widget build(BuildContext context) {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUserGoals(),
      builder: (context, snapshot) {
        int proteinGoal = 100;
        int carbsGoal = 250;
        int fatGoal = 70;
        int caloriesGoal = 2000;
        if (snapshot.hasData && snapshot.data != null) {
          proteinGoal = snapshot.data!['proteinGoal'] ?? 100;
          carbsGoal = snapshot.data!['carbsGoal'] ?? 250;
          fatGoal = snapshot.data!['fatGoal'] ?? 70;
          caloriesGoal = snapshot.data!['caloriesGoal'] ?? 2000;
        }
        return StreamBuilder<List<Meal>>(
          stream: _mealService.getMealsForDate(today),
          builder: (context, snapshot) {
            int totalCalories = 0;
            int totalProtein = 0;
            int totalCarbs = 0;
            int totalFat = 0;
            if (snapshot.hasData) {
              for (final meal in snapshot.data!) {
                totalCalories += meal.calories;
                totalProtein += meal.protein;
                totalCarbs += meal.carbs;
                totalFat += meal.fat;
              }
            }
            return Column(
              children: [
                NutrientProgressBar(
                  title: 'Calorías',
                  consumed: totalCalories,
                  goal: caloriesGoal,
                  color: Colors.orange.shade400,
                ),
                NutrientProgressBar(
                  title: 'Proteínas',
                  consumed: totalProtein,
                  goal: proteinGoal,
                  color: Colors.red.shade400,
                ),
                NutrientProgressBar(
                  title: 'Carbohidratos',
                  consumed: totalCarbs,
                  goal: carbsGoal,
                  color: Colors.amber.shade400,
                ),
                NutrientProgressBar(
                  title: 'Grasas',
                  consumed: totalFat,
                  goal: fatGoal,
                  color: Colors.blue.shade400,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _getUserGoals() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return doc.data();
    }
    return null;
  }
}

class MealsList extends StatelessWidget {
  final MealService _mealService = MealService();

  @override
  Widget build(BuildContext context) {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return StreamBuilder<List<Meal>>(
      stream: _mealService.getMealsForDate(today),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay comidas registradas hoy.'));
        }
        final meals = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            return MealCard(meal: meals[index]);
          },
        );
      },
    );
  }
}

class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = meal.calories == 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => EditMealDialog(meal: meal),
          );
        },
        onLongPress: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Eliminar comida'),
              content: const Text('¿Seguro que deseas eliminar esta comida?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Eliminar'),
                ),
              ],
            ),
          );
          if (confirm == true) {
            final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
            await MealService().deleteMeal(today, meal.id);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isEmpty
                      ? Colors.grey.shade200
                      : Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.restaurant_menu, // icono genérico para comida
                  color: isEmpty
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          meal.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          meal.time,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      meal.foods.join(', '),
                      style: TextStyle(
                        fontSize: 14,
                        color: isEmpty
                            ? Colors.grey
                            : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isEmpty
                            ? TextButton(
                          onPressed: () {},
                          child: const Text('Registrar comida'),
                        )
                            : Text(
                          meal.calories == 0
                              ? 'Por registrar'
                              : '${meal.calories} cal',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isEmpty)
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20),
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                color: Colors.red.shade400,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- NUEVO DIALOG PARA AGREGAR COMIDA ---
class AddMealDialog extends StatefulWidget {
  @override
  State<AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<AddMealDialog> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String time = '';
  String foods = '';
  int calories = 0;
  int protein = 0;
  int carbs = 0;
  int fat = 0;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Registrar comida'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                onSaved: (v) => name = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Hora (HH:mm)'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                onSaved: (v) => time = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Alimentos (separados por coma)'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                onSaved: (v) => foods = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Calorías'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                onSaved: (v) => calories = int.tryParse(v ?? '') ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Proteínas (g)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => protein = int.tryParse(v ?? '') ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Carbohidratos (g)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => carbs = int.tryParse(v ?? '') ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Grasas (g)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => fat = int.tryParse(v ?? '') ?? 0,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: loading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: loading
              ? null
              : () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              setState(() => loading = true);
              final meal = Meal(
                id: '', // Firestore asigna el id
                name: name,
                time: time,
                foods: foods.split(',').map((e) => e.trim()).toList(),
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
              );
              final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
              await MealService().addMeal(today, meal);
              Navigator.pop(context);
            }
          },
          child: loading ? const CircularProgressIndicator() : const Text('Registrar comida'),
        ),
      ],
    );
  }
}

// --- DIALOG PARA EDITAR COMIDA ---
class EditMealDialog extends StatefulWidget {
  final Meal meal;
  const EditMealDialog({super.key, required this.meal});

  @override
  State<EditMealDialog> createState() => _EditMealDialogState();
}

class _EditMealDialogState extends State<EditMealDialog> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String time;
  late String foods;
  late int calories;
  late int protein;
  late int carbs;
  late int fat;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    name = widget.meal.name;
    time = widget.meal.time;
    foods = widget.meal.foods.join(', ');
    calories = widget.meal.calories;
    protein = widget.meal.protein;
    carbs = widget.meal.carbs;
    fat = widget.meal.fat;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar comida'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                onSaved: (v) => name = v ?? '',
              ),
              TextFormField(
                initialValue: time,
                decoration: const InputDecoration(labelText: 'Hora (HH:mm)'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                onSaved: (v) => time = v ?? '',
              ),
              TextFormField(
                initialValue: foods,
                decoration: const InputDecoration(labelText: 'Alimentos (separados por coma)'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                onSaved: (v) => foods = v ?? '',
              ),
              TextFormField(
                initialValue: calories.toString(),
                decoration: const InputDecoration(labelText: 'Calorías'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                onSaved: (v) => calories = int.tryParse(v ?? '') ?? 0,
              ),
              TextFormField(
                initialValue: protein.toString(),
                decoration: const InputDecoration(labelText: 'Proteínas (g)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => protein = int.tryParse(v ?? '') ?? 0,
              ),
              TextFormField(
                initialValue: carbs.toString(),
                decoration: const InputDecoration(labelText: 'Carbohidratos (g)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => carbs = int.tryParse(v ?? '') ?? 0,
              ),
              TextFormField(
                initialValue: fat.toString(),
                decoration: const InputDecoration(labelText: 'Grasas (g)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => fat = int.tryParse(v ?? '') ?? 0,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: loading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: loading
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() => loading = true);
                    final updatedMeal = Meal(
                      id: widget.meal.id,
                      name: name,
                      time: time,
                      foods: foods.split(',').map((e) => e.trim()).toList(),
                      calories: calories,
                      protein: protein,
                      carbs: carbs,
                      fat: fat,
                    );
                    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                    await MealService().updateMeal(today, updatedMeal);
                    Navigator.pop(context);
                  }
                },
          child: loading ? const CircularProgressIndicator() : const Text('Guardar cambios'),
        ),
      ],
    );
  }
}
