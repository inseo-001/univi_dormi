import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'termsof_use_model.dart';
export 'termsof_use_model.dart';

/// 이용약관
///
class TermsofUseWidget extends StatefulWidget {
  const TermsofUseWidget({super.key});

  static String routeName = 'TermsofUse';
  static String routePath = '/termsofUse';

  @override
  State<TermsofUseWidget> createState() => _TermsofUseWidgetState();
}

class _TermsofUseWidgetState extends State<TermsofUseWidget> {
  late TermsofUseModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TermsofUseModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      context.pushNamed(JoinMainWidget.routeName);
    });
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
          child: ListView(
            padding: EdgeInsets.zero,
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 0.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 35.0,
                          icon: Icon(
                            Icons.arrow_back,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 20.0,
                          ),
                          onPressed: () async {
                            context.pushNamed(JoinMainWidget.routeName);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              37.0, 0.0, 0.0, 0.0),
                          child: Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor: Color(0xFF635D5D),
                            ),
                            child: Checkbox(
                              value: _model.checkboxValue1 ??= true,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue1 = newValue!);
                              },
                              side: (Color(0xFF635D5D) != null)
                                  ? BorderSide(
                                      width: 2,
                                      color: Color(0xFF635D5D),
                                    )
                                  : null,
                              activeColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              checkColor: Color(0xFF4D81E7),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 0.0, 0.0),
                          child: Text(
                            '커뮤니티 이용약관',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 350.0,
                    child: Divider(
                      thickness: 2.0,
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            37.0, 10.0, 0.0, 10.0),
                        child: Container(
                          width: 316.6,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Color(0xFF57636C),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      '제 2 조 (회원의 의무)\n회원은 본 약관 및 관련 법령을 준수해야 하며, 다음 행위를 해서는 안 됩니다:\n\n타인의 개인정보 도용 또는 사칭 행위\n\n음란물, 욕설, 혐오 표현, 차별적 언사 등 부적절한 게시물 작성\n\n허위 정보 유포, 특정 인물 또는 집단에 대한 비방\n\n영리 목적의 광고, 홍보성 글 반복 등록\n\n커뮤니티 운영을 방해하는 모든 행위\n\n회원은 다른 사용자와의 상호 존중을 기반으로 성숙한 커뮤니케이션 문화를 유지해야 합니다.\n\n',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            fontSize: 9.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              37.0, 0.0, 0.0, 0.0),
                          child: Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor: Color(0xFF635D5D),
                            ),
                            child: Checkbox(
                              value: _model.checkboxValue2 ??= true,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue2 = newValue!);
                              },
                              side: (Color(0xFF635D5D) != null)
                                  ? BorderSide(
                                      width: 2,
                                      color: Color(0xFF635D5D),
                                    )
                                  : null,
                              activeColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              checkColor: Color(0xFF4D81E7),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 0.0, 0.0),
                          child: Text(
                            '서비스 이용관',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 350.0,
                    child: Divider(
                      thickness: 2.0,
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            37.0, 10.0, 0.0, 10.0),
                        child: Container(
                          width: 316.6,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Color(0xFF57636C),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      '제 2 조 (회원의 의무)\n회원은 본 약관 및 관련 법령을 준수해야 하며, 다음 행위를 해서는 안 됩니다:\n\n타인의 개인정보 도용 또는 사칭 행위\n\n음란물, 욕설, 혐오 표현, 차별적 언사 등 부적절한 게시물 작성\n\n허위 정보 유포, 특정 인물 또는 집단에 대한 비방\n\n영리 목적의 광고, 홍보성 글 반복 등록\n\n커뮤니티 운영을 방해하는 모든 행위\n\n회원은 다른 사용자와의 상호 존중을 기반으로 성숙한 커뮤니케이션 문화를 유지해야 합니다.\n\n',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            fontSize: 9.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              37.0, 0.0, 0.0, 0.0),
                          child: Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor: Color(0xFF635D5D),
                            ),
                            child: Checkbox(
                              value: _model.checkboxValue3 ??= true,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue3 = newValue!);
                              },
                              side: (Color(0xFF635D5D) != null)
                                  ? BorderSide(
                                      width: 2,
                                      color: Color(0xFF635D5D),
                                    )
                                  : null,
                              activeColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              checkColor: Color(0xFF4D81E7),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 0.0, 0.0),
                          child: Text(
                            '개인정보 처리방침',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 350.0,
                    child: Divider(
                      thickness: 2.0,
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            37.0, 10.0, 0.0, 10.0),
                        child: Container(
                          width: 316.6,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Color(0xFF57636C),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      '제 2 조 (회원의 의무)\n회원은 본 약관 및 관련 법령을 준수해야 하며, 다음 행위를 해서는 안 됩니다:\n\n타인의 개인정보 도용 또는 사칭 행위\n\n음란물, 욕설, 혐오 표현, 차별적 언사 등 부적절한 게시물 작성\n\n허위 정보 유포, 특정 인물 또는 집단에 대한 비방\n\n영리 목적의 광고, 홍보성 글 반복 등록\n\n커뮤니티 운영을 방해하는 모든 행위\n\n회원은 다른 사용자와의 상호 존중을 기반으로 성숙한 커뮤니케이션 문화를 유지해야 합니다.\n\n',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            fontSize: 9.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              37.0, 0.0, 0.0, 0.0),
                          child: Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor: Color(0xFF635D5D),
                            ),
                            child: Checkbox(
                              value: _model.checkboxValue4 ??= true,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue4 = newValue!);
                              },
                              side: (Color(0xFF635D5D) != null)
                                  ? BorderSide(
                                      width: 2,
                                      color: Color(0xFF635D5D),
                                    )
                                  : null,
                              activeColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              checkColor: Color(0xFF4D81E7),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 0.0, 0.0),
                          child: Text(
                            '광고 정보 신',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 350.0,
                    child: Divider(
                      thickness: 2.0,
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            37.0, 10.0, 0.0, 10.0),
                        child: Container(
                          width: 316.6,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Color(0xFF57636C),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      '제 2 조 (회원의 의무)\n회원은 본 약관 및 관련 법령을 준수해야 하며, 다음 행위를 해서는 안 됩니다:\n\n타인의 개인정보 도용 또는 사칭 행위\n\n음란물, 욕설, 혐오 표현, 차별적 언사 등 부적절한 게시물 작성\n\n허위 정보 유포, 특정 인물 또는 집단에 대한 비방\n\n영리 목적의 광고, 홍보성 글 반복 등록\n\n커뮤니티 운영을 방해하는 모든 행위\n\n회원은 다른 사용자와의 상호 존중을 기반으로 성숙한 커뮤니케이션 문화를 유지해야 합니다.\n\n',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            fontSize: 9.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              190.0, 0.0, 0.0, 0.0),
                          child: Text(
                            '위 약관에 모두 동의한다',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w200,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w200,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                        Theme(
                          data: ThemeData(
                            checkboxTheme: CheckboxThemeData(
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            unselectedWidgetColor: Color(0xFF635D5D),
                          ),
                          child: Checkbox(
                            value: _model.checkboxValue5 ??= true,
                            onChanged: (newValue) async {
                              safeSetState(
                                  () => _model.checkboxValue5 = newValue!);
                            },
                            side: (Color(0xFF635D5D) != null)
                                ? BorderSide(
                                    width: 2,
                                    color: Color(0xFF635D5D),
                                  )
                                : null,
                            activeColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            checkColor: Color(0xFF4D81E7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(40.0, 0.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 0.0),
                          child: Container(
                            width: 314.3,
                            height: 45.5,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 5.0, 0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                text: '다음',
                                options: FFButtonOptions(
                                  height: 64.5,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFF0E1534),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
