import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sleepfy/models/comment_model.dart';
import 'package:sleepfy/src/providers/comments_provider.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/parse_utils.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsProvider = Provider.of<CommentsProvider>(context);
    final List<CommentModel> comments = commentsProvider.comments;
    final int myUserId = UserPreferences.id ?? -1;

    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Comunidad de Sueño'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Builder(builder: (context) {
              if (commentsProvider.loadingGetMsgs) {
                return Center(
                  child: CircularProgressIndicator(color: Constants.accent(context)),
                );
              }

              if (comments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded, size: 48, color: Constants.textSecondary(context)),
                      const Gap(12),
                      MyText(
                        'Aún no hay comentarios',
                        color: Constants.textPrimary(context),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      const Gap(4),
                      MyText(
                        '¡Sé el primero en compartir tu experiencia de descanso!',
                        color: Constants.textSecondary(context),
                        fontSize: 13,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final CommentModel comment = comments[index];
                  final bool isMine = comment.userId == myUserId;

                  return Align(
                    alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.78,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isMine
                            ? Constants.primary(context)
                            : Constants.surface(context),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMine ? 16 : 4),
                          bottomRight: Radius.circular(isMine ? 4 : 16),
                        ),
                        border: Border.all(
                          color: isMine ? Colors.transparent : Constants.border(context),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          MyText(
                            isMine ? 'Tú' : '${comment.user.name} ${comment.user.lastName}',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isMine ? Constants.primaryContent(context) : Constants.kSageGreen,
                          ),
                          const Gap(4),
                          MyText(
                            comment.comment,
                            fontSize: 13.5,
                            color: isMine ? Constants.primaryContent(context) : Constants.textPrimary(context),
                          ),
                          const Gap(6),
                          MyText(
                            ParseUtils.formatDate(comment.createdAt),
                            fontSize: 10,
                            color: isMine
                                ? Constants.primaryContent(context).withValues(alpha: 0.7)
                                : Constants.textSecondary(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // Barra inferior de envío
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Constants.surface(context),
              border: Border(
                top: BorderSide(color: Constants.border(context)),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField2(
                      controller: commentsProvider.controller,
                      text: 'Comparte tu experiencia o consejo...',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Builder(builder: (context) {
                    if (commentsProvider.loadingSendMsg) {
                      return SizedBox(
                        width: 36,
                        height: 36,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(Constants.accent(context)),
                          ),
                        ),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: Constants.primary(context),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          commentsProvider.addComment();
                          _scrollToBottom();
                        },
                        icon: Icon(
                          Icons.arrow_upward_rounded,
                          size: 20,
                          color: Constants.primaryContent(context),
                        ),
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
