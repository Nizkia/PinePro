import 'package:flutter/material.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/user.dart';
import '../../models/entrepreneur.dart';
import '../home_screen.dart';
//import '../userhome_screen.dart';

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

  // Role
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

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    final db = await DatabaseHelper.instance.database;

    final user = User(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      role: selectedRole,
    );

    try {
      await db.insert('users', user.toMap());

      // If role is entrepreneur, insert entrepreneur details
      if (selectedRole == "entrepreneur") {
        final entrepreneur = Entrepreneur(
          name: nameController.text.trim(),
          businessType: businessTypeController.text.trim(),
          location: locationController.text.trim(),
          phone: phoneController.text.trim(),
          telegram: telegramController.text.trim().isEmpty
              ? null
              : telegramController.text.trim(),
          website: websiteController.text.trim().isEmpty
              ? null
              : websiteController.text.trim(),
          imageUrl: imageUrlController.text.trim().isEmpty
              ? null
              : imageUrlController.text.trim(),
          description: descriptionController.text.trim().isEmpty
              ? null
              : descriptionController.text.trim(),
        );

        await db.insert('entrepreneurs', entrepreneur.toMap());
      }

      setState(() => errorMessage = null);
      Navigator.pop(context); // go back to login
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) =>
                value == null || value.isEmpty ? "Enter password" : null,
              ),
              const SizedBox(height: 16),

              // Role selection
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: const [
                  DropdownMenuItem(
                    value: "user",
                    child: Text("User"),
                  ),
                  DropdownMenuItem(
                    value: "entrepreneur",
                    child: Text("Entrepreneur"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
                decoration: const InputDecoration(labelText: "Role"),
              ),

              const SizedBox(height: 16),

              // Entrepreneur extra fields
              if (selectedRole == "entrepreneur") ...[
                TextFormField(
                  controller: businessTypeController,
                  decoration:
                  const InputDecoration(labelText: "Business Type"),
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
                  decoration: const InputDecoration(
                      labelText: "Telegram Handle (optional)"),
                ),
                TextFormField(
                  controller: websiteController,
                  decoration:
                  const InputDecoration(labelText: "Website (optional)"),
                ),
                TextFormField(
                  controller: imageUrlController,
                  decoration:
                  const InputDecoration(labelText: "Image URL (optional)"),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration:
                  const InputDecoration(labelText: "Description (optional)"),
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
