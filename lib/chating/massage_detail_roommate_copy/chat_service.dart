import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotService {
  static final ChatbotService _instance = ChatbotService._internal();
  factory ChatbotService() => _instance;
  ChatbotService._internal();

  // Google Generative AI 설정
  // Google AI Studio에서 발급받은 API 키
  static const String _apiKey = 'AIzaSyAaxD1lJzEsTEXVL-9Opd5YPZZSkmH_rsE';
  static const String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  // 모델 상태
  bool _isModelReady = false;

  // 언어 감지 함수
  String _detectLanguage(String text) {
    if (RegExp(r'[가-힣]').hasMatch(text)) {
      return 'ko';
    }
    if (RegExp(r'[a-zA-Z]').hasMatch(text)) {
      return 'en';
    }
    return 'ko';
  }

  // Google Generative AI와 대화하는 메서드
  Future<String> chatWithAI(
      String userMessage,
      List<Map<String, dynamic>> chatHistory,
      ) async {
    try {
      // 시스템 프롬프트 생성
      String systemPrompt = _createSystemPrompt(userMessage);

      // Google Generative AI API 호출
      final response =
      await _callGoogleGenerativeAI(userMessage, systemPrompt, chatHistory);
      return response;
    } catch (e) {
      return _getHardcodedResponse(userMessage);
    }
  }

  // 시스템 프롬프트 생성
  String _createSystemPrompt(String userMessage) {
    String language = _detectLanguage(userMessage);

    if (language == 'en') {
      return '''You are a helpful AI assistant for Shinhan University dormitory. 

**IMPORTANT: You can ONLY answer questions about Shinhan University dormitory. For any other questions, politely redirect to dormitory-related topics.**

**Shinhan University Dormitory Information:**
- Dormitories: Carmel 1 Building (Uijeongbu Campus), Carmel 2 Building, Carmel 3 Building (Dongducheon Campus)
- Contact: Carmel 1 Building 031-837-2700, Carmel 3 Building 031-838-7788
- Address: Carmel 1 Building - 95 Hoam-ro, Hoewon-dong, Uijeongbu-si, Gyeonggi-do, Carmel 3 Building - 30 Beolma-deul-ro 40-gil, Sangpae-dong, Dongducheon-si
- Website: www.shinhandorm.ac.kr

**Instructions:**
1. Answer naturally and helpfully in English
2. ONLY provide information about Shinhan University dormitory
3. If asked about other universities or general dormitory questions, redirect to Shinhan University dormitory
4. Be conversational and friendly
5. Always mention "Shinhan University" when talking about dormitories

Please answer the following question:''';
    } else {
      return '''당신은 신한대학교 기숙사를 위한 도움이 되는 AI 어시스턴트입니다.

**중요: 신한대학교 기숙사 관련 질문만 답변할 수 있습니다. 다른 질문은 기숙사 관련 주제로 정중하게 안내해주세요.**

**신한대학교 기숙사 정보:**
- 기숙사: 카르멜 1관(의정부캠퍼스), 카르멜 2관, 카르멜 3관(동두천캠퍼스)
- 연락처: 카르멜 1관 031-837-2700, 카르멜 3관 031-838-7788
- 주소: 카르멜 1관 - 경기도 의정부시 호암로 95(호원동), 카르멜 3관 - 경기도 동두천시 벌마들로 40번길 30(상패동)
- 홈페이지: www.shinhandorm.ac.kr

**지시사항:**
1. 자연스럽고 도움이 되게 한국어로 답변
2. 신한대학교 기숙사 정보만 제공
3. 다른 대학이나 일반적인 기숙사 질문은 신한대학교 기숙사로 안내
4. 대화하듯이 친근하게 답변
5. 기숙사에 대해 언급할 때 항상 "신한대학교"를 포함

다음 질문에 답변해주세요:''';
    }
  }

  // Google Generative AI API 호출
  Future<String> _callGoogleGenerativeAI(String userMessage,
      String systemPrompt, List<Map<String, dynamic>> chatHistory) async {
    try {
      // 전체 프롬프트 구성
      String fullPrompt = '$systemPrompt\n\n질문: $userMessage\n\n답변:';

      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": fullPrompt}
            ]
          }
        ]
      };

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': _apiKey,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          if (candidate['content'] != null &&
              candidate['content']['parts'] != null) {
            final generatedText =
                candidate['content']['parts'][0]['text'] ?? '';
            return generatedText.isNotEmpty
                ? generatedText
                : _getHardcodedResponse(userMessage);
          }
        }

        return _getHardcodedResponse(userMessage);
      } else {
        return _getHardcodedResponse(userMessage);
      }
    } catch (e) {
      return _getHardcodedResponse(userMessage);
    }
  }

  // 기숙사 관련 질문인지 판단
  bool _isDormitoryRelated(String message) {
    String lowerMessage = message.toLowerCase();
    return lowerMessage.contains('기숙사') ||
        lowerMessage.contains('숙소') ||
        lowerMessage.contains('dormitory') ||
        lowerMessage.contains('dorm') ||
        lowerMessage.contains('카르멜') ||
        lowerMessage.contains('carmel') ||
        lowerMessage.contains('입사') ||
        lowerMessage.contains('퇴사') ||
        lowerMessage.contains('외박') ||
        lowerMessage.contains('생활') ||
        lowerMessage.contains('규칙') ||
        lowerMessage.contains('연락') ||
        lowerMessage.contains('전화') ||
        lowerMessage.contains('주소') ||
        lowerMessage.contains('위치') ||
        lowerMessage.contains('공지') ||
        lowerMessage.contains('기숙사비') ||
        lowerMessage.contains('비용') ||
        lowerMessage.contains('where') ||
        lowerMessage.contains('where\'s') ||
        lowerMessage.contains('where is') ||
        lowerMessage.contains('night out') ||
        lowerMessage.contains('apply');
  }

  // 하드코딩된 응답 (다국어 지원)
  String _getHardcodedResponse(String userMessage) {
    String message = userMessage.toLowerCase();
    String language = _detectLanguage(userMessage);

    // 인사말 패턴
    if (message.contains('안녕') ||
        message.contains('hello') ||
        message.contains('hi')) {
      if (language == 'en') {
        return 'Hello! I am the Shinhan University dormitory AI assistant. I can help you with dormitory-related inquiries.';
      } else {
        return '안녕하세요! 신한대학교 기숙사 AI 어시스턴트입니다. 기숙사 관련 문의사항을 도와드리겠습니다.';
      }
    }

    // 기숙사 관련 질문 (정확한 정보 제공)
    if (message.contains('기숙사') ||
        message.contains('숙소') ||
        message.contains('dormitory') ||
        message.contains('dorm')) {
      if (language == 'en') {
        return 'Shinhan University dormitories are located at: Carmel 1 Building (Uijeongbu Campus), Carmel 2 Building, and Carmel 3 Building (Dongducheon Campus). Contact: Carmel 1 Building 031-837-2700, Carmel 3 Building 031-838-7788';
      } else {
        return '신한대학교 기숙사는 카르멜 1관(의정부캠퍼스), 카르멜 2관, 카르멜 3관(동두천캠퍼스)에 있습니다. 연락처: 카르멜 1관 031-837-2700, 카르멜 3관 031-838-7788';
      }
    }

    // 외박신청 관련 질문
    if (message.contains('외박') ||
        message.contains('night out') ||
        message.contains('apply')) {
      if (language == 'en') {
        return 'For overnight leave application, please visit the dormitory homepage (www.shinhandorm.ac.kr) and go to the community section. You can apply for overnight leave there.';
      } else {
        return '외박신청은 기숙사 홈페이지(www.shinhandorm.ac.kr)의 커뮤니티 섹션에서 가능합니다.';
      }
    }

    // 생활 관련 질문
    if (message.contains('생활') ||
        message.contains('규칙') ||
        message.contains('규정') ||
        message.contains('rule') ||
        message.contains('regulation')) {
      return '기숙사 생활 규칙은 각 층에 게시되어 있습니다. 자세한 내용은 층장님께 문의해주세요.';
    }

    // 긴급 상황
    if (message.contains('긴급') ||
        message.contains('응급') ||
        message.contains('사고') ||
        message.contains('emergency') ||
        message.contains('urgent')) {
      return '긴급한 상황이시군요. 즉시 실장님(010-1234-5678) 또는 사감님(010-9876-5432)께 연락해주세요.';
    }

    // 도움 요청
    if (message.contains('도움') ||
        message.contains('help') ||
        message.contains('어떻게')) {
      return '도움이 필요하시군요. 구체적인 내용을 말씀해주시면 더 정확한 안내를 드릴 수 있습니다.';
    }

    // 감정 표현
    if (message.contains('좋아') ||
        message.contains('싫어') ||
        message.contains('화나') ||
        message.contains('good') ||
        message.contains('bad') ||
        message.contains('angry')) {
      return '감정을 표현해주셔서 감사합니다. 더 구체적으로 말씀해주시면 도움을 드릴 수 있습니다.';
    }

    // 기숙사 관련이 아닌 질문에 대한 응답
    if (language == 'en') {
      return 'I can only answer Shinhan University dormitory related inquiries. Please ask dormitory-related questions.';
    } else {
      return '저는 신한대학교 기숙사 관련 문의사항만 답변할 수 있습니다. 기숙사 관련 질문을 해주세요.';
    }
  }
}
