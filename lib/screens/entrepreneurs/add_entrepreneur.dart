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

  final _nameController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();

  // NEW
  final _telegramController = TextEditingController();
  final _websiteController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _businessTypeController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _telegramController.dispose();
    _websiteController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveEntrepreneur() async {
    if (!_formKey.currentState!.validate()) return;

    final entrepreneur = Entrepreneur(
      name: _nameController.text.trim(),
      businessType: _businessTypeController.text.trim(),
      location: _locationController.text.trim(),
      phone: _phoneController.text.trim(),
      telegram: _telegramController.text.trim().isEmpty
          ? null
          : _telegramController.text.trim(),
      website: _websiteController.text.trim().isEmpty
          ? null
          : _websiteController.text.trim(),
      imageUrl: _imageUrlController.text.trim().isEmpty
          ? null
          : _imageUrlController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    final db = await DatabaseHelper.instance.database;
    await db.insert('entrepreneurs', entrepreneur.toMap());

    Navigator.pop(context, true); // tell previous page to reload
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Entrepreneur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _businessTypeController,
                decoration:
                const InputDecoration(labelText: 'Business Type / Product'),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // NEW FIELDS
              TextFormField(
                controller: _telegramController,
                decoration: const InputDecoration(
                  labelText: 'Telegram Handle (without @)',
                ),
              ),
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: 'Website / Online Store URL',
                ),
                keyboardType: TextInputType.url,
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (optional)',
                  hintText: 'https://example.com/image.jpg',
                ),
                keyboardType: TextInputType.url,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description / Short Bio',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveEntrepreneur,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
