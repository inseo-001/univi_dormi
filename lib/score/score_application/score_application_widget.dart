import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'score_application_model.dart';
export 'score_application_model.dart';

class ScoreApplicationWidget extends StatefulWidget {
  const ScoreApplicationWidget({super.key});

  static String routeName = 'scoreApplication';
  static String routePath = '/scoreApplication';

  @override
  State<ScoreApplicationWidget> createState() => _ScoreApplicationWidgetState();
}

class _ScoreApplicationWidgetState extends State<ScoreApplicationWidget> {
  late ScoreApplicationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ScoreApplicationModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // 신청 유형에 따른 점수 옵션 반환
  List<String> _getPointsOptions() {
    if (_model.applicationTypeValue == '벌점 신청') {
      return ['-1', '-2', '-3', '-4', '-5', '-6', '-7', '-8', '-9', '-10'];
    } else if (_model.applicationTypeValue == '상점 신청') {
      return ['+1', '+2', '+3', '+4', '+5', '+6', '+7', '+8', '+9', '+10'];
    } else {
      return ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
    }
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
          title: Text(
            '상벌점 신청',
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
          child: Form(
            key: _model.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 신청 유형 선택
                        Container(
                          width: double.infinity,
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
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 24.0, 24.0, 24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '신청 유형',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        color: Color(0xFF020000),
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 0.0),
                                  child: FlutterFlowDropDown<String>(
                                    controller: _model
                                            .applicationTypeValueController ??=
                                        FormFieldController<String>(null),
                                    options: ['상점 신청', '벌점 신청'],
                                    onChanged: (val) => setState(() {
                                      _model.applicationTypeValue = val;
                                      // 신청 유형이 변경되면 점수 선택 초기화
                                      _model.pointsValue = null;
                                      _model.pointsValueController?.value =
                                          null;
                                    }),
                                    width: double.infinity,
                                    height: 50.0,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                          ),
                                          color: Color(0xFF020000),
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                    hintText: '신청 유형을 선택하세요',
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF666666),
                                      size: 24.0,
                                    ),
                                    fillColor: Color(0xFFF8F9FA),
                                    elevation: 2.0,
                                    borderColor: Color(0xFFE9ECEF),
                                    borderWidth: 1.0,
                                    borderRadius: 12.0,
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    hidesUnderline: true,
                                    isSearchable: false,
                                    isMultiSelect: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
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
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 24.0, 24.0, 24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '사유',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          color: Color(0xFF020000),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 0.0),
                                    child: FlutterFlowDropDown<String>(
                                      controller:
                                          _model.reasonValueController ??=
                                              FormFieldController<String>(null),
                                      options: [
                                        '기숙사 규칙 준수',
                                        '봉사활동 참여',
                                        '모범적인 생활 태도',
                                        '기타 선행 행위',
                                        '기숙사 규칙 위반',
                                        '소음 발생',
                                        '청소 불량',
                                        '기타 위반 행위'
                                      ],
                                      onChanged: (val) => setState(
                                          () => _model.reasonValue = val),
                                      width: double.infinity,
                                      height: 50.0,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                            ),
                                            color: Color(0xFF020000),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                      hintText: '사유를 선택하세요',
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Color(0xFF666666),
                                        size: 24.0,
                                      ),
                                      fillColor: Color(0xFFF8F9FA),
                                      elevation: 2.0,
                                      borderColor: Color(0xFFE9ECEF),
                                      borderWidth: 1.0,
                                      borderRadius: 12.0,
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                      hidesUnderline: true,
                                      isSearchable: false,
                                      isMultiSelect: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
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
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 24.0, 24.0, 24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '상세 설명',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          color: Color(0xFF020000),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 0.0),
                                    child: TextFormField(
                                      controller:
                                          _model.descriptionTextController,
                                      focusNode: _model.descriptionFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: '상세한 설명을 입력해주세요',
                                        hintStyle: FlutterFlowTheme.of(context)
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
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFE9ECEF),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF4D7BBD),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFE57373),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFE57373),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        fillColor: Color(0xFFF8F9FA),
                                        contentPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                16.0, 16.0, 16.0, 16.0),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                            ),
                                            color: Color(0xFF020000),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                      maxLines: 4,
                                      validator: _model
                                          .descriptionTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
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
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 24.0, 24.0, 24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '점수',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          color: Color(0xFF020000),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 0.0),
                                    child: FlutterFlowDropDown<String>(
                                      controller:
                                          _model.pointsValueController ??=
                                              FormFieldController<String>(null),
                                      options: _getPointsOptions(),
                                      onChanged: (val) => setState(
                                          () => _model.pointsValue = val),
                                      width: double.infinity,
                                      height: 50.0,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                            ),
                                            color: Color(0xFF020000),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                      hintText: '점수를 선택하세요',
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Color(0xFF666666),
                                        size: 24.0,
                                      ),
                                      fillColor: Color(0xFFF8F9FA),
                                      elevation: 2.0,
                                      borderColor: Color(0xFFE9ECEF),
                                      borderWidth: 1.0,
                                      borderRadius: 12.0,
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                      hidesUnderline: true,
                                      isSearchable: false,
                                      isMultiSelect: false,
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

                // 하단 버튼 영역
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8.0,
                        color: Color(0x1A000000),
                        offset: Offset(0.0, -2.0),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            context.pop();
                          },
                          text: '취소',
                          options: FFButtonOptions(
                            height: 50.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: Color(0xFFF8F9FA),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  color: Color(0xFF666666),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: Color(0xFFE9ECEF),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                        child: Expanded(
                          child: FFButtonWidget(
                            onPressed: () async {
                              await _model.submitApplication(context);
                            },
                            text: '신청하기',
                            options: FFButtonOptions(
                              height: 50.0,
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

