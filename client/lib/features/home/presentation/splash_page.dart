import 'package:cloudstash/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cloudstash/features/storage/data/storage_api_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final StorageApiRepo storageApiRepo = StorageApiRepo();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      context.read<AuthCubit>().checkAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Center(child: _buildWelcomeImage())),
          Text(
            'Designed and Developed by\nVivek Upasani',
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 22),
        ],
      ),
    );
  }

  Widget _buildWelcomeImage() {
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 20,
            left: 70,
            child: Container(
              width: 50,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 70,
            child: Container(
              width: 40,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Container(
            width: 100,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF4F7FFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.cloud, color: Colors.white, size: 48),
          ),
          Positioned(
            bottom: 40,
            child: Container(
              width: 200,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image, color: Color(0xFF4F7FFF)),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 60,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 70,
            bottom: 20,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          Positioned(
            right: 70,
            bottom: 20,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
