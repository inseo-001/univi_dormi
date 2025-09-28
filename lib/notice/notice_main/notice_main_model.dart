import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'notice_main_widget.dart' show NoticeMainWidget;
import 'package:flutter/material.dart';
import '../../models/notice.dart';
import '../../services/notice_service.dart';

class NoticeMainModel extends FlutterFlowModel<NoticeMainWidget> {
  final NoticeService noticeService = NoticeService();
  List<Notice> notices = [];
  bool isLoading = true;

  @override
  void initState(BuildContext context) {
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    try {
      isLoading = true;
      notices = await noticeService.getNotices();
      isLoading = false;
    } catch (e) {
      print('공지사항 로딩 오류: $e');
      isLoading = false;
    }
  }

  @override
  void dispose() {}
}
