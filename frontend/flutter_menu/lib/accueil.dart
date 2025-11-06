import 'package:flutter/material.dart';
import 'menu.dart';


class AccueilPage extends StatelessWidget {
  final VoidCallback onMenuPressed;
  const AccueilPage({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Bienvenue chez Peppe Pizzeria 🍕",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Découvrez nos recettes italiennes authentiques et réservez votre table directement depuis l’application.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onMenuPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Accéder au menu",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Image.network(
                  "assets/images/home_img.jpeg",
                  height: 320,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.redAccent, size: 20),
                  Icon(Icons.star, color: Colors.redAccent, size: 20),
                  Icon(Icons.star, color: Colors.redAccent, size: 20),
                  Icon(Icons.star, color: Colors.redAccent, size: 20),
                  Icon(Icons.star_half, color: Colors.redAccent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '(1839 avis)',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "5 Rue des Marronniers, 69002 Lyon",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Ouvert tous les jours :",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const Text(
                "12:00–14:30, 19:00–22:45",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
