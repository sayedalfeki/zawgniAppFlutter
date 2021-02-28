import 'package:flutter/material.dart';
import 'package:hp_flutter_lablet/controller/entrypoints.dart';
import 'package:hp_flutter_lablet/controller/helper.dart';
import 'package:hp_flutter_lablet/controller/product.controller.dart';
import 'package:hp_flutter_lablet/controller/user.controller.dart';
import 'package:hp_flutter_lablet/models/product.model.dart';
import 'package:hp_flutter_lablet/views/projectvies/homepage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity/connectivity.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
class ProductDetails extends StatefulWidget {

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String productname,category,subcategory,details,seller,id,user_id;
  int price,quantity;
  List photos;
  List likes;
  List dislikes;
  var by=TextEditingController();
  var content=TextEditingController();
  var proctr=TextEditingController();
  var catctr=TextEditingController();
  var subcatctr=TextEditingController();
  var detctr=TextEditingController();
  var pricectr=TextEditingController();
  var quantityctr=TextEditingController();
  var args;
  bool isvisible=false;
  var likecolor=Colors.black12;
  bool pressed=false;
  bool liked;
  bool liked2;
  bool disliked;
  bool disliked2;
  int index=1;
  int disindex=1;
  int length;
  int dislength;
  String user_type;
  bool editimage=false;
  bool isconnected;
  var source;
  bool isedit=false;
  double rate=50.0;
  @override
  void initState() {
    super.initState();
    setState(() {
    });
    SharedPreferences.getInstance().then((value) => {
setState(() {
user_id=value.getString('user_id');
user_type=value.get('user_type');
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
  var textstyle=(double size,FontWeight fontWeight,Color color)=>TextStyle(
      fontSize: size,
      color: color,
      fontWeight: fontWeight
  );
  Widget build(BuildContext context) {
    args=ModalRoute.of(context).settings.arguments as Map;
    productname=args[HomePage.PRODUCT_NAME]!=null?args[HomePage.PRODUCT_NAME]:"";
    price=args[HomePage.PRODUCT_PRICE]!=null?args[HomePage.PRODUCT_PRICE]:"";
    quantity=args[HomePage.PRODUCT_QUANTITY]!=null?args[HomePage.PRODUCT_QUANTITY]:"";
    category=args[HomePage.PRODUCT_CATEGORY]!=null?args[HomePage.PRODUCT_CATEGORY]:"";
    subcategory=args[HomePage.PRODUCT_SUBCATEGORY]!=null?args[HomePage.PRODUCT_SUBCATEGORY]:"";
    seller=args[HomePage.PRODUCT_SELLER]!=null?args[HomePage.PRODUCT_SELLER]:"";
    details=args[HomePage.PRODUCT_DETAILS]!=null?args[HomePage.PRODUCT_DETAILS]:"";
    id=args[HomePage.PRODUCT_ID]!=null?args[HomePage.PRODUCT_ID]:"";
    photos=args[HomePage.PRODUCT_PHOTO];
    likes=args[HomePage.PRODUCT_LIKES];
    dislikes=args[HomePage.PRODUCT_DISLIKES];
    liked=searchlike(user_id);
    disliked=searchdislike(user_id);
    if(index==1)
    {
      liked2=liked;
    }
    if(disindex==1)
    {
      disliked2=disliked;
    }

    return  !isconnected||source==ConnectivityResult.none?Scaffold(
      appBar: AppBar(title: Text('no connection available'),),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text('check your connection and try again'),
        ],
      ),),
    ): Scaffold(
      appBar: AppBar(
        title: Text('product details page'),
      ),
      body:/*FutureBuilder(
        future: ProductDatabase().getProduct(id),
        builder: (ctx,snap){
          List likes=snap.data['likes'];
          return !snap.hasData?Center(child: CircularProgressIndicator(),):Container(
            child: Column(
children: [
  Text(snap.data['productname']),
  Text('${likes.length}'),
],
            ),
          );
        },
      )*/


     user_type=='seller'?getSellerPage(id):SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(color:Colors.cyan,border: Border.all(width: 1,color: Colors.black12)),
                            width: 200,
                            child:CarouselSlider(
                          options: CarouselOptions(
                              enlargeCenterPage: true,
                              height: 200,initialPage: 0,autoPlay: true),
                          items: photos.map((e) {
                            return Image.network("${EntryPoints.IMAGE_URL}${e.substring(7)}");}).toList(),
                        )),
                        FutureBuilder(
                          future: ProductDatabase().getProductRate(id),
                          builder:(_,ratesnap){
                            double frate=1;
                            List rates=ratesnap.data;
                            int ratesize=rates.length;
                            int sum=0;
                            for(var prorate in rates)
                              sum+=prorate['percent'];
                            frate=(sum/ratesize);
                            return !ratesnap.hasData?Text('loading rate .....'):rates.length<1?
                            Text('no rates yet ...')
                           : Column(
                             children: [
                               SmoothStarRating(
                                  rating:frate/20 ,
                                starCount: 5,
                                size: 30,
                                isReadOnly: true,
                          ),
                               Text('$frate')
                             ],
                           );}
                        )
                      ],
                    ),),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Text(productname,style: textstyle(20,FontWeight.bold,Colors.black),),
                        SizedBox(height: 10,),
                        Text(category,style: textstyle(15,FontWeight.w900,Colors.black)),
                        SizedBox(height: 10,),
                        Text(subcategory,style: textstyle(15,FontWeight.w900,Colors.black)),
                        SizedBox(height: 10,),
                        Text(details, style:textstyle(14,FontWeight.normal,Colors.black45)),
                        SizedBox(height: 10,),
                        Text("$price LE",style: textstyle(20,FontWeight.bold,Colors.lightBlueAccent)),
                        SizedBox(height: 10,),
                        FutureBuilder(
                          future: UserDataBase().getUser(seller),
                            builder:(_,selsnap)=>!selsnap.hasData?Text('no seller'): Text(selsnap.data['username']==null?'no user':'by : ${selsnap.data['username']}',style: textstyle(15,FontWeight.bold,Colors.black))),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('comments',style: textstyle(15,FontWeight.bold,Colors.black),),
                ],
              ),
              FutureBuilder(
               future:ProductDatabase().getAllComments(id),
               builder:(ctx,snap){
                 List comments=snap.data;
                 int length=comments.length;
                 return !snap.hasData||snap.data.length<1?Container(height: 0,):
                     Container(
                       height: 200,
                       decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.black12)),
                       child: ListView.builder(
                           itemCount: length,
                           itemBuilder: (con,index)
                       {

                         String date=DateTime.fromMillisecondsSinceEpoch(int.parse(snap.data[index]['commenttime'])).toString();
                        String newdate= date.substring(0,10);
                          return  FutureBuilder(
                            future: UserDataBase().getUser(comments[index]['commentedby']),
                            builder:(con,snap2){
                              bool image;
                              String path;
                              image= snap2.data['profile_image'].contains('upload')?image=true:image=false;
                              path=snap2.data['profile_image'].contains('upload')?snap2.data['profile_image'].substring(7):'assets/images/nophoto.jpg';
                              return !snap2.hasData?Container(
                               height: 0,
                              ): ListTile(
                             leading: Container(
                               height: 50,
                               width: 50,
                               child:CircleAvatar(radius: 100,backgroundImage:image? NetworkImage('${EntryPoints.IMAGE_URL}$path'):
                               AssetImage('assets/images/nophoto.jpg'),backgroundColor: Colors.transparent,)

                             ),
                             title: Text(snap2.data['username'],style: textstyle(16,FontWeight.bold,Colors.black),),
                             subtitle:Text(snap.data[index]['content'],style: textstyle(18,FontWeight.normal,Colors.indigo),) ,
                              trailing: Text(newdate),
                         );},
                          );
                       }),
                     );
               } ,

             ),
              SizedBox(height: 40,),
              user_id==null||user_id.isEmpty?Container():FutureBuilder(
                future: ProductDatabase().getProduct(id),
                builder:(_,psnap){
              List likesList=psnap.data['likes'];
              List dislikesList=psnap.data['dislikes'];
              bool islikedbyuser=SearchList(likesList, user_id);
              bool isdislikedbyuser=SearchList(dislikesList, user_id);
                  return !psnap.hasData?Text('loading......'): Row(children: [
                  SizedBox(width: 30,),
                  InkWell(child: Icon(Icons.thumb_up,color:!islikedbyuser? Colors.black12:Colors.blue,),onTap: ()async
                  {
                    if(!islikedbyuser)
                    {
                      if(isdislikedbyuser)
                        ProductDatabase().unDisLike(id, user_id);

                      ProductDatabase().addLike(id,user_id);
                    }
                    else
                      {
                        ProductDatabase().unLike(id, user_id);
                      }
                    setState(() {

                    });
                   // liked=searchlike(user_id);
                    //pressed=!pressed;
                    /*if(liked2==false) {
                      bool isliked = await ProductDatabase(context: context)
                          .addLike(id, user_id);
                      if (isliked) {
                      int len=await getLikesLength(id);
                        setState(() {
                          length=len;
                          index=2;
                          liked2=true;

                        });
                      }
                    }
                    else
                      {
                        bool unliked = await ProductDatabase(context: context)
                            .unLike(id, user_id);
                        if (unliked) {
                         int len =await getLikesLength(id);
                          setState(() {
                            length=len;
                            index=2;
                            liked2=false;

                          });

                        }
                      }*/
                    },),

                  Text('${likesList.length}'),
                  SizedBox(width: 20,),
                  InkWell(child: Icon(Icons.thumb_down,color:isdislikedbyuser?Colors.blue:Colors.black12,),onTap: ()async
                  {
                    if(!isdislikedbyuser)
                    {
                      if(islikedbyuser)
                        ProductDatabase().unLike(id, user_id);

                      ProductDatabase().addDisLike(id,user_id);
                    }
                    else
                    {
                      ProductDatabase().unDisLike(id, user_id);
                    }
                    setState(() {

                    });
                    /*if(disliked2==false) {
                      bool isdisliked = await ProductDatabase(context: context).addDisLike(id, user_id);
                      if (isdisliked) {
                        int len =await getDisLikesLength(id);
                        setState(() {
                          disindex=2;
                          dislength=len;
                          disliked2 = true;
                        });
                      }
                    }
                    else
                    {
                      bool undisliked = await ProductDatabase(context: context).unDisLike(id, user_id);
                      if (undisliked) {
                        int len =await getDisLikesLength(id);
                        setState(() {
                          dislength=len;
                          disindex=2;
                          disliked2 = false;
                        });
                      }
                    }*/
                  },),
                  Text('${dislikesList.length}'),
                  Expanded(
                    child: FlatButton(onPressed: (){

                      setState(() {
                        isvisible=!isvisible;
                      });
                    },child: Text('comment',style: TextStyle(fontSize:15,color: Colors.black,fontWeight: FontWeight.bold),),),
                  ),
                  FutureBuilder(
                    future: ProductDatabase().getUserRateOnProduct(id,user_id),
                    builder:(_,rsnap){
                      List rates=rsnap.data;
                    //  String rateid=rates['_id'];
                      return !rsnap.hasData? Text('loading'):FlatButton(onPressed: ()async{
                      if( rates.length<1)
                        showDialog(context: context,builder: (_)=>makeAlertDialoge(id,user_id));
                      else
                        {
                        bool result=await  ProductDatabase().RemoveRate(rates[0]['_id']);
                        if(result)
                        {
                          HelperCodes.showToast(context, 'un rated succefully');
                          setState(() {

                          });
                        }
                        else
                          HelperCodes.showToast(context, 'some thing wrong');
                        }

                    },child: Text(rates.length<1?'rate product':'unrate',style: TextStyle(fontSize:15,color: Colors.black,fontWeight: FontWeight.bold)),);
                    },
                  )
                ],);
                },
              ),
            
              isvisible?Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(border: Border.all()),
                child: TextField(
                  maxLines: 5,
                  minLines: 2,
                  decoration: InputDecoration(labelText:"comment",hintText: 'enter your comment',),controller: content,),):Container(),
              isvisible?RaisedButton(
                color: Colors.blue,
                onPressed: ()async{
                bool result=await ProductDatabase().addComment(id,user_id, content.text);
                if(result) {
                  HelperCodes.showToast(context, "comment added");
                by.clear();
                content.clear();
                setState(() {
                  isvisible=false;
                });
                }
              },child: Text('add comment',style: TextStyle(color: Colors.white),),):Container(),
             SizedBox(height: 100,),

           /*   Center(child: Container(
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft:Radius.circular(10) ,
                      bottomRight: Radius.circular(0)
                    )
                ),
                child: FlatButton(
                  //color: Colors.blue,
                  onPressed: (){

                },child: Text('chat with seller',style: TextStyle(color:Colors.white,fontSize: 25),),),
              ),)*/
              
            ],
          ),
        ),
      ),
      floatingActionButton:user_type=='seller'?Container(): Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ),
            elevation: 50,
            child: IconButton(
                icon: Icon(Icons.chat,size: 35,color: Colors.blue,),
                onPressed:(){
                  user_id==null||user_id.isEmpty?Navigator.pushNamed(context, '/loginpage'):Navigator.pushNamed(context,'/userchat',arguments: {
                    HomePage.Another_USER_ID:seller
                  });
                }),
          ),
          //SizedBox(height: 10,),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            color: Colors.blue,
            elevation: 50,
            child: IconButton(
              onPressed: (){
                user_id==null||user_id.isEmpty?Navigator.pushNamed(context, '/loginpage'):Navigator.pushNamed(context,'/orderpage',arguments:
                {
                  HomePage.PRODUCT_NAME:productname,
                  HomePage.PRODUCT_PRICE:price,
                  HomePage.PRODUCT_QUANTITY:quantity,
                  HomePage.PRODUCT_SELLER:seller,
                  HomePage.PRODUCT_ID:id,
                  HomePage.USER_ID:user_id,
                });
              },
              icon: Icon(Icons.shopping_cart,size: 35,color: Colors.white,),
            ),
          ),
        ],
      ),
      
    );
  }
  bool searchlike(String id){
    bool founded=false;
    for(int i=0;i<likes.length;i++)
      if(id==likes[i])
        founded=true;
      return founded;

  }
  bool searchdislike(String id){
    bool founded=false;
    for(int i=0;i<dislikes.length;i++)
      if(id==dislikes[i])
        founded=true;
    return founded;

  }
  Future<int> getLikesLength(String product_id)async
  {
    List likes1=[];
     var data=await ProductDatabase().getProduct(product_id);
     likes1=data['likes'];
    return likes1.length;
  }
  Future<int> getDisLikesLength(String product_id)async
  {
    List dislikes1=[];
    var data=await ProductDatabase().getProduct(product_id);
    dislikes1=data['dislikes'];
    return dislikes1.length;
  }
   Widget getSellerPage(String prod_id){
    return
      isedit?
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  myTextfield(label:'product name',hint: 'enter product name',controller: proctr),
                  myTextfield(label:'category',hint: 'enter product category',controller: catctr),
                  myTextfield(label:'subcategory',hint: 'enter product subcategory',controller: subcatctr),
                  myTextfield(label:'details',hint: 'enter product details',controller: detctr),
                  myTextfield(label:'price',hint: 'enter product name',controller: pricectr),
                  myTextfield(label:'quantity',hint: 'enter product name',controller:quantityctr),
                  RaisedButton(
                    color: Colors.blue,
                      child: Text('update',style: TextStyle(color: Colors.white,fontSize: 20),),
                      onPressed: ()async{
                    Product myproduct=Product(productname: proctr.text, price: int.parse(pricectr.text), quantity: int.parse(quantityctr.text),
                        category: catctr.text,subcategory: subcatctr.text,details: detctr.text);
                   bool isupdated=await  ProductDatabase().updateProduct(prod_id, myproduct);
                   if(isupdated)
                    setState(() {
                      isedit=false;
                    });
                    else
                      HelperCodes.showToast(context, 'error occured');
                  })
                ],
              ),
            ),
          ):
      FutureBuilder(
      future: ProductDatabase().getProduct(prod_id),
      builder:(con,snap) {
        List prod_photos=snap.data['productphotos'];
        return !snap.hasData?Center(child: CircularProgressIndicator(),):
    SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Center(child: Container(child: InkWell(
                  child:  CarouselSlider(
                      options: CarouselOptions(
                          height: 200, initialPage: 0, autoPlay: true),
                      items: prod_photos.map((e) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              editimage = !editimage;
                            });
                          },
                          onLongPress: (){
                            showDialog(context: con,builder: (_)=>AlertDialog(
                              content: Container(
                                height: 350,
                                child: Column(
                                  children: [
                                    Text('do you want to delete this photo?',style: TextStyle(color: Colors.red,fontSize:15,fontStyle: FontStyle.italic),),
                                    Container(
                                        child:
                                  Image.network( "${EntryPoints.IMAGE_URL}${e.substring(7)}")
                                    ),
                                    Row(
                                      children: [
                                        FlatButton(onPressed: ()async{
                                          bool result=await ProductDatabase().deleteProductPhoto(id,e);
                                          if(result)
                                          {
                                            HelperCodes.showToast(context, 'photo deleted');
                                            ProductDatabase().deleteFile(e);
                                            Navigator.pop(con);
                                            setState(() {
                                              editimage=false;
                                            });
                                          }
                                          else
                                            {
                                              HelperCodes.showToast(context, 'error occured');
                                              Navigator.pop(con);
                                              setState(() {
                                                editimage=false;
                                              });
                                            }

                                        }, child: Text('ok',style: TextStyle(color: Colors.red,fontSize:20,fontWeight: FontWeight.bold))),
                                        FlatButton(onPressed: (){
                                          Navigator.pop(con);
                                          setState(() {
                                            editimage=false;
                                          });
                                        }, child: Text('cancel',style: TextStyle(color: Colors.blue,fontSize:20,fontStyle: FontStyle.italic))),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ));
                          },
                          child: Image.network(
                              "${EntryPoints.IMAGE_URL}${e.substring(7)}"),
                        );
                      }).toList(),

                  ),
                )),),
                FutureBuilder(
                    future: ProductDatabase().getProductRate(id),
                    builder:(_,ratesnap){
                      double frate=1;
                      List rates=ratesnap.data;
                      int ratesize=rates.length;
                      int sum=0;
                      for(var prorate in rates)
                        sum+=prorate['percent'];
                      frate=(sum/ratesize);
                      return !ratesnap.hasData?Text('loading rate .....'):rates.length<1?
                      Text('no rates yet ...')
                          : Column(
                        children: [
                          SmoothStarRating(
                            rating:frate/20 ,
                            starCount: 5,
                            size: 30,
                            isReadOnly: true,
                          ),
                          Text('$frate')
                        ],
                      );}
                ),
                editimage
                    ? Center(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [IconButton(icon: Icon(Icons.add_a_photo,size: 50,color: Colors.blue,),
                      onPressed: () async {
                        PickedFile myfile = await HelperCodes.getimage(ImageSource.gallery);
                        if (myfile != null) {
                          ProductDatabase().addProductPhoto(id, myfile.path);
                          setState(() {
                            editimage = false;
                          });
                        }
                      }),
                   ],))
                    : Container(),
               // Text(''),
                SizedBox(height: 10,),
                Text(snap.data['productname'],style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text(snap.data['category']==null?'no category':snap.data['category'],style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
                SizedBox(height: 10,),
                Text(snap.data['subcategory'],style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
                SizedBox(height: 10,),
                Text(snap.data['details'],style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal)),
                SizedBox(height: 10,),
                Text("${snap.data['price']}",style: TextStyle(color: Colors.blue,fontSize: 30,fontWeight: FontWeight.bold)),
                SizedBox(height: 10,),
                Text("${snap.data['quantity']}",style: TextStyle(color: Colors.red,fontSize: 30,fontWeight: FontWeight.bold)),
                FutureBuilder(
            future: UserDataBase().getUser(seller),
            builder:(_,usnap)=> Text(usnap.data['username'],style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold))),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('comments',style: textstyle(15,FontWeight.bold,Colors.black),),
                  ],
                ),
                FutureBuilder(
                  future: ProductDatabase().getAllComments(id),
                  builder: (ctx, snap) {
                    List comments = snap.data;
                    int length = comments.length;
                    return !snap.hasData
                        ? Text('no comments for this product')
                        :
                    Container(
                      height: 200,
                      child: snap.data.length < 1 ? Text(
                          'no comments for this product') : ListView.builder(
                          itemCount: length,
                          itemBuilder: (con, index) {
                            String date = DateTime.fromMillisecondsSinceEpoch(
                                int.parse(snap.data[index]['commenttime']))
                                .toString();
                            return FutureBuilder(
                              future: UserDataBase().getUser(
                                  comments[index]['commentedby']),
                              builder: (con, snap2) {
                                bool image;
                                String path;
                                image =
                                snap2.data['profile_image'].contains('upload') ?
                                image = true : image = false;
                                path =
                                snap2.data['profile_image'].contains('upload')
                                    ? snap2.data['profile_image'].substring(7)
                                    : 'assets/images/nophoto.jpg';
                                return ListTile(
                                  leading: Container(
                                    height: 50,
                                    width: 50,
                                    child:CircleAvatar(
                                      radius: 100,
                                      backgroundColor: Colors.transparent,backgroundImage: image ? NetworkImage(
                                        '${EntryPoints.IMAGE_URL}$path') : AssetImage('assets/images/nophoto.jpg'),
                                  )),
                                  title: Text(snap2.data['username'],style: textstyle(20,FontWeight.bold,Colors.black ),),
                                  subtitle: Text(snap.data[index]['content']),
                                  trailing: Text(date),
                                );
                              },
                            );
                          }),
                    );
                  },

                ),
                user_id == null || user_id.isEmpty ? Container() : Row(
                  children: [
                    SizedBox(width: 30,),
                /*    InkWell(child: Icon(Icons.thumb_up,
                      color: !liked2 ? Colors.black12 : Colors.blue,),
                      onTap: () async {
                        // liked=searchlike(user_id);
                        //pressed=!pressed;
                        if (liked2 == false) {
                          bool isliked = await ProductDatabase(context: context)
                              .addLike(id, user_id);
                          if (isliked) {
                            int len = await getLikesLength(id);
                            setState(() {
                              length = len;
                              index = 2;
                              liked2 = true;
                            });
                          }
                        }
                        else {
                          bool unliked = await ProductDatabase(context: context)
                              .unLike(id, user_id);
                          if (unliked) {
                            int len = await getLikesLength(id);
                            setState(() {
                              length = len;
                              index = 2;
                              liked2 = false;
                            });
                          }
                        }
                      },)*/

                    Text(index == 1 ? ' total likes ${likes.length}' : 'total likes $length'),
                    SizedBox(width: 20,),
                   /* InkWell(child: Icon(Icons.thumb_down,
                      color: disliked2 ? Colors.blue : Colors.black12,),
                      onTap: () async
                      {
                        if (disliked2 == false) {
                          bool isdisliked = await ProductDatabase(
                              context: context).addDisLike(id, user_id);
                          if (isdisliked) {
                            int len = await getDisLikesLength(id);
                            setState(() {
                              disindex = 2;
                              dislength = len;
                              disliked2 = true;
                            });
                          }
                        }
                        else {
                          bool undisliked = await ProductDatabase(
                              context: context).unDisLike(id, user_id);
                          if (undisliked) {
                            int len = await getDisLikesLength(id);
                            setState(() {
                              dislength = len;
                              disindex = 2;
                              disliked2 = false;
                            });
                          }
                        }
                      },),*/
                    Text(index == 1 ? ' total dis likes ${dislikes.length}' : 'total dislikes $dislength'),
                    FlatButton(onPressed: () {
                      setState(() {
                        isvisible = !isvisible;
                      });
                    }, child: Text('comment',style: textstyle(20,FontWeight.bold,Colors.black),),),
                    //FlatButton(onPressed: () {}, child: Text('give rate'),)
                  ],),

                isvisible ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration:BoxDecoration(border: Border.all(color: Colors.black45,width: 0.5)),
                  child: TextField(
                    maxLines: 5,
                    minLines: 2,
                    decoration: InputDecoration(
                      labelText: "comment", hintText: 'enter your comment',),
                    controller: content,),
                ) : Container(),
                isvisible ? RaisedButton(
                    color: Colors.blue,
                    onPressed: () async {
                  bool result = await ProductDatabase().addComment(
                      id, user_id, content.text);
                  if (result) {
                    HelperCodes.showToast(context, "comment added");
                    by.clear();
                    content.clear();
                    setState(() {
                   isvisible=false;
                    });
                  }
                }, child:Text('add comment',style: TextStyle(color: Colors.white),) ): Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                        color: Colors.blue,
                        child: Text('edit product',style: TextStyle(color: Colors.white,fontSize: 20),),
                        onPressed: (){
                          proctr.text=snap.data['productname'];
                          detctr.text=snap.data['details'];
                          pricectr.text='${snap.data['price']}';
                          catctr.text=snap.data['category'];
                          subcatctr.text=snap.data['subcategory'];
                          quantityctr.text='${snap.data['quantity']}';
                          setState(() {
                            isedit=true;
                          });
                        }),
                    SizedBox(width: 10,),
                    RaisedButton(
                      color: Colors.red,
                      onPressed: (){
                        showDialog(context: context,builder: (_)=>AlertDialog(
                          content: Container(
                            height: 100,
                            margin: EdgeInsets.only(top:30),
                            child: Column(
                              children: [
                                Text('do you want to delete this product?',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                SizedBox(height: 30,),
                                Row(

                                  children: [
                                    SizedBox(width: 50,),
                                    FlatButton(onPressed: ()async{
                                      bool result=await ProductDatabase().deleteProduct(id);
                                      if(result)
                                      {
                                        for(var path in prod_photos)
                                          ProductDatabase().deleteFile(path);
                                        HelperCodes.showToast(context, 'product deleted');
                                        Navigator.pushReplacementNamed(context,'/homepage');
                                      }
                                      else
                                        HelperCodes.showToast(context, 'some thing wrong');
                                    }, child: Text('ok',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20))),
                                    FlatButton(onPressed: (){
                                      Navigator.pop(context);
                                    }, child: Text('cancel',style: TextStyle(color: Colors.blue,fontSize: 20)))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
                      },child: Text('delete product',style: TextStyle(color: Colors.white),),)
                  ],
                ),

              ],
            ),
          ),
        );
      }
    );
  }
  myTextfield({label:String,hint:String,controller:TextEditingController}){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45,width: 1)
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 20,color: Colors.red),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
  makeStareRating(){
    return SmoothStarRating(

       size: 50,
      starCount: 5,
      onRated: (value){

            rate=value*20;
            HelperCodes.showToast(context, '$rate');


      },
    );
  }
  makeAlertDialoge(String prodid,userid,)
  {
    return AlertDialog(
      content: Container(
        height: 100,
        child:Column(children: [
          makeStareRating(),
          FlatButton(onPressed: ()async{
            try {
              bool result = await ProductDatabase().giveRate(
                  prodid, userid, rate.toInt());
              if (result)
                HelperCodes.showToast(context, 'rate added');
              Navigator.pop(context);
     setState(() {

          });
            }catch(e)
            {
              HelperCodes.showToast(context, e.toString());
            }
          }, child: Text('rate'))
        ],)
      ),
    );
  }
  bool SearchList(List mylist,String id)
  {
bool founded=false;
for(var item in mylist)
  if(item==id)
    founded=true;
  return founded;
  }
}
