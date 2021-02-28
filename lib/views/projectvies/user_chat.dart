import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hp_flutter_lablet/controller/entrypoints.dart';
import 'package:hp_flutter_lablet/controller/helper.dart';
import 'package:hp_flutter_lablet/controller/messages.controller.dart';
import 'package:hp_flutter_lablet/controller/user.controller.dart';
import 'package:hp_flutter_lablet/models/message.model.dart';
//import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hp_flutter_lablet/views/projectvies/homepage.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
class UserChat extends StatefulWidget {
  @override
  _UserChatState createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  var msgctr=TextEditingController();
  String URI = EntryPoints.BASE_URL;
  String user_id;
  Map args;
 // SocketIOManager manager;
 // SocketIO socket;
  var msg = "";
  List ids=[];
  List Messagelist=[];
  var senderctr=TextEditingController();
  var sendingtorcr=TextEditingController();
  String another_user;
  bool isconnected;
  var source;
  @override
  void initState() {
    //saveMessage('no_one','no_one','nothing');
  //getMessages();
    SharedPreferences.getInstance().then((value) =>  setState(() {
user_id=value.getString('user_id');
    }));
    HelperCodes.checkConnection().then((value) =>setState(() {
      isconnected=value;
    }));
    HelperCodes.listenToConnection().listen((event) {
      setState(() {
        source=event;
      });
    });
    super.initState();

    //manager=SocketIOManager();
    //initSocket();
  }
 /* initSocket()async
  {
socket=await manager.createInstance(SocketOptions(URI,enableLogging: false,query: {'uid':'1'}));
socket.onConnect((data) {
  print('connected');
});
socket.on("msg", (data) {
  print("${data["message"]}" + "-----");
  setState(() {
    msg = data["message"];
    print("$msg" + "*****");
  });
});
socket.connect();
  }
  send(var msg){
    socket.emit("msg",[{
      "message": "$msg",
      "room": "1",
      "name" : "morad"
    }]
    );
  }



  disconnect(){
    manager.clearInstance(socket);
  }*/
  @override
  Widget build(BuildContext context) {
    args=ModalRoute.of(context).settings.arguments as Map ;
    another_user=args[HomePage.Another_USER_ID];
   /* return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text("Send"),
              onPressed: (){
                send("hello flutter111");
              },
            ),
            Text("$msg"),
            RaisedButton(
              child: Text("disconnect"),
              onPressed: (){
                disconnect();
              },
            ),
            RaisedButton(
              child: Text("connect"),
              onPressed: (){
                initSocket();
              },
            )
          ],
        ),
      ),
    );*/
    return !isconnected||source==ConnectivityResult.none?
    Scaffold(
      appBar: AppBar(title: Text('no connection available'),),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text('check your connection and try again'),
        ],
      ),),
    ):
    Scaffold(
      appBar: AppBar(title:FutureBuilder(
          future: UserDataBase().getUser(another_user),
          builder:(_,usnap)=>!usnap.hasData?Text('data loading .....') :Text(usnap.data['username']))),
      body: ListView(
          children:[
          Container(
          child: Column(

           children:[
             Center(child: Text('type message to another user')),
             StreamBuilder(
            stream:MessagesDatabase().getAllBetMessages(user_id,another_user),//MessagesDatabase().getAllBetMessages('sayed', 'sara'),
               builder:(ctx,snap){
              List docs1=snap.data.docs;

             // docs1.sort();
               /*  Messagelist.clear();
                 var ext=snap.data as Map<String,dynamic>;
                 ext.forEach((key, value) {
                   Messagelist.add({
                     'sender':value['sender'],
                     'message':value['message']
                   });
                 });*/
          return  !snap.hasData?Center(child: CircularProgressIndicator(),):
    Container(
               height: 650,
                  child: ListView.builder(itemCount:docs1.length,itemBuilder: (_,index){
                    return /*Card(
                      child: Column(
                    children: [*/
                          /*Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(docs1[index]['between'][0]=='sayed'?docs1[index]['between'][0]:''),
                            ],
                          ),*/
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment:docs1[index]['sender']==user_id?MainAxisAlignment.end:MainAxisAlignment.start,
                              children: [
                                Container(
margin: EdgeInsets.only(right: docs1[index]['sender']==user_id?10:0,left: docs1[index]['sender']==user_id?0:10),
                                  width:150,
                                    height: 50,
                                    decoration:BoxDecoration(
                                        color:docs1[index]['sender']==user_id?Colors.blue:Colors.green,
                                        borderRadius: BorderRadius.only(topLeft:Radius.circular(14) ,
                                            bottomLeft:docs1[index]['sender']==user_id?Radius.circular(0):Radius.circular(14) ,topRight:Radius.circular(14) ,
                                            bottomRight:docs1[index]['sender']==user_id? Radius.circular(14):Radius.circular(0))
                                    ),
                                    child: Center(child: ListView(
                                        children:[ Text(docs1[index]['content'],style: TextStyle(color: Colors.white,fontSize:17),)]))),
                              ]
                            ),
                          );
                     /* Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(docs1[index]['between'][1]=='sami'?docs1[index]['between'][1]:''),
                        ],
                      ),
                      Row(
                          mainAxisAlignment:MainAxisAlignment.start,
                          children: [
                            Text(docs1[index]['between'][1]=='sami'?docs1[index]['content']:''),
                          ]
                      ),*/
                        }));
      }),

             Row(
               children: [
                 Expanded(child: Container(
                     margin: EdgeInsets.symmetric(horizontal: 20),
                     decoration: BoxDecoration(border: Border.all(color: Colors.black45,width: 0.5)),
                     child: TextField(decoration: InputDecoration(hintText: 'enter your message',labelText: 'message'),controller: msgctr,))),
                 IconButton(icon: Icon(Icons.send,color: Colors.blue,),onPressed: ()async{
                 /*  Message msg=Message(sender: 'sayed',sendingto: 'sara',content: msgctr.text);
                   var result=await MessagesDatabase().SendMessage(msg);
                   if(result)

                   else
                   HelperCodes.showToast(context, 'error');*/
                   MessagesDatabase().SendMessage(Message(id1:user_id,id2:another_user,sender:user_id,sendingto:another_user,content: msgctr.text));
                   var user=await UserDataBase().getUser(user_id);
                   List chats=user['chats'];
                   bool founded=searchArray(chats, another_user);
                  if(!founded)
                    UserDataBase().addchat(user_id, another_user);
                   var user2=await UserDataBase().getUser(another_user);
                   List chats2=user2['chats'];
                   bool founded2=searchArray(chats2,user_id);
                   if(!founded2)
                     UserDataBase().addchat(another_user,user_id );
                  // saveMessage(senderctr.text,sendingtorcr.text, msgctr.text);
                   setState(() {
                     Messagelist.clear();
                     msgctr.clear();
                   });
                 },),
                 /*IconButton(icon: Icon(Icons.refresh), onPressed:(){
                   setState(() {
                   });
                 })*/
               ],
             )
           ]
          ),
        ),]
      ),
    );
  }
saveMessage(String sender,String sendingto,String msg)async
{
 /*var res=await http.post('https://zawageapp-default-rtdb.firebaseio.com/messages.json',body: jsonEncode({ 'sender':sender,
    'sendingto':sendingto,
    'message':msg,}));
 var name=jsonDecode(res.body);
 ids.add(name['name']);*/
 /* DatabaseReference database=FirebaseDatabase.instance.reference().child('messages');
// database.set(10);
  database.push().set({
    'sender':sender,
    'sendingto':sendingto,
    'message':msg,

  });*/
  FirebaseFirestore.instance.collection('messages').add({
   'sender':sender,
   'sendingto':sendingto,
   'content':msg,
   'messagetime':Timestamp.now()
 });
}
getMessages()
{
  List mymsg=[];
 /* //DatabaseReference database=FirebaseDatabase.instance.reference().child('messages');
  List<Map<String,dynamic>> msglist=[];
  var res=await http.get('https://zawageapp-default-rtdb.firebaseio.com/messages.json');
  if(res.statusCode==200)
  {
    return jsonDecode(res.body);
   *//* print( jsonDecode(res.body));
    var ext=jsonDecode(res.body) as Map<String,dynamic>;
    ext.forEach((key, value) {
      msglist.add({
        'sender':value['sender'],
        'message':value['message']
      });
    });*//*
   //return msglist;
  }
  return msglist;*/
 return  FirebaseFirestore.instance.collection('messages').orderBy('messagetime').snapshots(includeMetadataChanges: true);
 /* data.docs.forEach((element) {
    mymsg.add(
      {
        'sender':element['sender'],
        'sendingto':element['sendingto'],
        'content':element['content']
      }
    );
  });
  return mymsg;*/
}
searchArray(List mylist,String searched)
{
  bool found =false;
  for(var name in mylist)
    if(name==searched)
      found=true;
    return found;
}
}
