// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  PlatformFile? _selectedImage;
  Uint8List? webImage;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  Future<void> _pickImage() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: kIsWeb,
    );

    if (res != null) {
      setState(() {
        _selectedImage = res.files.first;
        if (kIsWeb) {
          webImage = _selectedImage?.bytes;
        }
      });
    }
  }

  void _simulateUpload() {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    const totalSteps = 100;
    for (int i = 0; i <= totalSteps; i++) {
      Future.delayed(Duration(milliseconds: 50 * i), () {
        if (mounted) {
          setState(() {
            _uploadProgress = i / totalSteps;
            if (i == totalSteps) {
              _isUploading = false;
            }
          });
        }
      });
    }
  }

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
  }

  @override
  Widget build(BuildContext context) {
    final String fileName = _selectedImage?.name ?? '';
    final String fileSize =
        _selectedImage != null
            ? '${(_selectedImage!.size / (1024 * 1024)).toStringAsFixed(2)} MB'
            : '';
    final String fileType = _selectedImage?.extension ?? '';

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
                  //on click check uploading
                  onTap: _isUploading ? null : _pickImage,
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

                    //show image
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Builder(
                        builder: (_) {
                          //show on app
                          if (_selectedImage != null && webImage == null) {
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  File(_selectedImage!.path!),
                                  fit: BoxFit.cover,
                                ),

                                //show progress indicator if uploading
                                if (_isUploading)
                                  Container(
                                    color: Colors.black.withOpacity(0.3),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircularProgressIndicator(
                                            value: _uploadProgress,
                                            color: const Color(0xFF4F7FFF),
                                            backgroundColor: Colors.white,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            '${(_uploadProgress * 100).toInt()}%',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            );

                            //show on web
                          } else if (webImage != null &&
                              _selectedImage != null) {
                            return Image.memory(webImage!, fit: BoxFit.cover);

                            //if image not selected
                          } else {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF4F7FFF,
                                      ).withOpacity(0.1),
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
                                    'Tap to select an image',
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
                        },
                      ),
                    ),
                  ),
                ),
              ),

              //Stash information
              if (_selectedImage != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
                              Icons.image,
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
                ),
              ],
              const SizedBox(height: 24),

              //buttons to select and upload
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4F7FFF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFF4F7FFF)),
                        ),
                      ),
                      child: const Text(
                        'Select Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _selectedImage != null ? _simulateUpload : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F7FFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Upload Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_upward, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
