import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';
import '../../models/notice.dart';
import '../../services/notice_service.dart';
import '../../services/auth_service.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  final NoticeService noticeService = NoticeService();
  final AuthService authService = AuthService();
  List<Notice> notices = [];
  bool isLoading = true;
  String? userName;

  @override
  void initState(BuildContext context) {
    loadUserData();
    _loadNotices();
  }

  Future<void> loadUserData() async {
    try {
      final user = authService.currentUser;
      if (user != null) {
        final userData = await authService.getUserData(user.uid);
        userName = userData?['name'] ?? user.displayName ?? '사용자';
      } else {
        userName = '사용자';
      }
      print('👤 홈페이지 사용자 정보 로드: $userName');
    } catch (e) {
      print('❌ 홈페이지 사용자 정보 로드 오류: $e');
      userName = '사용자';
    }
  }

  Future<void> _loadNotices() async {
    try {
      isLoading = true;
      notices = await noticeService.getNotices(limit: 3);
      isLoading = false;
      // Flutter Flow에서는 setState를 사용하여 UI 업데이트
    } catch (e) {
      print('공지사항 로딩 오류: $e');
      isLoading = false;
    }
  }

  @override
  void dispose() {}
}
