import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'civilcomplaint_main_widget.dart' show CivilcomplaintMainWidget;
import 'package:flutter/material.dart';
import '../../services/civil_complaint_service.dart';
import '../../models/civil_complaint.dart';

class CivilcomplaintMainModel
    extends FlutterFlowModel<CivilcomplaintMainWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;

  // 민원 서비스
  final CivilComplaintService _complaintService = CivilComplaintService();

  // 서비스 접근자
  CivilComplaintService get complaintService => _complaintService;

  // 로딩 상태
  bool isLoading = false;

  // 민원 목록
  List<CivilComplaint> complaints = [];

  // 민원 목록 로딩 상태
  bool isLoadingComplaints = false;

  @override
  void initState(BuildContext context) {
    loadComplaints();
    // 실시간 스트림 구독 시작
    _startRealtimeUpdates();
  }

  // 실시간 업데이트 시작
  void _startRealtimeUpdates() {
    _complaintService.getUserComplaintsStream().listen(
      (complaintsList) {
        print('🔄 실시간 업데이트: ${complaintsList.length}개 민원');
        complaints = complaintsList;
        isLoadingComplaints = false;
      },
      onError: (error) {
        print('❌ 실시간 스트림 오류: $error');
        isLoadingComplaints = false;
      },
    );
  }

  // 민원 목록 로드
  Future<void> loadComplaints() async {
    try {
      print('=== 민원 목록 로드 시작 ===');
      print('현재 로딩 상태: $isLoadingComplaints');
      print('현재 민원 개수: ${complaints.length}');

      isLoadingComplaints = true;
      print('로딩 상태를 true로 설정');

      final userComplaints = await _complaintService.getUserComplaints();
      print('서비스에서 받은 민원 개수: ${userComplaints.length}');

      complaints = userComplaints;
      print('민원 목록 업데이트 완료: ${complaints.length}개');

      // 각 민원의 상세 정보 출력
      for (int i = 0; i < complaints.length; i++) {
        final complaint = complaints[i];
        print('민원 $i: ${complaint.title} - ${complaint.status}');
      }
    } catch (e) {
      print('민원 목록 로드 오류: $e');
      print('오류 타입: ${e.runtimeType}');
      print('오류 메시지: ${e.toString()}');
      complaints = []; // 오류 시 빈 목록으로 설정
    } finally {
      isLoadingComplaints = false;
      print('로딩 상태를 false로 설정');
      print('최종 민원 개수: ${complaints.length}');
      print('=== 민원 목록 로드 완료 ===');
    }
  }

  // 민원 신청하기
  Future<void> submitComplaint(BuildContext context) async {
    print('=== 민원 신청 시작 ===');
    print('민원 종류: $dropDownValue1');
    print('카테고리: $dropDownValue2');
    print('제목: ${textController1?.text}');
    print('상세내용: ${textController2?.text}');

    if (dropDownValue1 == null || dropDownValue1!.isEmpty) {
      print('❌ 민원 종류 미선택');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('민원 종류를 선택해주세요.')),
      );
      return;
    }

    if (dropDownValue2 == null || dropDownValue2!.isEmpty) {
      print('❌ 카테고리 미선택');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카테고리를 선택해주세요.')),
      );
      return;
    }

    if (textController1?.text.isEmpty ?? true) {
      print('❌ 제목 미입력');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해주세요.')),
      );
      return;
    }

    if (textController2?.text.isEmpty ?? true) {
      print('❌ 상세내용 미입력');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('상세 내용을 입력해주세요.')),
      );
      return;
    }

    try {
      print('✅ 폼 검증 통과, 민원 신청 시작');
      isLoading = true;

      print('📡 서비스 호출 시작...');
      await _complaintService.submitComplaint(
        complaintType: dropDownValue1!,
        category: dropDownValue2!,
        title: textController1!.text,
        description: textController2!.text,
      );
      print('✅ 서비스 호출 완료');

      // 성공 메시지
      print('✅ 민원 접수 성공, 성공 메시지 표시');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('민원이 성공적으로 접수되었습니다.')),
      );

      // 폼 초기화
      print('🔄 폼 초기화 시작');
      dropDownValue1 = null;
      dropDownValue2 = null;
      textController1?.clear();
      textController2?.clear();
      dropDownValueController1?.reset();
      dropDownValueController2?.reset();
      print('✅ 폼 초기화 완료');

      // 실시간 스트림이 자동으로 업데이트하므로 수동 새로고침 불필요
      print('✅ 실시간 스트림이 자동으로 업데이트됩니다');
    } catch (e) {
      print('❌ 민원 접수 오류: $e');
      print('❌ 오류 타입: ${e.runtimeType}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('민원 접수 중 오류가 발생했습니다: $e')),
      );
    } finally {
      isLoading = false;
      print('=== 민원 신청 완료 ===');
    }
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
