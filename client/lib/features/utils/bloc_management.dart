import 'package:cloudstash/features/auth/data/auth_api_repo.dart';
import 'package:cloudstash/features/auth/domain/auth_repo.dart';
import 'package:cloudstash/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cloudstash/features/auth/presentation/welcome_screen.dart';
import 'package:cloudstash/features/home/presentation/home_page.dart';
import 'package:cloudstash/features/storage/data/storage_api_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocManagement extends StatefulWidget {
  const BlocManagement({super.key});

  @override
  State<BlocManagement> createState() => _BlocManagementState();
}

class _BlocManagementState extends State<BlocManagement> {
  final AuthApiRepo authRepo = AuthApiRepo();
  final StorageApiRepo storageRepo = StorageApiRepo();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(authRepo, storageRepo)..checkAuth(),
        ),
      ],
      child: BlocConsumer<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            });
            return Scaffold(body: Center(child: Text(state.message)));
          } else if (state is Authenticated) {
            return HomePage();
          } else if (state is Unauthenticated) {
            return WelcomeScreen();
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
