import 'package:flutter/material.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/entrepreneur.dart';

class AddEntrepreneur extends StatefulWidget {
  const AddEntrepreneur({super.key});

  @override
  State<AddEntrepreneur> createState() => _AddEntrepreneurState();
}

class _AddEntrepreneurState extends State<AddEntrepreneur> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final businessTypeController = TextEditingController();

  Future<void> saveEntrepreneur() async {
    if (_formKey.currentState!.validate()) {
      final newEntrepreneur = Entrepreneur(
        name: nameController.text,
        phone: phoneController.text,
        location: locationController.text,
        businessType: businessTypeController.text,
      );

      final db = await DatabaseHelper.instance.database;
      await db.insert('entrepreneurs', newEntrepreneur.toMap());

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Entrepreneur")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
                validator: (value) =>
                value!.isEmpty ? "Please enter name" : null,
              ),

              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                ),
                validator: (value) =>
                value!.isEmpty ? "Please enter phone number" : null,
              ),

              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "Farm/Shop Location",
                ),
                validator: (value) =>
                value!.isEmpty ? "Please enter location" : null,
              ),

              TextFormField(
                controller: businessTypeController,
                decoration: const InputDecoration(
                  labelText: "Business Type",
                ),
                validator: (value) =>
                value!.isEmpty ? "Please enter business type" : null,
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveEntrepreneur,
                child: const Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
