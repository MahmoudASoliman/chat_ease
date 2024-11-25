import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/chat_bubble.dart';

class ChatPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  static String id = 'ChatPage';
  ChatPage({super.key});
  CollectionReference messages =
      FirebaseFirestore.instance.collection(KMessageCollections);
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;

    print('*******${ModalRoute.of(context)!.settings.arguments}   $email');
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(KCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        List messageslist = [];
        Message message;
        if (snapshot.hasData) {
          for (var i = 0; i < snapshot.data!.docs.length; i++) {
            messageslist.add(Message.fromjson(snapshot.data!.docs[i]));
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: KPrimaryColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    KLogo,
                    height: 50,
                  ),
                  const Text("Chat"),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return messageslist[index].id == email
                          ? ChatBubble(
                              message: messageslist[index],
                             
                            )
                          : ChatBubbleFriends(
                              message: messageslist[index],
                            
                            );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (data) {
                      _sendMessage(data, email);
                    },
                    decoration: InputDecoration(
                      hintText: "Send Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: KPrimaryColor),
                      ),
                      suffix: IconButton(
                        onPressed: () {
                          _sendMessage(controller.text, email);
                        },
                        icon: const Icon(Icons.send),
                        color: KPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text("Loading ....");
        }
      },
    );
  }

  void _sendMessage(String data, email) {
    messages.add(
      {KMessage: data, KCreatedAt: DateTime.now(), 'id': email},
    );
    controller.clear();

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
