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
      backgroundColor: Constants.kBackgroundColor,
      appBar: AppBar(
        title: const MyTitleAppBar(title: 'Comunidad de Sueño'),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded, size: 50, color: Constants.kTextSecondaryColor),
                      Gap(12),
                      MyText(
                        'Aún no hay comentarios',
                        color: Constants.kTextSecondaryColor,
                        fontSize: 15,
                      ),
                      Gap(4),
                      MyText(
                        '¡Sé el primero en compartir tu experiencia de descanso!',
                        color: Constants.kTextSecondaryColor,
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
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isMine
                            ? const Color(0xFF312E81)
                            : Constants.kSurfaceColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMine ? 16 : 4),
                          bottomRight: Radius.circular(isMine ? 4 : 16),
                        ),
                        border: Border.all(
                          color: isMine
                              ? Constants.kPrimaryColor.withValues(alpha: 0.5)
                              : Constants.kBorderColor,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          MyText(
                            isMine ? 'Tú' : '${comment.user.name} ${comment.user.lastName}',
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: isMine ? Constants.kSecondaryColor : Constants.kMintColor,
                          ),
                          const Gap(5),
                          MyText(
                            comment.comment,
                            fontSize: 14,
                            color: Constants.kTextColor,
                          ),
                          const Gap(6),
                          MyText(
                            ParseUtils.formatDate(comment.createdAt),
                            fontSize: 10.5,
                            color: Constants.kTextSecondaryColor,
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
            decoration: const BoxDecoration(
              color: Constants.kSurfaceColor,
              border: Border(
                top: BorderSide(color: Constants.kBorderColor, width: 1),
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
                      return const SizedBox(
                        width: 36,
                        height: 36,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Constants.kSecondaryColor),
                          ),
                        ),
                      );
                    }
                    return Container(
                      decoration: const BoxDecoration(
                        color: Constants.kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          commentsProvider.addComment();
                          _scrollToBottom();
                        },
                        icon: const Icon(
                          Icons.arrow_upward_rounded,
                          size: 22,
                          color: Colors.white,
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
