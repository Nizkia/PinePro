import 'package:flutter/material.dart';
import 'package:pinepro/models/user.dart';
import '../entrepreneurs/entrepreneur_list.dart';
import '../announcements/announcement_list.dart';
import '../auth/login_screen.dart';

class UserHomeScreen extends StatefulWidget {
  final User loggedInUser;

  const UserHomeScreen({super.key, required this.loggedInUser});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Entrepreneurs + Announcements
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("PinePro – ${widget.loggedInUser.name}"),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.store), text: "Entrepreneurs"),
              Tab(icon: Icon(Icons.campaign), text: "Announcements"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        drawer: _buildDrawer(),
        body: TabBarView(
          children: [
            // All entrepreneurs are visible to users
            EntrepreneurList(loggedInUser: widget.loggedInUser),
            // All announcements visible to users
            AnnouncementList(loggedInUser: widget.loggedInUser),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.loggedInUser.name),
            accountEmail: Text(widget.loggedInUser.email),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text("Entrepreneurs List"),
            onTap: () {
              Navigator.pop(context);
              DefaultTabController.of(context)?.animateTo(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.campaign),
            title: const Text("Announcements"),
            onTap: () {
              Navigator.pop(context);
              DefaultTabController.of(context)?.animateTo(1);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
