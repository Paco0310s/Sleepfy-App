import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:sleepfy/controllers/test_controller.dart';
import 'package:sleepfy/src/utils/constants.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';
import 'package:sleepfy/src/widgets/my_text.dart';
import 'package:sleepfy/src/widgets/my_title_app_bar.dart';

class AiChatView extends StatefulWidget {
  final String? initialPrompt;

  const AiChatView({super.key, this.initialPrompt});

  @override
  State<AiChatView> createState() => _AiChatViewState();
}

class _ChatMessage {
  final String role; // 'user' | 'model'
  final String text;
  final DateTime timestamp;

  _ChatMessage({
    required this.role,
    required this.text,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class _AiChatViewState extends State<AiChatView> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isTyping = false;

  static const List<String> _quickPrompts = [
    'No puedo dormir hoy, ¿qué hago?',
    'Tengo muchos pensamientos acelerados',
    'Me desperté a mitad de la noche',
    'Guíame en una relajación muscular',
    '¿Cómo preparo mi habitación para dormir?',
  ];

  @override
  void initState() {
    super.initState();
    final name = (UserPreferences.name != null && UserPreferences.name!.isNotEmpty)
        ? ' ${UserPreferences.name}'
        : '';
    _messages.add(
      _ChatMessage(
        role: 'model',
        text: 'Hola$name 🌙 Soy **Sleepfy AI**, tu coach de descanso.\n\n'
            'Conozco tu rutina y estoy aquí para ayudarte a relajar la mente, resolver dudas sobre tu sueño o guiarte paso a paso si te cuesta conciliar el sueño esta noche.\n\n'
            '¿Cómo te sientes en este momento?',
      ),
    );

    if (widget.initialPrompt != null && widget.initialPrompt!.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(widget.initialPrompt!);
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  Future<void> _sendMessage([String? customText]) async {
    final text = (customText ?? _inputController.text).trim();
    if (text.isEmpty || _isTyping) return;

    if (customText == null) {
      _inputController.clear();
    }

    final history = _messages
        .skip(1)
        .map((m) => {'role': m.role, 'text': m.text})
        .toList();

    setState(() {
      _messages.add(_ChatMessage(role: 'user', text: text));
      _isTyping = true;
    });
    _scrollToBottom();

    final reply = await TestController.sendChatMessage(text, history);

    if (!mounted) return;

    setState(() {
      _isTyping = false;
      _messages.add(
        _ChatMessage(
          role: 'model',
          text: reply ??
              'Lo siento, tuve un inconveniente de conexión en este momento. Respira profundo con el método **4-7-8** e inténtalo de nuevo en unos segundos.',
        ),
      );
    });
    _scrollToBottom();
  }

  void _clearChat() {
    final name = (UserPreferences.name != null && UserPreferences.name!.isNotEmpty)
        ? ' ${UserPreferences.name}'
        : '';
    setState(() {
      _messages
        ..clear()
        ..add(
          _ChatMessage(
            role: 'model',
            text: 'Hola$name 🌙 Conversación reiniciada. ¿En qué te puedo ayudar esta noche?',
          ),
        );
    });
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background(context),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Constants.surfaceLight(context),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                color: Constants.accent(context),
                size: 16,
              ),
            ),
            const Gap(8),
            const MyTitleAppBar(title: 'Sleepfy AI Coach'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: Constants.textSecondary(context)),
            tooltip: 'Reiniciar conversación',
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner sutil de contexto personalizado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: Constants.surface(context),
              border: Border(
                bottom: BorderSide(color: Constants.border(context)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  size: 13,
                  color: Constants.kSageGreen,
                ),
                const Gap(6),
                Flexible(
                  child: MyText(
                    'Conectado con tu rutina personalizada de sueño',
                    fontSize: 11.5,
                    color: Constants.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),

          // Lista de mensajes
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return const _TypingIndicatorBubble();
                }
                final msg = _messages[index];
                final isUser = msg.role == 'user';
                return _MessageBubble(
                  message: msg.text,
                  isUser: isUser,
                  time: _formatTime(msg.timestamp),
                );
              },
            ),
          ),

          // Sugerencias rápidas
          if (_messages.length <= 2 && !_isTyping)
            Container(
              height: 42,
              margin: const EdgeInsets.only(bottom: 6),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _quickPrompts.length,
                separatorBuilder: (_, __) => const Gap(8),
                itemBuilder: (context, i) {
                  final prompt = _quickPrompts[i];
                  return ActionChip(
                    backgroundColor: Constants.surface(context),
                    side: BorderSide(color: Constants.border(context)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    avatar: Icon(
                      Icons.auto_awesome,
                      size: 13,
                      color: Constants.accent(context),
                    ),
                    label: MyText(
                      prompt,
                      fontSize: 11.5,
                      color: Constants.textPrimary(context),
                    ),
                    onPressed: () => _sendMessage(prompt),
                  );
                },
              ),
            ),

          // Barra de entrada inferior
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            decoration: BoxDecoration(
              color: Constants.surface(context),
              border: Border(
                top: BorderSide(color: Constants.border(context)),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Constants.surfaceLight(context),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Constants.border(context)),
                      ),
                      child: TextField(
                        controller: _inputController,
                        style: TextStyle(color: Constants.textPrimary(context), fontSize: 14),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Cuéntale a Sleepfy AI cómo te sientes...',
                          hintStyle: TextStyle(color: Constants.textSecondary(context), fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  GestureDetector(
                    onTap: _isTyping ? null : () => _sendMessage(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isTyping
                            ? Constants.surfaceLight(context)
                            : Constants.primary(context),
                      ),
                      child: Icon(
                        _isTyping ? Icons.hourglass_top_rounded : Icons.send_rounded,
                        color: _isTyping
                            ? Constants.textSecondary(context)
                            : Constants.primaryContent(context),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String time;

  const _MessageBubble({
    required this.message,
    required this.isUser,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Constants.surfaceLight(context),
                shape: BoxShape.circle,
                border: Border.all(color: Constants.border(context)),
              ),
              child: Icon(
                Icons.bedtime_outlined,
                color: Constants.accent(context),
                size: 15,
              ),
            ),
            const Gap(10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
              decoration: BoxDecoration(
                color: isUser
                    ? Constants.primary(context)
                    : Constants.surface(context),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: Border.all(
                  color: isUser ? Colors.transparent : Constants.border(context),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isUser)
                    MyText(
                      message,
                      color: Constants.primaryContent(context),
                      fontSize: 14,
                    )
                  else
                    MarkdownBody(
                      data: message,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: Constants.textPrimary(context),
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                        strong: TextStyle(
                          color: Constants.textPrimary(context),
                          fontWeight: FontWeight.w600,
                        ),
                        listBullet: TextStyle(
                          color: Constants.accent(context),
                          fontSize: 13.5,
                        ),
                        h3: TextStyle(
                          color: Constants.textPrimary(context),
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const Gap(4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: MyText(
                      time,
                      fontSize: 9.5,
                      color: isUser
                          ? Constants.primaryContent(context).withValues(alpha: 0.7)
                          : Constants.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) const Gap(4),
        ],
      ),
    );
  }
}

class _TypingIndicatorBubble extends StatelessWidget {
  const _TypingIndicatorBubble();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Constants.surfaceLight(context),
              shape: BoxShape.circle,
              border: Border.all(color: Constants.border(context)),
            ),
            child: Icon(
              Icons.bedtime_outlined,
              color: Constants.accent(context),
              size: 15,
            ),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Constants.surface(context),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: Constants.border(context)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,
                    color: Constants.accent(context),
                  ),
                ),
                const Gap(8),
                MyText(
                  'Sleepfy AI está escribiendo...',
                  fontSize: 12,
                  color: Constants.textSecondary(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
