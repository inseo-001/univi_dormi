import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'massage_detail_roommate_copy_model.dart';
export 'massage_detail_roommate_copy_model.dart';

import '../../services/notification_service.dart';
import '../../services/global_message_listener.dart';
import '../../services/image_upload_service.dart';

class MassageDetailRoommateCopyWidget extends StatefulWidget {
  const MassageDetailRoommateCopyWidget({super.key});

  static String routeName = 'massage_detail_roommateCopy';
  static String routePath = '/massageDetailRoommateCopy';

  @override
  State<MassageDetailRoommateCopyWidget> createState() =>
      _MassageDetailRoommateCopyWidgetState();
}

class _MassageDetailRoommateCopyWidgetState
    extends State<MassageDetailRoommateCopyWidget> {
  late MassageDetailRoommateCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  // 새 메시지 알림 관련 변수
  bool _showNewMessageIndicator = false;
  int _lastMessageCount = 0;
  bool _isInitialLoad = true; // 초기 로드 여부 확인

  // TextField 포커스 노드
  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MassageDetailRoommateCopyModel());

    // URL 파라미터에서 역할 정보 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = GoRouterState.of(context).uri;
      final role = uri.queryParameters['role'];
      final studentId = uri.queryParameters['studentId'];

      if (role != null) {
        _model.setRoleFromParameter(role);

        // 현재 채팅방 상태를 알림 서비스에 설정
        NotificationService()
            .setCurrentChatRoom(role, studentId ?? _model.currentStudentId);
        print(
            '🔔 채팅방 진입: $role, 학생ID: ${studentId ?? _model.currentStudentId}');

        setState(() {});
      }

      // 채팅방 진입 시 스크롤을 맨 아래로 이동 (더 확실하게)
      _scrollToBottomOnEntry();
    });

    // 스크롤 리스너 추가
    _scrollController.addListener(_onScroll);
  }

  // 채팅방 진입 시 초기 로드 완료 표시만
  void _scrollToBottomOnEntry() {
    // 초기 로드 완료만 표시하고 강제 스크롤은 하지 않음
    Future.delayed(Duration(milliseconds: 1000), () {
      if (mounted) {
        _isInitialLoad = false; // 초기 로드 완료 표시
      }
    });
  }

  // 스크롤 이벤트 처리 (reverse 모드에서는 맨 위가 최신 메시지)
  void _onScroll() {
    if (_scrollController.hasClients) {
      bool isAtTop =
          _scrollController.position.pixels <= 30; // reverse 모드에서는 맨 위가 최신

      // 맨 위에 도달하면 새 메시지 알림 숨기기
      if (isAtTop && _showNewMessageIndicator) {
        setState(() {
          _showNewMessageIndicator = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // 채팅방 나가기 시 현재 채팅방 상태 해제
    NotificationService().setCurrentChatRoom(null, null);
    print('🔔 채팅방 나가기: 알림 상태 해제');

    // 글로벌 메시지 리스너 재시작 (현재 채팅방 리스너)
    if (_model.selectedRole != null && _model.currentStudentId != null) {
      String adminType = _model.getAdminType(_model.selectedRole!);
      String chatId = 'chat_${_model.currentStudentId}_$adminType';
      GlobalMessageListener().resumeChatListener(chatId);
      print('🔔 글로벌 리스너 재시작: $chatId');
    }

    _model.dispose();
    _scrollController.dispose();
    _textFieldFocusNode.dispose();
    print('🔔 채팅 위젯 dispose');
    super.dispose();
  }

  // 스크롤을 맨 아래로 이동시키는 메서드 (reverse 모드에서는 맨 위가 최신 메시지)
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && mounted) {
        _scrollController.animateTo(
          0, // reverse 모드에서는 0이 최신 메시지
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 키보드가 올라올 때 스크롤 조정
  void _scrollToBottomWithKeyboard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && mounted) {
        // 새로운 메시지를 확실히 보여주기 위해 항상 맨 위(최신 메시지)로 스크롤
        _scrollController.animateTo(
          0, // reverse 모드에서는 0이 최신 메시지
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // 헤더 부분
            _buildHeader(),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Divider(
                    thickness: 2.0,
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                  // 채팅 메시지 목록
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // 채팅 영역 터치 시 키보드 숨기기
                        FocusScope.of(context).unfocus();
                      },
                      child: Stack(
                        children: [
                          _buildChatMessages(),
                          // 새 메시지 알림 표시
                          if (_showNewMessageIndicator)
                            Positioned(
                              bottom: 16.0,
                              right: 16.0,
                              child: _buildNewMessageIndicator(),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // 메시지 입력 부분
                  _buildMessageInput(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          FlutterFlowIconButton(
            borderRadius: 9.0,
            buttonSize: 28.5,
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.black,
              size: 26.0,
            ),
            onPressed: () async {
              context.pushNamed(ChatingMainWidget.routeName);
            },
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_model.selectedRole ?? '관리자'} 채팅',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
                Text(
                  '${_model.selectedRole ?? '관리자'}와 소통하세요',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                        ),
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    // 디버깅 정보 출력
    print('채팅 메시지 빌드 - chatStream: ${_model.chatStream != null}');
    print('selectedRole: ${_model.selectedRole}');
    print('currentStudentId: ${_model.currentStudentId}');

    // Firestore 스트림이 있는 경우 실시간 메시지 표시
    if (_model.chatStream != null) {
      return StreamBuilder<QuerySnapshot>(
        stream: _model.chatStream,
        builder: (context, snapshot) {
          print('StreamBuilder 상태: ${snapshot.connectionState}');
          print('StreamBuilder 데이터: ${snapshot.hasData}');
          print('StreamBuilder 오류: ${snapshot.hasError}');

          if (snapshot.hasError) {
            print('StreamBuilder 오류: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    '채팅을 불러오는데 실패했습니다.',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '오류: ${snapshot.error}',
                    style: FlutterFlowTheme.of(context).bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // UI 새로고침
                      });
                    },
                    child: Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('채팅을 불러오는 중...'),
                ],
              ),
            );
          }

          List<Map<String, dynamic>> messages = [];
          if (snapshot.hasData && snapshot.data != null) {
            print('Firestore에서 ${snapshot.data!.docs.length}개의 메시지 수신');
            for (var doc in snapshot.data!.docs) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              print('메시지 데이터: $data');

              // timestamp 처리
              DateTime? timestamp;
              if (data['timestamp'] != null) {
                if (data['timestamp'] is Timestamp) {
                  timestamp = (data['timestamp'] as Timestamp).toDate();
                } else if (data['timestamp'] is DateTime) {
                  timestamp = data['timestamp'] as DateTime;
                }
              }

              messages.add({
                'text': data['text'] ?? '',
                'senderId': data['senderId'] ?? '',
                'senderName': data['senderName'] ?? '',
                'timestamp': timestamp ?? DateTime.now(),
                'isAdmin': data['isAdmin'] ?? false,
                'imageUrl': data['imageUrl'],
              });
            }
          }

          // 메시지가 없는 경우 기본 메시지 표시
          if (messages.isEmpty) {
            print('Firestore 메시지가 없어 기본 메시지 사용');
            messages = _model.messages;
          }

          // 새 메시지가 추가되었는지 확인하고 알림 표시
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (messages.isNotEmpty && !_isInitialLoad) {
              // 메시지 개수가 증가했는지 확인
              if (messages.length > _lastMessageCount) {
                // 사용자가 스크롤을 맨 위에 있는지 확인 (reverse 모드)
                bool isAtTop = _scrollController.hasClients &&
                    _scrollController.position.pixels <= 30;

                if (!isAtTop) {
                  // 새 메시지 알림 표시 (새로운 메시지가 왔을 때만)
                  setState(() {
                    _showNewMessageIndicator = true;
                  });
                } else {
                  // 맨 위에 있으면 자동으로 스크롤
                  _scrollToBottom();
                }

                _lastMessageCount = messages.length;
              }
            } else if (_isInitialLoad) {
              // 초기 로드 시에는 메시지 개수만 업데이트
              _lastMessageCount = messages.length;
            }
          });

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: messages.length,
            reverse: true, // 맨 밑 대화창이 보이도록 reverse 사용
            itemBuilder: (context, index) {
              // reverse가 true이므로 인덱스를 뒤집어서 처리
              Map<String, dynamic> messageData =
                  messages[messages.length - 1 - index];
              bool isMyMessage = messageData['senderId'] == 'student';

              return _buildMessageBubble(messageData, isMyMessage);
            },
          );
        },
      );
    }

    // Firestore 스트림이 없는 경우 기본 메시지 표시
    print('Firestore 스트림이 없어 기본 메시지 사용');
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _model.messages.length,
      reverse: true, // 맨 밑 대화창이 보이도록 reverse 사용
      itemBuilder: (context, index) {
        // reverse가 true이므로 인덱스를 뒤집어서 처리
        Map<String, dynamic> messageData =
            _model.messages[_model.messages.length - 1 - index];
        bool isMyMessage = messageData['senderId'] == 'student';

        return _buildMessageBubble(messageData, isMyMessage);
      },
    );
  }

  Widget _buildMessageBubble(
      Map<String, dynamic> messageData, bool isMyMessage) {
    String messageText = messageData['text'] ?? '';
    String? imageUrl = messageData['imageUrl'] as String?;
    DateTime? timestamp = messageData['timestamp'] as DateTime?;

    String timeString = '';
    if (timestamp != null) {
      timeString =
          '${timestamp.hour.toString().padLeft(2, '0')} : ${timestamp.minute.toString().padLeft(2, '0')}';
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMyMessage) ...[
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(15.0),
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl != null && imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          messageText,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, bottom: 5.0),
                      child: Text(
                        timeString,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(),
                              color: Color(0xFF7C7C7E),
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                decoration: BoxDecoration(
                  color: Color(0xFF2C79E5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(0.0),
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (imageUrl != null && imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          messageText,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w300),
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0, bottom: 5.0),
                      child: Text(
                        timeString,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(),
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          // 이미지 첨부 버튼
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(color: const Color(0xFF969393)),
            ),
            child: IconButton(
              icon: const Icon(Icons.photo, color: Colors.black87, size: 22),
              onPressed: _onAttachImage,
              tooltip: '사진 첨부',
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Container(
              height: 40.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Color(0xFF969393)),
              ),
              child: TextField(
                controller: _model.messageController,
                focusNode: _textFieldFocusNode,
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                decoration: InputDecoration(
                  hintText: '메세지를 입력하세요',
                  hintStyle: TextStyle(
                    color: Color(0xFF7C7C7E),
                    fontSize: 14.0,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                ),
                onEditingComplete: _sendMessage,
                onSubmitted: (value) {
                  _sendMessage();
                },
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                onTap: () {
                  // 입력 필드 터치 시 포커스 주고 스크롤 조정
                  _textFieldFocusNode.requestFocus();
                  // 키보드가 올라올 때까지 잠시 대기
                  Future.delayed(Duration(milliseconds: 100), () {
                    if (mounted) {
                      _scrollToBottomWithKeyboard();
                    }
                  });
                },
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Color(0xFF2C79E5),
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: IconButton(
              icon: Icon(
                Icons.send_sharp,
                color: Color(0xFFFBFBFB),
                size: 24.0,
              ),
              onPressed: () {
                _sendMessage();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onAttachImage() async {
    try {
      final chatId = _model.currentStudentId == null ||
              _model.selectedRole == null
          ? null
          : 'chat_${_model.currentStudentId}_${_model.getAdminType(_model.selectedRole!)}';
      if (chatId == null) return;

      // 사용자 제스처 컨텍스트 내에서 즉시 파일 선택 창을 띄우기 위해
      // 비동기 대기 없이 서비스를 동기적으로 생성합니다.
      final imageService = _loadImageService();
      final String? url = await imageService.pickAndUploadChatImage(
        chatId: chatId,
        senderId: 'student',
      );
      if (url == null) return;
      await _model.sendImageMessage(url);
      _scrollToBottomWithKeyboard();
    } catch (e) {
      // 실패 무시
    }
  }

  // 분리: 테스트 용이성을 위해 팩토리 메서드 사용
  ImageUploadService _loadImageService() {
    // 정적 import된 서비스를 반환
    return ImageUploadService();
  }

  void _sendMessage() {
    if (_model.messageController?.text.trim().isEmpty ?? true) {
      return;
    }

    // 웹에서 엔터 입력 시 기본 줄바꿈을 막고 전송에만 사용되도록 포커스를 해제
    if (kIsWeb) {
      _textFieldFocusNode.unfocus();
    }

    print('메시지 전송 시작');
    print('현재 메시지 개수: ${_model.messages.length}');

    // 메시지 전송
    _model.sendMessage();

    print('메시지 전송 완료');
    print('전송 후 메시지 개수: ${_model.messages.length}');

    // UI 업데이트
    setState(() {
      print('UI 업데이트 완료');
    });

    // 즉시 스크롤 (UI 업데이트 직후)
    _scrollToBottomWithKeyboard();

    // 추가 지연 후 다시 스크롤 (Firestore 업데이트 후)
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        _scrollToBottomWithKeyboard();
      }
    });

    // 더 긴 지연 후 최종 스크롤 (확실한 스크롤 보장)
    Future.delayed(Duration(milliseconds: 600), () {
      if (mounted) {
        _scrollToBottomWithKeyboard();
      }
    });
  }

  // 새 메시지 알림 위젯
  Widget _buildNewMessageIndicator() {
    return GestureDetector(
      onTap: () {
        // 알림 터치 시 맨 아래로 스크롤하고 알림 숨기기
        _scrollToBottomWithKeyboard();
        setState(() {
          _showNewMessageIndicator = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Color(0xFF2C79E5),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 20.0,
            ),
            SizedBox(width: 8.0),
            Text(
              '새 메시지',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
