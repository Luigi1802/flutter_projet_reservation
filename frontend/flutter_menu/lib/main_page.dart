import 'package:flutter/material.dart';
import 'accueil.dart';
import 'menu.dart';
import 'reservations.dart';
import 'auth.dart'; // Pour gérer la connexion si non connecté

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Simule l'état de connexion (à remplacer par un vrai token JWT plus tard)
  bool isLoggedIn = false;

  void _onItemTapped(int index) {
    setState(() {
      // Si l'utilisateur tente d'accéder à "Réservations" sans être connecté
      if (index == 2 && !isLoggedIn) {
        _showAuthDialog();
      } else {
        _selectedIndex = index;
      }
    });
  }

  void _showAuthDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Connexion requise"),
        content: const Text(
            "Vous devez être connecté pour accéder à vos réservations."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AuthPage()),
              ).then((value) {
                // Quand l'utilisateur revient après connexion
                if (value == true) {
                  setState(() {
                    isLoggedIn = true;
                    _selectedIndex = 2; // Va à la page réservations
                  });
                }
              });
            },
            child: const Text("Se connecter"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      AccueilPage(
        onMenuPressed: () {
          setState(() {
            _selectedIndex = 1; // passe à l’onglet Menu
          });
        },
      ),
      const MenuPage(),
      const ReservationsPage(role: "client", clientName: "luigi", clientId: 2),
    ];
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pizza),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Réservations',
          ),
        ],
      ),
    );
  }
}
