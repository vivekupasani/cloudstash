import 'package:docs/features/home/presentation/view_image.dart';
import 'package:docs/responsive/scaffold_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docs/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:docs/features/post/presentation/cubit/post_cubit.dart';
import 'package:docs/features/post/domain/post.dart';
import 'package:docs/features/post/presentation/upload_file_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController renameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Color> tileColors = [
    const Color(0xFF1976D2), // Medium Blue
    const Color(0xFF8E24AA), // Medium Purple
    const Color(0xFFD81B60), // Medium Pink
    const Color(0xFF00796B), // Medium Teal
    const Color(0xFF388E3C), // Medium Green
    const Color(0xFFF57C00), // Medium Orange
    const Color(0xFFEF5350), // Medium Deep Orange
    const Color(0xFF8E24AA), // Medium Magenta
    const Color(0xFFFBC02D), // Medium Yellow
    const Color(0xFF00ACC1), // Medium Cyan
    const Color(0xFF303F9F), // Medium Indigo
    const Color(0xFF9C27B0), // Medium Rich Purple
  ];

  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.currentuser;

    if (currentUser != null) {
      context.read<PostCubit>().fetchFile(currentUser.id, currentUser.token);
    }
  }

  @override
  void dispose() {
    renameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('MMM d, y · h:mm a').format(date);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Logout'),
          content: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Are you sure you want to log out?',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthCubit>().signOut();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child:
                  const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void showOptions(BuildContext context, Post file) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Make the background transparent
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Rename button
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.edit, color: Colors.blue.shade700),
                ),
                title: const Text('Rename'),
                subtitle: const Text('Change the file name'),
                onTap: () {
                  Navigator.pop(context);
                  _renameFile(file, context);
                },
              ),
              const Divider(height: 1),
              // Delete button
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.delete, color: Colors.red.shade700),
                ),
                title: const Text('Delete'),
                subtitle: const Text('Remove this file permanently'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteFile(file, context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _renameFile(Post file, dynamic context) {
    renameController.text = file.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            Colors.transparent, // Transparent background for dialog
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          'Rename File',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLength: 50,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              controller: renameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter new name',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade700),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            if (renameController.text.trim().isEmpty)
              Text(
                'File name cannot be empty!',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newFileName = renameController.text.trim();
              if (newFileName.isNotEmpty) {
                final authCubit = context.read<AuthCubit>();
                if (authCubit.currentuser != null) {
                  context.read<PostCubit>().updateFile(
                        file.id,
                        newFileName,
                        authCubit.currentuser!,
                      );

                  Navigator.pop(context);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File name cannot be empty'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Rename',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteFile(Post file, dynamic context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            Colors.transparent, // Transparent background for dialog
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title:
            const Text('Delete File?', style: TextStyle(color: Colors.white)),
        content: const Text('This action cannot be undone.',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PostCubit>().deleteFile(file.id);

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldResponsive(
      // Refined AppBar
      appBar: AppBar(
        elevation: 3,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: false,
        title: const Text(
          'CloudStash',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),

      // Sleek Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UploadFilePage()));
        },
        backgroundColor: Colors.blue.shade700,
        elevation: 5,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),

      // Body
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            if (state.files.isEmpty) {
              return _buildEmptyState();
            }

            return _buildFileList(state.files);
          } else if (state is PostError) {
            return _buildErrorState(state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.currentuser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center everything
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No files found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start uploading your files!',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          // Spacer to push the "Logged in as" text to the bottom
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Logged in as: ${currentUser!.email}',
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 90, 90, 90),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              final authCubit = context.read<AuthCubit>();
              final currentUser = authCubit.currentuser;
              if (currentUser != null) {
                context
                    .read<PostCubit>()
                    .fetchFile(currentUser.id, currentUser.token);
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFileList(List<Post> files) {
    final authCubit = context.read<AuthCubit>();
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              final cardBackground = tileColors[index % tileColors.length];

              return Card(
                color: cardBackground,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewImage(post: file),
                        ));
                  },
                  contentPadding: const EdgeInsets.all(12),
                  leading: const Icon(Icons.insert_drive_file,
                      color: Colors.blue, size: 32),
                  title: Text(file.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(_formatDate(file.createdAt)),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showOptions(context, file);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Logged in as: ${authCubit.currentuser!.email}',
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 90, 90, 90),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _downloadFile(Post file) {}
}
