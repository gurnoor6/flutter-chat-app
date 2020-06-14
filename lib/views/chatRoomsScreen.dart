import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/views/search.dart';
import "package:flutter/material.dart";

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

AuthMethods authMethods = new AuthMethods();

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Image.asset("assets/images/logo.png",height:50),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=>Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app)
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed:() {
          Navigator.push(context,MaterialPageRoute(
            builder: (context)=> SearchScreen()
          ));
        },
      ),
    );
  }
}
