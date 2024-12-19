import 'package:docs/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:docs/features/home/presentation/home_page.dart';
import 'package:docs/features/post/domain/post.dart';
import 'package:docs/features/post/presentation/cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ViewImage extends StatelessWidget {
  final Post post;

  ViewImage({super.key, required this.post});

  final renameController = TextEditingController();

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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

  void _downloadFile(Post file, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Download service is not available we\'ll notify you once it\'s available...'),
        backgroundColor: Colors.white,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(post.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, // Transparent app bar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Go back to previous screen
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              showOptions(context, post);
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image display
              Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    post.files, // Assuming the post has a URL to the image
                    fit: BoxFit.contain,
                    height: 400,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Display the creation date
              Text(
                _formatDate(post.createdAt),
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('MMM d, y · h:mm a').format(date);
  }
}
