import 'package:flutter/material.dart';
import 'package:pinepro/screens/auth/login_screen.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/user.dart';
import 'package:pinepro/models/entrepreneur.dart';
import 'package:pinepro/screens/entrepreneurs/entrepreneur_list.dart';
import 'package:pinepro/screens/entrepreneurs/edit_entrepreneur_profile.dart';
import 'announcements/all_announcements.dart';
import 'announcements/announcement_list.dart';
import 'announcements/add_announcement.dart';
import 'entrepreneurs/entrepreneur_list_page.dart';
import 'entrepreneurs/registered_entrepreneurs_page.dart';

class HomeScreen extends StatefulWidget {
  final User loggedInUser;

  const HomeScreen({super.key, required this.loggedInUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Entrepreneur? entrepreneur;
  bool isLoading = true;
  String? loadError;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TabController? _tabController = null;

  @override
  void initState() {
    super.initState();
    _loadEntrepreneurData();
  }

  Future<void> _loadEntrepreneurData() async {
    try {
      final db = await DatabaseHelper.instance.database;

      final result = await db.query(
        'entrepreneurs',
        where: 'userId = ?',
        whereArgs: [widget.loggedInUser.id],
      );

      if (result.isNotEmpty) {
        entrepreneur = Entrepreneur.fromMap(result.first);
      } else {
        loadError = "No entrepreneur profile found for this user.";
      }
    } catch (e) {
      loadError = "Failed to load entrepreneur profile.";
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (entrepreneur == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("PinePro – Entrepreneur"),
        ),
        body: Center(
          child: Text(
            loadError ?? "No entrepreneur data found.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2, // Profile + My Announcements
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _buildDrawer(context),
        // ⭐ SIDEBAR HERE

        appBar: AppBar(
          title: const Text("PinePro – Entrepreneur"),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person), text: "Profile"),
              Tab(icon: Icon(Icons.campaign), text: "My Announcements"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
          ],
        ),

        body: TabBarView(
          children: [
            _buildProfileTab(),
            _buildAnnouncementsTab(),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddAnnouncement(
                  entrepreneurId: entrepreneur!.id!,  // 🔹 pass entrepreneurId
                ),
              ),
            );

            // 🔹 If new announcement saved, refresh announcements tab
            if (result == true) {
              setState(() {}); // simplest reload of AnnouncementList
            }
          },
          child: const Icon(Icons.add),
        ),

      ),
    );
  }

  /// ⭐  SIDEBAR / DRAWER IMPLEMENTATION
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(entrepreneur!.name),
            accountEmail: Text(widget.loggedInUser.email),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pop(context); // close drawer
              DefaultTabController.of(context).animateTo(0);
            },
          ),

          ListTile(
            leading: const Icon(Icons.campaign),
            title: const Text("All Announcements"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AllAnnouncementsPage(
                    loggedInUser: widget.loggedInUser,
                  ),
                ),
              );
            },
          ),


          ListTile(
            leading: const Icon(Icons.store),
            title: const Text("Registered Entrepreneurs"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegisteredEntrepreneursPage(
                    loggedInUser: widget.loggedInUser,
                  ),
                ),
              );
            },
          ),



          const Divider(),

          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditEntrepreneurProfileScreen(
                    entrepreneur: entrepreneur!,
                  ),
                ),
              ).then((updated) {
                if (updated == true) {
                  _loadEntrepreneurData();
                }
              });
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  /// 👤 Profile Tab
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entrepreneur!.name,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Business Type: ${entrepreneur!.businessType}"),
              Text("Location: ${entrepreneur!.location}"),
              Text("Phone: ${entrepreneur!.phone}"),
              if (entrepreneur!.telegram != null &&
                  entrepreneur!.telegram!.isNotEmpty)
                Text("Telegram: ${entrepreneur!.telegram}"),
              if (entrepreneur!.website != null &&
                  entrepreneur!.website!.isNotEmpty)
                Text("Website: ${entrepreneur!.website}"),
              const SizedBox(height: 12),
              if (entrepreneur!.description != null &&
                  entrepreneur!.description!.isNotEmpty)
                Text(
                  entrepreneur!.description!,
                  style: const TextStyle(fontSize: 14),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// 📢 Announcements Tab
  Widget _buildAnnouncementsTab() {
    return AnnouncementList(
      loggedInUser: widget.loggedInUser,
      entrepreneurId: entrepreneur!.id!,
      embedded: true,
    );
  }
}
