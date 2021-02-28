import 'package:flutter/material.dart';
import 'package:hp_flutter_lablet/controller/entrypoints.dart';
import 'package:hp_flutter_lablet/controller/helper.dart';
import 'package:hp_flutter_lablet/controller/user.controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity/connectivity.dart';
class UserProfile extends StatefulWidget {
  static final USER_ID='user_id';
  static final USER_NAME='user_name';
  static final USER_FIRST_NAME='user_first_name';
  static final USER_MIDDLE_NAME='user_middle_name';
  static final USER_LAST_NAME='user_last_name';
  static final USER_EMAIL='user_email';
  static final USER_PHONE='user_phone';
  static final USER_IMAGE='user_image';
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String firstname,middlename,lastname,username,email,phone;
  String id='';
  bool isvisible=false;
  bool added=false;
  bool update=false;
  var phone_ctr=TextEditingController();
  var firstname_ctr=TextEditingController();
  var middlename_ctr=TextEditingController();
  var lastname_ctr=TextEditingController();
  bool isconnected;
  var source;
  @override
  void initState() {
    // TODO: implement initState
    try {
      super.initState();
       SharedPreferences.getInstance().then((value) => {
       setState(() {
         id=value.getString('user_id');
       })

       });
      HelperCodes.checkConnection().then((value) =>setState(() {
        isconnected=value;
      }));
      HelperCodes.listenToConnection().listen((event) {
        setState(() {
          source=event;
        });
      });
    }catch(e){
      HelperCodes.showToast(context, e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget mycontainer(child)=>Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.black45)),
      child:child ,
    );
    return  !isconnected||source==ConnectivityResult.none?Scaffold(
      appBar: AppBar(title: Text('no connection available'),),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text('check your connection and try again'),
        ],
      ),),
    ):FutureBuilder(
      future: UserDataBase().getUser(id),
      builder:(ctx,snap) {
        String path=snap.data['profile_image'];

       return !snap.hasData ? Center(child: CircularProgressIndicator(),) : Scaffold(
          appBar: AppBar(title: Text(snap.data['username']),),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 200,
                child: InkWell(
                  onTap: (){
                              setState(() {
                                isvisible=!isvisible;
                              });
                            },
                            child: Center(
                              child:CircleAvatar(
                                radius: 100,

                                backgroundImage:path.contains('upload') ?
                               NetworkImage("${EntryPoints.IMAGE_URL}${snap.data['profile_image'].substring(7)}") : AssetImage('assets/images/nophoto.jpg') ,
                              ) ,),
                          )),
                         !isvisible?Container(): Row(
                           mainAxisAlignment:MainAxisAlignment.center,
                           children: [
                            IconButton(
                              iconSize: 50,
                              color: Colors.blue,
                              icon: Icon(Icons.photo),onPressed: ()async{
                              UpdateImage(id,ImageSource.gallery);

                            },),
                            IconButton(
                              iconSize: 50,
                              color: Colors.blue,
                              icon: Icon(Icons.camera_alt),onPressed: (){ UpdateImage(id,ImageSource.camera);},),
                          ],),
                  Text(snap.data['email'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                  update?Card(
                    child: Container(
                      height: 250,
                      child: Column(children: [
                        mycontainer( TextField(
                          style: TextStyle(color: Colors.redAccent,fontSize:15),
                          decoration: InputDecoration(
                              hintText: 'enter first name',labelText: 'first name'),controller: firstname_ctr,)),
                        SizedBox(height: 5,),
                        mycontainer( TextField( style: TextStyle(color: Colors.redAccent,fontSize: 15),decoration: InputDecoration(hintText: 'enter middle name',labelText: 'middle name'),controller: middlename_ctr,)),
                        SizedBox(height: 5,),
                        mycontainer( TextField( style: TextStyle(color: Colors.redAccent,fontSize: 15),decoration: InputDecoration(hintText: 'enter last name',labelText: 'last name'),controller: lastname_ctr,)),
                        RaisedButton(
                            color: Colors.blue,
                            child:Text(
                            'update', style: TextStyle(color: Colors.white,fontSize:15)),onPressed: (){
                          UserDataBase().updateName(id, firstname_ctr.text, middlename_ctr.text, lastname_ctr.text);
                          setState(() {
                            update=false;
                          });
                        })
                      ],),
                    ),
                  ):Padding(
                    padding: const EdgeInsets.only(left:100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Text('${snap.data['name']['firstname']}  ${snap.data['name']['middlename']}  ${snap.data['name']['lastname']}',
                        style: TextStyle(color: Colors.black54,fontWeight: FontWeight.normal,fontSize: 20),
                        )),
                       IconButton(
                           color: Colors.blue,
                           icon: Icon(Icons.edit), onPressed: (){
                         firstname_ctr.text=snap.data['name']['firstname'];
                         middlename_ctr.text=snap.data['name']['middlename'];
                         lastname_ctr.text=snap.data['name']['lastname'];
                         setState(() {
                           update=true;
                         });
                       })

                      ],
                    ),
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text('phones:',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                ],
              ),
                  added?Card(
                    child: Container(
                      height: 300,
                      child: Column(
                        children: [
                          mycontainer( TextField(decoration: InputDecoration(hintText: 'enter phone',labelText: 'phone'),controller: phone_ctr,)),
                          Center(child: RaisedButton(
                            color: Colors.blue,
                            onPressed: ()async{
                            UserDataBase().addPhone(id,phone_ctr.text);
                            setState(() {
                              added=false;
                            });
                          },child: Text('add',style: TextStyle(color: Colors.white),),),)
                        ],
                      ),
                    ),
                  ): Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                      height: 200,
                      child: ListView.builder(itemCount:snap.data['phones'].length,itemBuilder:(_,index){
                        return Row(
                          children: [Expanded(flex:7, child: Text(snap.data['phones'][index]==null?'no phones add?':snap.data['phones'][index],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue),)) ,
                             Expanded(child: IconButton(
                                 color: Colors.red,
                                 icon: Icon(Icons.delete), onPressed:snap.data['phones'].length==1?null:(){
                               UserDataBase().deletePhone(id,snap.data['phones'][index]);
                               setState(() {
                                 added=false;
                               });
                             })),
                            Expanded(child: IconButton(
                                color: Colors.blue,
                                icon: Icon(Icons.add), onPressed:(){
                              setState(() {
                                added=true;
                              });
                            }))
                          ],

                         // Expanded(child: IconButton(icon: Icon(Icons.add), onPressed:(){}))

                      );}),
                    ),

                 /* Center(child: RaisedButton(onPressed: (){
                    Navigator.pushNamed(context,'/edituser',arguments: {
                      UserProfile.USER_ID:snap.data['_id'],
                      UserProfile.USER_FIRST_NAME:snap.data['name']['firstname'],
                      UserProfile.USER_MIDDLE_NAME:snap.data['name']['middlename'],
                      UserProfile.USER_LAST_NAME:snap.data['name']['lastname'],
                      UserProfile.USER_NAME:snap.data['username'],
                      UserProfile.USER_EMAIL:snap.data['email'],
                      UserProfile.USER_PHONE:snap.data['phones'][0],
                      UserProfile.USER_IMAGE:snap.data['profile_image'],
                    });
                  },child: Text('edit'),),)*/
                ],
              ),
            ),
          ),
        );
      },
    );
   /* return FutureBuilder(
        future: UserDataBase().getUser(id),
        builder:(ctx,snap){
          firstname=snap.data['name']['firstname'];
          return Scaffold(
  appBar: AppBar(title: Text('user page'),),
  body: Container(
    child: Column(
      children: [
        Text(firstname),
       // Text(middlename),
       // Text(lastname),
      ],
    ),
  ),
);
        } );*/
  }
 Future getid()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    id= pref.getString('user_id');
    setState(() {

    });

  }
  Future UpdateImage(String id,ImageSource src)async {

    PickedFile myfile=await HelperCodes.getimage(src);
    if(myfile!=null)
    {
     bool result=await UserDataBase().updateProfileImage(id,myfile.path);
     if(result)
       setState(() {
    isvisible=false;
     });
    }
  }
}
