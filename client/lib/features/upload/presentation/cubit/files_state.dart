part of 'files_cubit.dart';

@immutable
sealed class FilesState {}

final class FilesInitial extends FilesState {}

// General loading state
final class FilesLoading extends FilesState {}

// Error state
final class FileError extends FilesState {
  final String message;
  FileError({required this.message});
}

// State for file upload
class FileUploading extends FilesState {
  final double progress; // Add progress property

  FileUploading({required this.progress});
}

final class FileUploaded extends FilesState {
  final FileModel? file;
  FileUploaded({required this.file});
}

final class FilesLoaded extends FilesState {
  final List<FileModel> files;
  FilesLoaded({required this.files});
}

final class FileDeleted extends FilesState {}

final class FileUpdated extends FilesState {
  final FileModel updatedFile;
  FileUpdated({required this.updatedFile});
}
