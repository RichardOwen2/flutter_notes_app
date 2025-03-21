import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: child,
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              title: const Text('Notes'),
              onTap: () => Navigator.pushNamed(context, '/notes'),
            ),
            ListTile(
              title: const Text('Archived'),
              onTap: () => Navigator.pushNamed(context, '/notes/archived'),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // You can dispatch LogoutRequested here
                Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
