import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widgets/widget.dart';
import "package:flutter/material.dart";

class ConversationScreen extends StatefulWidget {
  String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {



  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();


  Stream chatMessageStream;
  Widget ChatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder : (context, snapshot){
        return ListView.builder(
          itemCount: snapshot.data.documents.length ,
          itemBuilder: (context,index){
            return MessageTile(snapshot.data.documents[index].data["message"]);
          },
        );
      }
    );
  }

  sendMessage(){
    if(messageController.text.isNotEmpty) {
      print(messageController.text);
      Map<String, String> messageMap = {
        "message": messageController.text,
        "sendBy" : Constants.myName
      };
      databaseMethods.addConversationMessages(widget.chatRoomId,messageMap);
      messageController.text="";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId)
    .then((val){
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children:[
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: "Message",
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                            border: InputBorder.none,
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                        //initiateSearch();
                        sendMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration:BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ) ,
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png")
                      ),
                    )
                  ],
                ),
              ),
            )
          ]
        )
      )
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  MessageTile(this.message);
  @override
  Widget build(BuildContext context) {
    return Text(message);
  }
}
