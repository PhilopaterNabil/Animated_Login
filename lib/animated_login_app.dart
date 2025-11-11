import 'package:animated_login/features/Auth/presentation/views/login_view.dart';
import 'package:flutter/material.dart';

class AnimatedLoginApp extends StatelessWidget {
  const AnimatedLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginView(),
    );
  }
}
