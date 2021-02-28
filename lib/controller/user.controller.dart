import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hp_flutter_lablet/controller/entrypoints.dart';
import 'package:hp_flutter_lablet/controller/helper.dart';
import 'package:hp_flutter_lablet/models/user.model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart'as http;
class UserDataBase
{
 BuildContext context;
 UserDataBase({this.context});
 Future isuser(String data,int num)async{
if(num==1)
{
 var response= await http.get("${EntryPoints.IS_USERNAME_URL}?username=$data");
 if(response.statusCode==200)
 {
  var result=jsonDecode(response.body);
  if(result['founded'])
   return true;
  else
   return false;
 }
 else
  throw('no response from server');
}
else
 {
  var response= await http.get("${EntryPoints.IS_EMAIL_URL}?email=$data");
  if(response.statusCode==200)
  {
   var result=jsonDecode(response.body);
   if(result['founded'])
    return true;
   else
    return false;
  }
  else
   throw('no response from server');
 }
 }
Future registerUser(User user,bool image) async
{
 if (image) {
  var request = await http.MultipartRequest(
      'POST', Uri.parse(EntryPoints.REGISTER_USER_URL));
  request.headers['Content-Type'] = 'multipart/form-data';
  request.fields['firstname'] = user.firstName;
  request.fields['middlename'] = user.middleName;
  request.fields['lastname'] = user.lastName;
  request.fields['username'] = user.userName;
  request.fields['email'] = user.email;
  request.fields['password'] = user.password;
  request.fields['profile_image'] = user.profileImage;
  request.fields['phone'] = user.phones[0];
  request.fields['usertype'] = user.usertype;
  request.files.add(
      await http.MultipartFile.fromPath('image', user.profileImage));
  var response = await http.Response.fromStream(await request.send());
  if (response.statusCode == 200) {
   //var register=response.toString();
   //HelperCodes.showToast(context, register);
   var result = jsonDecode(response.body);
   if (result['register']) {
    HelperCodes.showToast(context, result['msg']);
    return result['id'];
   }
   else {
    HelperCodes.showToast(context, result['msg']);
    return null;
   }
  }
 }
  else {
   // var usermap={'firstname':user.firstName,'middlename':user.middleName,'lastname':user.lastName,'username':user.userName,'email':user.email,
   // 'password':user.password,'phone':user.phones[0],'profile_image':user.profileImage};
   var response = await http.post(EntryPoints.REGISTER_USER_URL,
       headers: {"Content-Type": "application/json"},
       body: jsonEncode(user.toMap()));
   if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    if (result['register']) {
     HelperCodes.showToast(context, result['msg']);
     return result['id'];
    }
    else  {
     HelperCodes.showToast(context, result['msg']);
     return null;
    }

   }

 }
}
 Future updateProfileImage(String id,String path) async
 {
  var request = await http.MultipartRequest(
       'PUT', Uri.parse('${EntryPoints.UPDATE_PROFILE_IMAGE_URL}$id'));
  request.fields['profile_image'] =path;
  request.files.add(
       await http.MultipartFile.fromPath('image',path));
   var response = await http.Response.fromStream(await request.send());
   if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    if (result['updated']) {
     HelperCodes.showToast(context, result['msg']);
     return true;
    }
    else {
     HelperCodes.showToast(context, result['msg']);
     return false;
    }
   }
  }

  Future loginUser(String username,String password) async
{
 var response=await http.get("${EntryPoints.LOGIN_USER_URL}?name=$username&pass=$password");
 /*var request = http.Request('GET', Uri.parse(EntryPoints.LOGIN_USER_URL));
 request.bodyFields['username'] = username;
 request.bodyFields['password'] = password;
 request.headers['Content-Type'] = "application/x-www-form-urlencoded";
 var response = await http.Response.fromStream(await request.send());*/
 var resjson=jsonDecode(response.body);
 if(resjson['founded'])
  return true;
 else
  return false;
}
getUserId(String username)async{
  var res=await http.get("${EntryPoints.GET_USERID_URL}?username=$username");
  if(res.statusCode==200)
  {
   String id=jsonDecode(res.body);
   return id;
  }
  else
   return null;
}
 Future getUser(String id)async{
  var res=await http.get("${EntryPoints.GET_USER_URL}?id=$id");
  if(res.statusCode==200)
  {
   return  jsonDecode(res.body);

  }
  else
   return null;
 }
Future updateName(String id,String firstname,String middlename,String lastname) async
{
var namesmap={'firstname':firstname,'middlename':middlename,'lastname':lastname};
var response=await http.put("${EntryPoints.CHNGE_NAMES_USER_URL}$id",headers: {'Content-Type':'application/json'},body: jsonEncode(namesmap));
if(response.statusCode==200)
{
 var jsonresp=jsonDecode(response.body);
 if(jsonresp['updated']){
  HelperCodes.showToast(context, jsonresp['msg']);
  return true;
 }
 else{
  HelperCodes.showToast(context, jsonresp['msg']);
  return false;
 }
}
else{
 HelperCodes.showToast(context,"${response.reasonPhrase}");
 return false;
}
}
Future addPhone(String id,String phone) async
{
 var phonebody={'phone':phone};
 var response=await http.put("${EntryPoints.ADD_PHONE_URL}$id",headers: {'Content-Type':'application/json'},body: jsonEncode(phonebody));
 if(response.statusCode==200)
 {
  var jsonresp=jsonDecode(response.body);
  if(jsonresp['update']){
   HelperCodes.showToast(context, jsonresp['msg']);
   return true;
  }
  else{
   HelperCodes.showToast(context, jsonresp['msg']);
   return false;
  }
 }
 else {
  HelperCodes.showToast(context, "${response.reasonPhrase}");
  return false;
 }
}
 Future deletePhone(String id,String phone) async
 {
  var phonebody={'phone':phone};
  var response=await http.put("${EntryPoints.DELETE_PHONE_URL}$id",headers: {'Content-Type':'application/json'},body: jsonEncode(phonebody));
  if(response.statusCode==200)
  {
   var jsonresp=jsonDecode(response.body);
   if(jsonresp['update']){
    HelperCodes.showToast(context, jsonresp['msg']);
    return true;
   }
   else{
    HelperCodes.showToast(context, jsonresp['msg']);
    return false;
   }
  }
  else {
   HelperCodes.showToast(context, "${response.reasonPhrase}");
   return false;
  }
 }
 Future addchat(String id,String user_id) async
 {
  var chat={'chat':user_id};
  var response=await http.put("${EntryPoints.ADD_CHAT_URL}$id",headers: {'Content-Type':'application/json'},body: jsonEncode(chat));
  if(response.statusCode==200)
  {
   var jsonresp=jsonDecode(response.body);
   if(jsonresp['update']){
    HelperCodes.showToast(context, jsonresp['msg']);
    return true;
   }
   else{
    HelperCodes.showToast(context, jsonresp['msg']);
    return false;
   }
  }
  else {
   HelperCodes.showToast(context, "${response.reasonPhrase}");
   return false;
  }
 }
 Future getUserInfo(String username)async{
 var response=await http.get("${EntryPoints.GET_USER_URL}?username=$username");
 if(response.statusCode==200){
  return jsonDecode(response.body);


 /*var phones=[];
  for(var phone in userjson['phones'])
   phones.add(phone);
  return User(userName:userjson['username'] , email: userjson['email'], password: userjson['password'], firstName:userjson['name']['firstname'],
      middleName: userjson['name']['middlename'], lastName:userjson['name']['lastname'],profileImage: userjson['profile_image'],phones:phones );*/
 }
}
}