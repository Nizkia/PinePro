import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pinepro/models/entrepreneur.dart';
import 'package:url_launcher/url_launcher.dart';

class EntrepreneurDetail extends StatelessWidget {
  final Entrepreneur entrepreneur;

  const EntrepreneurDetail({super.key, required this.entrepreneur});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(entrepreneur.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: (entrepreneur.imageUrl != null &&
                    entrepreneur.imageUrl!.isNotEmpty)
                    ? NetworkImage(entrepreneur.imageUrl!)
                    : null,
                child: (entrepreneur.imageUrl == null ||
                    entrepreneur.imageUrl!.isEmpty)
                    ? const Icon(Icons.store, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              entrepreneur.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              entrepreneur.businessType,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text("📍 ${entrepreneur.location}"),
            Text("📞 ${entrepreneur.phone}"),

            const SizedBox(height: 16),

            if (entrepreneur.description != null &&
                entrepreneur.description!.isNotEmpty)
              Text(
                entrepreneur.description!,
                style: const TextStyle(fontSize: 16),
              ),

            const SizedBox(height: 16),

            if (entrepreneur.telegram != null &&
                entrepreneur.telegram!.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.telegram),
                title: Text(
                  "@${entrepreneur.telegram}",
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () async {
                  final username = entrepreneur.telegram!.trim();

                  // final URL to open
                  final url = Uri.parse("https://t.me/$username");
                  print("Launching: https://t.me/$username");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Could not open Telegram link")),
                    );
                  }
                },
              ),



            if (entrepreneur.website != null &&
                entrepreneur.website!.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.link),
                title: Text(entrepreneur.website!),
                onTap: () async {
                  final url = Uri.parse(entrepreneur.website!);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
