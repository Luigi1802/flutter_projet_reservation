import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.title});

  final String title;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Liste des catégories
  final List<String> categories = [
    "Formules",
    "Entrées",
    "Plats",
    "Desserts",
    "Boissons",
  ];

  // Catégorie sélectionnée
  // Entrées par défaut
  String selectedCategory = "Entrées";

  // Données de plats codées en dur
  final Map<String, List<Map<String, dynamic>>> menu = {
    "Formules": [
      {
        "name": "Formule Midi",
        "price": 18.50,
        "image": "assets/images/formule.jpg",
        "description": "Pizza + dessert + boisson."
      },
    ],
    "Entrées": [
      {
        "name": "Cheesy Stick",
        "price": 9.90,
        "image": "assets/images/cheesy.jpg",
        "description": "3 bâtonnets de Provolone avec notre panure recette maison, servis avec une sauce tomate San Marzano mijotée 2h."
      },
      {
        "name": "Arancini pistache",
        "price": 6.50,
        "image": "assets/images/arancini.png",
        "description": "3 boules de riz croustillantes  au Fior di latte & pistache, accompagnées d'un pesto de pistache."
      },
    ],
    "Plats": [
      {
        "name": "Gnocchi alla Sorrentina",
        "price": 15.90,
        "image": "assets/images/sorrentina.jpg",
        "description": "Gnocchis fondants gratinés au four avec une sauce tomate maison, Provola fumée, Grana padano et basilic frais."
      },
      {
        "name": "Piccante Calabrese",
        "price": 13.50,
        "image": "assets/images/calabrese.jpg",
        "description": "Sauce tomate, Fior di latte, Ricotta fraîche, Spianata piccante, oignons confits et poivrons doux séchés."
      },
      {
        "name": "Regina",
        "price": 15.00,
        "image": "assets/images/regina.jpg",
        "description": "Sauce tomate, Fior di latte, champignons de Paris sautés, jambon cuit Gran Biscotto et persil."
      },
      {
        "name": "Margherita",
        "price": 13.50,
        "image": "assets/images/margherita.jpg",
        "description": "Tomates, Fior di Latte, Parmigiano Reggiano DOP et basilic."
      },
    ],
    "Desserts": [
      {
        "name": "Tiramisu",
        "price": 6.90,
        "image": "assets/images/tiramisu.jpg",
        "description": "Café et mascarpone."
      },
    ],
    "Boissons": [
      {
        "name": "Coca-Cola",
        "price": 2.50,
        "image": "assets/images/coca.png",
        "description": "Canette 33cl."
      },
      {
        "name": "Eau minérale",
        "price": 1.00,
        "image": "assets/images/eau.png",
        "description": "Giorgio 50cl"
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final dishes = menu[selectedCategory]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Catégories défilables horizontalement
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: Colors.redAccent,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Liste de plats scrollable
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                final dish = dishes[index];
                return DishCard(
                  name: dish["name"],
                  imageUrl: dish["image"],
                  price: dish["price"],
                  description: dish["description"],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DishCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final String description;

  const DishCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image du plat
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Texte descriptif
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Text(
                  "${price.toStringAsFixed(2)} €",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}