const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// 새 메시지가 추가될 때 알림을 보내는 함수
exports.sendChatNotification = functions.firestore
  .document('chats/{chatId}/messages/{messageId}')
  .onCreate(async (snap, context) => {
    try {
      const messageData = snap.data();
      const chatId = context.params.chatId;
      
      console.log('새 메시지 알림 전송 시작:', messageData);
      
      // 채팅방 정보 가져오기
      const chatDoc = await admin.firestore()
        .collection('chats')
        .doc(chatId)
        .get();
      
      if (!chatDoc.exists) {
        console.log('채팅방 정보를 찾을 수 없습니다:', chatId);
        return null;
      }
      
      const chatData = chatDoc.data();
      const studentId = chatData.studentId;
      const adminType = chatData.adminType;
      
      // 관리자 타입에 따른 제목 설정
      let title = '';
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
      
      // 메시지 내용 (50자로 제한)
      const messageText = messageData.text.length > 50 
        ? messageData.text.substring(0, 50) + '...' 
        : messageData.text;
      
      // 학생이 보낸 메시지인 경우 (관리자에게 알림)
      if (messageData.senderId === 'student') {
        const notificationData = {
          studentId: studentId,
          studentName: chatData.studentName || '학생',
          message: messageData.text,
          adminType: adminType,
          title: title,
        };
        
        // 관리자들에게 FCM 푸시 알림 전송 (Firestore 저장 없이)
        await sendPushNotificationToAdmins(notificationData);
        
        console.log('학생 메시지 알림 전송 완료');
      }
      
      // 관리자가 보낸 메시지인 경우 (AI 어시스턴트 제외)
      if (messageData.senderId === 'admin' && messageData.senderName !== 'AI 어시스턴트') {
        const notificationData = {
          studentId: studentId,
          studentName: chatData.studentName || '학생',
          message: messageData.text,
          adminType: adminType,
          adminName: messageData.senderName || '관리자',
          title: title,
        };
        
        // 학생에게 FCM 푸시 알림 전송 (Firestore 저장 없이)
        await sendPushNotificationToStudent(notificationData);
        
        console.log('관리자 메시지 알림 전송 완료');
      }
      
      return null;
    } catch (error) {
      console.error('알림 전송 오류:', error);
      return null;
    }
  });

// 관리자들에게 푸시 알림 전송
async function sendPushNotificationToAdmins(notificationData) {
  try {
    // 관리자들의 FCM 토큰을 가져오기
    const adminTokensSnapshot = await admin.firestore()
      .collection('admin_tokens')
      .where('adminType', '==', notificationData.adminType)
      .get();
    
    if (adminTokensSnapshot.empty) {
      console.log('해당 관리자 타입의 FCM 토큰이 없습니다:', notificationData.adminType);
      return;
    }
    
    const tokens = adminTokensSnapshot.docs.map(doc => doc.data().fcmToken);
    
    // 알림 메시지 구성
    const message = {
      notification: {
        title: `${notificationData.title}에게 새 메시지`,
        body: `${notificationData.studentName}: ${notificationData.message}`,
      },
      data: {
        chatId: `chat_${notificationData.studentId}_${notificationData.adminType}`,
        studentId: notificationData.studentId,
        adminType: notificationData.adminType,
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
      },
      tokens: tokens,
    };
    
    // FCM으로 알림 전송
    const response = await admin.messaging().sendMulticast(message);
    
    console.log('관리자 푸시 알림 전송 완료:', response.successCount, '성공,', response.failureCount, '실패');
    
    // 실패한 토큰들 처리
    if (response.failureCount > 0) {
      const failedTokens = [];
      response.responses.forEach((resp, idx) => {
        if (!resp.success) {
          failedTokens.push(tokens[idx]);
        }
      });
      
      // 실패한 토큰들 삭제
      for (const token of failedTokens) {
        const tokenDoc = await admin.firestore()
          .collection('admin_tokens')
          .where('fcmToken', '==', token)
          .get();
        
        if (!tokenDoc.empty) {
          await tokenDoc.docs[0].ref.delete();
          console.log('실패한 토큰 삭제:', token);
        }
      }
    }
  } catch (error) {
    console.error('관리자 푸시 알림 전송 오류:', error);
  }
}

// 학생에게 푸시 알림 전송
async function sendPushNotificationToStudent(notificationData) {
  try {
    // 학생의 FCM 토큰을 가져오기
    const studentDoc = await admin.firestore()
      .collection('users')
      .doc(notificationData.studentId)
      .get();
    
    if (!studentDoc.exists) {
      console.log('학생 정보를 찾을 수 없습니다:', notificationData.studentId);
      return;
    }
    
    const studentData = studentDoc.data();
    const fcmToken = studentData.fcmToken;
    
    if (!fcmToken) {
      console.log('학생의 FCM 토큰이 없습니다:', notificationData.studentId);
      return;
    }
    
    // 알림 메시지 구성
    const message = {
      notification: {
        title: `${notificationData.title}으로부터 메시지`,
        body: `${notificationData.message}`,
      },
      data: {
        chatId: `chat_${notificationData.studentId}_${notificationData.adminType}`,
        studentId: notificationData.studentId,
        adminType: notificationData.adminType,
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
      },
      token: fcmToken,
    };
    
    // FCM으로 알림 전송
    const response = await admin.messaging().send(message);
    
    console.log('학생 푸시 알림 전송 완료:', response);
    
  } catch (error) {
    console.error('학생 푸시 알림 전송 오류:', error);
  }
}

// 관리자 FCM 토큰 등록 함수
exports.registerAdminToken = functions.https.onCall(async (data, context) => {
  try {
    const { fcmToken, adminType, adminId } = data;
    
    if (!fcmToken || !adminType || !adminId) {
      throw new functions.https.HttpsError('invalid-argument', '필수 파라미터가 누락되었습니다.');
    }
    
    // 관리자 토큰 저장
    await admin.firestore()
      .collection('admin_tokens')
      .doc(adminId)
      .set({
        fcmToken: fcmToken,
        adminType: adminType,
        adminId: adminId,
        lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
      });
    
    console.log('관리자 FCM 토큰 등록 완료:', adminId);
    
    return { success: true };
  } catch (error) {
    console.error('관리자 토큰 등록 오류:', error);
    throw new functions.https.HttpsError('internal', '토큰 등록에 실패했습니다.');
  }
});

// 알림 읽음 처리 함수
exports.markNotificationAsRead = functions.https.onCall(async (data, context) => {
  try {
    const { notificationId } = data;
    
    if (!notificationId) {
      throw new functions.https.HttpsError('invalid-argument', '알림 ID가 누락되었습니다.');
    }
    
    // 알림을 읽음으로 표시
    await admin.firestore()
      .collection('notifications')
      .doc(notificationId)
      .update({
        isRead: true,
        readAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    
    console.log('알림 읽음 처리 완료:', notificationId);
    
    return { success: true };
  } catch (error) {
    console.error('알림 읽음 처리 오류:', error);
    throw new functions.https.HttpsError('internal', '알림 읽음 처리에 실패했습니다.');
  }
});
