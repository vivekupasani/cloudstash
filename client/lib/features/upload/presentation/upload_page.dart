// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'dart:typed_data';

import 'package:cloudstash/features/upload/presentation/cubit/files_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import 'package:cloudstash/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cloudstash/features/upload/data/file_api_repo.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with SingleTickerProviderStateMixin {
  PlatformFile? _selectedImage;
  Uint8List? webImage;

  final FileApiRepo fileRepo = FileApiRepo();

  late AuthCubit authCubit;
  late FilesCubit filesCubit;

  // Animation controller for the upload animation
  late AnimationController _animationController;

  late String fileSize;
  bool _isUploading = false; // Prevent overlapping uploads

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    authCubit = context.read<AuthCubit>();
    filesCubit = context.read<FilesCubit>();
    debugPrint(
      authCubit.currentuser != null
          ? "uid : ${authCubit.currentuser!.id}"
          : "User is null",
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: kIsWeb,
    );

    if (res != null && res.files.isNotEmpty) {
      setState(() {
        _selectedImage = res.files.first;
        if (kIsWeb) webImage = _selectedImage?.bytes;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_isUploading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An upload is already in progress.")),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select file to upload!')));
      return;
    }

    if (authCubit.currentuser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    _isUploading = true;

    try {
      if (kIsWeb && webImage != null) {
        await filesCubit.uploadFile(
          userId: authCubit.currentuser!.id,
          name: _selectedImage!.name,
          type: _selectedImage!.extension ?? 'unknown',
          size: fileSize,
          fileName: _selectedImage!.name,
          webImage: webImage,
        );
      } else if (!kIsWeb && _selectedImage != null) {
        await filesCubit.uploadFile(
          userId: authCubit.currentuser!.id,
          name: _selectedImage!.name,
          type: _selectedImage!.extension ?? 'unknown',
          size: fileSize,
          fileName: _selectedImage!.name,
          path: _selectedImage!.path,
        );
      }

      // Reset the selected image after upload
      setState(() {
        _selectedImage = null;
        webImage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      _isUploading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = _selectedImage?.name ?? '';
    fileSize =
        _selectedImage != null
            ? '${(_selectedImage!.size / (1024 * 1024)).toStringAsFixed(2)} MB'
            : '';

    return BlocConsumer<FilesCubit, FilesState>(
      listener: (context, state) {
        if (state is FilesLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("File uploaded successfully!")),
          );
          Navigator.pop(context);
        } else if (state is FileError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is FilesLoading || state is FileUploading) {
          return _buildUploadingState(state);
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: const Text(
              'Upload File',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF4F7FFF).withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _buildImagePreview(),
                        ),
                      ),
                    ),
                  ),
                  if (_selectedImage != null) ...[
                    const SizedBox(height: 24),
                    _buildFileInfo(fileName, fileSize),
                  ],
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadingState(FilesState state) {
    final progress = state is FileUploading ? state.progress : 0.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Upload illustration
            Image.network(
              "https://imgs.search.brave.com/B50zfTBzRXbCG0qcfUnfCWRy5WN-iHikwgqsehTotAg/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdG9y/aWVzLmZyZWVwaWts/YWJzLmNvbS9zdG9y/YWdlLzI1MTQvMjQ5/LVVwbG9hZF9BcnRi/b2FyZC0xLnN2Zw",
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 32),

            // Animated title
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    2 * (0.5 - _animationController.value).abs(),
                  ),
                  child: child,
                );
              },
              child: const Text(
                "Uploading your file",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F7FFF),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text(
              _selectedImage?.name ?? "File",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),

            // Progress indicator with percentage
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: const Color(0xFF4F7FFF).withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF4F7FFF),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF4F7FFF),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Text(
              "Please wait while your file is being uploaded to CloudStash",
              style: TextStyle(color: Colors.black54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImage != null) {
      final isImage =
          _selectedImage!.extension != null &&
          [
            'jpg',
            'jpeg',
            'png',
            'gif',
            'bmp',
            'webp'
                'ico',
          ].contains(_selectedImage!.extension!.toLowerCase());

      if (isImage) {
        if (kIsWeb && webImage != null) {
          return Image.memory(webImage!, fit: BoxFit.cover);
        } else if (!kIsWeb && _selectedImage!.path != null) {
          return Image.file(File(_selectedImage!.path!), fit: BoxFit.cover);
        }
      }

      // If not image, show placeholder
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://imgs.search.brave.com/spFQ8yd9PI41hcesAL7MMkF1fzDi-vm2_tkRJR9d9_I/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdG9y/aWVzLmZyZWVwaWts/YWJzLmNvbS9zdG9y/YWdlLzYyMzA5L0Rl/Y2lzaW9uLWZhdGln/dWVfQXJ0Ym9hcmQt/MS5zdmc",
              height: 300,
              width: 300,
              fit: BoxFit.contain,
            ),
            const Text(
              'No preview available for this file type.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF4F7FFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                size: 40,
                color: Color(0xFF4F7FFF),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tap to select a file',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildFileInfo(String fileName, String fileSize) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'File Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4F7FFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.insert_drive_file,
                  color: Color(0xFF4F7FFF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      fileSize,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4F7FFF),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF4F7FFF)),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Select File',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _selectedImage != null ? _uploadFile : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F7FFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Upload Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_upward, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
