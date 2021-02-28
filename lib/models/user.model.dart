import 'package:flutter/material.dart';

class User
{
  String firstName,middleName,lastName;
  String userName;
  String email;
  String password;
  List<String> phones;
  String profileImage;
  String usertype;
  User({@required this.userName,@required this.email,@required this.password,@required this.firstName,@required this.middleName,
    @required this.lastName,this.phones,this.profileImage,this.usertype});
  Map<Object, Object> toMap(){
    return
      {
        'firstname':firstName,
        'middlename':middleName,
        'lastname':lastName,
        'username':userName,
        'email':email,
        'password':password,
        'profile_image':profileImage,
        'phone':phones[0],
        'usertype':usertype
      };
  }
}