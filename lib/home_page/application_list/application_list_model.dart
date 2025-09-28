import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'application_list_widget.dart' show ApplicationListWidget;
import 'package:flutter/material.dart';
import '../../services/application_service.dart';

class ApplicationListModel extends FlutterFlowModel<ApplicationListWidget> {
  final ApplicationService applicationService = ApplicationService();

  bool isLoading = true;
  Map<String, int> applicationCounts = {
    'join': 0,
    'leave': 0,
    'sleepover': 0,
    'complaint': 0,
  };
  List<Map<String, dynamic>> recentApplications = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
