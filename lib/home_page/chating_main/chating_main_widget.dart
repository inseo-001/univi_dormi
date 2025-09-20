import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chating_main_model.dart';
export 'chating_main_model.dart';
import '/chating/massage_detail_roommate_copy/massage_detail_roommate_copy_widget.dart';

class ChatingMainWidget extends StatefulWidget {
  const ChatingMainWidget({super.key});

  static String routeName = 'ChatingMain';
  static String routePath = '/chatingMain';

  @override
  State<ChatingMainWidget> createState() => _ChatingMainWidgetState();
}

class _ChatingMainWidgetState extends State<ChatingMainWidget> {
  late ChatingMainModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatingMainModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
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
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // 헤더
              _buildHeader(),
              // 카드 목록
              Expanded(
                child: _buildRoleCards(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '관리자 채팅',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                    ),
                    fontSize: 24.0,
                  ),
            ),
          ),
          Icon(
            Icons.notifications_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCards() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          _buildRoleCard(
            title: '실장님',
            description: '기숙사 실장 - 전반적인 관리',
            icon: Icons.admin_panel_settings,
            iconColor: Color(0xFF2196F3),
            backgroundColor: Color(0xFFE3F2FD),
            onTap: () {
              context.pushNamed(
                MassageDetailRoommateCopyWidget.routeName,
                queryParameters: {'role': '실장님'},
              );
            },
          ),
          SizedBox(height: 16.0),
          _buildRoleCard(
            title: '사감님',
            description: '기숙사 사감 - 생활 관리',
            icon: Icons.home,
            iconColor: Color(0xFFFF9800),
            backgroundColor: Color(0xFFFFF3E0),
            onTap: () {
              context.pushNamed(
                MassageDetailRoommateCopyWidget.routeName,
                queryParameters: {'role': '사감님'},
              );
            },
          ),
          SizedBox(height: 16.0),
          _buildRoleCard(
            title: '층장님',
            description: '층년 관리자 - 층별 생활 관리',
            icon: Icons.people,
            iconColor: Color(0xFF4CAF50),
            backgroundColor: Color(0xFFE8F5E8),
            onTap: () {
              context.pushNamed(
                MassageDetailRoommateCopyWidget.routeName,
                queryParameters: {'role': '층장'},
              );
            },
          ),
          SizedBox(height: 16.0),
          _buildRoleCard(
            title: '챗봇',
            description: 'AI 어시스턴트 - 24시간 상담 가능',
            icon: Icons.smart_toy,
            iconColor: Color(0xFF9C27B0),
            backgroundColor: Color(0xFFF3E5F5),
            onTap: () {
              context.pushNamed(
                MassageDetailRoommateCopyWidget.routeName,
                queryParameters: {'role': 'chatbot'},
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 아이콘
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24.0,
              ),
            ),
            SizedBox(width: 16.0),
            // 텍스트 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                          ),
                          fontSize: 18.0,
                        ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    description,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 14.0,
                        ),
                  ),
                ],
              ),
            ),
            // 온라인 상태 및 화살표
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      '온라인',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: Color(0xFF4CAF50),
                            fontSize: 12.0,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Icon(
                  Icons.arrow_forward_ios,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 16.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
