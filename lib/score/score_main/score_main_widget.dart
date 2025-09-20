import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/score_service.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'score_main_model.dart';
export 'score_main_model.dart';

class ScoreMainWidget extends StatefulWidget {
  const ScoreMainWidget({super.key});

  static String routeName = 'scoreMain';
  static String routePath = '/scoreMain';

  @override
  State<ScoreMainWidget> createState() => _ScoreMainWidgetState();
}

class _ScoreMainWidgetState extends State<ScoreMainWidget> {
  late ScoreMainModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ScoreMainModel());
    _loadData();
  }

  Future<void> _loadData() async {
    await _model.loadScoreData();
    if (mounted) {
      setState(() {});
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
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 8.0,
            borderWidth: 1.0,
            buttonSize: 40.0,
            fillColor: FlutterFlowTheme.of(context).info,
            icon: Icon(
              Icons.arrow_back_ios,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          actions: [
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 8.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).info,
              icon: Icon(
                Icons.bug_report,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                print('🐛 디버깅 정보:');
                print('   - 로딩 상태: ${_model.isLoading}');
                print('   - 상점: ${_model.rewardPoints}점');
                print('   - 벌점: ${_model.penaltyPoints}점');
                print('   - 신청 목록 수: ${_model.applicationList.length}개');
                for (int i = 0; i < _model.applicationList.length; i++) {
                  final app = _model.applicationList[i];
                  print(
                      '   - 신청 ${i + 1}: ${app['type']} - ${app['reason']} (${app['status']})');
                }

                // Firebase에서 직접 데이터 조회
                print('🔄 Firebase 직접 조회 시작...');
                final applications =
                    await ScoreService.getUserScoreApplications();
                print('📋 직접 조회 결과: ${applications.length}개');

                // 현재 모델 데이터와 비교
                print('🔄 현재 모델 데이터 새로고침...');
                await _loadData();
              },
            ),
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 8.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).info,
              icon: Icon(
                Icons.add,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                await ScoreService.createSampleData();
                await _loadData();
              },
            ),
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 8.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).info,
              icon: Icon(
                Icons.update,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                await ScoreService.updateCompletedToApproved();
                await _loadData();
              },
            ),
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 8.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).info,
              icon: Icon(
                Icons.refresh,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                await _loadData();
              },
            ),
          ],
          title: Text(
            '상벌점 관리',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight: FontWeight.w600,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // 1. 상&벌점 점수 섹션
              Container(
                width: double.infinity,
                margin: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8.0,
                      color: Color(0x1A000000),
                      offset: Offset(0.0, 2.0),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '내 상벌점 현황',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              font: GoogleFonts.interTight(
                                fontWeight: FontWeight.w600,
                              ),
                              color: Color(0xFF020000),
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 16.0, 16.0, 16.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF0F8FF),
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: Color(0xFF60A9F0),
                                    width: 1.0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '상점',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight: FontWeight.w500,
                                            ),
                                            color: Color(0xFF60A9F0),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 0.0),
                                      child: _model.isLoading
                                          ? SizedBox(
                                              width: 20.0,
                                              height: 20.0,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xFF60A9F0),
                                                ),
                                              ),
                                            )
                                          : Text(
                                              '${_model.rewardPoints}점',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .headlineLarge
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    color: Color(0xFF60A9F0),
                                                    fontSize: 24.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 12.0, 0.0),
                              child: Container(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 16.0, 16.0, 16.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFF5F5),
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: Color(0xFFE57373),
                                    width: 1.0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '벌점',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight: FontWeight.w500,
                                            ),
                                            color: Color(0xFFE57373),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 0.0),
                                      child: _model.isLoading
                                          ? SizedBox(
                                              width: 20.0,
                                              height: 20.0,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xFFE57373),
                                                ),
                                              ),
                                            )
                                          : Text(
                                              '${_model.penaltyPoints}점',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .headlineLarge
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    color: Color(0xFFE57373),
                                                    fontSize: 24.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. 상벌점 신청하기 섹션
              Container(
                width: double.infinity,
                margin: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8.0,
                      color: Color(0x1A000000),
                      offset: Offset(0.0, 2.0),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '상벌점 신청하기',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              font: GoogleFonts.interTight(
                                fontWeight: FontWeight.w600,
                              ),
                              color: Color(0xFF020000),
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: Text(
                          '상벌점 신청을 통해 점수를 요청할 수 있습니다.',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                    ),
                                    color: Color(0xFF666666),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            // 상벌점 신청 페이지로 이동
                            final result = await context
                                .pushNamed(ScoreApplicationWidget.routeName);

                            // 신청 완료 후 데이터 새로고침 (결과와 관계없이 새로고침)
                            print('🔄 신청 페이지에서 돌아옴 - 데이터 새로고침 시작');
                            await _loadData();
                          },
                          text: '신청하기',
                          options: FFButtonOptions(
                            height: 48.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFF4D7BBD),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                            elevation: 2.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. 신청 목록 섹션
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin:
                      EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8.0,
                        color: Color(0x1A000000),
                        offset: Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '신청 목록',
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: Color(0xFF020000),
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: _model.isLoading
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 24.0,
                                          height: 24.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Color(0xFF4D7BBD),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 12.0, 0.0, 0.0),
                                          child: Text(
                                            '데이터를 불러오는 중...',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  color: Color(0xFF999999),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : _model.applicationList.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.inbox_outlined,
                                              size: 48.0,
                                              color: Color(0xFF999999),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 12.0, 0.0, 0.0),
                                              child: Text(
                                                '신청 내역이 없습니다',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      color: Color(0xFF999999),
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        itemCount:
                                            _model.applicationList.length,
                                        itemBuilder: (context, index) {
                                          final application =
                                              _model.applicationList[index];
                                          final type =
                                              application['type'] ?? '알 수 없음';
                                          final reason =
                                              application['reason'] ?? '알 수 없음';
                                          final status =
                                              application['status'] ?? '신청';
                                          final points =
                                              application['points'] ?? 0;
                                          final createdAt =
                                              application['createdAt']
                                                  as DateTime?;

                                          final pointsText = points >= 0
                                              ? '+${points}점'
                                              : '${points}점';
                                          final color = points >= 0
                                              ? Color(0xFF60A9F0)
                                              : Color(0xFFE57373);
                                          final dateText = createdAt != null
                                              ? '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.day.toString().padLeft(2, '0')}'
                                              : '알 수 없음';

                                          return Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0,
                                                    index == 0 ? 0.0 : 12.0,
                                                    0.0,
                                                    0.0),
                                            child: _buildApplicationItem(
                                              context,
                                              type,
                                              reason,
                                              status,
                                              pointsText,
                                              dateText,
                                              color,
                                            ),
                                          );
                                        },
                                      ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationItem(
    BuildContext context,
    String type,
    String reason,
    String status,
    String points,
    String date,
    Color color,
  ) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Color(0xFFE9ECEF),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        type,
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  color: Color(0xFF020000),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        points,
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  color: color,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                    child: Text(
                      reason,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                            ),
                            color: Color(0xFF666666),
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          date,
                          style:
                              FlutterFlowTheme.of(context).bodySmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                    ),
                                    color: Color(0xFF999999),
                                    fontSize: 11.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                        Container(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 4.0, 8.0, 4.0),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            status,
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      color: Colors.white,
                                      fontSize: 10.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '승인':
        return Color(0xFF4CAF50);
      case '처리중':
        return Color(0xFFFF9800);
      case '반려':
        return Color(0xFFF44336);
      default:
        return Color(0xFF999999);
    }
  }
}

