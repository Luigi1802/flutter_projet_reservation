import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'accueil.dart';
import 'menu.dart';
import 'reservations.dart';
import 'auth.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool isLoggedIn = false;
  int? idRole;
  String? pseudo;
  int? idUser;
  String? token; // <-- Ajout du token ici

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString("access_token");
    final savedRole = prefs.getInt("idRole");
    final savedPseudo = prefs.getString("pseudo");
    final savedId = prefs.getInt("idUser");

    setState(() {
      token = savedToken;
      isLoggedIn = savedToken != null;
      idRole = savedRole ?? 2;
      pseudo = savedPseudo ?? "client";
      idUser = savedId ?? 0;
    });
  }

  void _onItemTapped(int index) {
    if (index == 2 && !isLoggedIn) {
      _showAuthDialog();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showAuthDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Connexion requise"),
        content: const Text("Vous devez être connecté pour accéder à vos réservations."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthPage()))
                  .then((value) async {
                if (value == true) {
                  await _loadSession(); // recharge les infos (token, pseudo, etc.)
                  setState(() => _selectedIndex = 2);
                }
              });
            },
            child: const Text("Se connecter", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 On passe le token ici à la page Réservations
    final List<Widget> _pages = [
      AccueilPage(onMenuPressed: () => setState(() => _selectedIndex = 1)),
      const MenuPage(),
      ReservationsPage(
        idRole: idRole ?? 2,
        clientName: pseudo ?? "",
        clientId: idUser ?? 0,
        token: token ?? "", // <-- ajout ici
      ),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.local_pizza), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Réservations'),
        ],
      ),
    );
  }
}
