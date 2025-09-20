import '/flutter_flow/flutter_flow_util.dart';
import '/services/score_service.dart';
import 'score_main_widget.dart' show ScoreMainWidget;
import 'package:flutter/material.dart';

class ScoreMainModel extends FlutterFlowModel<ScoreMainWidget> {
  // 상벌점 점수 데이터
  int rewardPoints = 0; // 기본값
  int penaltyPoints = 0; // 기본값

  // 신청 목록 데이터
  List<Map<String, dynamic>> applicationList = [];

  // 로딩 상태
  bool isLoading = true;

  @override
  void initState(BuildContext context) {
    // 데이터 로드는 위젯에서 호출
  }

  @override
  void dispose() {}

  // 상벌점 데이터 로드
  Future<void> loadScoreData() async {
    try {
      print('🔄 상벌점 데이터 로드 시작...');
      isLoading = true;

      // 사용자의 상벌점 점수 가져오기 (승인된 점수만)
      print('📊 상벌점 점수 조회 중...');
      final scoreSummary = await ScoreService.getUserScoreSummary();
      rewardPoints = scoreSummary['rewardPoints'] ?? 0;
      penaltyPoints = scoreSummary['penaltyPoints'] ?? 0;
      print('📈 점수 설정 완료 - 상점: ${rewardPoints}점, 벌점: ${penaltyPoints}점');

      // 사용자의 신청 목록 가져오기
      print('📋 신청 목록 조회 중...');
      applicationList = await ScoreService.getUserScoreApplications();
      print('📝 신청 목록 수: ${applicationList.length}개');

      // 신청 목록 상세 정보 출력
      for (int i = 0; i < applicationList.length; i++) {
        final app = applicationList[i];
        print(
            '   📄 신청 ${i + 1}: ${app['type']} - ${app['reason']} (${app['status']}) - ${app['points']}점');
      }

      isLoading = false;
      print('✅ 상벌점 데이터 로드 완료');
    } catch (e) {
      isLoading = false;
      print('❌ 상벌점 데이터 로드 오류: $e');
      print('❌ 스택 트레이스: ${e.toString()}');
    }
  }
}

