import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final pseudo = _pseudoController.text.trim();

    final String baseUrl = "http://localhost:8000";

    try {
      final url = Uri.parse(isLogin
          ? "$baseUrl/user/login"
          : "$baseUrl/user/register");

      final body = isLogin
          ? {"email": email, "password": password}
          : {"pseudo": pseudo, "email": email, "password": password};

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (isLogin) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("access_token", data["access_token"]);
          await prefs.setInt("idUser", data["user"]["idUser"]);
          await prefs.setString("pseudo", data["user"]["pseudo"]);
          await prefs.setString("email", data["user"]["email"]);
          await prefs.setInt("idRole", data["user"]["idRole"]);

          Navigator.pop(context, true); // signal succès
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Inscription réussie ! Vous pouvez vous connecter.")),
          );
          setState(() => isLogin = true);
        }
      } else {
        final errorData = jsonDecode(response.body);
        setState(() => _errorMessage =
            errorData["detail"] ?? "Erreur ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _errorMessage = "Erreur de connexion : $e");
    } finally {
      setState(() => _isLoading = false);
    }
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

                      if (!isLogin)
                        TextFormField(
                          controller: _pseudoController,
                          decoration: const InputDecoration(
                            labelText: "Nom / pseudonyme",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez entrer un nom / pseudo";
                            }
                            if (value.length < 2) {
                              return "Minimum 2 caractères";
                            }
                            return null;
                          },
                        ),

                      if (!isLogin) const SizedBox(height: 15),

                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final regex = RegExp(
                              r"^[\w\.-]+@[\w\.-]+\.\w+$");
                          if (value == null || value.isEmpty) {
                            return "Veuillez entrer votre email";
                          }
                          if (!regex.hasMatch(value)) {
                            return "Email invalide";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

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
                          if (value.length < 3) {
                            return "Minimum 3 caractères";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: _isLoading ? null : _submitForm,
                          child: _isLoading
                              ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            isLogin ? "Se connecter" : "S’inscrire",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      TextButton(
                        onPressed: _toggleMode,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: isLogin
                                    ? "Pas encore de compte ? "
                                    : "Déjà un compte ? ",
                                style: const TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: isLogin ? "S’inscrire" : "Se connecter",
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
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
