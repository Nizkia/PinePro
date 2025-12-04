import 'package:flutter/material.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/user.dart';                // ✅ import User model
import 'package:pinepro/screens/home_screen.dart';
import 'package:pinepro/screens/users/userhome_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? errorMessage;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Enter email";
    if (!value.contains("@") || !value.contains(".")) {
      return "Enter a valid email";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Enter password";
    if (value.length < 6) return "Password must be at least 6 characters";

    final hasLetter = value.contains(RegExp(r'[A-Za-z]'));
    final hasNumber = value.contains(RegExp(r'[0-9]'));

    if (!hasLetter || !hasNumber) {
      return "Password must contain letters and numbers";
    }

    return null;
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final db = await DatabaseHelper.instance.database;

    // 🔹 Find user by email
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [emailController.text.trim()],
    );

    if (result.isEmpty) {
      setState(() {
        errorMessage = "No account found with this email";
      });
      return;
    }

    // 🔹 Convert DB row -> User model
    final user = User.fromMap(result.first);

    // 🔹 Check password
    if (user.password != passwordController.text) {
      setState(() {
        errorMessage = "Invalid email or password";
      });
      return;
    }

    // 🔹 Clear error message
    setState(() => errorMessage = null);

    // 🔹 Navigate based on role
    if (user.role == 'entrepreneur') {
      // Entrepreneur dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(loggedInUser: user),
        ),
      );
    } else {
      // Ordinary user home – now pass loggedInUser
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UserHomeScreen(loggedInUser: user),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PinePro Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: _validatePassword,
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text("Login"),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignUpScreen(),
                    ),
                  );
                },
                child: const Text("Create new account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
