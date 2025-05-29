import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'hydration/hydration_screen.dart';
import 'meals/meals_screen.dart';
import 'diet/diet_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HydrationScreen(),
    const MealsScreen(),
    const DietScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.water_drop),
                label: 'H2O',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu),
                label: 'Comidas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart),
                label: 'Dietas',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
