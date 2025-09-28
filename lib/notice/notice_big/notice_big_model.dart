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
    _loadNotice();
  }

  Future<void> _loadNotice() async {
    try {
      isLoading = true;
      final notices = await noticeService.getNotices(limit: 1);
      if (notices.isNotEmpty) {
        notice = notices.first;
      }
      isLoading = false;
    } catch (e) {
      print('공지사항 상세 로딩 오류: $e');
      isLoading = false;
    }
  }

  @override
  void dispose() {}
}
