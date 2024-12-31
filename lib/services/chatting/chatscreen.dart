import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String recipientId;
  final bool isRecipientAdmin;

  const ChatScreen({Key? key, required this.recipientId, required this.isRecipientAdmin}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    final user = _auth.currentUser;
    if (user != null) {
      final chatId = _getChatId(user.uid, widget.recipientId);
      final messagesCollection = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true);

      messagesCollection.snapshots().listen((snapshot) {
        setState(() {
          _messages = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        });
        _scrollDown();
      });
    }
  }

  String _getChatId(String userId1, String userId2) {
    return userId1.hashCode < userId2.hashCode
        ? '$userId1$userId2'
        : '$userId2$userId1';
  }

  Future<void> _sendMessage() async {
    final user = _auth.currentUser;
    if (user != null && _messageController.text.isNotEmpty) {
      final chatId = _getChatId(user.uid, widget.recipientId);
      final messagesCollection = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages');

      await messagesCollection.add({
        'senderId': user.uid,
        'recipientId': widget.recipientId,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
      _scrollDown();
    }
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isRecipientAdmin ? 'Chat with Admin' : 'Chat with User'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final messageData = _messages[index];
                final senderId = messageData['senderId'];
                final message = messageData['message'];
                final user = _auth.currentUser;
                final isCurrentUser = senderId == user?.uid;

                return Align(
                  alignment: isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isCurrentUser
                          ? Colors.blue[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}