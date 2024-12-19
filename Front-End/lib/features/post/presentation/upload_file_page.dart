import 'package:docs/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:docs/features/post/presentation/cubit/post_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadFilePage extends StatefulWidget {
  const UploadFilePage({super.key});

  @override
  State<UploadFilePage> createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  PlatformFile? selectedFile;
  Uint8List? fileBytes;

  final List<Color> tileolors = [
    const Color(0xFF0D47A1), // Dark Blue
    const Color(0xFF004D40), // Dark Teal
    const Color(0xFF00695C), // Dark Cyan
  ];

  // PICK FILE FROM SYSTEM
  void pickFile() async {
    // Try to pick file
    try {
      // Store result
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false, // Single file only
        withData: kIsWeb,
      );

      // Check result is not null and has selected file
      if (result != null && result.files.isNotEmpty) {
        // Set the state to show file on the screen
        setState(() {
          selectedFile = result.files.first;
          fileBytes = kIsWeb ? selectedFile!.bytes : null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No file selected.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking file: $e")),
      );
    }
  }

  // UPLOAD FILE TO STORAGE AND DB
  void uploadFile() async {
    // Check selected image is not null
    if (selectedFile != null) {
      try {
        // Try to upload file
        final authCubit = context.read<AuthCubit>();
        final postCubit = context.read<PostCubit>();
        final currentuser = authCubit.currentuser;
        await postCubit.uploadFile(
            selectedFile!, currentuser!.token, currentuser.id);
        // Show snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("File uploaded successfully!")),
        );
        // Throw error if exists
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading file: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No file to upload. Please select one.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostUploading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Uploading..."),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: const Text(
              "Upload File",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            foregroundColor: Colors.white,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: uploadFile,
                  child: const Icon(Icons.upload),
                ),
              ),
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16.0),
                    if (selectedFile == null)
                      const Text(
                        "No file selected.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    if (selectedFile != null)
                      Column(
                        children: [
                          // Display the image thumbnail if it's available
                          if (fileBytes != null)
                            Image.memory(
                              fileBytes!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(height: 16),
                          Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            color: Colors.blue.shade700,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.file_present,
                                  color: Colors.blue.shade700,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                selectedFile!.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                "Size: ${(selectedFile!.size / 1024).toStringAsFixed(2)} KB",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Floating Action Button to pick a file
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: pickFile,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Pick File',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is PostUploaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("File uploaded successfully!")),
          );
          Navigator.pop(context);
        }
      },
    );
  }
}
