import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'b_b_s_list_widget.dart' show BBSListWidget;
import 'package:flutter/material.dart';

class BBSListModel extends FlutterFlowModel<BBSListWidget> {
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
