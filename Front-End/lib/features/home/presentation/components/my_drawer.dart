import 'package:docs/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:docs/features/home/presentation/components/my_drawer_tile.dart';
import 'package:docs/features/post/presentation/upload_file_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // App logo
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Icon(
                    Icons.person,
                    size: 82,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                // Home tile
                MyDrawerTile(
                    title: "H O M E",
                    icon: Icons.home,
                    onTap: () {
                      Navigator.pop(context);
                    }),

                // Settings tile
                MyDrawerTile(
                  title: "S E T T I N G S",
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                // Upload file tile
                MyDrawerTile(
                    title: "U P L O A D  F I L E",
                    icon: Icons.upload_file,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UploadFilePage(),
                          ));
                    }),
              ],
            ),
            // Logout tile
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: MyDrawerTile(
                  title: "L O G O U T",
                  icon: Icons.logout,
                  onTap: () async {
                    final authCubit = context.read<AuthCubit>();
                    authCubit.signOut();
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
