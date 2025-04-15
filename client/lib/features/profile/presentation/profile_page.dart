import 'package:cloudstash/features/auth/domain/auth_repo.dart';
import 'package:cloudstash/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cloudstash/features/home/presentation/settings_page.dart';
import 'package:cloudstash/features/upload/presentation/upload_page.dart';
import 'package:cloudstash/features/utils/AvtaarPainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

    final authCubit = context.read<AuthCubit>();
    authCubit.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AuthError) {
          return Center(child: Text(state.message));
        } else if (state is Authenticated) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              title: Text('My profile'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile card
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.blue[200],
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: CustomPaint(
                                      painter: AvatarPainter(),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Text(
                                    'Hey!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.user.username,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.user.profession,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.user.about,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // My folders header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'My stash',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UploadPage(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.add, color: Colors.blue),
                                Text(
                                  'Add new',
                                  style: TextStyle(
                                    color: Colors.blue[500],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Folder grid
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.1,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: 8,
                        itemBuilder: (context, index) {
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

                          return Container(
                            decoration: BoxDecoration(
                              color: colors[index],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: iconColors[index],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.folder,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.more_vert,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  titles[index],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  index % 2 == 0
                                      ? 'December 20, 2020'
                                      : 'December 14, 2020',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('Unknown state'));
        }
      },
    );
  }
}
