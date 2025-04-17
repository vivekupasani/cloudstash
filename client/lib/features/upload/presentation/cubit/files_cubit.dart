import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloudstash/features/upload/domain/file_repo.dart';
import 'package:cloudstash/features/storage/domain/storage_repo.dart';
import 'package:cloudstash/features/upload/domain/File.dart';
import 'package:flutter/material.dart';

part 'files_state.dart';

class FilesCubit extends Cubit<FilesState> {
  final FileRepo fileRepo;
  final StorageRepo storageRepo;

  FilesCubit(this.fileRepo, this.storageRepo) : super(FilesInitial());

  Future<void> fetchFiles() async {
    try {
      emit(FilesLoading());

      final token = await storageRepo.getToken("x-auth-token");
      if (token == null) {
        emit(FileError(message: "User not authenticated."));
        return;
      }

      final files = await fileRepo.getFiles(token);

      emit(FilesLoaded(files: files));
    } catch (e) {
      emit(FileError(message: e.toString()));
    }
  }

  Future<void> uploadFile({
    required String userId,
    required String name,
    required String type,
    required String size,
    final String? path,
    final Uint8List? webImage,
    required String fileName,
  }) async {
    try {
      emit(FileUploading(progress: 0.0)); // Initial progress

      final token = await storageRepo.getToken("x-auth-token");
      if (token == null) {
        emit(FileError(message: "User not authenticated."));
        return;
      }

      late String? downloadUrl;
      try {
        if (path != null && webImage == null) {
          // Simulate upload progress for mobile
          for (double progress = 0.1; progress <= 1.0; progress += 0.1) {
            await Future.delayed(const Duration(milliseconds: 500));
            emit(FileUploading(progress: progress)); // Update progress
          }
          downloadUrl = await storageRepo.uploadProfileImageMobile(
            path,
            fileName,
          );
        } else if (path == null && webImage != null) {
          // Simulate upload progress for web
          for (double progress = 0.1; progress <= 1.0; progress += 0.1) {
            await Future.delayed(const Duration(milliseconds: 500));
            emit(FileUploading(progress: progress)); // Update progress
          }
          downloadUrl = await storageRepo.uploadProfileImageWeb(
            webImage,
            fileName,
          );
        }
      } catch (e) {
        emit(FileError(message: "Error uploading file: $e"));
        return;
      }

      if (downloadUrl == null) {
        emit(
          FileError(
            message: "Failed to upload file. No download URL returned.",
          ),
        );
        return;
      }

      final file = await fileRepo.uploadFile(
        userId: userId,
        name: name,
        url: downloadUrl,
        type: type,
        size: size,
        token: token,
      );

      if (file == null) {
        emit(FileError(message: "Error creating file."));
        return;
      }

      fetchFiles();
    } catch (e) {
      emit(FileError(message: e.toString()));
    }
  }

  Future<void> deleteFile(String fileId) async {
    try {
      final token = await storageRepo.getToken("x-auth-token");
      if (token == null) {
        emit(FileError(message: "User not authenticated."));
        return;
      }

      await fileRepo.deleteFile(fileId, token);

      fetchFiles();
    } catch (e) {
      emit(FileError(message: e.toString()));
    }
  }

  Future<void> renameFile(String fileId, String newName) async {
    try {
      emit(FilesLoading());

      final token = await storageRepo.getToken("x-auth-token");
      if (token == null) {
        emit(FileError(message: "User not authenticated."));
        return;
      }

      await fileRepo.renameFile(fileId, newName, token);

      fetchFiles();
    } catch (e) {
      emit(FileError(message: e.toString()));
    }
  }
}
