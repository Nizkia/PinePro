import 'package:flutter/material.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/entrepreneur.dart';
import 'package:pinepro/models/user.dart';
import 'entrepreneur_detail.dart';

class EntrepreneurList extends StatefulWidget {
  final User loggedInUser;

  const EntrepreneurList({super.key, required this.loggedInUser});

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
      entrepreneurs = data.map((item) => Entrepreneur.fromMap(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final canDelete = widget.loggedInUser.role == "entrepreneur";

    return entrepreneurs.isEmpty
        ? const Center(child: Text("No entrepreneurs found."))
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
                ? CircleAvatar(backgroundImage: NetworkImage(e.imageUrl!))
                : const CircleAvatar(child: Icon(Icons.store)),
            title: Text(e.name),
            subtitle: Text("${e.businessType}\n${e.location}\n📞 ${e.phone}"),
            isThreeLine: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EntrepreneurDetail(entrepreneur: e),
                ),
              );
            },
            trailing: canDelete
                ? IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {}, // delete logic here if needed
            )
                : null,
          ),
        );
      },
    );
  }
}
