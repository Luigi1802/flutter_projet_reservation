import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pseudoController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  void _toggleMode() {
    setState(() {
      isLogin = !isLogin;
      _errorMessage = null;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(seconds: 1)); // Simule un délai réseau

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Simule un utilisateur existant (à remplacer par appel API)
    if (isLogin) {
      if (email == "client@peppe.com" && password == "1234") {
        Navigator.pop(context, true); // Retourne "true" à MainPage
      } else {
        setState(() => _errorMessage = "Identifiants invalides");
      }
    } else {
      // Simule une inscription réussie
      Navigator.pop(context, true);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? "Connexion" : "Inscription"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLogin
                            ? "Connectez-vous pour réserver"
                            : "Créez un compte pour réserver",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Champ pseudo visible uniquement à l'inscription
                      if (!isLogin)
                        TextFormField(
                          controller: _pseudoController,
                          decoration: const InputDecoration(
                            labelText: "Pseudo",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez entrer un pseudo";
                            }
                            return null;
                          },
                        ),

                      if (!isLogin) const SizedBox(height: 15),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez entrer votre email";
                          }
                          if (!value.contains("@")) {
                            return "Email invalide";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Mot de passe
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: "Mot de passe",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez entrer un mot de passe";
                          }
                          if (value.length < 4) {
                            return "Minimum 4 caractères";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Message d’erreur
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),

                      const SizedBox(height: 20),

                      // Bouton de connexion / inscription
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : Text(isLogin ? "Se connecter" : "S’inscrire"),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Changer de mode
                      TextButton(
                        onPressed: _toggleMode,
                        child: Text(isLogin
                            ? "Pas encore de compte ? S’inscrire"
                            : "Déjà un compte ? Se connecter"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
