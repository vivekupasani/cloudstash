import 'package:docs/features/authentication/data/auth_api_repo.dart';
import 'package:docs/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:docs/features/authentication/presentation/login_page.dart';
import 'package:docs/features/home/presentation/home_page.dart';
import 'package:docs/features/post/data/post_api_repo.dart';
import 'package:docs/features/post/presentation/cubit/post_cubit.dart';
import 'package:docs/features/storage/data/storage_api_repo.dart';
import 'package:docs/theme/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthApiRepo authRepo = AuthApiRepo();

  final StorageApiRepo storageRepo = StorageApiRepo();
  final PostApiRepo postRepo = PostApiRepo();

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //Auth Cubit
        BlocProvider(
          create: (context) => AuthCubit(authRepo, storageRepo)..checkAuth(),
        ),

        //Post cubit
        BlocProvider(
          create: (context) => PostCubit(postRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '100xCodes',
        theme: darkMode,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            //state is unauthenticated
            if (state is Unauthenticated) {
              return const LoginPage();

              //state is authenticated
            } else if (state is Authenticated) {
              return const HomePage();

              //Auth Error state
            } else if (state is AuthError) {
              // Show a snackbar for the error
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              });
              // Provide a fallback widget, e.g., the login screen
              return const LoginPage();

              //else
            } else {
              //show loading
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}
