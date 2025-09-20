import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'join_main_widget.dart' show JoinMainWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../services/auth_service.dart';

class JoinMainModel extends FlutterFlowModel<JoinMainWidget> {
  ///  State fields for stateful widgets in this page.

  // 1. 아이디 (이메일)
  FocusNode? emailFocusNode;
  TextEditingController? emailController;
  String? Function(BuildContext, String?)? emailControllerValidator;

  // 2. 비밀번호
  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordControllerValidator;

  // 3. 비밀번호 재입력
  FocusNode? confirmPasswordFocusNode;
  TextEditingController? confirmPasswordController;
  late bool confirmPasswordVisibility;
  String? Function(BuildContext, String?)? confirmPasswordControllerValidator;

  // 4. 이름
  FocusNode? nameFocusNode;
  TextEditingController? nameController;
  String? Function(BuildContext, String?)? nameControllerValidator;

  // 5. 학번
  FocusNode? studentIdFocusNode;
  TextEditingController? studentIdController;
  String? Function(BuildContext, String?)? studentIdControllerValidator;

  // 6. 생년월일
  DateTime? birthDate;

  // 7. 성별
  String? gender;

  // 8. 전화번호
  FocusNode? phoneFocusNode;
  TextEditingController? phoneController;
  late MaskTextInputFormatter phoneMask;
  String? Function(BuildContext, String?)? phoneControllerValidator;

  // 9. 거주지역 (도로명 주소)
  FocusNode? addressFocusNode;
  TextEditingController? addressController;
  String? Function(BuildContext, String?)? addressControllerValidator;

  // 10. 상세주소 (호실)
  FocusNode? roomNumberFocusNode;
  TextEditingController? roomNumberController;
  String? Function(BuildContext, String?)? roomNumberControllerValidator;

  // 약관 동의
  bool? termsAgreement;

  // Auth service instance
  final AuthService _authService = AuthService();

  // 비밀번호 일치 여부
  bool isPasswordMismatch = false;

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
    confirmPasswordVisibility = false;
    phoneMask = MaskTextInputFormatter(mask: '###-####-####');
  }

  // 비밀번호 재입력 검증
  void validatePasswordMatch() {
    if (passwordController?.text.isNotEmpty == true &&
        confirmPasswordController?.text.isNotEmpty == true) {
      isPasswordMismatch =
          passwordController!.text != confirmPasswordController!.text;
    } else {
      isPasswordMismatch = false;
    }
  }

  // 유효성 검사 메서드들
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '올바른 이메일 형식을 입력해주세요';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    if (value.length < 6) {
      return '비밀번호는 6자 이상이어야 합니다';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '이름을 입력해주세요';
    }
    if (value.length < 2) {
      return '이름은 2자 이상이어야 합니다';
    }
    return null;
  }

  String? validateStudentId(String? value) {
    if (value == null || value.isEmpty) {
      return '학번을 입력해주세요';
    }
    if (!RegExp(r'^\d{8}$').hasMatch(value)) {
      return '학번은 8자리 숫자여야 합니다';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '전화번호를 입력해주세요';
    }
    if (!RegExp(r'^\d{3}-\d{4}-\d{4}$').hasMatch(value)) {
      return '올바른 전화번호 형식을 입력해주세요 (010-1234-5678)';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return '도로명 주소를 입력해주세요';
    }
    if (value.length < 5) {
      return '올바른 도로명 주소를 입력해주세요';
    }
    return null;
  }

  String? validateRoomNumber(String? value) {
    if (value == null || value.isEmpty) {
      return '호실을 입력해주세요';
    }
    return null;
  }

  // Validation method
  bool _validateForm() {
    bool isValid = true;

    // 이메일 검증
    if (emailController?.text.isEmpty ?? true) {
      isValid = false;
    }

    // 비밀번호 검증
    if (passwordController?.text.isEmpty ?? true) {
      isValid = false;
    }

    // 비밀번호 재입력 검증
    if (confirmPasswordController?.text.isEmpty ?? true) {
      isValid = false;
    }

    // 이름 검증
    if (nameController?.text.isEmpty ?? true) {
      isValid = false;
    }

    // 학번 검증
    if (studentIdController?.text.isEmpty ?? true) {
      isValid = false;
    }

    // 생년월일 검증
    if (birthDate == null) {
      isValid = false;
    }

    // 성별 검증
    if (gender == null || gender!.isEmpty) {
      isValid = false;
    }

    // 전화번호 검증
    if (phoneController?.text.isEmpty ?? true) {
      isValid = false;
    }

    // 거주지역 검증
    if (validateAddress(addressController?.text) != null) {
      isValid = false;
    }

    // 호실 검증
    if (roomNumberController?.text.isEmpty ?? true) {
      isValid = false;
    }

    // 약관 동의 검증
    if (termsAgreement != true) {
      isValid = false;
    }

    return isValid;
  }

  // Sign up method
  Future<void> signUp(BuildContext context) async {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }

    validatePasswordMatch();
    if (isPasswordMismatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    try {
      await _authService.signUp(
        email: emailController!.text.trim(),
        password: passwordController!.text,
        name: nameController!.text.trim(),
        studentId: studentIdController!.text.trim(),
        phoneNumber: phoneController!.text.trim(),
        address: addressController!.text.trim(),
        roomNumber: roomNumberController!.text.trim(),
        gender: gender,
        birthDate: birthDate,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 성공! 로그인해주세요.')),
        );
        context.pushNamed('LoginMain');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  void dispose() {
    emailFocusNode?.dispose();
    emailController?.dispose();

    passwordFocusNode?.dispose();
    passwordController?.dispose();

    confirmPasswordFocusNode?.dispose();
    confirmPasswordController?.dispose();

    nameFocusNode?.dispose();
    nameController?.dispose();

    studentIdFocusNode?.dispose();
    studentIdController?.dispose();

    phoneFocusNode?.dispose();
    phoneController?.dispose();

    addressFocusNode?.dispose();
    addressController?.dispose();

    roomNumberFocusNode?.dispose();
    roomNumberController?.dispose();
  }
}
