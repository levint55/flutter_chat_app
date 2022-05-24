import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: documents.length,
          itemBuilder: (context, index) => MessageBubble(
            message: documents[index]['text'],
            isMe: documents[index]['userId'] == user?.uid,
            key: ValueKey(documents[index].id),
            userId: documents[index]['userId'],
            userName: documents[index]['username'],
            imageUrl: documents[index]['userImage'],
          ),
        );
      },
    );
  }
}
