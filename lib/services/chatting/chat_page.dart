import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/color_constants/color_constant.dart';
import '../../main.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String currentUserId;
  String? chatId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
      _initializeChat();
    } else {
      // Handle user not logged in
      Navigator.of(context).pop();
    }
  }

  Future<void> _initializeChat() async {
    final adminId = "nDpFGhAK78aheqEnuyGfRN4NOEr2"; // Replace with actual admin user ID

    final chatQuery = await _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .get();

    final existingChat = chatQuery.docs.firstWhereOrNull((doc) {
      final participants = List<String>.from(doc['participants']);
      return participants.contains(adminId);
    });

    if (existingChat != null) {
      setState(() {
        chatId = existingChat.id;
      });
    } else {
      final newChat = await _firestore.collection('chats').add({
        'participants': [currentUserId, adminId],
        'lastMessage': {
          'senderId': '',
          'content': '',
          'timestamp': FieldValue.serverTimestamp(),
        },
      });
      setState(() {
        chatId = newChat.id;
      });
    }
    _listenForNewMessages();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty && chatId != null) {
      final timestamp = DateTime.now(); // Current timestamp
      final content = _messageController.text.trim();

      // Update last message in the chat document
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': {
          'senderId': currentUserId,
          'content': content,
          'timestamp': timestamp,
        },
      });

      // Add new message to the messages subcollection
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': currentUserId,
        'content': content,
        'timestamp': timestamp,
        'read': false,
      });

      _messageController.clear();
    }
  }

  void _listenForNewMessages() {
    if (chatId != null) {
      _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('senderId', isEqualTo: "nDpFGhAK78aheqEnuyGfRN4NOEr2") // Listening for admin's messages
          .where('read', isEqualTo: false)
          .snapshots()
          .listen((snapshot) {
        for (final doc in snapshot.docs) {
          doc.reference.update({'read': true});
        }
      });
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return TimeOfDay.fromDateTime(dateTime).format(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorConstant.secondaryColor,
        ),
        backgroundColor: ColorConstant.primaryColor,
        title: Text('Chat with Admin',
          style: TextStyle(
            fontSize: width*0.04,
            color: ColorConstant.secondaryColor,
            fontWeight: FontWeight.w900
        ),),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatId == null
                ? Center(child: Text('Initializing chat...'))
                : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return messages.isEmpty
                    ? Center(child: Text('Start the conversation!'))
                    : ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                    messages[index].data() as Map<String, dynamic>;
                    final isMe = message['senderId'] == currentUserId;

                    final timestamp = message['timestamp'] as Timestamp?;
                    final formattedTime = timestamp != null
                        ? _formatTimestamp(timestamp)
                        : '';

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe
                              ? ColorConstant.primaryColor
                              : ColorConstant.primaryColor.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(width*.03),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['content'],
                              style: TextStyle(
                                color: isMe
                                    ? Colors.white
                                    : Colors.black,
                                  fontSize: width*0.03
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorConstant.primaryColor.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(
                        color: ColorConstant.secondaryColor
                    ),
                    controller: _messageController,
                    cursorColor: ColorConstant.secondaryColor,
                    decoration: InputDecoration(
                      focusColor: ColorConstant.secondaryColor,
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontWeight: FontWeight.w900,
                        fontSize: width*0.03,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width*0.025       ),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: ColorConstant.primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    size: width*0.06,
                    color: ColorConstant.primaryColor,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
