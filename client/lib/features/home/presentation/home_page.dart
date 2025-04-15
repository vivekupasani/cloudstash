import 'package:cloudstash/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cloudstash/features/home/presentation/view_stash.dart';
import 'package:cloudstash/features/profile/presentation/profile_page.dart';
import 'package:cloudstash/features/upload/presentation/upload_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final authcubit;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    authcubit = context.read<AuthCubit>();
    print(authcubit.currentuser.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    authcubit.currentuser.username,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_sharp, size: 32),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search your stash',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  IconButton(icon: const Icon(Icons.sort), onPressed: () {}),
                ],
              ),
              const SizedBox(height: 16),

              // stash grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    final titles = [
                      'Mobile apps',
                      'SVG icons',
                      'Prototypes',
                      'Avatars',
                      'Mobile apps',
                      'SVG icons',
                      'Prototypes',
                      'Avatars',
                    ];
                    return _gridItem(index, context, titles);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gridItem(int index, BuildContext context, List<String> titles) {
    final colors = [
      const Color(0xFFE9F1FF),
      const Color(0xFFFFF7E9),
      const Color(0xFFFFEAE9),
      const Color(0xFFE9FFF8),
      const Color(0xFFE9F1FF),
      const Color(0xFFFFF7E9),
      const Color(0xFFFFEAE9),
      const Color(0xFFE9FFF8),
    ];
    final iconColors = [
      Colors.blue[500],
      Colors.amber[500],
      Colors.red[400],
      Colors.cyan[400],
      Colors.blue[500],
      Colors.amber[500],
      Colors.red[400],
      Colors.cyan[400],
    ];
    final colorIndex = index % 4;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ViewStash(title: titles[index]);
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: colors[colorIndex],
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColors[colorIndex],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.folder, color: Colors.white),
                ),
                const Icon(Icons.more_vert, color: Colors.grey),
              ],
            ),
            const Spacer(),
            Text(
              titles[colorIndex],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              colorIndex % 2 == 0 ? 'December 20, 2020' : 'November 20, 2020',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
