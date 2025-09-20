import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'join_main_model.dart';
export 'join_main_model.dart';

class JoinMainWidget extends StatefulWidget {
  const JoinMainWidget({super.key});

  static String routeName = 'joinMain';
  static String routePath = '/joinMain';

  @override
  State<JoinMainWidget> createState() => _JoinMainWidgetState();
}

class _JoinMainWidgetState extends State<JoinMainWidget> {
  late JoinMainModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => JoinMainModel());

    // 1. 아이디 (이메일)
    _model.emailController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    // 2. 비밀번호
    _model.passwordController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    // 3. 비밀번호 재입력
    _model.confirmPasswordController ??= TextEditingController();
    _model.confirmPasswordFocusNode ??= FocusNode();

    // 4. 이름
    _model.nameController ??= TextEditingController();
    _model.nameFocusNode ??= FocusNode();

    // 5. 학번
    _model.studentIdController ??= TextEditingController();
    _model.studentIdFocusNode ??= FocusNode();

    // 8. 전화번호
    _model.phoneController ??= TextEditingController();
    _model.phoneFocusNode ??= FocusNode();

    // 9. 거주지역 (도로명 주소)
    _model.addressController ??= TextEditingController();
    _model.addressFocusNode ??= FocusNode();

    // 10. 상세주소 (호실)
    _model.roomNumberController ??= TextEditingController();
    _model.roomNumberFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).info,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // 상단 헤더
              Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 35.0,
                      icon: Icon(
                        Icons.arrow_back,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 20.0,
                      ),
                      onPressed: () async {
                        context.pushNamed(LoginMainWidget.routeName);
                      },
                    ),
                    Expanded(
                      child: Text(
                        '회원가입',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    SizedBox(width: 35.0),
                  ],
                ),
              ),

              // 회원가입 폼
              Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. 아이디 (이메일)
                    _buildInputField(
                      label: '아이디 (이메일)',
                      controller: _model.emailController,
                      focusNode: _model.emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'example@email.com',
                      validator: _model.validateEmail,
                    ),
                    SizedBox(height: 20.0),

                    // 2. 비밀번호
                    _buildPasswordField(
                      label: '비밀번호',
                      controller: _model.passwordController,
                      focusNode: _model.passwordFocusNode,
                      visibility: _model.passwordVisibility,
                      onToggleVisibility: () {
                        setState(() {
                          _model.passwordVisibility =
                              !_model.passwordVisibility;
                        });
                      },
                      validator: _model.validatePassword,
                    ),
                    SizedBox(height: 20.0),

                    // 3. 비밀번호 재입력
                    _buildPasswordField(
                      label: '비밀번호 재입력',
                      controller: _model.confirmPasswordController,
                      focusNode: _model.confirmPasswordFocusNode,
                      visibility: _model.confirmPasswordVisibility,
                      onToggleVisibility: () {
                        setState(() {
                          _model.confirmPasswordVisibility =
                              !_model.confirmPasswordVisibility;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 다시 입력해주세요';
                        }
                        if (value != _model.passwordController?.text) {
                          return '비밀번호가 일치하지 않습니다';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _model.validatePasswordMatch();
                      },
                    ),
                    if (_model.isPasswordMismatch)
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                        child: Text(
                          '비밀번호가 일치하지 않습니다.',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context).error,
                                  ),
                        ),
                      ),
                    SizedBox(height: 20.0),

                    // 4. 이름
                    _buildInputField(
                      label: '이름',
                      controller: _model.nameController,
                      focusNode: _model.nameFocusNode,
                      hintText: '홍길동',
                      validator: _model.validateName,
                    ),
                    SizedBox(height: 20.0),

                    // 5. 학번
                    _buildInputField(
                      label: '학번',
                      controller: _model.studentIdController,
                      focusNode: _model.studentIdFocusNode,
                      keyboardType: TextInputType.number,
                      hintText: '20241234',
                      validator: _model.validateStudentId,
                    ),
                    SizedBox(height: 20.0),

                    // 6. 생년월일
                    _buildDatePickerField(
                      label: '생년월일',
                      selectedDate: _model.birthDate,
                      onDateSelected: (DateTime date) {
                        setState(() {
                          _model.birthDate = date;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),

                    // 7. 성별
                    _buildGenderSelector(
                      label: '성별',
                      selectedGender: _model.gender,
                      onGenderSelected: (String gender) {
                        setState(() {
                          _model.gender = gender;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),

                    // 8. 전화번호
                    _buildInputField(
                      label: '전화번호',
                      controller: _model.phoneController,
                      focusNode: _model.phoneFocusNode,
                      keyboardType: TextInputType.phone,
                      hintText: '010-1234-5678',
                      inputFormatters: [_model.phoneMask],
                      validator: _model.validatePhone,
                    ),
                    SizedBox(height: 20.0),

                    // 9. 거주지역 (도로명 주소)
                    _buildInputField(
                      label: '거주지역 (도로명 주소)',
                      controller: _model.addressController,
                      focusNode: _model.addressFocusNode,
                      hintText: '서울특별시 강남구 테헤란로 123',
                      validator: _model.validateAddress,
                    ),
                    SizedBox(height: 20.0),

                    // 10. 상세주소 (호실)
                    _buildInputField(
                      label: '상세주소 (호실)',
                      controller: _model.roomNumberController,
                      focusNode: _model.roomNumberFocusNode,
                      hintText: '101호',
                      validator: _model.validateRoomNumber,
                    ),
                    SizedBox(height: 30.0),

                    // 약관 동의
                    _buildTermsAgreement(
                      value: _model.termsAgreement,
                      onChanged: (bool? value) {
                        setState(() {
                          _model.termsAgreement = value;
                        });
                      },
                    ),
                    SizedBox(height: 30.0),

                    // 회원가입 버튼
                    FFButtonWidget(
                      onPressed: () async {
                        await _model.signUp(context);
                      },
                      text: '회원가입',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Color(0xFF3677B8),
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                        elevation: 3.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
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

  Widget _buildInputField({
    required String label,
    required TextEditingController? controller,
    required FocusNode? focusNode,
    String? hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF3677B8),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
              ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required bool visibility,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: !visibility,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: '비밀번호를 입력하세요',
            hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF3677B8),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            suffixIcon: InkWell(
              onTap: onToggleVisibility,
              focusNode: FocusNode(skipTraversal: true),
              child: Icon(
                visibility
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 22.0,
              ),
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
              ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 8.0),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ??
                  DateTime.now().subtract(Duration(days: 365 * 20)),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              onDateSelected(picked);
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일'
                        : '생년월일을 선택하세요',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: selectedDate != null
                              ? FlutterFlowTheme.of(context).primaryText
                              : FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 20.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector({
    required String label,
    required String? selectedGender,
    required Function(String) onGenderSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => onGenderSelected('남성'),
                child: Container(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                  decoration: BoxDecoration(
                    color: selectedGender == '남성'
                        ? Color(0xFF3677B8)
                        : FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: selectedGender == '남성'
                          ? Color(0xFF3677B8)
                          : FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                  ),
                  child: Text(
                    '남성',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: selectedGender == '남성'
                              ? Colors.white
                              : FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: InkWell(
                onTap: () => onGenderSelected('여성'),
                child: Container(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                  decoration: BoxDecoration(
                    color: selectedGender == '여성'
                        ? Color(0xFF3677B8)
                        : FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: selectedGender == '여성'
                          ? Color(0xFF3677B8)
                          : FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                  ),
                  child: Text(
                    '여성',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: selectedGender == '여성'
                              ? Colors.white
                              : FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTermsAgreement({
    required bool? value,
    required Function(bool?) onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: onChanged,
          activeColor: FlutterFlowTheme.of(context).primary,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '이용약관 및 개인정보처리방침에 ',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                      ),
                ),
                TextSpan(
                  text: '동의합니다',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
