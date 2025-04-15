import 'package:cloudstash/features/auth/data/auth_api_repo.dart';
import 'package:cloudstash/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cloudstash/features/auth/presentation/welcome_screen.dart';
import 'package:cloudstash/features/home/presentation/home_page.dart';
import 'package:cloudstash/features/home/presentation/splash_page.dart';
import 'package:cloudstash/features/storage/data/storage_api_repo.dart';
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

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(authRepo, storageRepo)),
      ],
      child: BlocConsumer<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          } else if (state is AuthError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            });
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(body: Center(child: Text(state.message))),
            );
          } else if (state is Authenticated) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                fontFamily: 'Poppins',
                scaffoldBackgroundColor: Colors.white,
              ),
              home: HomePage(),
            );
          } else if (state is Unauthenticated) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                fontFamily: 'Poppins',
                scaffoldBackgroundColor: Colors.white,
              ),
              home: WelcomeScreen(),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                fontFamily: 'Poppins',
                scaffoldBackgroundColor: Colors.white,
              ),
              home: const SplashPage(),
            );
          }
        },
        listener: (context, state) {},
      ),
    );
  }
}
