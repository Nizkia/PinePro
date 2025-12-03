import 'package:flutter/material.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? errorMessage;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Enter email";

    // must contain @ and .
    if (!value.contains("@") || !value.contains(".")) {
      return "Enter a valid email";
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Enter password";
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    final hasLetter = value.contains(RegExp(r'[A-Za-z]'));
    final hasNumber = value.contains(RegExp(r'[0-9]'));

    if (!hasLetter || !hasNumber) {
      return "Password must contain letters and numbers";
    }

    return null;
  }

  Future<void> _signUp() async {
    // 🔴 THIS is what stops invalid values
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final db = await DatabaseHelper.instance.database;

    final newUser = User(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    try {
      await db.insert('users', newUser.toMap());
      setState(() => errorMessage = null);

      // Go back to login after successful registration
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        errorMessage = "Email already registered or error occurred.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter name" : null,
              ),

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
                onPressed: _signUp,
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
