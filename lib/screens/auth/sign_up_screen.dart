import 'package:flutter/material.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/user.dart';
import '../../models/entrepreneur.dart';
import '../home_screen.dart';

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
  String selectedRole = "user";

  // Entrepreneur fields
  final businessTypeController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final telegramController = TextEditingController();
  final websiteController = TextEditingController();
  final imageUrlController = TextEditingController();
  final descriptionController = TextEditingController();

  String? errorMessage;

  // VALIDATIONS (keep your version)
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Enter email";
    if (!value.contains("@") || !value.contains(".")) return "Enter a valid email";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Enter password";
    if (value.length < 6) return "Password must be at least 6 characters";

    final hasLetter = value.contains(RegExp(r'[A-Za-z]'));
    final hasNumber = value.contains(RegExp(r'[0-9]'));
    if (!hasLetter || !hasNumber) return "Password must contain letters and numbers";

    return null;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    businessTypeController.dispose();
    locationController.dispose();
    phoneController.dispose();
    telegramController.dispose();
    websiteController.dispose();
    imageUrlController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // SIGN UP
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    final db = await DatabaseHelper.instance.database;

    final newUser = User(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      role: selectedRole,
    );

    try {
      // INSERT user & get ID
      final userId = await db.insert('users', newUser.toMap());

      // If entrepreneur → save extra details
      if (selectedRole == "entrepreneur") {
        final ent = Entrepreneur(
          userId: userId,
          name: nameController.text.trim(),
          businessType: businessTypeController.text.trim(),
          location: locationController.text.trim(),
          phone: phoneController.text.trim(),
          telegram: telegramController.text.isEmpty
              ? null
              : telegramController.text.trim(),
          website: websiteController.text.isEmpty
              ? null
              : websiteController.text.trim(),
          imageUrl: imageUrlController.text.isEmpty
              ? null
              : imageUrlController.text.trim(),
          description: descriptionController.text.isEmpty
              ? null
              : descriptionController.text.trim(),
        );

        await db.insert('entrepreneurs', ent.toMap());
      }

      setState(() => errorMessage = null);
      Navigator.pop(context); // back to login
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

              // NAME
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter name" : null,
              ),

              // EMAIL
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),

              // PASSWORD
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: _validatePassword,
              ),

              const SizedBox(height: 16),

              // ROLE SELECTION
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: const [
                  DropdownMenuItem(value: "user", child: Text("User")),
                  DropdownMenuItem(value: "entrepreneur", child: Text("Entrepreneur")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
                decoration: const InputDecoration(labelText: "Role"),
              ),

              const SizedBox(height: 16),

              // EXTRA FIELDS (ONLY FOR ENTREPRENEURS)
              if (selectedRole == "entrepreneur") ...[
                TextFormField(
                  controller: businessTypeController,
                  decoration: const InputDecoration(labelText: "Business Type"),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Enter business type" : null,
                ),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Enter location" : null,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Enter phone" : null,
                ),
                TextFormField(
                  controller: telegramController,
                  decoration: const InputDecoration(labelText: "Telegram Handle (optional)"),
                ),
                TextFormField(
                  controller: websiteController,
                  decoration: const InputDecoration(labelText: "Website (optional)"),
                ),
                TextFormField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(labelText: "Image URL (optional)"),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description (optional)"),
                  maxLines: 3,
                ),
              ],

              if (errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
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
