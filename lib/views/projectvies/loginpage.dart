import 'package:flutter/material.dart';
import 'package:hp_flutter_lablet/controller/helper.dart';
import 'package:hp_flutter_lablet/controller/user.controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username='',password='';

  var tfcolor=Colors.redAccent;
  var tfsize=20.0;
  bool showpass=false;

  bool changeicon=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(title: Text('login page'),),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 180),
          child: Column(

            children: [
              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.lightBlueAccent),),

                  child: TextField(style: TextStyle(fontSize:tfsize,color: tfcolor),decoration: InputDecoration(hintText: 'enter your user name',labelText: 'user name',
                      prefixIcon:Icon(Icons.person,color: Colors.blue,),),onChanged:(val)=> username=val,),

              ),
              SizedBox(height: 10,),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.lightBlueAccent),),

                child: TextField(obscureText:showpass?false: true,style: TextStyle(fontSize:tfsize,color: tfcolor),decoration: InputDecoration(hintText: 'enter your password',labelText: 'password',
                    prefixIcon:Icon(Icons.lock,color: Colors.blue,),suffixIcon: IconButton(onPressed:(){
                      setState(() {
                        changeicon=!changeicon;
                        showpass=!showpass;
                      });
                    },icon: Icon(changeicon?Icons.remove_red_eye:Icons.remove_red_eye_outlined,color: Colors.blue,),)),onChanged:(val)=> password=val,),
              ),
              SizedBox(height: 10,),
              RaisedButton(color:Colors.blue,onPressed: ()async{
              if(!await HelperCodes.checkConnection()) {
                HelperCodes.showToast(context, 'check your connection and try again');
                return;
              }
              if(username.isEmpty||password.isEmpty)
              {
                HelperCodes.showToast(context, 'please fill all fields');
                return;
              }
                bool isuser=await UserDataBase().loginUser(username, password);
                if(isuser) {
                  String id=await UserDataBase().getUserId(username);
                  //HelperCodes.showToast(context, id);
                  var user=await UserDataBase().getUser(id);
                  String user_type=user['usertype'];
                  SharedPreferences pref=await SharedPreferences.getInstance();
                  pref.setString('user_id',id);
                  pref.setString('user_type', user_type);
                  Navigator.pushReplacementNamed(context, '/homepage');
                }
                else
                  HelperCodes.showToast(context,"user name or password are incorrect");
              },child: Text('login',style: TextStyle(fontSize: tfsize,color: Colors.white),),),
              FlatButton(onPressed: (){
                Navigator.pushReplacementNamed(context, '/registerpage');
              }, child: Text('not user register?',style: TextStyle(fontSize: tfsize)),textColor: Colors.red,)
            ],
          ),
        ),
      ),
    );
  }
}
