import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widgets/widget.dart';
import "package:flutter/material.dart";

import 'chatRoomsScreen.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;
  
  AuthMethods authMethods= new AuthMethods(); 
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState> ();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUp(){
    if(formKey.currentState.validate()){
      Map<String,String> userInfoMap = {
        "name":userNameTextEditingController.text,
        "email": emailTextEditingController.text
      };

      setState(() {
        isLoading=true;
      });
      
      authMethods.signUpWithEmailAndPassword
        (emailTextEditingController.text, passwordTextEditingController.text).then((val) {
//          print(val);
          databaseMethods.uploadUserInfo(userInfoMap);

          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context)=> ChatRoom()
          ));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading? Container(
        child: Center(child: CircularProgressIndicator()),
      ) :SingleChildScrollView(
          child:Container(
            padding: EdgeInsets.only(bottom: 30),
            height: MediaQuery.of(context).size.height-50,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                  mainAxisSize:MainAxisSize.min ,
                  children:[
                    Form(
                      key:formKey,
                      child: Column(
                        children:[
                          TextFormField(
                            validator: (val){
                              return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null :"Please provide valid email!!";
                            },
                            controller: emailTextEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("Email"),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val){
                              return val.length>6 ? null:"Please provide password 6+ characters";
                            },
                            controller: passwordTextEditingController,
                            style:simpleTextStyle(),
                            decoration: textFieldInputDecoration("Password"),
                          ),
                          TextFormField(
                            validator: (val){
                              return val.isEmpty || val.length<4 ?"Please provide valid username": null;
                            },
                            controller: userNameTextEditingController,
                            style:simpleTextStyle(),
                            decoration: textFieldInputDecoration("Username"),
                          ),
                        ]
                      ),
                    ),
                    SizedBox(height:8),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding:EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child:Text("Forgot Password?",style:simpleTextStyle()),
                      ),
                    ),
                    SizedBox(height:8),
                    GestureDetector(
                      onTap:(){
                        signMeUp();
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width:MediaQuery.of(context).size.width,
                          padding:EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              gradient:LinearGradient(
                                  colors:[
                                    const Color(0xff007EF4),
                                    const Color(0xff2A75BC)
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child:Text("Sign Up",style: mediumTextStyle(),)
                      ),
                    ),
                    SizedBox(height:16),
                    Container(
                        alignment: Alignment.center,
                        width:MediaQuery.of(context).size.width,
                        padding:EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child:Text("Sign Up with Google",style: TextStyle(
                          fontSize: 17,
                          color:Colors.black87,
                        ),
                        )
                    ),
                    SizedBox(height:16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text("Already have an account? ", style:mediumTextStyle()),
                        GestureDetector(
                          onTap: (){
                            widget.toggle();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("Sign In Here",style:TextStyle(
                              fontSize: 17,
                              color:Colors.white,
                              decoration: TextDecoration.underline,
                            )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height:50)
                  ]
              ),
            ),
          )
      ),
    );
  }
}
