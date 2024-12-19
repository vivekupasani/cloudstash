import 'package:bloc/bloc.dart';
import 'package:docs/features/authentication/domain/user.dart';
import 'package:docs/features/post/domain/post.dart';
import 'package:docs/features/post/domain/post_repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  PostCubit(this.postRepo) : super(PostInitial());

  Future<void> uploadFile(PlatformFile file, String token, String uid) async {
    try {
      //emit uploading state
      emit(PostUploading());

      //try to upload files
      await postRepo.uploadFile(file, token, uid);

      //emit uploaded state
      emit(PostUploaded());
      fetchFile(uid, token);

      //throw error if exists
    } catch (e) {
      emit(
        PostError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> fetchFile(String uid, String token) async {
    try {
      //emit loading state
      emit(PostLoading());

      //try to fetch files
      final files = await postRepo.fetchFiles(uid, token);

      //emit post loaded state
      emit(
        PostLoaded(files: files),
      );
      //throw error if exists
    } catch (e) {
      emit(
        PostError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> updateFile(String id, String name, User? currentUser) async {
    try {
      await postRepo.updateFile(id, name);

      fetchFile(currentUser!.id, currentUser.token);
    } catch (e) {
      emit(
        PostError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> deleteFile(String id) async {
    try {
      await postRepo.deleteFile(id);

      final currentState = state;
      if (currentState is PostLoaded) {
        final updatedFile = currentState.files
            .where(
              (file) => file.id != id,
            )
            .toList();

        emit(
          PostLoaded(files: updatedFile),
        );
      }
    } catch (e) {
      emit(
        PostError(
          e.toString(),
        ),
      );
    }
  }
}
