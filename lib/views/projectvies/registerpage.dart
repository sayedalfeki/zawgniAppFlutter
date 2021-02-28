

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hp_flutter_lablet/controller/helper.dart';
import 'package:hp_flutter_lablet/controller/user.controller.dart';
import 'package:hp_flutter_lablet/models/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController firstname=TextEditingController();
  TextEditingController middlename=TextEditingController();
  TextEditingController lastname=TextEditingController();
  TextEditingController username=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController password=TextEditingController();

  List<String> prof_image=[];
  bool image=false;
var ftcolor=Colors.red;
  var ftsize=20.0;
  var iccolor=Colors.purpleAccent;
  var icsize=50.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('register page'),),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
child: Column(
  children: [
    Center(
        child: Column(
          children: [
            Container(

              margin: EdgeInsets.only(top: 20),
height:200,
width: 220,
              child:  image?CircleAvatar(backgroundColor:Colors.transparent,radius: 50,backgroundImage: FileImage(File(prof_image[0]))):
              CircleAvatar(backgroundColor:Colors.transparent,radius:200,backgroundImage:AssetImage('assets/images/nophoto.jpg')),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              IconButton(color:iccolor,iconSize: icsize,icon:Icon(Icons.photo), onPressed:()async{
                prof_image.clear();
                PickedFile myfile=await HelperCodes.getimage(ImageSource.gallery);
                if(myfile!=null) {
                  prof_image.add(myfile.path);
                  setState(() {
                    image = true;
                  });
                  HelperCodes.showToast(context, myfile.path);
                }
              }),
              IconButton(color:iccolor,iconSize: icsize,icon:Icon(Icons.camera_alt), onPressed:()async{
                prof_image.clear();
                PickedFile myfile=await HelperCodes.getimage(ImageSource.camera);
                if(myfile!=null) {
                  prof_image.add(myfile.path);
                  setState(() {
                    image=true;
                  });
                  HelperCodes.showToast(context, myfile.path);
                }
              }),
            ],)
          ],
        ),
    ),
    myfields('enter your first name ', 'first name', firstname,0,icon:Icons.person),
    myfields('enter your middle name', 'middle name', middlename,0,icon:Icons.person),
    myfields('enter your last name', 'last name', lastname,0,icon:Icons.person),
    myfields('enter your user name', 'user name', username,0,icon:Icons.person),
    myfields('enter your email', 'email', email,0,icon:Icons.email),
    myfields('enter your phone ', 'phone', phone,1,icon:Icons.phone),
    myfields('enter your password', 'password', password,0,icon:Icons.lock),
    RaisedButton(
      color: Colors.blue,
      onPressed: ()async{
      try {
        if(!await HelperCodes.checkConnection())
        {
          HelperCodes.showToast(context,'check internet connection and try again');
          return;
        }
        if (checkValidation(context)) {
          // HelperCodes.showToast(context, 'now you can register');
          List<String> phones = [phone.text];
          bool isusername = await UserDataBase().isuser(username.text, 1);
          bool isemail = await UserDataBase().isuser(email.text, 0);
          //prof_image.length>0 ?image=true:image=false;
          if (isusername)
            HelperCodes.showToast(context, 'this username not available');
          else if (isemail)
            HelperCodes.showToast(context, 'this email already registered');
          else {
            SharedPreferences pref = await SharedPreferences.getInstance();
            String usertype = pref.get("user_type");
            User user = User(firstName: firstname.text,
                lastName: lastname.text,
                middleName: middlename.text,
                userName: username.text,
                email: email.text,
                password: password.text,
                phones: phones,
                profileImage: prof_image.length > 0
                    ? prof_image[0]
                    : "assets/images/nophoto.jpg",
                usertype: usertype
            );
            String id = prof_image.length > 0 ? await UserDataBase()
                .registerUser(user, true) : await UserDataBase().registerUser(
                user, false);
            if (id != null) {
              HelperCodes.showToast(context, "user register with id $id");
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setString('user_id', id);
              Navigator.pushReplacementNamed(context, '/homepage');
            }
            else {
              HelperCodes.showToast(context,
                  "username name or email already registered you can login");
            }
          }
        }
      }
      catch(e){
        HelperCodes.showToast(context, e.toString());
      }

    },child: Text('register',style: TextStyle(color: Colors.white),),)
  ],
),
        ),
      ),
    );
  }
  Widget myfields(String hint,String label,TextEditingController controller,int input,{icon:IconData}){
    assert(icon != null);
    return Column(
      children: [
        SizedBox(height: 10,),
        Container(
          margin: EdgeInsets.only(left: 20,right: 20),
          decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.lightBlueAccent),),
          child: TextField(
            style: TextStyle(fontSize: ftsize,color: ftcolor),
            decoration: InputDecoration(prefixIcon: Icon(icon,color: Colors.blue,),hintText: hint,labelText: label),
            controller: controller,
            keyboardType:input==1?TextInputType.phone:TextInputType.text,
          ),
        ),
      ],
    );
  }
  bool checkValidation(BuildContext context){
    if(firstname.text.isEmpty) {
      HelperCodes.showToast(context, "please enter your first name");
      return false;
    }
    else if(middlename.text.isEmpty) {
      HelperCodes.showToast(context, "please enter your middle name");
      return false;
    }
    else if(lastname.text.isEmpty) {
      HelperCodes.showToast(context, "please enter your last name");
      return false;
    }
    else if(username.text.isEmpty) {
      HelperCodes.showToast(context, "please enter your user name");
      return false;
    }
    else if(email.text.isEmpty) {
      HelperCodes.showToast(context, "please enter your email");
      return false;
    }
    else if(password.text.isEmpty) {
      HelperCodes.showToast(context, "please enter your password");
      return false;
    }
    else
    return true;
  }
}
