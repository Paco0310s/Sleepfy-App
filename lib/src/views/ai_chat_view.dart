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
        text: 'Hola$name 🌙 Soy **Sleepfy AI**, tu coach nocturno de descanso.\n\n'
            'Conozco tu rutina personalizada y estoy aquí para ayudarte a relajar la mente, resolver dudas sobre tu sueño o guiarte paso a paso si te cuesta conciliar el sueño esta noche.\n\n'
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

    // Construir historial previo (excluyendo el mensaje de bienvenida inicial si se desea, o incluyéndolo)
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
      backgroundColor: Constants.kBackgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Constants.kSecondaryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Constants.kSecondaryColor,
                size: 18,
              ),
            ),
            const Gap(8),
            const MyTitleAppBar(title: 'Sleepfy AI Coach'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Constants.kTextSecondaryColor),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Constants.kSurfaceColor,
              border: Border(
                bottom: BorderSide(color: Constants.kBorderColor.withValues(alpha: 0.7)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 14,
                  color: Constants.kMintColor.withValues(alpha: 0.9),
                ),
                const Gap(6),
                const Flexible(
                  child: MyText(
                    'Conectado con tu rutina personalizada de sueño',
                    fontSize: 11.5,
                    color: Constants.kTextSecondaryColor,
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
              height: 46,
              margin: const EdgeInsets.only(bottom: 6),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _quickPrompts.length,
                separatorBuilder: (_, __) => const Gap(8),
                itemBuilder: (context, i) {
                  final prompt = _quickPrompts[i];
                  return ActionChip(
                    backgroundColor: Constants.kSurfaceColor,
                    side: BorderSide(color: Constants.kSecondaryColor.withValues(alpha: 0.35)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    avatar: const Icon(
                      Icons.auto_awesome,
                      size: 14,
                      color: Constants.kSecondaryColor,
                    ),
                    label: MyText(
                      prompt,
                      fontSize: 12,
                      color: Constants.kTextColor,
                    ),
                    onPressed: () => _sendMessage(prompt),
                  );
                },
              ),
            ),

          // Barra de entrada inferior
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            decoration: const BoxDecoration(
              color: Constants.kSurfaceColor,
              border: Border(
                top: BorderSide(color: Constants.kBorderColor),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Constants.kBackgroundColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Constants.kBorderColor),
                      ),
                      child: TextField(
                        controller: _inputController,
                        style: const TextStyle(color: Constants.kTextColor, fontSize: 14.5),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        minLines: 1,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Cuéntale a Sleepfy AI cómo te sientes...',
                          hintStyle: TextStyle(color: Constants.kTextSecondaryColor, fontSize: 13.5),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  GestureDetector(
                    onTap: _isTyping ? null : () => _sendMessage(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: _isTyping
                            ? null
                            : const LinearGradient(
                                colors: [Constants.kPrimaryColor, Constants.kSecondaryColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        color: _isTyping ? Constants.kSurfaceLightColor : null,
                        boxShadow: _isTyping
                            ? []
                            : [
                                BoxShadow(
                                  color: Constants.kPrimaryColor.withValues(alpha: 0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                      ),
                      child: Icon(
                        _isTyping ? Icons.hourglass_top_rounded : Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
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
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Constants.kPrimaryColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Constants.kSecondaryColor.withValues(alpha: 0.4)),
              ),
              child: const Icon(
                Icons.nightlight_round,
                color: Constants.kSecondaryColor,
                size: 16,
              ),
            ),
            const Gap(10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Constants.kPrimaryColor, Color(0xFF4F46E5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isUser ? null : Constants.kSurfaceColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: isUser ? null : Border.all(color: Constants.kBorderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isUser)
                    MyText(
                      message,
                      color: Colors.white,
                      fontSize: 14.5,
                    )
                  else
                    MarkdownBody(
                      data: message,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          color: Constants.kTextColor,
                          fontSize: 14,
                          height: 1.48,
                        ),
                        strong: const TextStyle(
                          color: Constants.kSecondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        listBullet: const TextStyle(
                          color: Constants.kSecondaryColor,
                          fontSize: 14,
                        ),
                        h3: const TextStyle(
                          color: Constants.kSecondaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const Gap(4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: MyText(
                      time,
                      fontSize: 10,
                      color: isUser
                          ? Colors.white.withValues(alpha: 0.7)
                          : Constants.kTextSecondaryColor,
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
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Constants.kPrimaryColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Constants.kSecondaryColor.withValues(alpha: 0.4)),
            ),
            child: const Icon(
              Icons.nightlight_round,
              color: Constants.kSecondaryColor,
              size: 16,
            ),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Constants.kSurfaceColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(color: Constants.kBorderColor),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Constants.kSecondaryColor,
                  ),
                ),
                Gap(10),
                MyText(
                  'Sleepfy AI está escribiendo...',
                  fontSize: 12.5,
                  color: Constants.kTextSecondaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

