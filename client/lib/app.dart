import 'package:cloudstash/features/auth/data/auth_api_repo.dart';
import 'package:cloudstash/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cloudstash/features/auth/presentation/welcome_screen.dart';
import 'package:cloudstash/features/home/presentation/home_page.dart';
import 'package:cloudstash/features/home/presentation/splash_page.dart';
import 'package:cloudstash/features/storage/data/storage_api_repo.dart';
import 'package:cloudstash/features/upload/data/file_api_repo.dart';
import 'package:cloudstash/features/upload/presentation/cubit/files_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final AuthApiRepo authRepo = AuthApiRepo();
    final StorageApiRepo storageRepo = StorageApiRepo();
    final FileApiRepo fileRepo = FileApiRepo();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(authRepo, storageRepo)),
        BlocProvider(create: (context) => FilesCubit(fileRepo, storageRepo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.white,
        ),
        home: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              // Show a SnackBar when there's an error
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is Authenticated) {
              return const HomePage();
            } else if (state is Unauthenticated) {
              return const WelcomeScreen();
            } else {
              return const SplashPage();
            }
          },
        ),
      ),
    );
  }
}
