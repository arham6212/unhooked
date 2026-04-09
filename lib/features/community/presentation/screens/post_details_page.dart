import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';
import '../widgets/post_card_widget.dart';
import '../../../../core/theme/app_colors.dart';

class PostDetailsPage extends StatefulWidget {
  final String postId;
  final Post? post;

  const PostDetailsPage({super.key, required this.postId, this.post});

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  // Mocking replies to instantly match the visual design goal
  late final List<Post> _mockReplies;

  @override
  void initState() {
    super.initState();
    _mockReplies = [
      Post(
        id: 'reply1',
        userId: 'user_a',
        body: 'Keep going! Every single day makes you stronger. 💪',
        likesCount: 12,
        commentsCount: 0,
        createdAt: DateTime.now().subtract(const Duration(minutes: 42)),
      ),
      Post(
        id: 'reply2',
        userId: 'user_b',
        body: 'I relate to this so much man, staying strong with you.',
        likesCount: 4,
        commentsCount: 0,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Post(
        id: 'reply3',
        userId: 'user_c',
        body: 'This community has your back. Don\'t hesitate to reach out if it gets hard!',
        likesCount: 1,
        commentsCount: 0,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("Post not found")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Replies',
          style: TextStyle(
            fontSize: 16, 
            color: Color(0xFF0F0F0F), 
            fontWeight: FontWeight.w600
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0F0F0F)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0x1F000000), // YouTube hairline border
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Top-Level Comment (The Post)
                PostCard(post: widget.post!, isDetail: true),
                
                // Replies (Indented directly matching YouTube UI)
                ..._mockReplies.map((reply) => Padding(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: PostCard(post: reply, isDetail: true),
                    )),
              ],
            ),
          ),
          
          // YouTube Style Bottom Input
          _buildReplyInput(),
        ],
      ),
    );
  }

  Widget _buildReplyInput() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final paddingBottom = bottomInset > 0 ? 10.0 : MediaQuery.of(context).padding.bottom + 10.0;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0x1F000000), width: 1.0)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 8, paddingBottom),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: kColorAvatarPalette[0],
              child: const Text(
                'Y', 
                style: TextStyle(color: Colors.white, fontSize: 14)
              ), // Representing the current user
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2), // YouTube gray input background
                borderRadius: BorderRadius.circular(18),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Add a reply...',
                  hintStyle: TextStyle(
                    color: Color(0xFF606060), 
                    fontSize: 13.5
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 14, color: Color(0xFF0F0F0F)),
                maxLines: 4,
                minLines: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded, 
                color: Color(0xFF0F0F0F), // YT defaults to black or inactive grey for send icon
                size: 24
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
