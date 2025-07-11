import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../data/data.dart'; // for globalUser['name']

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final prompt = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> messages = [];
  final gemini = Gemini.instance;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    messages.add({
      'role': 'bot',
      'text': "Hi! I'm your mental wellness companion. How can I help you today?"
    });
  }

  void chat() async {
    if (prompt.text.trim().isEmpty) return;

    final userMessage = prompt.text.trim();
    setState(() {
      messages.add({'role': 'user', 'text': userMessage});
      isLoading = true;
      prompt.clear();
    });
    _scrollToBottom();

    try {
      final response = await gemini.text(userMessage);
      setState(() {
        messages.add({'role': 'bot', 'text': response ?? 'No response received.'});
      });
    } catch (e) {
      setState(() {
        messages.add({'role': 'bot', 'text': 'Oops! Something went wrong.'});
      });
    } finally {
      setState(() => isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    prompt.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MindSpace AI Assistant'),
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isLoading) {
                  return _botBubble("Typing...");
                }

                final msg = messages[index];
                final isUser = msg['role'] == 'user';

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: isUser
                      ? _userBubble(msg['text'])
                      : _botBubble(msg['text']),
                );
              },
            ),
          ),
          _inputArea(),
        ],
      ),
    );
  }

  Widget _inputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: prompt,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Type your thoughts or questions...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onSubmitted: (_) => chat(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: isLoading ? null : chat,
            icon: Icon(Icons.send_rounded,
                color: isLoading ? Colors.grey : Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  Widget _userBubble(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _botBubble(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
