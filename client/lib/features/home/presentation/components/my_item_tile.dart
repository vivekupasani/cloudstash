import 'package:cloudstash/features/home/presentation/view_stash.dart';
import 'package:cloudstash/features/upload/domain/File.dart';
import 'package:cloudstash/features/upload/presentation/cubit/files_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

// import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class MyItemTile extends StatefulWidget {
  final FileModel file;
  const MyItemTile({super.key, required this.file});

  @override
  State<MyItemTile> createState() => _MyItemTileState();
}

class _MyItemTileState extends State<MyItemTile> {
  final TextEditingController _renameController = TextEditingController();
  late FilesCubit filesCubit;
  final colors = [
    const Color(0xFFE9F1FF),
    const Color(0xFFFFF7E9),
    const Color(0xFFFFEAE9),
    const Color(0xFFE9FFF8),
  ];
  final iconColors = [
    Colors.blue[500] ?? Colors.blue,
    Colors.amber[500] ?? Colors.amber,
    Colors.red[400] ?? Colors.red,
    Colors.cyan[400] ?? Colors.cyan,
  ];

  late final int index;

  @override
  void initState() {
    super.initState();
    index = Random().nextInt(4);
    _renameController.text = widget.file.name;
    filesCubit = context.read<FilesCubit>();
  }

  Icon _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case "png":
      case "jpg":
      case "jpeg":
        return const Icon(Icons.image, color: Colors.white);
      case "pdf":
        return const Icon(Icons.picture_as_pdf, color: Colors.white);
      case "doc":
      case "docx":
        return const Icon(Icons.description, color: Colors.white);
      case "mp4":
      case "mkv":
        return const Icon(Icons.movie, color: Colors.white);
      case "mp3":
        return const Icon(Icons.music_note, color: Colors.white);
      default:
        return const Icon(Icons.insert_drive_file, color: Colors.white);
    }
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: const Icon(Icons.download, color: Colors.white),
                ),
                title: const Text(
                  'Download',
                  style: TextStyle(
                    color: Color.fromARGB(255, 76, 76, 76),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _downloadFile(widget.file.file, widget.file.name);
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
                  _renameFile(widget.file.name, backgroundColor, color);
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

  Future<void> _downloadFile(String file, String fileName) async {
    final dio = Dio();

    try {
      if (kIsWeb) {
        // Web-specific implementation
        final response = await dio.get(
          file,
          options: Options(responseType: ResponseType.bytes),
        );

        // // Create a Blob and trigger the download
        // final blob = html.Blob([response.data]);
        // final url = html.Url.createObjectUrlFromBlob(blob);
        // final anchor =
        //     html.AnchorElement(href: url)
        //       ..target = 'blank'
        //       ..download = fileName
        //       ..click();
        // html.Url.revokeObjectUrl(url);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File downloaded successfully')),
        );
      } else {
        // Non-web platforms (Android, iOS, Desktop)
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';

        // Show a loading indicator
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Downloading...')));

        // Download the file
        await dio.download(file, filePath);

        // Show success message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('File downloaded to $filePath')));
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to download file: $e')));
    }
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
      filesCubit.renameFile(widget.file.id, newFileName);
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
      filesCubit.deleteFile(widget.file.id);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ViewStash(
                  fileModel: widget.file,
                  backgroundColor: colors[index],
                  color: iconColors[index],
                );
              },
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: colors[index],
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
                      color: iconColors[index],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _getFileIcon(widget.file.fileType),
                  ),
                  GestureDetector(
                    onTap:
                        () =>
                            onMoreButtonClick(colors[index], iconColors[index]),
                    child: const Icon(Icons.more_vert, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                widget.file.name.length > 18
                    ? "${widget.file.name.substring(0, 17)}.${widget.file.fileType}"
                    : widget.file.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(widget.file.updatedAt),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to format the date
  String _formatDate(dynamic updatedAt) {
    if (updatedAt is DateTime) {
      return "${updatedAt.day}/${updatedAt.month}/${updatedAt.year}";
    } else if (updatedAt is String) {
      try {
        final date = DateTime.parse(updatedAt);
        return "${date.day}/${date.month}/${date.year}";
      } catch (e) {
        return "Invalid date";
      }
    } else {
      return "Unknown date";
    }
  }
}
