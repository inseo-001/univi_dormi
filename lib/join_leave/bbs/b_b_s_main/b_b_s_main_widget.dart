import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'b_b_s_main_model.dart';
import '/services/bbs_service.dart';
export 'b_b_s_main_model.dart';

class BBSMainWidget extends StatefulWidget {
  const BBSMainWidget({super.key});

  static String routeName = 'BBSMain';
  static String routePath = '/bBSMain';

  @override
  State<BBSMainWidget> createState() => _BBSMainWidgetState();
}

class _BBSMainWidgetState extends State<BBSMainWidget> {
  late BBSMainModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final BBSService _bbsService = BBSService();

  // 게시글 데이터
  Map<String, dynamic>? _post;
  List<Map<String, dynamic>> _comments = [];
  bool _isLoading = true;
  bool _isSubmittingComment = false;
  final TextEditingController _commentController = TextEditingController();

  // 좋아요 관련 상태
  bool _isLiked = false;
  bool _isTogglingLike = false;

  // 오류 처리 상태
  String? _errorMessage;
  bool _hasError = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _model = BBSMainModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_post == null) {
      _loadPostData();
    }
  }

  @override
  void dispose() {
    _model.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // 게시글 데이터 로드
  Future<void> _loadPostData() async {
    try {
      // 오류 상태 초기화
      setState(() {
        _hasError = false;
        _errorMessage = null;
        _isLoading = true;
      });

      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final postId = extra?['postId'] as String?;

      // 게시글 ID 유효성 검증
      if (postId == null || postId.isEmpty) {
        _handleError('게시글 ID가 전달되지 않았습니다.');
        return;
      }

      // 게시글 데이터 로드
      final post = await _bbsService.getPost(postId);

      // 게시글 데이터 유효성 검증
      if (post == null) {
        _handleError('게시글을 찾을 수 없습니다.');
        return;
      }

      // 필수 필드 검증
      if (!_validatePostData(post)) {
        _handleError('게시글 데이터가 올바르지 않습니다.');
        return;
      }

      // 상세보기 진입 시 조회수 증가
      try {
        await _bbsService.incrementViewCount(postId);
        post['viewCount'] = (post['viewCount'] ?? 0) + 1;
        print('조회수 증가 완료');
      } catch (viewError) {
        print('조회수 증가 실패: $viewError');
        // 조회수 증가 실패는 게시글 표시를 막지 않음
      }

      // 사용자의 좋아요 상태 확인
      bool isLiked = false;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          isLiked = await _bbsService.isLiked(postId, user.uid);
          print('좋아요 상태 확인: $isLiked');
        } catch (likeError) {
          print('좋아요 상태 확인 실패: $likeError');
          // 좋아요 상태 확인 실패는 게시글 표시를 막지 않음
        }
      }

      // 댓글 데이터 로드 (실패해도 게시글은 표시)
      List<Map<String, dynamic>> comments = [];
      try {
        comments = await _bbsService.getComments(postId);
      } catch (commentError) {
        print('댓글 로드 실패: $commentError');
        // 댓글 로드 실패는 게시글 표시를 막지 않음
      }

      setState(() {
        _post = post;
        _comments = comments;
        _isLiked = isLiked;
        _isLoading = false;
        _hasError = false;
        _errorMessage = null;
        _retryCount = 0; // 성공 시 재시도 카운트 리셋
      });
    } catch (e) {
      _handleError(_getErrorMessage(e));
    }
  }

  // 게시글 데이터 유효성 검증
  bool _validatePostData(Map<String, dynamic> post) {
    try {
      // 필수 필드 확인
      if (post['id'] == null || post['title'] == null) {
        return false;
      }

      // 제목 길이 확인
      if (post['title'].toString().isEmpty) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // 오류 처리
  void _handleError(String message) {
    setState(() {
      _isLoading = false;
      _hasError = true;
      _errorMessage = message;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[600],
          action: _retryCount < _maxRetries
              ? SnackBarAction(
                  label: '재시도',
                  textColor: Colors.white,
                  onPressed: _retryLoadData,
                )
              : null,
        ),
      );
    }
  }

  // 재시도 로직
  Future<void> _retryLoadData() async {
    if (_retryCount >= _maxRetries) return;

    setState(() {
      _retryCount++;
    });

    await _loadPostData();
  }

  // 오류 메시지 생성
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException') ||
        error.toString().contains('NetworkException')) {
      return '네트워크 연결을 확인해주세요.';
    } else if (error.toString().contains('TimeoutException')) {
      return '요청 시간이 초과되었습니다. 다시 시도해주세요.';
    } else if (error.toString().contains('FormatException')) {
      return '데이터 형식이 올바르지 않습니다.';
    } else if (error.toString().contains('Permission denied')) {
      return '권한이 없습니다.';
    } else {
      return '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.';
    }
  }

  // 댓글 작성
  Future<void> _submitComment() async {
    final content = _commentController.text.trim();

    // 댓글 내용 유효성 검증
    if (content.isEmpty) {
      _showErrorSnackBar('댓글 내용을 입력해주세요.');
      return;
    }

    if (content.length > 500) {
      _showErrorSnackBar('댓글은 500자 이하로 작성해주세요.');
      return;
    }

    if (_post == null) {
      _showErrorSnackBar('게시글 정보가 없습니다.');
      return;
    }

    setState(() {
      _isSubmittingComment = true;
    });

    try {
      await _bbsService.addComment(
        postId: _post!['id'],
        content: content,
      );

      _commentController.clear();
      await _loadPostData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('댓글이 작성되었습니다.'),
            backgroundColor: Colors.green[600],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getCommentErrorMessage(e)),
            backgroundColor: Colors.red[600],
            action: SnackBarAction(
              label: '재시도',
              textColor: Colors.white,
              onPressed: _submitComment,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingComment = false;
        });
      }
    }
  }

  // 댓글 오류 메시지 생성
  String _getCommentErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException') ||
        error.toString().contains('NetworkException')) {
      return '네트워크 연결을 확인해주세요.';
    } else if (error.toString().contains('TimeoutException')) {
      return '요청 시간이 초과되었습니다.';
    } else if (error.toString().contains('Permission denied')) {
      return '댓글 작성 권한이 없습니다.';
    } else if (error.toString().contains('Invalid content')) {
      return '댓글 내용이 올바르지 않습니다.';
    } else {
      return '댓글 작성 중 오류가 발생했습니다.';
    }
  }

  // 오류 스낵바 표시
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  // 좋아요 토글
  Future<void> _toggleLike() async {
    if (_post == null || _isTogglingLike) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showErrorSnackBar('로그인이 필요합니다.');
      return;
    }

    setState(() {
      _isTogglingLike = true;
    });

    try {
      await _bbsService.toggleLike(_post!['id'], user.uid);

      setState(() {
        _isLiked = !_isLiked;
        if (_isLiked) {
          _post!['likeCount'] = (_post!['likeCount'] ?? 0) + 1;
        } else {
          _post!['likeCount'] = (_post!['likeCount'] ?? 0) - 1;
          if (_post!['likeCount'] < 0) _post!['likeCount'] = 0;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isLiked ? '좋아요를 눌렀습니다.' : '좋아요를 취소했습니다.'),
            backgroundColor: Colors.green[600],
            duration: Duration(milliseconds: 1500),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('좋아요 처리 중 오류가 발생했습니다.'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTogglingLike = false;
        });
      }
    }
  }

  // 날짜 포맷팅
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${date.month}/${date.day}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  // 게시글 작성자인지 확인
  bool _isPostAuthor() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _post == null) return false;
    return _post!['userId'] == user.uid;
  }

  // 게시글 메뉴 표시
  void _showPostMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.0,
              height: 4.0,
              margin: EdgeInsets.only(top: 12.0, bottom: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            if (_isPostAuthor()) ...[
              // 본인 글일 때 - 삭제하기
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Colors.red[600],
                ),
                title: Text(
                  '삭제하기',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmDialog();
                },
              ),
            ] else ...[
              // 남의 글일 때 - 신고하기
              ListTile(
                leading: Icon(
                  Icons.report_outlined,
                  color: Colors.orange[600],
                ),
                title: Text(
                  '신고하기',
                  style: TextStyle(
                    color: Colors.orange[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog();
                },
              ),
            ],
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  // 삭제 확인 다이얼로그
  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          '게시글 삭제',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
          ),
        ),
        content: Text(
          '정말로 이 게시글을 삭제하시겠습니까?\n삭제된 게시글은 복구할 수 없습니다.',
          style: TextStyle(fontSize: 15.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePost();
            },
            child: Text(
              '삭제',
              style: TextStyle(
                color: Colors.red[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 게시글 삭제
  Future<void> _deletePost() async {
    if (_post == null) return;

    try {
      await _bbsService.deletePost(_post!['id']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('게시글이 삭제되었습니다.'),
            backgroundColor: Colors.green[600],
          ),
        );
        context.pop(true); // 게시글 목록으로 돌아가기
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('게시글 삭제 중 오류가 발생했습니다.'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

  // 신고 다이얼로그
  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          '게시글 신고',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
          ),
        ),
        content: Text(
          '이 게시글을 신고하시겠습니까?\n신고된 게시글은 검토 후 조치됩니다.',
          style: TextStyle(fontSize: 15.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reportPost();
            },
            child: Text(
              '신고',
              style: TextStyle(
                color: Colors.orange[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 게시글 신고
  Future<void> _reportPost() async {
    if (_post == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showErrorSnackBar('로그인이 필요합니다.');
      return;
    }

    try {
      await _bbsService.reportPost(_post!['id'], user.uid);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('게시글이 신고되었습니다. 검토 후 조치하겠습니다.'),
            backgroundColor: Colors.green[600],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('신고 처리 중 오류가 발생했습니다.'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

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
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFF0C62FD),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        '게시글을 불러오는 중...',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                            ),
                      ),
                    ],
                  ),
                )
              : _hasError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.0,
                            color: Colors.red[400],
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            _errorMessage ?? '오류가 발생했습니다',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  color: Colors.red[600],
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24.0),
                          if (_retryCount < _maxRetries)
                            ElevatedButton(
                              onPressed: _retryLoadData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0C62FD),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 12.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: Text(
                                '다시 시도',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          SizedBox(height: 8.0),
                          Text(
                            '재시도 횟수: $_retryCount/$_maxRetries',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _post == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.article_outlined,
                                size: 64.0,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                '게시글을 찾을 수 없습니다',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      color: Colors.grey[600],
                                      fontSize: 16.0,
                                    ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '게시글이 삭제되었거나 존재하지 않습니다',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            // 헤더
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  FlutterFlowIconButton(
                                    borderRadius: 20.0,
                                    buttonSize: 40.0,
                                    icon: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.black,
                                      size: 20.0,
                                    ),
                                    onPressed: () async {
                                      context.pop(true);
                                    },
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      '게시글 상세보기',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                            ),
                                            fontSize: 18.0,
                                            color: Colors.black,
                                          ),
                                    ),
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 20.0,
                                    buttonSize: 40.0,
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.grey[600],
                                      size: 20.0,
                                    ),
                                    onPressed: () {
                                      _showPostMenu(context);
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // 게시글 내용
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 게시글 헤더
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.03),
                                            blurRadius: 12.0,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // 작성자 정보 및 통계 (첫 번째)
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 20.0,
                                                backgroundColor:
                                                    Color(0xFF0C62FD),
                                                child: Text(
                                                  (_post!['userName'] ?? 'U')[0]
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 12.0),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _post!['userName'] ?? '',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            fontSize: 15.0,
                                                            color: Colors.black,
                                                          ),
                                                    ),
                                                    Text(
                                                      _formatDate(
                                                          _post!['createdAt']),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontSize: 13.0,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  _buildStatItem(
                                                    Icons.visibility_outlined,
                                                    '${_post!['viewCount'] ?? 0}',
                                                  ),
                                                  SizedBox(width: 16.0),
                                                  _buildLikeButton(),
                                                  SizedBox(width: 16.0),
                                                  _buildStatItem(
                                                    Icons.chat_bubble_outline,
                                                    '${_comments.length}',
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 16.0),

                                          // 제목 (두 번째)
                                          Text(
                                            _post!['title'] ?? '',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  fontSize: 22.0,
                                                  color: Colors.black,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 20.0),

                                    // 게시글 내용
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.03),
                                            blurRadius: 12.0,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        _post!['content'] ?? '',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontSize: 16.0,
                                              color: Colors.black87,
                                            ),
                                      ),
                                    ),

                                    SizedBox(height: 24.0),

                                    // 댓글 섹션
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.03),
                                            blurRadius: 12.0,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.chat_bubble_outline,
                                                color: Color(0xFF0C62FD),
                                                size: 22.0,
                                              ),
                                              SizedBox(width: 8.0),
                                              Text(
                                                '댓글 ${_comments.length}개',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          fontSize: 18.0,
                                                          color: Colors.black,
                                                        ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 20.0),

                                          // 댓글 입력
                                          Container(
                                            padding: EdgeInsets.all(16.0),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[50],
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                color: Colors.grey[200]!,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller:
                                                      _commentController,
                                                  maxLines: 3,
                                                  maxLength: 500,
                                                  decoration: InputDecoration(
                                                    hintText: '댓글을 입력하세요...',
                                                    hintStyle: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontSize: 15.0,
                                                    ),
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    counterText:
                                                        '', // 글자 수 표시 숨김
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black,
                                                  ),
                                                  onChanged: (value) {
                                                    // 실시간 글자 수 검증
                                                    if (value.length > 500) {
                                                      _commentController.text =
                                                          value.substring(
                                                              0, 500);
                                                      _commentController
                                                              .selection =
                                                          TextSelection
                                                              .fromPosition(
                                                        TextPosition(
                                                            offset: 500),
                                                      );
                                                    }
                                                  },
                                                ),
                                                SizedBox(height: 12.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed:
                                                          _isSubmittingComment
                                                              ? null
                                                              : _submitComment,
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color(0xFF0C62FD),
                                                        foregroundColor:
                                                            Colors.white,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 24.0,
                                                          vertical: 10.0,
                                                        ),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        elevation: 0,
                                                      ),
                                                      child:
                                                          _isSubmittingComment
                                                              ? SizedBox(
                                                                  width: 16.0,
                                                                  height: 16.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2.0,
                                                                    valueColor: AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                                  ),
                                                                )
                                                              : Text(
                                                                  '댓글 작성',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(height: 20.0),

                                          // 댓글 목록
                                          if (_comments.isEmpty)
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 40.0),
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.chat_bubble_outline,
                                                    size: 48.0,
                                                    color: Colors.grey[400],
                                                  ),
                                                  SizedBox(height: 12.0),
                                                  Text(
                                                    '아직 댓글이 없습니다',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.0),
                                                  Text(
                                                    '첫 번째 댓글을 작성해보세요!',
                                                    style: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontSize: 13.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          else
                                            ..._comments.map((comment) =>
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 16.0),
                                                  padding: EdgeInsets.all(16.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    border: Border.all(
                                                      color: Colors.grey[100]!,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 14.0,
                                                            backgroundColor:
                                                                Color(
                                                                    0xFF0C62FD),
                                                            child: Text(
                                                              (comment['userName'] ??
                                                                      'U')[0]
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 11.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10.0),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  comment['userName'] ??
                                                                      '',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  _formatDate(
                                                                      comment[
                                                                          'createdAt']),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11.0,
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .favorite_border,
                                                            color: Colors
                                                                .grey[400],
                                                            size: 16.0,
                                                          ),
                                                          SizedBox(width: 4.0),
                                                          Text(
                                                            '${comment['likeCount'] ?? 0}',
                                                            style: TextStyle(
                                                              fontSize: 12.0,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10.0),
                                                      Text(
                                                        comment['content'] ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 100.0), // 하단 여백
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
          size: 16.0,
        ),
        SizedBox(width: 4.0),
        Text(
          count,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLikeButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: _isLiked ? Colors.red[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: _isLiked ? Colors.red[200]! : Colors.grey[200]!,
          width: 1.0,
        ),
      ),
      child: GestureDetector(
        onTap: _isTogglingLike ? null : _toggleLike,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _isTogglingLike
                ? SizedBox(
                    width: 16.0,
                    height: 16.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isLiked ? Colors.red[400]! : Colors.grey[600]!,
                      ),
                    ),
                  )
                : Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? Colors.red[500] : Colors.grey[600],
                    size: 18.0,
                  ),
            SizedBox(width: 6.0),
            Text(
              '${_post?['likeCount'] ?? 0}',
              style: TextStyle(
                color: _isLiked ? Colors.red[600] : Colors.grey[600],
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
