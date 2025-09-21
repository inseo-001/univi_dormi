import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'b_b_s_list_model.dart';
import '/services/bbs_service.dart';
export 'b_b_s_list_model.dart';

class BBSListWidget extends StatefulWidget {
  const BBSListWidget({super.key});

  static String routeName = 'BBSList';
  static String routePath = '/bBSList';

  @override
  State<BBSListWidget> createState() => _BBSListWidgetState();
}

class _BBSListWidgetState extends State<BBSListWidget> {
  late BBSListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final BBSService _bbsService = BBSService();
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = BBSListModel();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      print('=== 게시글 목록 로드 시작 ===');
      setState(() {
        _isLoading = true;
      });

      final posts = await _bbsService.getPosts();
      print('📊 로드된 게시글 수: ${posts.length}개');

      for (var post in posts) {
        print('📄 게시글: ${post['id']} - ${post['title']}');
      }

      setState(() {
        _posts = posts;
        _isLoading = false;
      });
      print('✅ 게시글 목록 로드 완료');
    } catch (e) {
      print('❌ 게시글 목록 로드 오류: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시글을 불러오는 중 오류가 발생했습니다: $e')),
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // 테스트 게시글 생성
  Future<void> _createTestPost() async {
    try {
      print('=== 테스트 게시글 생성 시작 ===');

      final postId = await _bbsService.createPost(
        title: '테스트 게시글입니다',
        content: '이것은 테스트용 게시글입니다.\n\n게시판 기능을 테스트하기 위해 생성되었습니다.\n\n댓글도 달아보세요!',
      );

      print('✅ 테스트 게시글 생성 완료: $postId');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('테스트 게시글이 생성되었습니다.')),
        );
        _loadPosts(); // 목록 새로고침
      }
    } catch (e) {
      print('❌ 테스트 게시글 생성 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('테스트 게시글 생성 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
          child: Column(
            children: [
              // 헤더
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: AlignmentDirectional(-0.91, -1.03),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 20.0),
                      child: FlutterFlowIconButton(
                        borderRadius: 9.0,
                        buttonSize: 28.5,
                        icon: Icon(
                          Icons.keyboard_backspace,
                          color: Colors.black,
                          size: 26.0,
                        ),
                        onPressed: () async {
                          context.safePop();
                        },
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-0.6, -1.02),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 0.0, 70.0, 0.0),
                          child: Text(
                            '게시판',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.58, -0.97),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 27.0, 0.0),
                          child: Text(
                            '커뮤니티 게시판',
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 10.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.71, -0.57),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              80.0, 5.0, 0.0, 0.0),
                          child: FlutterFlowIconButton(
                            buttonSize: 40.0,
                            icon: Icon(
                              Icons.refresh,
                              color: Color(0xFF0C62FD),
                              size: 20.0,
                            ),
                            onPressed: () async {
                              _loadPosts();
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.71, -0.57),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 5.0, 0.0, 0.0),
                          child: Container(
                            width: 80.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: Color(0xFF0C62FD),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: InkWell(
                              onTap: () async {
                                final result = await context
                                    .pushNamed(BBSWriteWidget.routeName);
                                if (result == true) {
                                  _loadPosts(); // 게시글 작성 후 목록 새로고침
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16.0,
                                  ),
                                  SizedBox(width: 4.0),
                                  Text(
                                    '글쓰기',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                          ),
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // 구분선
              Divider(
                thickness: 2.0,
                color: FlutterFlowTheme.of(context).alternate,
              ),

              // 게시글 목록
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0C62FD),
                        ),
                      )
                    : _posts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.article_outlined,
                                  size: 64.0,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  '아직 게시글이 없습니다',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  '첫 번째 게시글을 작성해보세요!',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        color: Colors.grey,
                                        fontSize: 12.0,
                                      ),
                                ),
                                SizedBox(height: 16.0),
                                ElevatedButton(
                                  onPressed: _createTestPost,
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
                                    '테스트 게시글 생성',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadPosts,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _posts.length,
                              itemBuilder: (context, index) {
                                final post = _posts[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      print('=== 게시글 클릭 ===');
                                      print('게시글 ID: ${post['id']}');
                                      print('게시글 제목: ${post['title']}');

                                      await _bbsService
                                          .incrementViewCount(post['id']);
                                      if (mounted) {
                                        print('상세보기 페이지로 이동 중...');
                                        final result = await context.pushNamed(
                                          BBSMainWidget.routeName,
                                          extra: <String, dynamic>{
                                            'postId': post['id'],
                                          },
                                        );
                                        print('상세보기에서 돌아옴: $result');
                                        // 상세보기에서 돌아올 때 목록 새로고침
                                        if (result == true) {
                                          _loadPosts();
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 12.0, 16.0, 12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  post['title'] ?? '',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        fontSize: 16.0,
                                                        color: Colors.black,
                                                      ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              if (post['imageUrl'] != null)
                                                Icon(
                                                  Icons.image,
                                                  size: 16.0,
                                                  color: Colors.grey,
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: 8.0),
                                          Row(
                                            children: [
                                              Text(
                                                post['userName'] ?? '',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          color:
                                                              Color(0xFF676767),
                                                          fontSize: 12.0,
                                                        ),
                                              ),
                                              SizedBox(width: 8.0),
                                              Text(
                                                _formatDate(post['createdAt']),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          color:
                                                              Color(0xFF676767),
                                                          fontSize: 12.0,
                                                        ),
                                              ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.visibility_outlined,
                                                    color: Color(0xFF676767),
                                                    size: 14.0,
                                                  ),
                                                  SizedBox(width: 4.0),
                                                  Text(
                                                    '${post['viewCount'] ?? 0}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          color:
                                                              Color(0xFF676767),
                                                          fontSize: 12.0,
                                                        ),
                                                  ),
                                                  SizedBox(width: 12.0),
                                                  Icon(
                                                    Icons.favorite_border,
                                                    color: Color(0xFF676767),
                                                    size: 14.0,
                                                  ),
                                                  SizedBox(width: 4.0),
                                                  Text(
                                                    '${post['likeCount'] ?? 0}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          color:
                                                              Color(0xFF676767),
                                                          fontSize: 12.0,
                                                        ),
                                                  ),
                                                  SizedBox(width: 12.0),
                                                  Icon(
                                                    Icons.chat_bubble_outline,
                                                    color: Color(0xFF676767),
                                                    size: 14.0,
                                                  ),
                                                  SizedBox(width: 4.0),
                                                  Text(
                                                    '${post['commentCount'] ?? 0}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          color:
                                                              Color(0xFF676767),
                                                          fontSize: 12.0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
