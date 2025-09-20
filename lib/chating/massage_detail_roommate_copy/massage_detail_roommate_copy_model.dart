import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'massage_detail_roommate_copy_widget.dart'
    show MassageDetailRoommateCopyWidget;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_service.dart';

import '../../services/global_message_listener.dart';

class MassageDetailRoommateCopyModel
    extends FlutterFlowModel<MassageDetailRoommateCopyWidget> {
  // 채팅 관련 변수들
  TextEditingController? messageController;
  String? selectedRole; // 실장님, 사감님, 층장
  String? currentUserId;
  String? currentUserName;
  String? currentStudentId; // 학생 학번

  // Firestore 인스턴스
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 채팅 스트림
  Stream<QuerySnapshot>? chatStream;

  // 메시지 목록 (임시로 사용)
  List<Map<String, dynamic>> messages = [];

  // 초기 로드 완료 여부
  bool _isInitialLoad = true;

  // 마지막으로 확인한 메시지 개수
  int _lastMessageCount = 0;

  @override
  void initState(BuildContext context) {
    messageController = TextEditingController();
    _initializeChat();
  }

  void _initializeChat() {
    // 현재 사용자 정보 가져오기
    User? user = _auth.currentUser;
    if (user != null) {
      currentUserId = user.uid;
      _getUserInfo();
    } else {
      // 임시 사용자 정보 설정 (학생 시뮬레이션)
      print('Firebase 인증 사용자가 없어 임시 사용자 정보 설정');
      currentUserId = 'student_001';
      currentUserName = '이민구';
      currentStudentId = '20230709';

      // 빈 메시지 목록으로 시작
      messages = [];
    }

    // 채팅 스트림 초기화
    _initializeChatStream();
  }

  void _getUserInfo() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUserId).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        currentUserName = userData['name'];
        currentStudentId = userData['studentId'];
      } else {
        // 사용자 정보가 없는 경우 기본값 설정
        currentUserName = '학생';
        currentStudentId = '20230709';
      }
    } catch (e) {
      print('사용자 정보 가져오기 오류: $e');
      currentUserName = '학생';
      currentStudentId = '20230709';
    }
  }

  // URL 파라미터에서 역할 설정
  void setRoleFromParameter(String? role) {
    if (role != null) {
      selectedRole = role;
      _initializeChatStream();
    }
  }

  void _initializeChatStream() {
    if (selectedRole != null && currentStudentId != null) {
      // 초기 로드 플래그 리셋
      _isInitialLoad = true;
      _lastMessageCount = 0;

      // 학생별 채팅방 ID 생성
      String chatId = _getChatId();

      // 역할별 관리자 타입 매핑
      String adminType = getAdminType(selectedRole!);

      // 채팅방 생성 또는 업데이트
      _createOrUpdateChatRoom(chatId, adminType);

      // 현재 채팅방의 글로벌 리스너 일시정지 (중복 알림 방지)
      GlobalMessageListener().pauseChatListener(chatId);

      // 간단한 알림 서비스 사용

      // 메시지 스트림 설정 - chats 컬렉션 사용
      try {
        print('Firestore 연결 시도 중...');

        chatStream = _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .snapshots();

        // 메시지 스트림 리스너 추가 - 새 메시지 수신 시 간단한 알림
        chatStream?.listen(
          (snapshot) {
            print('🔔 메시지 스트림 업데이트: ${snapshot.docs.length}개 메시지');

            // 초기 로드인지 확인
            if (_isInitialLoad) {
              print('🔔 초기 로드 - 기존 메시지들은 알림 생략');
              _lastMessageCount = snapshot.docs.length;
              _isInitialLoad = false;
              return;
            }

            // 실제로 새로운 메시지가 추가되었는지 확인
            int currentMessageCount = snapshot.docs.length;
            if (currentMessageCount <= _lastMessageCount) {
              print('🔔 새로운 메시지 없음 - 알림 생략');
              return;
            }

            print('🔔 새 메시지 감지: ${currentMessageCount - _lastMessageCount}개');

            // DocumentChange를 통해 실제 새로 추가된 메시지만 처리
            for (var change in snapshot.docChanges) {
              if (change.type == DocumentChangeType.added) {
                var messageData = change.doc.data() as Map<String, dynamic>;
                String messageText = messageData['text'] ?? '';
                String senderName = messageData['senderName'] ?? '알 수 없음';
                bool isAdmin = messageData['isAdmin'] ?? false;
                String senderId = messageData['senderId'] ?? '';

                print('🔔 새 메시지 상세: $messageText');
                print(
                    '🔔 발신자: $senderName, isAdmin: $isAdmin, senderId: $senderId');

                // 자신이 보낸 메시지는 알림 제외
                if (senderId == 'student' &&
                    senderName == (currentUserName ?? '학생')) {
                  print('🔔 자신이 보낸 메시지 - 알림 생략');
                  continue;
                }

                // AI 어시스턴트 메시지는 알림 제외
                if (senderName == 'AI 어시스턴트') {
                  print('🔔 AI 어시스턴트 메시지 - 알림 생략');
                  continue;
                }

                // 채팅방 내에서는 알림을 표시하지 않음 (글로벌 리스너에서 처리)
                print('🔔 채팅방 내에서는 알림 생략 (글로벌 리스너에서 처리)');
              }
            }

            // 메시지 개수 업데이트
            _lastMessageCount = currentMessageCount;
          },
          onError: (error) {
            print('🔔 Firestore 스트림 오류: $error');
            // 네트워크 오류 시 재시도 로직
            Future.delayed(Duration(seconds: 5), () {
              print('🔔 Firestore 연결 재시도 중...');
              _initializeChatStream();
            });
          },
        );

        print('🔔 채팅 스트림 초기화 성공: $chatId');
      } catch (e) {
        print('🔔 채팅 스트림 초기화 오류: $e');
        // 오류 발생 시 5초 후 재시도
        Future.delayed(Duration(seconds: 5), () {
          print('🔔 Firestore 연결 재시도 중...');
          _initializeChatStream();
        });
      }
    } else {
      print(
          '🔔 채팅 스트림 초기화 실패: selectedRole=$selectedRole, currentStudentId=$currentStudentId');
      chatStream = null;
    }
  }

  String _getChatId() {
    // 학생 학번과 관리자 타입으로 채팅방 ID 생성
    String adminType = getAdminType(selectedRole!);
    return 'chat_${currentStudentId}_$adminType';
  }

  String getAdminType(String role) {
    switch (role) {
      case '실장님':
        return 'director';
      case '사감님':
        return 'supervisor';
      case '층장':
        return 'floor_manager';
      case 'chatbot':
        return 'chatbot';
      default:
        return 'general';
    }
  }

  void _createOrUpdateChatRoom(String chatId, String adminType) async {
    try {
      // chats 컬렉션에 채팅방 정보 저장
      await _firestore.collection('chats').doc(chatId).set({
        'studentName': currentUserName ?? '학생',
        'studentId': currentStudentId ?? 'unknown',
        'participants': [currentStudentId ?? 'unknown', 'admin'],
        'adminType': adminType,
        'lastMessage': '채팅방이 생성되었습니다.',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageBy': 'admin',
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('채팅방 생성/업데이트 성공: $chatId');
    } catch (e) {
      print('채팅방 생성/업데이트 오류: $e');
    }
  }

  void sendMessage() async {
    if (messageController?.text.trim().isEmpty ?? true) return;

    print('메시지 전송 시작: ${messageController!.text.trim()}');
    print('selectedRole: $selectedRole');
    print('currentStudentId: $currentStudentId');

    // 메시지 텍스트 저장
    String messageText = messageController!.text.trim();

    // 입력 필드 초기화
    messageController!.clear();

    try {
      String chatId = _getChatId();
      print('채팅방 ID: $chatId');

      // 네트워크 연결 상태 확인
      print('Firestore 연결 확인 중...');

      // Firebase 인증 여부와 관계없이 Firestore에 메시지 저장
      print('Firestore에 메시지 저장 중...');
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'text': messageText,
        'senderId': 'student',
        'senderName': currentUserName ?? '학생',
        'timestamp': FieldValue.serverTimestamp(),
        'isAdmin': false,
      });

      // 채팅방 정보 업데이트 - 웹에서 목록에 표시되도록
      print('채팅방 정보 업데이트 중...');
      await _firestore.collection('chats').doc(chatId).set({
        'studentName': currentUserName ?? '학생',
        'studentId': currentStudentId ?? 'unknown',
        'participants': [currentStudentId ?? 'unknown', 'admin'],
        'adminType': getAdminType(selectedRole!),
        'lastMessage': messageText,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageBy': 'student',
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('메시지 전송 성공: $messageText');

      // 자신이 보낸 메시지는 알림 제거 (주석 처리)
      // _sendNewMessageNotification(messageText);

      // 챗봇인 경우 자동 응답
      if (selectedRole == 'chatbot') {
        _sendChatbotResponse(messageText);
      }
    } catch (e) {
      print('메시지 전송 오류: $e');

      // 네트워크 오류인지 확인
      if (e.toString().contains('EAI_NODATA') ||
          e.toString().contains('network') ||
          e.toString().contains('connection')) {
        print('네트워크 연결 오류로 인한 메시지 전송 실패');
        // 사용자에게 네트워크 오류 알림
        // TODO: 사용자에게 네트워크 오류 메시지 표시
      }

      // 오류 발생 시 임시 메시지 추가
      messages.add({
        'text': messageText,
        'senderId': 'student',
        'senderName': currentUserName ?? '학생',
        'timestamp': DateTime.now(),
        'isAdmin': false,
      });
      print('오류로 인한 임시 메시지 추가 완료: ${messages.length}개 메시지');

      // 5초 후 재시도
      Future.delayed(Duration(seconds: 5), () {
        print('메시지 전송 재시도 중...');
        sendMessage();
      });
    }
  }

  Future<void> sendImageMessage(String imageUrl) async {
    try {
      final String chatId = _getChatId();

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'text': '',
        'imageUrl': imageUrl,
        'senderId': 'student',
        'senderName': currentUserName ?? '학생',
        'timestamp': FieldValue.serverTimestamp(),
        'isAdmin': false,
      });

      // 채팅방 정보 업데이트
      await _firestore.collection('chats').doc(chatId).set({
        'studentName': currentUserName ?? '학생',
        'studentId': currentStudentId ?? 'unknown',
        'participants': [currentStudentId ?? 'unknown', 'admin'],
        'adminType': getAdminType(selectedRole!),
        'lastMessage': '사진',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageBy': 'student',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('이미지 메시지 전송 오류: $e');
    }
  }

  void updateRole(String newRole) {
    selectedRole = newRole;
    _initializeChatStream();
  }

  // 챗봇 자동 응답 메서드
  void _sendChatbotResponse(String userMessage) async {
    try {
      // 잠시 대기 후 응답 (자연스러운 느낌을 위해)
      await Future.delayed(Duration(seconds: 1));

      // ChatGPT API를 사용한 응답 생성
      String response = await _generateChatbotResponseWithGPT(userMessage);

      String chatId = _getChatId();

      // 챗봇 응답을 Firestore에 저장
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'text': response,
        'senderId': 'admin',
        'senderName': 'AI 어시스턴트',
        'timestamp': FieldValue.serverTimestamp(),
        'isAdmin': true,
      });

      // 채팅방 정보 업데이트
      await _firestore.collection('chats').doc(chatId).set({
        'studentName': currentUserName ?? '학생',
        'studentId': currentStudentId ?? 'unknown',
        'participants': [currentStudentId ?? 'unknown', 'admin'],
        'adminType': 'chatbot',
        'lastMessage': response,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageBy': 'admin',
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('챗봇 응답 전송 완료: $response');
    } catch (e) {
      print('챗봇 응답 전송 오류: $e');
    }
  }

  // ChatGPT API를 사용한 응답 생성
  Future<String> _generateChatbotResponseWithGPT(String userMessage) async {
    try {
      print('🔧 ChatbotService 호출 시작: $userMessage');
      // ChatbotService 사용
      final chatbotService = ChatbotService();
      print('🔧 ChatbotService 인스턴스 생성 완료');
      final response = await chatbotService.chatWithAI(userMessage, messages);
      print('🔧 ChatbotService 응답: $response');
      return response;
    } catch (e) {
      print('❌ ChatbotService 호출 오류: $e');
      print('❌ 오류 스택: ${StackTrace.current}');
      return _generateChatbotResponse(userMessage);
    }
  }

  // 챗봇 응답 생성 메서드
  String _generateChatbotResponse(String userMessage) {
    String message = userMessage.toLowerCase();

    // 기본 인사말
    if (message.contains('안녕') ||
        message.contains('hello') ||
        message.contains('hi')) {
      return '안녕하세요! AI 어시스턴트입니다. 무엇을 도와드릴까요?';
    }

    // 기숙사 관련 질문
    if (message.contains('기숙사') || message.contains('숙소')) {
      return '기숙사 관련 문의사항이 있으시면 실장님, 사감님, 또는 층장님께 직접 문의해주세요.';
    }

    // 생활 관련 질문
    if (message.contains('생활') ||
        message.contains('규칙') ||
        message.contains('규정')) {
      return '기숙사 생활 규칙은 각 층에 게시되어 있습니다. 자세한 내용은 층장님께 문의해주세요.';
    }

    // 긴급 상황
    if (message.contains('긴급') ||
        message.contains('응급') ||
        message.contains('사고')) {
      return '긴급한 상황이시군요. 즉시 실장님(010-1234-5678) 또는 사감님(010-9876-5432)께 연락해주세요.';
    }

    // 일반적인 질문
    if (message.contains('도움') ||
        message.contains('help') ||
        message.contains('어떻게')) {
      return '도움이 필요하시군요. 구체적인 내용을 말씀해주시면 더 정확한 안내를 드릴 수 있습니다.';
    }

    // 기본 응답
    return '죄송합니다. 더 구체적으로 말씀해주시면 도움을 드릴 수 있습니다. 긴급한 사항은 실장님, 사감님, 층장님께 직접 문의해주세요.';
  }

  @override
  void dispose() {
    // 채팅방을 나갈 때 글로벌 리스너 재시작
    if (selectedRole != null && currentStudentId != null) {
      String chatId = _getChatId();
      GlobalMessageListener().resumeChatListener(chatId);
    }

    messageController?.dispose();
    print('🔔 채팅 모델 dispose');
  }
}
