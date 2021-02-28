import 'package:cloud_firestore/cloud_firestore.dart';
class Message
{
  String id1, id2 ,sender,sendingto,content;
  Message({this.id1,this.id2,this.sender,this.sendingto,this.content});
  Map<String ,dynamic> toMap()
  {
    return
      {
        'sender':sender,
        'sendingto':sendingto,
        'content':content,
        'messagetimr':Timestamp.now()
      };
  }
}