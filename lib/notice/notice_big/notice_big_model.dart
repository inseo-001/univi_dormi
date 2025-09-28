import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'notice_big_widget.dart' show NoticeBigWidget;
import 'package:flutter/material.dart';
import '../../models/notice.dart';
import '../../services/notice_service.dart';

class NoticeBigModel extends FlutterFlowModel<NoticeBigWidget> {
  final NoticeService noticeService = NoticeService();
  Notice? notice;
  bool isLoading = true;

  @override
  void initState(BuildContext context) {
    // initState에서는 아무것도 하지 않음
  }

  @override
  void dispose() {}
}
