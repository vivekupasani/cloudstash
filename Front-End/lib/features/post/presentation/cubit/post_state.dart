part of 'post_cubit.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

class PostUploading extends PostState {}

class PostUploaded extends PostState {}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> files;

  PostLoaded({required this.files});
}
