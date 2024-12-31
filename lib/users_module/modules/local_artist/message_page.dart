import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegantia_art/constants/image_constants/image_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/color_constants/color_constant.dart';
import '../../../services/chatting/chatscreen.dart';

// Replace 'your_admin_uid' with the actual UID of your admin user
const String adminUid = 'nDpFGhAK78aheqEnuyGfRN4NOEr2';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final userDocs = await _firestore.collection('users').get();
      setState(() {
        _users = userDocs.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryColor,
        title: Text('Messages'),
      ),
      backgroundColor: ColorConstant.secondaryColor,
      body: Column(
        children: [
          // Container for admin profile (optional, can be removed)
          // ...

          // Button to chat with admin (optional, can be removed)
          // ...

          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                final userId = user['uid'];
                return ListTile(
                  title: Text(user['username'] ?? 'Unknown User'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          recipientId: userId,
                          isRecipientAdmin: false, // Indicate that the user is chatting with another user
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}