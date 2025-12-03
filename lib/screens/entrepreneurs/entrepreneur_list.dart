import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/entrepreneur.dart';
import 'add_entrepreneur.dart';

class EntrepreneurList extends StatefulWidget {
  const EntrepreneurList({super.key});

  @override
  State<EntrepreneurList> createState() => _EntrepreneurListState();
}

class _EntrepreneurListState extends State<EntrepreneurList> {
  List<Entrepreneur> entrepreneurs = [];

  @override
  void initState() {
    super.initState();
    loadEntrepreneurs();
  }

  Future<void> loadEntrepreneurs() async {
    final db = await DatabaseHelper.instance.database;
    final data = await db.query('entrepreneurs');
    setState(() {
      entrepreneurs =
          data.map((item) => Entrepreneur.fromMap(item)).toList();
    });
  }

  Future<void> deleteEntrepreneur(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'entrepreneurs',
      where: 'id = ?',
      whereArgs: [id],
    );
    loadEntrepreneurs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Entrepreneurs")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEntrepreneur(),
            ),
          );
          if (result == true) loadEntrepreneurs();
        },
        child: const Icon(Icons.add),
      ),
      body: entrepreneurs.isEmpty
          ? const Center(child: Text("No entrepreneurs added yet."))
          : ListView.builder(
        itemCount: entrepreneurs.length,
        itemBuilder: (ctx, index) {
          final e = entrepreneurs[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 15, vertical: 8),
            child: ListTile(
              title: Text(e.name),
              subtitle: Text(
                  "${e.businessType}\n${e.location}\n📞 ${e.phone}"),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  deleteEntrepreneur(e.id!);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
