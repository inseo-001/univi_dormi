import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/flutter_flow/nav/nav.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 알림 중복 방지를 위한 변수 (메시지 내용 기반)
  Map<String, String> _lastNotificationContent = {};
  Map<String, DateTime> _lastNotificationTime = {}; // 같은 내용 재전송 방지용

  // 현재 채팅방 상태를 추적하는 변수
  String? _currentChatRole;
  String? _currentStudentId;

  // 현재 채팅방 상태 getter 메서드
  String? get currentChatRole => _currentChatRole;
  String? get currentStudentId => _currentStudentId;

  // 알림 권한 요청
  Future<void> requestPermission() async {
    print('🔔 알림 권한 요청 시작');

    try {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('🔔 사용자 권한 상태: ${settings.authorizationStatus}');

      // 권한 상태에 따른 처리
      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
          print('🔔 알림 권한 승인됨');
          break;
        case AuthorizationStatus.denied:
          print('🔔 알림 권한 거부됨');
          break;
        case AuthorizationStatus.notDetermined:
          print('🔔 알림 권한 미결정');
          break;
        case AuthorizationStatus.provisional:
          print('🔔 알림 권한 임시 승인');
          break;
      }
    } catch (e) {
      print('🔔 알림 권한 요청 오류: $e');
    }
  }

  // FCM 토큰 가져오기
  Future<String?> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      print('🔔 FCM 토큰: $token');

      if (token != null) {
        print('🔔 FCM 토큰 성공적으로 가져옴');
      } else {
        print('🔔 FCM 토큰이 null입니다');
      }

      return token;
    } catch (e) {
      print('🔔 FCM 토큰 가져오기 오류: $e');
      return null;
    }
  }

  // 로컬 알림 초기화
  Future<void> initializeLocalNotifications() async {
    print('🔔 로컬 알림 초기화 시작');

    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

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
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      );

      print('🔔 로컬 알림 초기화 완료');
    } catch (e) {
      print('🔔 로컬 알림 초기화 오류: $e');
    }
  }

  // 알림 응답 처리
  void onDidReceiveNotificationResponse(NotificationResponse response) {
    print('알림 응답: ${response.payload}');

    // 알림 클릭 시 해당 채팅 화면으로 이동
    try {
      if (response.payload != null) {
        String payload = response.payload!;

        // payload 형식: 'chat_studentId_adminType' 또는 'admin_chat_studentId_adminType'
        if (payload.startsWith('chat_') || payload.startsWith('admin_chat_')) {
          List<String> parts = payload.split('_');

          String studentId = '';
          String adminType = '';

          if (payload.startsWith('admin_chat_')) {
            // 'admin_chat_studentId_adminType' 형식
            if (parts.length >= 4) {
              studentId = parts[2];
              adminType = parts[3];
            }
          } else {
            // 'chat_studentId_adminType' 형식
            if (parts.length >= 3) {
              studentId = parts[1];
              adminType = parts[2];
            }
          }

          if (studentId.isNotEmpty && adminType.isNotEmpty) {
            String roleName = _getRoleName(adminType);

            print(
                '로컬 알림 클릭: 학생ID=$studentId, adminType=$adminType, 역할=$roleName');

            // 채팅 화면으로 이동 (지연 실행으로 context 사용)
            Future.delayed(Duration(milliseconds: 100), () {
              _navigateToChatScreen(roleName, studentId);
            });
          }
        }
      }
    } catch (e) {
      print('로컬 알림 클릭 처리 오류: $e');
    }
  }

  // 채팅 화면으로 이동하는 메서드
  void _navigateToChatScreen(String roleName, String studentId) {
    try {
      // Flutter Flow의 GoRouter를 사용하여 채팅 화면으로 이동
      final router = GoRouter.of(appNavigatorKey.currentContext!);

      // 채팅 화면의 라우트 이름
      final chatRouteName = 'massage_detail_roommateCopy';

      // 쿼리 파라미터로 역할 정보 전달
      final queryParams = {
        'role': roleName,
        'studentId': studentId,
      };

      // 채팅 화면으로 이동
      router.pushNamed(
        chatRouteName,
        queryParameters: queryParams,
      );

      print('채팅 화면으로 이동: 역할=$roleName, 학생ID=$studentId');
    } catch (e) {
      print('채팅 화면 이동 오류: $e');
    }
  }

  // 로컬 알림 표시
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    print('🔔 로컬 알림 표시 시도: $title - $body');

    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'chat_notifications',
        '채팅 알림',
        channelDescription: '새로운 메시지 알림',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF2C79E5),
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      // 고유한 알림 ID 생성 (중복 방지)
      int notificationId =
          DateTime.now().millisecondsSinceEpoch.remainder(100000);

      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

      print('🔔 로컬 알림 표시 성공: ID=$notificationId, 제목=$title');
    } catch (e) {
      print('🔔 로컬 알림 표시 오류: $e');
    }
  }

  // 조용한 알림 표시 (소리 없음, 진동 없음, 하지만 잘 보임)
  Future<void> showQuietNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    print('🔔 조용한 알림 표시 시도: $title - $body');

    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'chat_notifications_quiet',
        '조용한 채팅 알림',
        channelDescription: '조용한 메시지 알림 (소리 없음)',
        importance: Importance.high, // 중요도를 높여서 잘 보이게 함
        priority: Priority.high, // 우선순위를 높여서 잘 보이게 함
        showWhen: true,
        enableVibration: false,
        playSound: false,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF2C79E5),
        silent: true,
        ongoing: false,
        autoCancel: true,
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: false,
        interruptionLevel: InterruptionLevel.passive, // iOS에서 조용하게 표시
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      // 고유한 알림 ID 생성 (중복 방지)
      int notificationId =
          DateTime.now().millisecondsSinceEpoch.remainder(100000);

      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

      print('🔔 조용한 알림 표시 성공: ID=$notificationId, 제목=$title');
    } catch (e) {
      print('🔔 조용한 알림 표시 오류: $e');
    }
  }

  // 헤드업 알림 표시 (채팅방 내부용 - 소리 없지만 화면에 잘 보임)
  Future<void> showHeadsUpNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    print('🔔 헤드업 알림 표시 시도: $title - $body');

    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'chat_notifications_headsup',
        '채팅 헤드업 알림',
        channelDescription: '채팅방 내부 헤드업 알림 (소리 없음)',
        importance: Importance.max, // 최대 중요도로 헤드업 표시
        priority: Priority.max, // 최대 우선순위로 헤드업 표시
        showWhen: true,
        enableVibration: false,
        playSound: false,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF2C79E5),
        silent: true,
        ongoing: false,
        autoCancel: true,
        fullScreenIntent: false, // 전체 화면은 하지 않음
        category: AndroidNotificationCategory.message,
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: false,
        presentBanner: true, // iOS에서 배너 표시
        interruptionLevel: InterruptionLevel.timeSensitive, // 시간 민감한 알림으로 설정
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      // 고유한 알림 ID 생성 (중복 방지)
      int notificationId =
          DateTime.now().millisecondsSinceEpoch.remainder(100000);

      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

      print('🔔 헤드업 알림 표시 성공: ID=$notificationId, 제목=$title');
    } catch (e) {
      print('🔔 헤드업 알림 표시 오류: $e');
    }
  }

  // 백그라운드 메시지 처리
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('백그라운드 메시지 수신: ${message.messageId}');
    print('메시지 데이터: ${message.data}');
    print('메시지 알림: ${message.notification?.title}');

    // 백그라운드에서도 로컬 알림 표시
    try {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

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

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'chat_notifications',
        '채팅 알림',
        channelDescription: '새로운 메시지 알림',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        message.notification?.title ?? '새 메시지',
        message.notification?.body ?? '새로운 메시지가 도착했습니다.',
        platformChannelSpecifics,
        payload: message.data.toString(),
      );
    } catch (e) {
      print('백그라운드 알림 표시 오류: $e');
    }
  }

  // 포그라운드 메시지 처리
  void onMessage(RemoteMessage message) {
    print('🔔 포그라운드 메시지 수신: ${message.messageId}');
    print('🔔 메시지 데이터: ${message.data}');
    print('🔔 메시지 알림: ${message.notification?.title}');

    try {
      // 포그라운드에서도 로컬 알림 표시
      showLocalNotification(
        title: message.notification?.title ?? '새 메시지',
        body: message.notification?.body ?? '새로운 메시지가 도착했습니다.',
        payload: message.data.toString(),
      );

      print('🔔 포그라운드 메시지 처리 완료');
    } catch (e) {
      print('🔔 포그라운드 메시지 처리 오류: $e');
    }
  }

  // 앱이 백그라운드에서 열릴 때 처리
  void onMessageOpenedApp(RemoteMessage message) {
    print('백그라운드에서 앱 열림: ${message.messageId}');
    print('메시지 데이터: ${message.data}');

    // 알림 클릭 시 해당 채팅 화면으로 이동
    try {
      if (message.data.containsKey('chatId')) {
        String chatId = message.data['chatId'];
        String studentId = message.data['studentId'] ?? '';
        String adminType = message.data['adminType'] ?? '';

        // 관리자 타입을 한국어로 변환
        String roleName = _getRoleName(adminType);

        // 채팅 화면으로 네비게이션
        print('채팅 화면으로 이동: $chatId, 역할: $roleName');
        Future.delayed(Duration(milliseconds: 100), () {
          _navigateToChatScreen(roleName, studentId);
        });
      }
    } catch (e) {
      print('알림 클릭 처리 오류: $e');
    }
  }

  // 현재 채팅방 상태 설정
  void setCurrentChatRoom(String? role, String? studentId) {
    _currentChatRole = role;
    _currentStudentId = studentId;
    print('🔔 현재 채팅방 상태 설정: 역할=$role, 학생ID=$studentId');

    // 채팅방을 나갈 때 중복 알림 방지 데이터도 초기화
    if (role == null && studentId == null) {
      _lastNotificationContent.clear();
      _lastNotificationTime.clear();
      print('🔔 채팅방 나감: 알림 중복 방지 데이터 초기화');
    }
  }

  // 알림 중복 방지 체크 (메시지 내용 기반)
  bool _shouldShowNotification(String notificationKey, String messageContent) {
    DateTime now = DateTime.now();
    String? lastContent = _lastNotificationContent[notificationKey];
    DateTime? lastTime = _lastNotificationTime[notificationKey];

    // 이전에 같은 내용의 알림이 없으면 허용
    if (lastContent == null) {
      _lastNotificationContent[notificationKey] = messageContent;
      _lastNotificationTime[notificationKey] = now;
      print('🔔 알림 허용: 새로운 메시지 내용 - $notificationKey');
      return true;
    }

    // 메시지 내용이 다르면 허용
    if (lastContent != messageContent) {
      _lastNotificationContent[notificationKey] = messageContent;
      _lastNotificationTime[notificationKey] = now;
      print('🔔 알림 허용: 다른 메시지 내용 - $notificationKey');
      return true;
    }

    // 같은 내용이지만 5분 이상 지났으면 허용 (재전송 방지)
    if (lastTime != null && now.difference(lastTime).inMinutes >= 5) {
      _lastNotificationTime[notificationKey] = now;
      print('🔔 알림 허용: 같은 내용이지만 5분 경과 - $notificationKey');
      return true;
    }

    print('🔔 알림 차단: 같은 내용의 메시지 - $notificationKey');
    return false;
  }

  // 관리자 타입을 한국어로 변환
  String _getRoleName(String adminType) {
    switch (adminType) {
      case 'director':
        return '실장님';
      case 'supervisor':
        return '사감님';
      case 'floor_manager':
        return '층장';
      case 'chatbot':
        return 'chatbot';
      default:
        return '관리자';
    }
  }

  // 토큰 새로고침 처리
  void onTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((token) {
      print('FCM 토큰 새로고침: $token');
      // 토큰을 서버에 업데이트
      _updateTokenOnServer(token);
    });
  }

  // 서버에 토큰 업데이트
  Future<void> _updateTokenOnServer(String token) async {
    try {
      // 현재 사용자 ID 가져오기 (Firebase Auth 사용)
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      // Firebase Auth 사용자가 없는 경우 임시 사용자 ID 사용
      if (userId == null) {
        userId = 'student_001';
      }

      // userId는 이미 null이 아님을 확인했으므로 직접 사용
      await _firestore.collection('users').doc(userId).set({
        'fcmToken': token,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('FCM 토큰이 서버에 업데이트되었습니다.');
    } catch (e) {
      print('FCM 토큰 업데이트 오류: $e');
    }
  }

  // 알림 서비스 초기화
  Future<void> initialize() async {
    print('🔔 알림 서비스 초기화 시작');

    try {
      // 백그라운드 메시지 핸들러 설정
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      print('🔔 백그라운드 메시지 핸들러 설정 완료');

      // 권한 요청
      await requestPermission();

      // 로컬 알림 초기화
      await initializeLocalNotifications();

      // 포그라운드 메시지 처리
      FirebaseMessaging.onMessage.listen(onMessage);
      print('🔔 포그라운드 메시지 리스너 설정 완료');

      // 백그라운드에서 앱 열림 처리
      FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
      print('🔔 백그라운드 앱 열림 리스너 설정 완료');

      // 토큰 새로고침 처리
      onTokenRefresh();

      // 초기 토큰 가져오기 및 서버에 저장
      String? token = await getToken();
      if (token != null) {
        await _updateTokenOnServer(token);
      }

      print('🔔 알림 서비스 초기화 완료');
    } catch (e) {
      print('🔔 알림 서비스 초기화 오류: $e');
    }
  }

  // 채팅 메시지 알림 전송 (학생 → 관리자)
  Future<void> sendChatNotification({
    required String studentId,
    required String studentName,
    required String message,
    required String adminType,
  }) async {
    try {
      // 관리자 타입에 따른 제목 설정
      String title = '';
      switch (adminType) {
        case 'director':
          title = '실장님';
          break;
        case 'supervisor':
          title = '사감님';
          break;
        case 'floor_manager':
          title = '층장님';
          break;
        default:
          title = '관리자';
      }

      // 알림 중복 방지 체크 (메시지 내용 기반)
      String notificationKey = 'student_${studentId}_$adminType';
      if (!_shouldShowNotification(notificationKey, message)) {
        print('🔔 중복 알림 방지: $notificationKey - $message');
        return;
      }

      // 현재 채팅방 상태 확인
      bool isInChatRoom = await _checkIfInChatRoom(studentId, adminType);

      // 채팅방에 있지 않을 때만 알림 표시
      if (!isInChatRoom) {
        await showLocalNotification(
          title: '$title에게 메시지 전송',
          body:
              message.length > 50 ? '${message.substring(0, 50)}...' : message,
          payload: 'chat_${studentId}_$adminType',
        );
        print('🔔 채팅 알림 전송 완료 (채팅방 외부)');
      } else {
        print('🔔 채팅방 내부에서는 알림 표시하지 않음');
      }

      // 중요 알림만 Firestore에 저장 (선택적)
      // await _firestore.collection('notifications').add({
      //   'studentId': studentId,
      //   'studentName': studentName,
      //   'message': message,
      //   'adminType': adminType,
      //   'title': title,
      //   'timestamp': FieldValue.serverTimestamp(),
      //   'isRead': false,
      //   'type': 'student_to_admin',
      // });
    } catch (e) {
      print('🔔 채팅 알림 전송 오류: $e');
    }
  }

  // 관리자 메시지 수신 알림 전송 (관리자 → 학생)
  Future<void> sendAdminMessageNotification({
    required String studentId,
    required String studentName,
    required String message,
    required String adminName,
    required String adminType,
  }) async {
    print('🔔 관리자 메시지 알림 전송 시작');
    print('🔔 학생ID: $studentId, 학생이름: $studentName');
    print('🔔 관리자이름: $adminName, 관리자타입: $adminType');
    print('🔔 메시지: $message');

    try {
      // 관리자 타입에 따른 제목 설정
      String title = '';
      switch (adminType) {
        case 'director':
          title = '실장님';
          break;
        case 'supervisor':
          title = '사감님';
          break;
        case 'floor_manager':
          title = '층장님';
          break;
        case 'chatbot':
          title = 'AI 어시스턴트';
          break;
        default:
          title = '관리자';
      }

      // 알림 중복 방지 체크 (메시지 내용 기반)
      String notificationKey = 'admin_${studentId}_$adminType';
      if (!_shouldShowNotification(notificationKey, message)) {
        print('🔔 중복 알림 방지: $notificationKey - $message');
        return;
      }

      // 현재 채팅방 상태 확인
      bool isInChatRoom = await _checkIfInChatRoom(studentId, adminType);
      print('🔔 채팅방 상태 확인: $isInChatRoom');

      String payload = 'admin_chat_${studentId}_$adminType';
      print('🔔 알림 payload 생성: $payload (adminType: $adminType)');

      // 현재 채팅방에 있는지 확인하여 알림 표시 여부 결정
      if (!isInChatRoom) {
        // 채팅방에 있지 않을 때는 일반 알림 표시
        await showLocalNotification(
          title: '$title으로부터 메시지',
          body:
              message.length > 50 ? '${message.substring(0, 50)}...' : message,
          payload: payload,
        );
        print('🔔 관리자 메시지 알림 전송 완료 (채팅방 외부)');
      } else {
        // 현재 채팅방에 있을 때는 알림을 표시하지 않음
        print('🔔 현재 채팅방($title)에 있으므로 알림 표시하지 않음');
      }

      // 중요 알림만 Firestore에 저장 (선택적)
      // await _firestore.collection('notifications').add({
      //   'studentId': studentId,
      //   'studentName': studentName,
      //   'message': message,
      //   'adminType': adminType,
      //   'adminName': adminName,
      //   'title': title,
      //   'timestamp': FieldValue.serverTimestamp(),
      //   'isRead': false,
      //   'type': 'admin_to_student',
      // });
    } catch (e) {
      print('🔔 관리자 메시지 알림 전송 오류: $e');
    }
  }

  // 채팅방 상태 확인 메서드
  Future<bool> _checkIfInChatRoom(String studentId, String adminType) async {
    try {
      print('🔔 채팅방 상태 확인: 학생ID=$studentId, adminType=$adminType');
      print('🔔 현재 채팅방: 역할=$_currentChatRole, 학생ID=$_currentStudentId');

      // 현재 채팅방에 있는지 확인
      if (_currentChatRole != null && _currentStudentId != null) {
        // 현재 채팅방의 관리자 타입 확인
        String currentAdminType = _getAdminTypeFromRole(_currentChatRole!);
        print('🔔 현재 채팅방 adminType: $currentAdminType');

        // 같은 학생이고 같은 관리자 타입이면 현재 채팅방에 있음
        if (_currentStudentId == studentId && currentAdminType == adminType) {
          print('🔔 현재 채팅방에 있음: $adminType');
          return true;
        }
      }

      print('🔔 현재 채팅방에 없음: $adminType');
      return false;
    } catch (e) {
      print('🔔 채팅방 상태 확인 오류: $e');
      return false;
    }
  }

  // 역할을 관리자 타입으로 변환
  String _getAdminTypeFromRole(String role) {
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

  // 테스트용 알림 메서드
  Future<void> testNotification() async {
    print('🔔 테스트 알림 시작');
    try {
      await showLocalNotification(
        title: '테스트 알림',
        body: '알림 시스템이 정상 작동합니다!',
        payload: 'test_notification',
      );
      print('✅ 테스트 알림 전송 완료');
    } catch (e) {
      print('❌ 테스트 알림 오류: $e');
    }
  }

  // 메시지 알림 테스트 메서드
  Future<void> testMessageNotification() async {
    print('🔔 메시지 알림 테스트 시작');
    try {
      // 관리자 메시지 알림 테스트
      await sendAdminMessageNotification(
        studentId: 'test_student',
        studentName: '테스트 학생',
        message: '테스트 메시지입니다. 알림이 정상적으로 작동하는지 확인합니다.',
        adminName: '테스트 실장님',
        adminType: 'director',
      );

      // 잠시 대기
      await Future.delayed(Duration(seconds: 2));

      // 조용한 알림 테스트
      await showQuietNotification(
        title: '조용한 알림 테스트',
        body: '이 알림은 소리가 나지 않습니다.',
        payload: 'quiet_test_notification',
      );

      print('✅ 메시지 알림 테스트 완료');
    } catch (e) {
      print('❌ 메시지 알림 테스트 오류: $e');
    }
  }
}
