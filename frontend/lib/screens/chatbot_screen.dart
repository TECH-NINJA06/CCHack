// ignore_for_file: deprecated_member_use

import 'package:frontend/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  Content c = Content(
    parts: [Part.text('Hello')],
    role: 'user',
  );
  List<Content> messages = [];
  List<String> messageList = [];
  String? reply;
  bool isLoading = false;
  final prompt = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final gemini = Gemini.instance;

  @override
  void initState() {
    super.initState();
    // Optional: Add a welcome message from the chatbot
    messages.add(Content(
      parts: [
        Part.text(
            "Hello! I'm your Mental Health Assistant. How can I help you plan your journey today?")
      ],
      role: 'model',
    ));
    messageList.add(
        "Hello! I'm your Mental Health Assistant. How can I help you plan your journey today?");
  }

  void chat() async {
    if (prompt.text.trim().isEmpty) return;

    setState(() {
      isLoading = true;
    });

    // Add user message
    messages.add(Content(
        parts: [Part.text('${prompt.text} make it concise')], role: 'user'));
    messageList.add(prompt.text);
    prompt.clear();

    // Scroll to bottom
    _scrollToBottom();

    try {
      // Get response from Gemini
      reply = await gemini.chat(messages).then((onValue) {
        return onValue?.output ?? "I'm sorry, I couldn't process that request.";
      });
      var temp = reply!.split('**');
      String newReply = "";
      int i = 0;
      for (String s in temp) {
        if (i % 2 == 0) {
          newReply += '/bold$s/bold';
        }
        if (s.isNotEmpty) {
          newReply += s;
        }
      }
      newReply = newReply.replaceAll('* ', '');

      // Add bot response
      messages.add(Content(parts: [Part.text(reply!)], role: 'model'));
      messageList.add(newReply);
    } catch (e) {
      // Handle errors
      messages.add(Content(
        parts: [Part.text("Sorry, I encountered an error. Please try again.")],
        role: 'model',
      ));
      messageList.add("Sorry, I encountered an error. Please try again.");
    } finally {
      setState(() {
        isLoading = false;
      });

      // Scroll to bottom again after receiving response
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.travel_explore,
                color: Colors.blueAccent,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mental Health Assistant",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Online",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black54,
            ),
            onPressed: () {
              // Optional menu for chat settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  itemCount: messages.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Loading indicator
                    if (index == messages.length) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: _buildBotMessageBubble(
                          child: 'thinking...',
                        ),
                      );
                    }

                    final isUser = messages[index].role == 'user';
                    final message = messageList[index];

                    // Message bubble
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bot avatar
                          if (!isUser) ...[
                            CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  Colors.blueAccent.withOpacity(0.2),
                              child: const Icon(
                                Icons.assistant,
                                size: 18,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],

                          // Message content
                          Flexible(
                            child: isUser
                                ? _buildUserMessageBubble(message)
                                : _buildBotMessageBubble(child: message),
                          ),

                          // User avatar
                          if (isUser) ...[
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  Colors.orangeAccent.withOpacity(0.2),
                              child: Text(
                                globalUser['name']?[0] ?? "U",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Optional attachment button
                  IconButton(
                    icon: Icon(
                      Icons.photo_outlined,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                     
                    },
                  ),

                  // Text input field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: prompt,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Ask me about travel destinations...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          if (prompt.text.isNotEmpty) {
                            chat();
                          }
                        },
                      ),
                    ),
                  ),

                  // Send button
                  IconButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (prompt.text.isNotEmpty) {
                              chat();
                            }
                          },
                    icon: Icon(
                      Icons.send_rounded,
                      color: isLoading ? Colors.grey : Colors.blueAccent,
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

  Widget _buildUserMessageBubble(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orangeAccent.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildBotMessageBubble({required String child}) {
    if (child == 'thinking') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Thinking...',
            style: TextStyle(color: Colors.white),
          ),
        ],
      );
    }
    List<TextSpan> spans = [];
    List<String> parts = child.split('/bold');
    int i = 0;
    for (String s in parts) {
      if (i % 2 == 0) {
        spans.add(
          TextSpan(
            text: s,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: s,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        );
      }
      i++;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text.rich(
        TextSpan(children: spans),
        textAlign: TextAlign.start,
      ),
    );
  }

  @override
  void dispose() {
    prompt.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
