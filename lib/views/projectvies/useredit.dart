import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hp_flutter_lablet/controller/entrypoints.dart';
import 'package:hp_flutter_lablet/controller/helper.dart';
import 'package:hp_flutter_lablet/views/projectvies/userpage.dart';
import 'package:image_picker/image_picker.dart';
class UserEdit extends StatefulWidget {
  @override
  _UserEditState createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  var firstname_ctr=TextEditingController();
  var middlename_ctr=TextEditingController();
  var lastname_ctr=TextEditingController();
  var phone_ctr=TextEditingController();
  String user_id, firstname,lastname,middlename,email,username,phone,profile_image;
  List images=[];
Map args;
  @override
  Widget build(BuildContext context) {
    args=ModalRoute.of(context).settings.arguments as Map;
    firstname=args[UserProfile.USER_FIRST_NAME];
    middlename=args[UserProfile.USER_MIDDLE_NAME];
    lastname=args[UserProfile.USER_LAST_NAME];
    username=args[UserProfile.USER_NAME];
    email=args[UserProfile.USER_EMAIL];
    phone=args[UserProfile.USER_PHONE];
    user_id=args[UserProfile.USER_ID];
    profile_image=args[UserProfile.USER_IMAGE];
    firstname_ctr.text=firstname;
    middlename_ctr.text=middlename;
    lastname_ctr.text=lastname;
    phone_ctr.text=phone;
    return Scaffold(
      appBar: (AppBar(title: Text('edit page'),)),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 200,
                child: Center(child: profile_image.contains('upload')?Image.network("${EntryPoints.IMAGE_URL}${profile_image.substring(7)}"):Image.asset('assets/images/nophoto.jpg'),),
              ),
              Center(child: Row(children: [RaisedButton(onPressed:()async{
                images.clear();
               PickedFile myfile=await HelperCodes.getimage(ImageSource.gallery);
               images.add(myfile);
              },child: Icon(Icons.photo),),RaisedButton(onPressed:()async{
                images.clear();
                PickedFile myfile=await HelperCodes.getimage(ImageSource.camera);
                images.add(myfile);
              },child: Icon(Icons.camera_alt))],)),
              Center(child: Text(username)),
              Center(child: Text(email)),
              TextField(decoration: InputDecoration(hintText: 'enter first name',labelText: 'first name'),controller: firstname_ctr,),
              TextField(decoration: InputDecoration(hintText: 'enter middle name name',labelText: 'middle name'),controller: middlename_ctr,),
              TextField(decoration: InputDecoration(hintText: 'enter last name',labelText: 'last name'),controller: lastname_ctr,),
              Row(
                children: [
                  Expanded(child: TextField(decoration: InputDecoration(hintText: 'enter your phone',labelText: 'phone'),controller: phone_ctr,)),
                  IconButton(icon: Icon(Icons.add), onPressed: (){

                  })
                ],
              ),
Center(child: RaisedButton(onPressed: (){

},child: Text('edit'),),)
            ],
          ),
        ),
      ),
    );
  }
}
