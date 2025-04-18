import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudstash/features/home/presentation/home_page.dart';
import 'package:cloudstash/features/upload/presentation/cubit/files_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart'; // Import video_player package
import 'package:cloudstash/features/upload/domain/File.dart';

class ViewStash extends StatefulWidget {
  final FileModel fileModel;
  final Color backgroundColor;
  final Color color;

  const ViewStash({
    super.key,
    required this.fileModel,
    required this.backgroundColor,
    required this.color,
  });

  @override
  State<ViewStash> createState() => _ViewStashState();
}

class _ViewStashState extends State<ViewStash> {
  String? _localPDFPath;
  bool _isLoading = true;
  int _currentPage = 0;
  int _totalPages = 0;
  late PDFViewController _pdfViewController;
  final TextEditingController _renameController = TextEditingController();

  VideoPlayerController? _videoController;
  late FilesCubit filesCubit;
  @override
  void initState() {
    super.initState();
    _prepareFile();
    _initializeVideoPlayer();
    filesCubit = context.read<FilesCubit>();
    _renameController.text = widget.fileModel.name;
  }

  Future<void> _prepareFile() async {
    final String file = widget.fileModel.file;
    final String ext = _getFileExtension(file);

    if (ext == 'pdf') {
      try {
        File pdfFile = await _downloadAndSavePDF(file);
        setState(() {
          _localPDFPath = pdfFile.path;
          _isLoading = false;
        });
      } catch (e) {
        debugPrint("Error downloading PDF: $e");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initializeVideoPlayer() {
    final String file = widget.fileModel.file;
    final String ext = _getFileExtension(file);

    if (ext == 'mp4' || ext == 'mov') {
      _videoController = VideoPlayerController.network(file)
        ..initialize()
            .then((_) {
              setState(() {}); // Update the UI when the video is ready
            })
            .catchError((e) {
              debugPrint("Error initializing video player: $e");
            });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose(); // Dispose of the video player controller
    super.dispose();
  }

  void onMoreButtonClick(Color? backgroundColor, Color? color) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 76, 76, 76),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                height: 5,
                width: 100,
                child: SizedBox(),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
                title: const Text(
                  'Rename',
                  style: TextStyle(
                    color: Color.fromARGB(255, 76, 76, 76),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _renameFile(widget.fileModel.name, backgroundColor, color);
                },
              ),
              const Divider(color: Color.fromARGB(255, 76, 76, 76)),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                title: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Color.fromARGB(255, 76, 76, 76),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteFile(backgroundColor, color);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _renameFile(String fileName, Color? backgroundColor, Color? color) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: backgroundColor,
            title: Center(child: Text('Rename')),
            content: TextField(
              controller: _renameController,
              decoration: InputDecoration(hintText: 'Enter file name'),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: color),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: color),
                    onPressed: () => renameFile(_renameController.text),
                    child: Text(
                      'Rename',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  void renameFile(String newFileName) {
    if (newFileName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('File name can\'t be empty')));
    }

    try {
      filesCubit.renameFile(widget.fileModel.id, newFileName);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _deleteFile(Color? backgroundColor, Color? color) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: backgroundColor,
            title: Center(child: Text('Delete')),
            content: Text('Are you sure you want to delete this file?'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: color),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: color),
                    onPressed: () => deleteFile(),
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  void deleteFile() {
    try {
      filesCubit.deleteFile(widget.fileModel.id);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileModel.name),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap:
                  () => onMoreButtonClick(widget.backgroundColor, widget.color),
              child: const Icon(Icons.more_vert, color: Colors.grey, size: 30),
            ),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildFilePreview(),
    );
  }

  Widget _buildFilePreview() {
    final String file = widget.fileModel.file;
    final String ext = _getFileExtension(file);

    switch (ext) {
      case 'png':
      case 'jpg':
      case 'jpeg':
        return _imageView(file);

      case 'pdf':
        if (_localPDFPath != null) {
          return Stack(
            children: [
              PDFView(
                filePath: _localPDFPath!,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: false,
                pageFling: true,
                fitEachPage: false,
                fitPolicy: FitPolicy.BOTH,
                onRender: (pages) {
                  setState(() {
                    _totalPages = pages ?? 0;
                  });
                },
                onViewCreated: (controller) {
                  _pdfViewController = controller;
                },
                onPageChanged: (currentPage, totalPages) {
                  setState(() {
                    _currentPage = currentPage ?? 0;
                  });
                },
                onError: (error) {
                  debugPrint("Error loading PDF: $error");
                },
                onPageError: (page, error) {
                  debugPrint("Error on page $page: $error");
                },
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed:
                          _currentPage > 0
                              ? () {
                                _pdfViewController.setPage(_currentPage - 1);
                              }
                              : null,
                    ),
                    Text(
                      "Page ${_currentPage + 1} of $_totalPages",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed:
                          _currentPage < _totalPages - 1
                              ? () {
                                _pdfViewController.setPage(_currentPage + 1);
                              }
                              : null,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: Text(
              "Failed to load PDF.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

      case 'mp4':
      case 'mov':
        if (_videoController != null && _videoController!.value.isInitialized) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
              const SizedBox(height: 16),
              IconButton(
                icon: Icon(
                  _videoController!.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    _videoController!.value.isPlaying
                        ? _videoController!.pause()
                        : _videoController!.play();
                  });
                },
              ),
            ],
          );
        } else {
          return const Center(
            child: Text(
              "Loading video...",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://imgs.search.brave.com/spFQ8yd9PI41hcesAL7MMkF1fzDi-vm2_tkRJR9d9_I/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdG9y/aWVzLmZyZWVwaWts/YWJzLmNvbS9zdG9y/YWdlLzYyMzA5L0Rl/Y2lzaW9uLWZhdGln/dWVfQXJ0Ym9hcmQt/MS5zdmc",
                height: 400,
                width: 400,
                fit: BoxFit.contain,
              ),
              const Text(
                "No preview available for this file.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
    }
  }

  String _getFileExtension(String path) {
    return path.split('.').last.toLowerCase().split('?').first;
  }

  Future<File> _downloadAndSavePDF(String url) async {
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Widget _imageView(String file) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: CachedNetworkImage(
          imageUrl: file,
          height: 600,
          width: 600,
          placeholder:
              (context, url) => const Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 192, 192, 192),
                  ),
                ),
              ),
          errorWidget:
              (context, url, error) =>
                  const Icon(Icons.error, color: Colors.red),
        ),
      ),
    );
  }
}
