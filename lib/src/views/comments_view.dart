import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/models/comment_model.dart';
import 'package:sleepfy/src/providers/comments_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/parse_utils.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/widgets/my_text_field.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class CommentsView extends StatefulWidget {
  const CommentsView({super.key});

  @override
  CommentsViewState createState() => CommentsViewState();
}

class CommentsViewState extends State<CommentsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final commentsProvider = Provider.of<CommentsProvider>(context);
    final List<CommentModel> comments = commentsProvider.comments;
    final int myUserId = UserPreferences.id ?? -1;

    return Scaffold(
      appBar: AppBar(
        title: MyTitleAppBar(title: 'Comentarios de la comunidad'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Builder(builder: (context) {
              if (commentsProvider.loadingGetMsgs) {
                return const Center(
                  child: CircularProgressIndicator(color: Constants.kPrimaryColor),
                );
              }

              if (comments.isEmpty) {
                return const Center(
                  child: Text('No hay comentarios'),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final CommentModel comment = comments[index];
                  final bool isMyComment = comment.userId == myUserId;
                  final bool isMine = comment.userId == myUserId;
                  final double isNotMinePadding = isMine ? 10 : 40;
                  final double isMinePadding = isMine ? 40 : 10;

                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 10, left: isMinePadding, right: isNotMinePadding),
                    decoration: BoxDecoration(
                      color: isMyComment ? Constants.kPrimaryColor.withValues(alpha: 0.3) : Constants.kBackgroundColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${comment.user.name} ${comment.user.lastName}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(comment.comment),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              ParseUtils.formatDate(comment.createdAt),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          SizedBox(
            height: 70,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField2(
                      controller: commentsProvider.controller,
                      text: 'Escribe un comentario...',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Builder(builder: (context) {
                    if (commentsProvider.loadingSendMsg) {
                      return SizedBox(
                        width: 32,
                        height: 32,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Constants.kPrimaryColor),
                        ),
                      );
                    }
                    return IconButton(
                      onPressed: () {
                        commentsProvider.addComment();
                        _scrollToBottom();
                      },
                      icon: const Icon(
                        size: 32,
                        Icons.send,
                        color: Constants.kPrimaryColor,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
