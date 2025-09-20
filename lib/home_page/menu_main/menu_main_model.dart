import '/flutter_flow/flutter_flow_util.dart';
import '/services/score_service.dart';
import '/index.dart';
import 'menu_main_widget.dart' show MenuMainWidget;
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class MenuMainModel extends FlutterFlowModel<MenuMainWidget> {
  final AuthService _authService = AuthService();

  // 상벌점 데이터
  int rewardPoints = 0;
  int penaltyPoints = 0;

  // 로그아웃 메서드
  Future<void> signOut(BuildContext context) async {
    try {
      await _authService.signOut();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그아웃되었습니다.')),
        );
        context.go('/');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그아웃 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  // 상벌점 데이터 로드 (빠른 로드)
  Future<void> loadScoreData() async {
    try {
      final scoreSummary = await ScoreService.getUserScoreSummary();
      rewardPoints = scoreSummary['rewardPoints'] ?? 0;
      penaltyPoints = scoreSummary['penaltyPoints'] ?? 0;
      print('📈 메뉴 점수 업데이트 - 상점: ${rewardPoints}점, 벌점: ${penaltyPoints}점');
    } catch (e) {
      print('❌ 메뉴 상벌점 데이터 로드 오류: $e');
    }
  }

  @override
  void initState(BuildContext context) {
    loadScoreData();
  }

  @override
  void dispose() {}
}
