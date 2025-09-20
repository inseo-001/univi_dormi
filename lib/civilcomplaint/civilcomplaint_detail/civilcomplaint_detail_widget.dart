import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/civil_complaint.dart';

class CivilcomplaintDetailWidget extends StatefulWidget {
  const CivilcomplaintDetailWidget({
    super.key,
    required this.complaint,
  });

  final CivilComplaint complaint;

  static String routeName = 'CivilcomplaintDetail';
  static String routePath = '/civilcomplaintDetail';

  @override
  State<CivilcomplaintDetailWidget> createState() =>
      _CivilcomplaintDetailWidgetState();
}

class _CivilcomplaintDetailWidgetState
    extends State<CivilcomplaintDetailWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // 헤더
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-0.91, -1.03),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 0.0, 0.0, 20.0),
                        child: FlutterFlowIconButton(
                          borderRadius: 9.0,
                          buttonSize: 28.5,
                          icon: Icon(
                            Icons.keyboard_backspace,
                            color: Colors.black,
                            size: 26.0,
                          ),
                          onPressed: () async {
                            context.pop();
                          },
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-0.6, -1.02),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 35.0, 0.0),
                            child: Text(
                              '민원 상세',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.58, -0.97),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 0.0, 0.0),
                            child: Text(
                              '민원 내용 및 처리 현황',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 10.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                  child: Container(
                    width: 100.0,
                    height: 0.5,
                    decoration: BoxDecoration(
                      color: Color(0xFFC1BDBD),
                    ),
                  ),
                ),

                // 민원 정보 카드
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Color(0xFFC3BFBF),
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          20.0, 20.0, 20.0, 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 상태 표시
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    widget.complaint.statusIcon,
                                    color: widget.complaint.statusColor,
                                    size: 24.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      widget.complaint.title,
                                      style: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 6.0, 12.0, 6.0),
                                decoration: BoxDecoration(
                                  color: widget.complaint.statusColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  widget.complaint.status,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(),
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16.0),

                          // 민원 정보
                          _buildInfoRow(
                              '민원 종류', widget.complaint.complaintType),
                          _buildInfoRow('카테고리', widget.complaint.category),
                          _buildInfoRow('접수일',
                              '${widget.complaint.createdAt.year}-${widget.complaint.createdAt.month.toString().padLeft(2, '0')}-${widget.complaint.createdAt.day.toString().padLeft(2, '0')}'),

                          if (widget.complaint.updatedAt != null)
                            _buildInfoRow('최종 수정일',
                                '${widget.complaint.updatedAt!.year}-${widget.complaint.updatedAt!.month.toString().padLeft(2, '0')}-${widget.complaint.updatedAt!.day.toString().padLeft(2, '0')}'),

                          if (widget.complaint.completedAt != null)
                            _buildInfoRow('완료일',
                                '${widget.complaint.completedAt!.year}-${widget.complaint.completedAt!.month.toString().padLeft(2, '0')}-${widget.complaint.completedAt!.day.toString().padLeft(2, '0')}'),
                        ],
                      ),
                    ),
                  ),
                ),

                // 민원 내용
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Color(0xFFC3BFBF),
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          20.0, 20.0, 20.0, 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '민원 내용',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            widget.complaint.description,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 관리자 답변
                if (widget.complaint.adminResponse != null &&
                    widget.complaint.adminResponse!.isNotEmpty)
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Color(0xFF0184FB),
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 20.0, 20.0, 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.admin_panel_settings,
                                  color: Color(0xFF0184FB),
                                  size: 20.0,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    '관리자 답변',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          color: Color(0xFF0184FB),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              widget.complaint.adminResponse!,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    color: Color(0xFF2D3748),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Color(0xFFFFB300),
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 20.0, 20.0, 20.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Color(0xFFFFB300),
                              size: 20.0,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: Text(
                                '아직 관리자 답변이 없습니다.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      color: Color(0xFF8B4513),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.0,
            child: Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                    ),
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    color: Color(0xFF88898D),
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(),
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    color: Color(0xFF14181B),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
