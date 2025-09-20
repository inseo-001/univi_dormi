import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'b_b_s_main_widget.dart' show BBSMainWidget;
import 'package:flutter/material.dart';

class BBSMainModel extends FlutterFlowModel<BBSMainWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
