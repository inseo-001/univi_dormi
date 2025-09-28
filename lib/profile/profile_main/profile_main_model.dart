import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profile_main_widget.dart' show ProfileMainWidget;
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ProfileMainModel extends FlutterFlowModel<ProfileMainWidget> {
  final AuthService authService = AuthService();
  String? userName;
  String? userEmail;
  String? studentId;
  String? phoneNumber;
  String? address;
  String? roomNumber;

  @override
  void initState(BuildContext context) {
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final user = authService.currentUser;
      if (user != null) {
        final userData = await authService.getUserData(user.uid);
        userName = userData?['name'] ?? user.displayName ?? '사용자';
        userEmail = user.email ?? '';
        studentId = userData?['studentId'] ?? '';
        phoneNumber = userData?['phoneNumber'] ?? '';
        address = userData?['address'] ?? '';
        roomNumber = userData?['roomNumber'] ?? '';
      } else {
        userName = '사용자';
        userEmail = '';
        studentId = '';
        phoneNumber = '';
        address = '';
        roomNumber = '';
      }
      print('👤 프로필 사용자 정보 로드: $userName');
    } catch (e) {
      print('❌ 프로필 사용자 정보 로드 오류: $e');
      userName = '사용자';
      userEmail = '';
      studentId = '';
      phoneNumber = '';
      address = '';
      roomNumber = '';
    }
  }

  @override
  void dispose() {}
}
