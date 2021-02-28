import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hp_flutter_lablet/controller/entrypoints.dart';
import 'package:hp_flutter_lablet/controller/helper.dart';
import 'package:hp_flutter_lablet/controller/product.controller.dart';
import 'package:hp_flutter_lablet/controller/user.controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
class HomePage extends StatefulWidget {
  static final String PRODUCT_ID='product_id';
  static final String PRODUCT_SELLER='product_seller';
  static final String PRODUCT_NAME='product_name';
  static final String PRODUCT_CATEGORY='product_category';
  static final String PRODUCT_SUBCATEGORY='product_subcategory';
  static final String PRODUCT_DETAILS='product_details';
  static final String PRODUCT_PRICE='product_price';
  static final String PRODUCT_QUANTITY='product_quantity';
  static final String PRODUCT_PHOTO='product_photo';
  static final String PRODUCT_LIKES='product_likes';
  static final String PRODUCT_DISLIKES='product_dislikes';
  static final String PRODUCT_LIKED='product_liked';
  static final String USER_ID='user_id';
  static final String Another_USER_ID='another_user_id';

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  String user_type,username="",path;
  String id;
  SharedPreferences pref;
  bool isvisible=false;
  bool issearched=false;
  String searched_word="golden";
  double height=1000;
bool isconnected=false;
  var btncolor=Colors.lime;
  var source;
  bool clear=false;
  @override
  void initState() {

    super.initState();
    SharedPreferences.getInstance().then((value) => {
    setState(() {
         user_type=value.getString('user_type');
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
  }

  @override
  Widget build(BuildContext context) {

    return !isconnected||source==ConnectivityResult.none?Scaffold(
      appBar: AppBar(title: Text('no connection available'),),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text('check your connection and try again'),
        ],
      ),),
    ): Scaffold(
           appBar: AppBar(title:id==null||id.isEmpty?Text('home page'):
           FutureBuilder(
             future: UserDataBase().getUser(id) ,
             builder:(_,snap) {
               return !snap.hasData?Text('loading data .....'):Text(
                 snap.data['username']
               );
             },
           ),),
           body:Container(
             child: ListView(
               children:  [
                         Container(
                           height: 60,
                           margin: EdgeInsets.only(top:20,left: 10,right: 10),
                           decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.blue),),
                           child: TextField(
                             onTap: (){
                               setState(() {
                                 clear=true;
                               });
                             },
                             decoration: InputDecoration(
                                 suffixIcon: Icon( Icons.search),
                               labelText: 'search',
                               hintText: 'type here your search'),onChanged: (vale){
                             if(vale.isEmpty)
                               setState(() {
                                 searched_word=vale;
                                 issearched=false;
                                 isvisible=false;
                               });
                             else
                             setState(() {
                               searched_word=vale;
                               issearched=true;
                             isvisible=true;
                           });},),
                         ),
    SizedBox(height: 10,),
    Container(
height: 650,
     child: FutureBuilder(
      future:issearched&&user_type=='seller'?ProductDatabase().searchProductsBySeller(id,searched_word):
      issearched&&user_type=='customer'?ProductDatabase().searchProducts(searched_word):
      user_type==null||user_type=='customer'?ProductDatabase().getAllProducts():ProductDatabase().getSellerProducts(id),
      builder:(ctx,snap){
                   var data=snap.data;
        return !snap.hasData?Center(child: CircularProgressIndicator()):
        GridView.builder(
          itemCount: snap.data.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 130,
          childAspectRatio: 4/8,
          mainAxisSpacing: 5,crossAxisSpacing: 5
        ), itemBuilder: (con,index){
          String path=snap.data[index]['productphotos'][0];
          String photopath="${EntryPoints.IMAGE_URL}${path.substring(7)}";
  return  InkWell(
    onTap:()=> goToProduct(index,snap),
    child: Stack(
        children:[
          Container(
                margin:EdgeInsets.only(top:10),
          child: Card(color: Colors.cyan,
                  elevation: 20,
                  child: Column(
                      children: [
                        Container(
                            height: 120,
                            width: 120,
                          child: Image.network(photopath),
                        ),
                        SizedBox(height: 20,),
                        Text(snap.data[index]['productname'],style: TextStyle(fontSize:15,fontWeight: FontWeight.bold,color: Colors.white),),
                        SizedBox(height: 20,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("${snap.data[index]['price']} LE", overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo)),
                            ],
                        )
                      ],
                  ),
                ),
          ),

                  ]
    ),
  );
        },);
     },
    ),
                          ),
                       ],
                     ),
             ),
      floatingActionButton: user_type == 'seller' ? FloatingActionButton(
             onPressed: () {
id.isEmpty?Navigator.pushReplacementNamed(context, '/loginpage'):Navigator.pushNamed(context, '/addproduct');
             }, child: Icon(Icons.add),) : null,
          drawer:id==null||id.isEmpty?null:Drawer(child:
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 200,
                  width: 200,
                  child: Center(child: FutureBuilder(
                    future:  UserDataBase().getUser(id),
                    builder:(_,snap)=>!snap.hasData?Text('loading image ....'): CircleAvatar(
                      radius:100,backgroundColor: Colors.transparent,
                      backgroundImage: !snap.data['profile_image'].contains('upload')?AssetImage('assets/images/nophoto.jpg'):NetworkImage("${EntryPoints.IMAGE_URL}${snap.data['profile_image'].substring(7)}"),)),),
                ),
                SizedBox(height:15),
                FutureBuilder(
                    future:UserDataBase().getUser(id),
                    builder:(_,snap)=> !snap.hasData?Text('........'):Text(snap.data['username'],style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),)),
                SizedBox(height:30),
                Container(
                  margin: EdgeInsets.only(top: 10),

                  height: 1,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12,width: 0.5)),),
                Container(
                  
                  child: Column(
                    children: [
                      ListTile(
                        onTap:(){
                Navigator.pushNamed(context, '/userpage');
                },
                        leading:Icon(Icons.person),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                           Text('profile')
                          ],
                        ),
                        subtitle: Text('go to profile page'),
                        trailing: Icon(Icons.arrow_right),
                      ),
                      ListTile(
                        onTap:(){
                          Navigator.pushNamed(context,'/homechat');
                        } ,
                        leading:Icon(Icons.chat),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                           Text('chat')
                          ],
                        ),
                        subtitle: Text('go to chat page'),
                        trailing: Icon(Icons.arrow_right),
                      ),
                      ListTile(
                        onTap:()async{
                          SharedPreferences pref=await SharedPreferences.getInstance();
                          pref.setString("user_id", "");
                          //Navigator.pushReplacementNamed(context,'/');
                          exit(0);
                        } ,
                        leading:Icon(Icons.exit_to_app),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('logout')
                          ],
                        ),
                        subtitle: Text('exit from the app'),
                        trailing: Icon(Icons.arrow_right),
                      )
                    ],
                  ),
                )


              ],
            ),
          ),),
         );
  }
  goToProduct(int index,AsyncSnapshot snap){
    Navigator.pushNamed(context, '/productpage',arguments: {
      HomePage.PRODUCT_ID:snap.data[index]['_id'],
      HomePage.PRODUCT_NAME:snap.data[index]['productname'],
      HomePage.PRODUCT_CATEGORY:snap.data[index]['category'],
      HomePage.PRODUCT_SUBCATEGORY:snap.data[index]['subcategory'],
      HomePage.PRODUCT_SELLER:snap.data[index]['seller'],
      HomePage.PRODUCT_DETAILS:snap.data[index]['details'],
      HomePage.PRODUCT_PRICE:snap.data[index]['price'],
      HomePage.PRODUCT_QUANTITY:snap.data[index]['quantity'],
      HomePage.PRODUCT_PHOTO:snap.data[index]['productphotos'],
      HomePage.PRODUCT_LIKES:snap.data[index]['likes'],
      HomePage.PRODUCT_DISLIKES:snap.data[index]['dislikes'],
      // HomePage.PRODUCT_LIKED:snap.data[index]['liked'],
    });
  }
  getUsertype()async {
    pref=await SharedPreferences.getInstance();
   return pref.get('user_type');
  }
 bool searchlist(List mylist,String id)
  {
    bool founded=false;
    for(int i=0;i<mylist.length;i++)
      if(id==mylist[i])
        founded=true;
      return founded;
  }
}
/*
*    /*ListView.builder(itemCount:data.length,itemBuilder:(con,index)=>ListTile(
  onTap: (){
    goToProduct(index, snap);
  },
        leading: Text(data[index]['productname']),

        title: Text('${data[index]['price']}'),

      ));*/
    /*isvisible?Container(height: 0,):Container(
  height: height,
  child: FutureBuilder(
    future:user_type=='customer'?ProductDatabase().getAllProducts():ProductDatabase().getSellerProducts(id),
    builder:(ctx,snap) {
      return !snap.hasData?Center(child: CircularProgressIndicator(),):
      GridView.builder(
        itemCount:snap.data.length ,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent:200 ,
          childAspectRatio: 3/2,
          mainAxisSpacing: 20
      ), itemBuilder: (_,index){
        String path=snap.data[index]['productphotos'][0];
        String photopath="${EntryPoints.IMAGE_URL}${path.substring(7)}";
        return InkWell(
          child: Container(
            child: Card(
              color: Colors.cyan,
              elevation: 20,
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Image.network(photopath),
                  ),
                  Text(snap.data[index]['productname']),
                  Text("${snap.data[index]['price']}")
                ],
              ),
            ),
          ),
        );
      },);
 *//*     ListView.builder(itemCount:snap.data.length,itemBuilder: (con,index){
        String path=snap.data[index]['productphotos'][0];
        String photopath="${EntryPoints.IMAGE_URL}${path.substring(7)}";
        List likes=snap.data[index]['likes'];
        bool liked=searchlist(likes, id);
        return  ListTile(
          onTap: (){
           goToProduct(index, snap);

          },
          leading: Container(width:100,height:100,child: Image.network(photopath),),
          title: Text(snap.data[index]['productname']),
          subtitle: Text(snap.data[index]['details']==null?"no details found":snap.data[index]['details']),
          trailing: Text('${snap.data[index]['price']}'),

        );}
      );*//*
    },
))*/
//!isvisible?Container(height: 0,):
 */
 

