import 'package:flutter/material.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/entrepreneur.dart';

class EditEntrepreneurProfileScreen extends StatefulWidget {
  final Entrepreneur entrepreneur; // 🔹 existing data to edit

  const EditEntrepreneurProfileScreen({
    super.key,
    required this.entrepreneur,
  });

  @override
  State<EditEntrepreneurProfileScreen> createState() =>
      _EditEntrepreneurProfileScreenState();
}

class _EditEntrepreneurProfileScreenState
    extends State<EditEntrepreneurProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _businessTypeController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;
  late TextEditingController _telegramController;
  late TextEditingController _websiteController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    // 🔹 Pre-fill with existing entrepreneur data
    _nameController =
        TextEditingController(text: widget.entrepreneur.name);
    _businessTypeController =
        TextEditingController(text: widget.entrepreneur.businessType);
    _locationController =
        TextEditingController(text: widget.entrepreneur.location);
    _phoneController =
        TextEditingController(text: widget.entrepreneur.phone);
    _telegramController =
        TextEditingController(text: widget.entrepreneur.telegram ?? "");
    _websiteController =
        TextEditingController(text: widget.entrepreneur.website ?? "");
    _imageUrlController =
        TextEditingController(text: widget.entrepreneur.imageUrl ?? "");
    _descriptionController =
        TextEditingController(text: widget.entrepreneur.description ?? "");
  }

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

    // 🔹 Create a new Entrepreneur object with updated values
    final updatedEntrepreneur = Entrepreneur(
      id: widget.entrepreneur.id,             // keep same PK
      userId: widget.entrepreneur.userId,     // keep same FK
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

    await db.update(
      'entrepreneurs',
      updatedEntrepreneur.toMap(),
      where: 'id = ?',
      whereArgs: [updatedEntrepreneur.id],
    );

    // 🔹 Go back and tell previous screen “I updated”
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
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
                decoration: const InputDecoration(
                  labelText: 'Business Type / Product',
                ),
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
                decoration:
                const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Optional fields
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
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
