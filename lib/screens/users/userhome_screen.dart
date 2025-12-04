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
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2, // Entrepreneurs + Announcements
      child: Scaffold(
        key: _scaffoldKey,

        // ------------------ AppBar ------------------
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          title: Text("PinePro – ${widget.loggedInUser.name}"),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
            tabs: const [
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

        // ------------------ Drawer ------------------
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: theme.primaryColor),
                accountName: Text(
                  widget.loggedInUser.name,
                  style: const TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  widget.loggedInUser.email,
                  style: const TextStyle(color: Colors.white70),
                ),
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
        ),

        // ------------------ Body ------------------
        body: TabBarView(
          children: [
            EntrepreneurList(loggedInUser: widget.loggedInUser),
            AnnouncementList(loggedInUser: widget.loggedInUser),
          ],
        ),
      ),
    );
  }
}
