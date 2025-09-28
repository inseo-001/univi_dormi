import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notice_big_model.dart';
export 'notice_big_model.dart';

class NoticeBigWidget extends StatefulWidget {
  const NoticeBigWidget({super.key, this.noticeId});

  final String? noticeId;

  static String routeName = 'NoticeBig';
  static String routePath = '/noticeBig';

  @override
  State<NoticeBigWidget> createState() => _NoticeBigWidgetState();
}

class _NoticeBigWidgetState extends State<NoticeBigWidget> {
  late NoticeBigModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NoticeBigModel());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadNotice();
  }

  Future<void> _loadNotice() async {
    try {
      setState(() {
        _model.isLoading = true;
      });

      // arguments에서 noticeId 가져오기
      final extra =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final noticeId = extra?['noticeId'] as String?;

      if (noticeId != null && noticeId.isNotEmpty) {
        // 특정 공지사항 로드
        _model.notice = await _model.noticeService.getNoticeById(noticeId);
      } else {
        // 첫 번째 공지사항 로드 (기존 방식)
        final notices = await _model.noticeService.getNotices(limit: 1);
        if (notices.isNotEmpty) {
          _model.notice = notices.first;
        }
      }

      setState(() {
        _model.isLoading = false;
      });
    } catch (e) {
      print('공지사항 로딩 오류: $e');
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
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.arrow_back,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            context.pushNamed(NoticeMainWidget.routeName);
                          },
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 0.0, 0.0, 0.0),
                          child: Text(
                            '공지사항 상세',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: _model.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      )
                    : _model.notice == null
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 60.0,
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  '공지사항을 불러올 수 없습니다',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      30.0, 20.0, 30.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: Color(0xFFABA5A5),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20.0, 20.0, 20.0, 20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // 중요도 배지
                                          if (_model.notice!.isImportant)
                                            Container(
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 10.0),
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8.0, 4.0, 8.0, 4.0),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFBC9C9),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Text(
                                                '중요',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          color:
                                                              Color(0xFFF80808),
                                                          fontSize: 10.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ),
                                          // 제목
                                          Text(
                                            _model.notice!.title,
                                            style: FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .override(
                                                  font: GoogleFonts.interTight(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  fontSize: 18.0,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                          SizedBox(height: 10.0),
                                          // 작성자 및 날짜
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person_outline,
                                                color: Color(0xFF57636C),
                                                size: 14.0,
                                              ),
                                              SizedBox(width: 5.0),
                                              Text(
                                                _model.notice!.author,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          color:
                                                              Color(0xFF57636C),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                              SizedBox(width: 15.0),
                                              Icon(
                                                Icons.calendar_today_outlined,
                                                color: Color(0xFF57636C),
                                                size: 14.0,
                                              ),
                                              SizedBox(width: 5.0),
                                              Text(
                                                _model
                                                    .notice!.formattedDateTime,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          color:
                                                              Color(0xFF57636C),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                              SizedBox(width: 15.0),
                                              Icon(
                                                Icons.remove_red_eye,
                                                color: Color(0xFF57636C),
                                                size: 14.0,
                                              ),
                                              SizedBox(width: 5.0),
                                              Text(
                                                '${_model.notice!.viewCount}',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          color:
                                                              Color(0xFF57636C),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20.0),
                                          // 내용
                                          Container(
                                            width: double.infinity,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    15.0, 15.0, 15.0, 15.0),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF8F9FA),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              _model.notice!.content,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
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
            ],
          ),
        ),
      ),
    );
  }
}
