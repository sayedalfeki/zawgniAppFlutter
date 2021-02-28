import 'dart:convert';

import 'package:hp_flutter_lablet/controller/entrypoints.dart';
import 'package:hp_flutter_lablet/models/message.model.dart';
import 'package:http/http.dart'as http;
import 'package:cloud_firestore/cloud_firestore.dart';
class MessagesDatabase {
   SendMessage(Message msg)  {
     List users=[msg.id1,msg.id2];
     users.sort();
     String coll='${users[0]}${users[1]}';
    /* if(id1.compareTo(id2)<id2.compareTo(id1))
       coll='$id1$id2';
     else
       coll='$id2$id1';*/
  FirebaseFirestore.instance.collection('messages$coll').add(msg.toMap()).then((value) =>  true).catchError((err)=>false);
    
   /* var response = await http.post(EntryPoints.SEND_MESSAGE_URL,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(msg.toMap()));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      if (result['sending'])
        return true;
      else
        return false;
    }
    else
      return false;*/
  }

  Future getUserMessages(String user) async
  {
   var sendr= FirebaseFirestore.instance.collection('messages').where('sender',isEqualTo:user ).snapshots();
   var sending=FirebaseFirestore.instance.collection('messages').where('sendingto',isEqualTo:user ).snapshots();
   var response = await http.get('${EntryPoints
        .GET_ALL_USER_MESSAGE_URL}?user=$user');
    if (response.statusCode == 200)
      return jsonDecode(response.body);
    else
      throw('server closed');
  }

  getAllBetMessages(String id1,String id2)
  {
    List users=[id1,id2];
    users.sort();
    String coll='${users[0]}${users[1]}';
   /* if(id1.compareTo(id1)<id2.compareTo(id1))
      coll='$id1$id2';
    else
      coll='$id2$id1';*/
    return FirebaseFirestore.instance.collection('messages$coll').orderBy('messagetimr').snapshots();

/*
    var response = await http.get(
        '${EntryPoints.GRT_ALL_BET_MESSAGE_URL}?user1=$user1&user2=$user2');
    if (response.statusCode == 200)
      return jsonDecode(response.body);
    else
      throw('server closed');*/
  }
   getAlllastMessages(String id1,String id2)
   {
     List users=[id1,id2];
     users.sort();
     String coll='${users[0]}${users[1]}';
     /* if(id1.compareTo(id1)<id2.compareTo(id1))
      coll='$id1$id2';
    else
      coll='$id2$id1';*/
     return FirebaseFirestore.instance.collection('messages$coll').orderBy('messagetimr').limitToLast(1).snapshots();

/*
    var response = await http.get(
        '${EntryPoints.GRT_ALL_BET_MESSAGE_URL}?user1=$user1&user2=$user2');
    if (response.statusCode == 200)
      return jsonDecode(response.body);
    else
      throw('server closed');*/
   }
   getAllotherMessages(String user1,String user2)
   {
     return FirebaseFirestore.instance.collection('messages').where('between',isEqualTo: [user2,user1]).snapshots();

/*
    var response = await http.get(
        '${EntryPoints.GRT_ALL_BET_MESSAGE_URL}?user1=$user1&user2=$user2');
    if (response.statusCode == 200)
      return jsonDecode(response.body);
    else
      throw('server closed');*/
   }


}