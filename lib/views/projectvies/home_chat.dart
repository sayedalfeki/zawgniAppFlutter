import 'package:flutter/material.dart';
import 'package:hp_flutter_lablet/controller/entrypoints.dart';
import 'package:hp_flutter_lablet/controller/helper.dart';
import 'package:hp_flutter_lablet/controller/messages.controller.dart';
import 'package:hp_flutter_lablet/controller/user.controller.dart';
import 'package:hp_flutter_lablet/views/projectvies/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
class HomeChat extends StatefulWidget {
  @override
  _HomeChatState createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  String user_id;
  bool isconnected;
  var source;
  @override
  void initState() {
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

  }
  @override
  Widget build(BuildContext context) {
    return !isconnected||source==ConnectivityResult.none?Scaffold(
      appBar: AppBar(title: Text('no cennection available'),),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text('check your connection and try again'),
        ],
      ),),
    ):
    Scaffold(
      appBar: AppBar(title: Text('home chat'),),
      body:HelperCodes.checkConnection()==false?Center(child: Text('no internet connection'),) :FutureBuilder(
        future: UserDataBase().getUser(user_id),
        builder: (_, usersnap) {
          String username = usersnap.data['username'];
          List chats = usersnap.data['chats'];
          List uniquechats=[];
          for(var chat in chats)
            {
              if(!searchList(uniquechats, chat))
                uniquechats.add(chat);
            }
          bool isimage = usersnap.data['profile_image'].contains('upload');
          String path = usersnap.data['profile_image'].contains('upload')
              ? usersnap.data['profile_image'].substring(7)
              : 'assets/images/nophoto.jpg';
          return !usersnap.hasData
              ? Center(child: CircularProgressIndicator(),)
              :
              SingleChildScrollView(
                  child: Container(
                    height: 700,
                    child: ListView.builder(itemCount:uniquechats.length,
                        itemBuilder: (con, index) {
                          return ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/userchat',arguments: {
                                HomePage.Another_USER_ID:chats[index]
                              });
                            },
                            leading:CircleAvatar(backgroundColor: Colors.transparent,backgroundImage:
                            isimage?NetworkImage('${EntryPoints.IMAGE_URL}$path'):AssetImage(path),
                            ) ,

                            title: FutureBuilder(
                              future: UserDataBase().getUser(uniquechats[index]),
                                builder:(_,snap)=>snap.hasData? Text(snap.data['username'],style: TextStyle(
                                  fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black
                                ),):Text('data loading .......')),
                            subtitle: StreamBuilder(
                              stream:MessagesDatabase().getAlllastMessages(user_id, uniquechats[index]),
                              builder: (context, snapshot) {
                                //List msg=snapshot.data.docs;
                                return Text(snapshot.data.docs[0]['content']);
                              }
                            ),
                          );
                        }),
                  )


              );


        },
      ),
    );
  }
 bool  searchList(List mylist,String searchedword){
    bool founded=false;
    for(var item in mylist)
      if(item==searchedword)
        founded=true;
      return founded;
  }
}
