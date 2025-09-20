import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'login_main_widget.dart' show LoginMainWidget;
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginMainModel extends FlutterFlowModel<LoginMainWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? textController2Validator;

  // Auth service instance
  final AuthService _authService = AuthService();

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
  }

  // Login method
  Future<void> signIn(BuildContext context) async {
    if ((textController1?.text.isEmpty ?? true) ||
        (textController2?.text.isEmpty ?? true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일과 비밀번호를 입력해주세요.')),
      );
      return;
    }

    try {
      await _authService.signIn(
        email: textController1!.text.trim(),
        password: textController2!.text,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 성공!')),
        );
        context.pushNamed('HomePage');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
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
