import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/nav/nav.dart';

/// 간단하고 확실한 메시지 알림 서비스
class SimpleNotificationService {
  static final SimpleNotificationService _instance =
      SimpleNotificationService._internal();
  factory SimpleNotificationService() => _instance;
  SimpleNotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 마지막으로 표시된 알림 내용 (중복 방지용)
  String? _lastNotificationContent;
  DateTime? _lastNotificationTime;

  /// 알림 서비스 초기화
  Future<void> initialize() async {
    print('🔔 간단한 알림 서비스 초기화 시작');

    try {
      // Android 설정
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS 설정
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Android 알림 채널 생성
      await _createNotificationChannel();

      print('🔔 간단한 알림 서비스 초기화 완료');
    } catch (e) {
      print('🔔 알림 서비스 초기화 오류: $e');
    }
  }

  /// Android 알림 채널 생성
  Future<void> _createNotificationChannel() async {
    try {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'message_notifications',
        '메시지 알림',
        description: '새로운 메시지 알림',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.createNotificationChannel(channel);
        print('🔔 Android 알림 채널 생성 완료: ${channel.id}');
      }
    } catch (e) {
      print('🔔 알림 채널 생성 오류: $e');
    }
  }

  /// 알림 클릭 시 처리
  void _onNotificationTapped(NotificationResponse response) {
    print('🔔 알림 클릭됨: ${response.payload}');

    if (response.payload != null) {
      try {
        // payload에서 채팅방 정보 파싱
        String payload = response.payload!;
        print('🔔 알림 페이로드 파싱: $payload');

        // 채팅 메시지 알림인지 확인
        if (payload.startsWith('chat_')) {
          // payload 형식: chat_role_admin 또는 chat_role_student
          List<String> parts = payload.split('_');
          if (parts.length >= 3) {
            String role = parts[2]; // admin, student 등
            print('🔔 채팅방 이동: role=$role');

            // 채팅방으로 이동
            _navigateToChat(role);
          }
        }
      } catch (e) {
        print('🔔 알림 클릭 처리 오류: $e');
      }
    }
  }

  /// 채팅방으로 이동하는 메서드
  void _navigateToChat(String role) {
    try {
      print('🔔 채팅방으로 이동 시작: role=$role');

      // appNavigatorKey를 사용하여 컨텍스트 가져오기
      final context = appNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        // GoRouter를 사용하여 채팅방으로 이동
        context.pushNamed(
          'massage_detail_roommateCopy',
          queryParameters: {'role': role},
        );
        print('🔔 채팅방 이동 완료');
      } else {
        print('🔔 ⚠️ 유효한 컨텍스트를 찾을 수 없습니다');

        // 대체 방법: 직접 GoRouter 사용
        try {
          final router = GoRouter.of(appNavigatorKey.currentState!.context);
          router.pushNamed(
            'massage_detail_roommateCopy',
            queryParameters: {'role': role},
          );
          print('🔔 대체 방법으로 채팅방 이동 완료');
        } catch (altError) {
          print('🔔 대체 방법도 실패: $altError');
        }
      }
    } catch (e) {
      print('🔔 채팅방 이동 오류: $e');
    }
  }

  /// 새로운 메시지 알림 표시
  Future<void> showNewMessageNotification({
    required String senderName,
    required String message,
    bool isFromAdmin = false,
    String? chatRole, // 채팅방 역할 정보 추가
  }) async {
    print('🔔 새 메시지 알림 표시: $senderName -> $message');

    try {
      // 중복 체크 (같은 내용의 메시지는 1분 내에는 다시 표시하지 않음)
      if (_isDuplicateMessage(message)) {
        print('🔔 중복 메시지 알림 차단');
        return;
      }

      // 알림 제목과 내용 설정
      String title = isFromAdmin ? '$senderName으로부터 메시지' : '새 메시지';
      String body =
          message.length > 100 ? '${message.substring(0, 100)}...' : message;

      // 알림 권한 확인
      bool notificationsEnabled = await areNotificationsEnabled();
      if (!notificationsEnabled) {
        print('🔔 ⚠️ 알림이 비활성화되어 있습니다. 권한을 확인해주세요.');
        await requestPermissions();
      }

      // Android 알림 설정 - 더 강력한 설정
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'message_notifications',
        '메시지 알림',
        channelDescription: '새로운 메시지 알림',
        importance: Importance.max, // 최대 중요도로 변경
        priority: Priority.max, // 최대 우선순위로 변경
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF2C79E5),
        styleInformation: BigTextStyleInformation(body),
        category: AndroidNotificationCategory.message,
        visibility: NotificationVisibility.public,
        autoCancel: true,
        ongoing: false,
        silent: false, // 소리 활성화
        channelShowBadge: true,
      );

      // iOS 알림 설정
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        presentBanner: true,
        presentList: true,
        interruptionLevel: InterruptionLevel.active,
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // 고유한 알림 ID 생성
      int notificationId =
          DateTime.now().millisecondsSinceEpoch.remainder(100000);

      // 채팅방 정보를 포함한 페이로드 생성
      String payload;
      if (chatRole != null) {
        payload = 'chat_role_$chatRole';
      } else {
        // 발신자 이름에 따라 자동으로 역할 결정
        String role = _determineRoleFromSender(senderName);
        payload = 'chat_role_$role';
      }

      print('🔔 알림 표시 시도: ID=$notificationId, 제목=$title, 페이로드=$payload');

      // 알림 표시
      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

      // 마지막 알림 정보 저장
      _lastNotificationContent = message;
      _lastNotificationTime = DateTime.now();

      print('🔔 ✅ 알림 표시 완료: ID=$notificationId');

      // 추가 확인: 알림이 실제로 표시되었는지 확인
      await Future.delayed(Duration(milliseconds: 500));
      print('🔔 알림 표시 후 0.5초 경과 - 화면에 알림이 보이나요?');
    } catch (e) {
      print('🔔 ❌ 알림 표시 오류: $e');
      print('🔔 오류 스택 트레이스: ${StackTrace.current}');
    }
  }

  /// 중복 메시지 체크
  bool _isDuplicateMessage(String message) {
    if (_lastNotificationContent == null || _lastNotificationTime == null) {
      return false;
    }

    // 같은 내용이고 1분 이내라면 중복으로 판단
    bool isSameContent = _lastNotificationContent == message;
    bool isWithinOneMinute =
        DateTime.now().difference(_lastNotificationTime!).inMinutes < 1;

    return isSameContent && isWithinOneMinute;
  }

  /// 발신자 이름에 따라 채팅방 역할 결정
  String _determineRoleFromSender(String senderName) {
    // 발신자 이름에 따른 역할 매핑 (채팅방 모델과 일치)
    if (senderName.contains('실장') || senderName.contains('실장님')) {
      return '실장님'; // 실장님 채팅방
    } else if (senderName.contains('사감') || senderName.contains('사감님')) {
      return '사감님'; // 사감님 채팅방
    } else if (senderName.contains('층장') || senderName.contains('층장님')) {
      return '층장'; // 층장님 채팅방
    } else if (senderName.contains('관리자') || senderName.contains('admin')) {
      return 'admin'; // 관리자 채팅방
    } else {
      return 'student'; // 기본값: 학생 채팅방
    }
  }

  /// 실장님 메시지 알림
  Future<void> showManagerMessage(String message) async {
    await showNewMessageNotification(
      senderName: '실장님',
      message: message,
      isFromAdmin: true,
    );
  }

  /// 사감님 메시지 알림
  Future<void> showHousemasterMessage(String message) async {
    await showNewMessageNotification(
      senderName: '사감님',
      message: message,
      isFromAdmin: true,
    );
  }

  /// 층장님 메시지 알림
  Future<void> showFloorManagerMessage(String message) async {
    await showNewMessageNotification(
      senderName: '층장님',
      message: message,
      isFromAdmin: true,
    );
  }

  /// 알림 권한 요청 (Android 13+)
  Future<bool> requestPermissions() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? granted =
            await androidImplementation.requestNotificationsPermission();
        print('🔔 Android 알림 권한: ${granted == true ? '허용' : '거부'}');

        if (granted != true) {
          print('🔔 ⚠️ 알림 권한이 거부되었습니다. 알림이 표시되지 않을 수 있습니다.');
          return false;
        }
        return true;
      }

      // Android 구현이 없는 경우 (iOS 등)
      return true;
    } catch (e) {
      print('🔔 권한 요청 오류: $e');
      return false;
    }
  }

  /// 알림 권한 상태 확인
  Future<bool> areNotificationsEnabled() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? enabled =
            await androidImplementation.areNotificationsEnabled();
        print('🔔 알림 활성화 상태: ${enabled == true ? '활성화' : '비활성화'}');
        return enabled ?? false;
      }

      return true; // iOS나 다른 플랫폼의 경우 기본적으로 true
    } catch (e) {
      print('🔔 알림 상태 확인 오류: $e');
      return false;
    }
  }
}
