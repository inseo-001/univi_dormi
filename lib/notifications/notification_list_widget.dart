import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

class NotificationListWidget extends StatefulWidget {
  const NotificationListWidget({super.key});

  @override
  State<NotificationListWidget> createState() => _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<NotificationListWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
          '알림',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    '알림을 불러오는데 실패했습니다.',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    '새로운 알림이 없습니다',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Outfit',
                          color: Colors.grey[600],
                          fontSize: 16.0,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final isRead = data['isRead'] ?? false;
              final title = data['title'] ?? '관리자';
              final studentName = data['studentName'] ?? '학생';
              final message = data['message'] ?? '';
              final timestamp = data['timestamp'] as Timestamp?;

              String timeAgo = '';
              if (timestamp != null) {
                final now = DateTime.now();
                final messageTime = timestamp.toDate();
                final difference = now.difference(messageTime);

                if (difference.inDays > 0) {
                  timeAgo = '${difference.inDays}일 전';
                } else if (difference.inHours > 0) {
                  timeAgo = '${difference.inHours}시간 전';
                } else if (difference.inMinutes > 0) {
                  timeAgo = '${difference.inMinutes}분 전';
                } else {
                  timeAgo = '방금 전';
                }
              }

              return Container(
                margin: EdgeInsets.only(bottom: 12.0),
                decoration: BoxDecoration(
                  color: isRead ? Colors.grey[50] : Colors.blue[50],
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: isRead ? Colors.grey[200]! : Colors.blue[200]!,
                    width: 1.0,
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: isRead ? Colors.grey[300] : Colors.blue[100],
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Icon(
                      Icons.message,
                      color: isRead ? Colors.grey[600] : Colors.blue[600],
                      size: 24.0,
                    ),
                  ),
                  title: Text(
                    '$title에게 메시지',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Outfit',
                          color: isRead ? Colors.grey[700] : Colors.black,
                          fontWeight:
                              isRead ? FontWeight.normal : FontWeight.w600,
                        ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.0),
                      Text(
                        '$studentName: ${message.length > 50 ? '${message.substring(0, 50)}...' : message}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Outfit',
                              color: Colors.grey[600],
                            ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        timeAgo,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Outfit',
                              color: Colors.grey[500],
                              fontSize: 12.0,
                            ),
                      ),
                    ],
                  ),
                  trailing: isRead
                      ? null
                      : Container(
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                  onTap: () {
                    // 알림 클릭 시 읽음 처리
                    _markAsRead(doc.id);

                    // 채팅 화면으로 이동
                    _navigateToChat(data);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 알림을 읽음으로 표시
  Future<void> _markAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('알림 읽음 처리 오류: $e');
    }
  }

  // 채팅 화면으로 이동
  void _navigateToChat(Map<String, dynamic> notificationData) {
    final studentId = notificationData['studentId'] ?? '';
    final adminType = notificationData['adminType'] ?? '';

    // 관리자 타입에 따른 역할 매핑
    String role = '';
    switch (adminType) {
      case 'director':
        role = '실장님';
        break;
      case 'supervisor':
        role = '사감님';
        break;
      case 'floor_manager':
        role = '층장';
        break;
      default:
        role = '관리자';
    }

    // 채팅 화면으로 이동
    context.pushNamed(
      'massageDetailRoommateCopy',
      queryParameters: {'role': role},
    );
  }
}
