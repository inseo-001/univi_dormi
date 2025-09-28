import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'application_list_model.dart';
export 'application_list_model.dart';

class ApplicationListWidget extends StatefulWidget {
  const ApplicationListWidget({super.key});

  static String routeName = 'ApplicationList';
  static String routePath = '/applicationList';

  @override
  State<ApplicationListWidget> createState() => _ApplicationListWidgetState();
}

class _ApplicationListWidgetState extends State<ApplicationListWidget> {
  late ApplicationListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ApplicationListModel());
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    try {
      setState(() {
        _model.isLoading = true;
      });

      _model.applicationCounts =
          await _model.applicationService.getUserApplicationCounts();
      _model.recentApplications =
          await _model.applicationService.getRecentApplications();

      setState(() {
        _model.isLoading = false;
      });
    } catch (e) {
      print('신청 목록 로딩 오류: $e');
      setState(() {
        _model.isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).info,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).info,
          automaticallyImplyLeading: false,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              context.pop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
          ),
          title: Text(
            '신청 목록',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  fontSize: 20.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: _model.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // 신청 유형별 개수 카드들
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 20.0, 20.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: _buildCountCard(
                                '입사신청',
                                _model.applicationCounts['join'] ?? 0,
                                Icons.login,
                                Color(0xFF4CAF50),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: _buildCountCard(
                                '퇴사신청',
                                _model.applicationCounts['leave'] ?? 0,
                                Icons.logout,
                                Color(0xFFF44336),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 10.0, 20.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: _buildCountCard(
                                '외박신청',
                                _model.applicationCounts['sleepover'] ?? 0,
                                Icons.night_shelter,
                                Color(0xFF2196F3),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: _buildCountCard(
                                '민원신청',
                                _model.applicationCounts['complaint'] ?? 0,
                                Icons.report_problem,
                                Color(0xFFFF9800),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 최근 신청 목록
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 30.0, 20.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              '최근 신청 내역',
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .fontStyle,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      // 신청 목록
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 10.0, 20.0, 20.0),
                        child: _model.recentApplications.isEmpty
                            ? Container(
                                width: double.infinity,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 40.0, 20.0, 40.0),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.inbox_outlined,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 48.0,
                                    ),
                                    SizedBox(height: 16.0),
                                    Text(
                                      '신청 내역이 없습니다',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '다양한 신청을 해보세요!',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: _model.recentApplications
                                    .map((application) {
                                  return _buildApplicationItem(application);
                                }).toList(),
                              ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCountCard(String title, int count, IconData icon, Color color) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 20.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Color(0xFFE0E0E0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 32.0,
          ),
          SizedBox(height: 8.0),
          Text(
            title,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontSize: 12.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.0),
          Text(
            '$count',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontSize: 24.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationItem(Map<String, dynamic> application) {
    final status = application['status'] ?? '대기';
    final statusColor = _model.applicationService.getStatusColor(status);
    final typeIcon =
        _model.applicationService.getTypeIcon(application['type'] ?? '');

    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Color(0xFFE0E0E0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              typeIcon,
              color: statusColor,
              size: 24.0,
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        application['title'] ?? '',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        status,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              color: statusColor,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Text(
                  application['type'] ?? '',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                      ),
                ),
                if (application['description'] != null &&
                    application['description'].isNotEmpty)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                    child: Text(
                      application['description'],
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                SizedBox(height: 8.0),
                Text(
                  _formatDate(application['date']),
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 11.0,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return '';

    try {
      DateTime dateTime;
      if (date is Timestamp) {
        dateTime = date.toDate();
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return '';
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        return '오늘';
      } else if (difference.inDays == 1) {
        return '어제';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}일 전';
      } else {
        return '${dateTime.month}/${dateTime.day}';
      }
    } catch (e) {
      return '';
    }
  }
}
