import 'package:flutter/material.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/entrepreneur.dart';
import 'package:pinepro/models/user.dart';
import 'entrepreneur_detail.dart';

class RegisteredEntrepreneursPage extends StatefulWidget {
  final User loggedInUser;

  const RegisteredEntrepreneursPage({super.key, required this.loggedInUser});

  @override
  State<RegisteredEntrepreneursPage> createState() =>
      _RegisteredEntrepreneursPageState();
}

class _RegisteredEntrepreneursPageState
    extends State<RegisteredEntrepreneursPage> {
  List<Entrepreneur> entrepreneurs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEntrepreneurs();
  }

  Future<void> loadEntrepreneurs() async {
    final db = await DatabaseHelper.instance.database;
    final data = await db.query('entrepreneurs');

    setState(() {
      entrepreneurs = data.map((item) => Entrepreneur.fromMap(item)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Registered Entrepreneurs")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Registered Entrepreneurs")),
      body: entrepreneurs.isEmpty
          ? const Center(child: Text("No registered entrepreneurs found."))
          : ListView.builder(
        itemCount: entrepreneurs.length,
        itemBuilder: (ctx, index) {
          final e = entrepreneurs[index];

          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              leading: e.imageUrl != null && e.imageUrl!.isNotEmpty
                  ? CircleAvatar(
                  backgroundImage: NetworkImage(e.imageUrl!))
                  : const CircleAvatar(child: Icon(Icons.store)),
              title: Text(e.name),
              subtitle: Text(
                  "${e.businessType}\n${e.location}\n📞 ${e.phone}"),
              isThreeLine: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        EntrepreneurDetail(entrepreneur: e),
                  ),
                );
              },
              trailing: null, // No delete button
            ),
          );
        },
      ),
    );
  }
}
