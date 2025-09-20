import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/services/score_service.dart';
import 'score_application_widget.dart' show ScoreApplicationWidget;
import 'package:flutter/material.dart';

class ScoreApplicationModel extends FlutterFlowModel<ScoreApplicationWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();

  // State field(s) for applicationType widget.
  String? applicationTypeValue;
  FormFieldController<String>? applicationTypeValueController;
  // State field(s) for reason widget.
  String? reasonValue;
  FormFieldController<String>? reasonValueController;
  // State field(s) for description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;
  String? Function(BuildContext, String?)? descriptionTextControllerValidator;
  // State field(s) for points widget.
  FocusNode? pointsFocusNode;
  TextEditingController? pointsTextController;
  String? Function(BuildContext, String?)? pointsTextControllerValidator;
  // State field(s) for points dropdown.
  String? pointsValue;
  FormFieldController<String>? pointsValueController;

  @override
  void initState(BuildContext context) {
    descriptionTextControllerValidator = _descriptionTextControllerValidator;
    pointsTextControllerValidator = _pointsTextControllerValidator;
  }

  @override
  void dispose() {
    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();

    pointsFocusNode?.dispose();
    pointsTextController?.dispose();
  }

  String? _descriptionTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '상세 설명을 입력해주세요.';
    }
    if (val.length < 10) {
      return '최소 10자 이상 입력해주세요.';
    }
    return null;
  }

  String? _pointsTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '점수를 입력해주세요.';
    }
    if (int.tryParse(val) == null) {
      return '올바른 숫자를 입력해주세요.';
    }
    return null;
  }

  Future<void> submitApplication(BuildContext context) async {
    if (formKey.currentState == null) {
      return;
    }
    if (!formKey.currentState!.validate()) {
      return;
    }

    // 폼 검증
    if (applicationTypeValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('신청 유형을 선택해주세요.')),
      );
      return;
    }

    if (reasonValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사유를 선택해주세요.')),
      );
      return;
    }

    // 로딩 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('상벌점 신청 중...'),
              ],
            ),
          ),
        );
      },
    );

    try {
      // 점수 선택 검증
      if (pointsValue == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('점수를 선택해주세요.')),
        );
        return;
      }

      // 선택된 점수를 정수로 변환 (이미 + 또는 -가 포함된 문자열)
      int points = int.tryParse(pointsValue!) ?? 0;

      print(
          '📊 점수 처리: ${applicationTypeValue} - 선택값: $pointsValue, 최종값: $points');
      print('🔍 벌점 신청 여부: ${applicationTypeValue == '벌점 신청'}');

      // Firebase에 상벌점 신청 데이터 저장
      final success = await ScoreService.submitScoreApplication(
        applicationType: applicationTypeValue!,
        reason: reasonValue!,
        description: descriptionTextController?.text ?? '',
        points: points,
      );

      // 로딩 다이얼로그 닫기
      Navigator.of(context).pop();

      if (success) {
        // 성공 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('상벌점 신청이 완료되었습니다.'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );

        // 페이지 닫기 (성공 결과 반환)
        context.pop(true);

        // 추가로 상벌점 관리 페이지에 알림
        print('✅ 상벌점 신청 완료 - 페이지 새로고침 필요');
      } else {
        // 실패 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('상벌점 신청 중 오류가 발생했습니다. 다시 시도해주세요.'),
            backgroundColor: Color(0xFFE57373),
          ),
        );
      }
    } catch (e) {
      // 로딩 다이얼로그 닫기
      Navigator.of(context).pop();

      // 오류 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('상벌점 신청 중 오류가 발생했습니다: $e'),
          backgroundColor: Color(0xFFE57373),
        ),
      );
    }
  }
}

