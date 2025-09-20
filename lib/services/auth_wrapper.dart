import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../sign_up_pasge/login_main/login_main_widget.dart';
import '../main.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 로딩 중
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // 사용자가 로그인되어 있으면 네비게이션 바가 있는 홈페이지로
        if (snapshot.hasData) {
          return NavBarPage(initialPage: 'HomePage');
        }

        // 사용자가 로그인되어 있지 않으면 로그인 페이지로
        return const LoginMainWidget();
      },
    );
  }
}
