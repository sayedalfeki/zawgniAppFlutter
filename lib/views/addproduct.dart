import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hp_flutter_lablet/controller/helper.dart';
import 'package:hp_flutter_lablet/controller/product.controller.dart';
import 'package:hp_flutter_lablet/models/product.model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:carousel_slider/carousel_slider.dart';
class ProductAdding extends StatefulWidget {
  @override
  _ProductAddingState createState() => _ProductAddingState();
}

class _ProductAddingState extends State<ProductAdding> {
  int index=0;
  List<Asset> images=[];
  List<File> imagesfiles=[];
  List<String> prodfiles=[];
  String productname,details,categoty,subcategory,userid;
  String price,quantity;
  String catselected='electrics',subcatselected;
  List<String> categories=['electrics','elecronics','furniture','wedding rooms','kwafir','maazon','dresses'];
  Map<String,List<String>> subcategories={'electronics':['mobile','labtop','playstation','other'],'electrics':['TV','fridge','washer','other'],
    'furniture':['bed room','children room'],'weddingrooms':['open','closed','other'],'kwafir':['with makeup artist','home','other'],
  'maazon':['internal','external','other'],'dress':['wedding','other']
  };
  List<String> electrics=['TV','fridge','washer','other'];
  List<String> electronics=['mobile','labtop','playstation','other'];
  List<String> furniture=['bed room','children room','other'];
  List<String> weddingrooms=['open','closed','other'];
  List<String> kwafir=['with makeup artist','home','other'];
  List<String> maazon=['internal','external','other'];
  List<String> dress=['wedding','other'];
bool isloading=false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) => setState(() {
      userid=value.getString('user_id');
    }));
  }
  @override
  Widget build(BuildContext context) {
  mycontainer(Widget child)
  {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 0.5)),
      child: child,
    );
  }

    List<List<String>> subcats=[electrics,electronics,furniture,weddingrooms,kwafir,maazon,dress];
    //catselected=categories[0];
    subcatselected=subcats[index][0];
    return Scaffold(
      appBar:AppBar(title:Text('adding product page')),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                  width: 250,
                  height:250,child: Center(child:
               images.length<1? Icon(Icons.add_a_photo,color: Colors.indigo,size: 200,):
               CarouselSlider(
                 options: CarouselOptions(
                   enlargeCenterPage: true,
                   autoPlay: true,
                   aspectRatio: 2,
                   height: 250
                 ),
                 items: images.map((e) =>
                  FutureBuilder(
                      future: FlutterAbsolutePath.getAbsolutePath(e.identifier),
                      builder:(_,snap)=> Image.file(File(snap.data)))


                 ).toList(),
               )
              //Image.asset('assets/images/addphoto.png')
                )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'gallery',
                    color: Colors.blue,
                    iconSize: 50,
                    onPressed: (){
                      loadImages();
                      //chooseImages(context,  ImageSource.gallery);
                  /*  String prods="\n";
                    for(var prod in prodfiles)
                      prods+="${prod}";
                    HelperCodes.showToast(context, prods);*/
                  },icon: Icon(Icons.photo),),
                  SizedBox(width: 10,),

                ],
              ),
              mycontainer( TextField(
                style: TextStyle(fontSize: 20,color: Colors.red),
                decoration: InputDecoration(
                    labelText:'product name' ,hintText: 'enter product name'),onChanged: (val)=>productname=val,)),
              Row(
                children: [
Text('select category     '),
                  Container(
                    child: DropdownButton(

                        style: TextStyle(color: Colors.red,fontSize: 30,fontWeight: FontWeight.bold),
                        value:catselected
           ,items: categories.map((e) =>DropdownMenuItem(
                         value:e,child: Text(e),) ).toList() , onChanged: (val)=> setState(() {
                             index=categories.indexOf(val);
                             subcatselected=subcats[index][0];
                         catselected=val;
HelperCodes.showToast(context, '$catselected\n$subcatselected');
                       })),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('select sub category     '),
                  Container(

                    child: DropdownButton(
                        style: TextStyle(color: Colors.red,fontSize: 30,fontWeight: FontWeight.bold),
                        value:subcatselected,items:subcats[index].map((e)=>DropdownMenuItem(value:e,child: Text(e),) ).toList() , onChanged: (val)=>setState(() {
                      subcatselected=val;
                      HelperCodes.showToast(context, '$catselected\n$subcatselected');
                    })),
                  ),
                ],
              ),
             SizedBox(height: 10,),
             // TextField(decoration: InputDecoration(labelText: 'category',hintText:'enter product category' ),onChanged: (val)=>categoty=val,),
              //TextField(decoration: InputDecoration(labelText: 'subcategory',hintText:'enter product subcategory' ),onChanged: (val)=>subcategory=val,),
              mycontainer( TextField( style: TextStyle(fontSize: 20,color: Colors.red),decoration: InputDecoration(labelText:'details' ,hintText: 'enter the details of product'),onChanged: (val)=>details=val,)),
              SizedBox(height: 10,), //TextField(decoration: InputDecoration(labelText: 'seller',hintText: 'enter name of seller'),onChanged: (val)=>seller=val,),
              mycontainer( TextField( style: TextStyle(fontSize: 20,color: Colors.red),decoration: InputDecoration(labelText: 'price',hintText:'enter the price' ),onChanged: (val)=>price=val,keyboardType: TextInputType.number,)),
              SizedBox(height: 10,),
              mycontainer( TextField( style: TextStyle(fontSize: 20,color: Colors.red),decoration: InputDecoration(labelText: 'quantity',hintText: 'enter the quantity'),onChanged: (val)=>quantity=val,keyboardType: TextInputType.number)),
              SizedBox(height: 10,),
              Center(
                child:RaisedButton(
                  color: Colors.blue,
                  child: Text('add product',style: TextStyle(color: Colors.white),),onPressed: ()async{
                    if(! await HelperCodes.checkConnection())
                    {
                      HelperCodes.showToast(context, 'check internet connection and try again');
                      return;
                    }
                  String path=await FlutterAbsolutePath.getAbsolutePath(images[0].identifier);
                  List<String> pathes=[path];
                  Product myproduct=Product(productname: productname, price: int.parse(price), quantity: int.parse(quantity), seller:userid,
                      category: catselected,subcategory: subcatselected,details: details,productPhoto: pathes);
              //    HelperCodes.showToast(context, "${myproduct.productname}\n${myproduct.category}\n${myproduct.subcategory}\n"
                //      "${myproduct.details}\n${myproduct.seller}\n${myproduct.price}\n${myproduct.productPhoto[0]}\n");
                  String id='';
                 id=await ProductDatabase(context: context).addProduct(myproduct);
                 // HelperCodes.showToast(context, id);
                  for(int i=1;i<images.length;i++)
                  {
                    String path=await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
                    ProductDatabase(context: context).addProductPhoto(id, path);
                    }
                  Navigator.pushReplacementNamed(context,'/homepage');
                  },)
              )
            ],
          ),
        ),
      ),
    );
  }
  chooseImages(BuildContext context,ImageSource src)async{
   /* if(!finish) {
     // Navigator.of(context).pop();
      HelperCodes.showToast(context, "finished");
    }
    else{*/
        int count=1;
          var file=await HelperCodes.getimage(src);
          prodfiles.add(file.path);
    /*  AlertDialog mydialoge = AlertDialog(
        title: Text('photo no $count'),
        content: Container(
          height: 75,
          child: Column(
          children: [
            Text('take another photo?'),
            Row(
              children: [
                FlatButton(onPressed:(){
                  count++;
                  chooseImages(context,  src);

                // ended=true;
                }, child: Text('yes')),
                FlatButton(onPressed: (){

                  // chooseImages(context, false, src);
                   Navigator.of(context).pop();
                }, child: Text('no'))
              ],
            )

          ],
        ),),
      );*/
      showDialog(context: context, builder:(ctx)=>AlertDialog(
        title: Text('photo no $count'),
        content: Container(
          height: 75,
          child: Column(
            children: [
              Text('take another photo?'),
              Row(
                children: [
                  FlatButton(onPressed:(){
                    count++;
                    chooseImages(context,  src);

                    // ended=true;
                  }, child: Text('yes')),
                  FlatButton(onPressed: (){

                    // chooseImages(context, false, src);
                    Navigator.of(context).pop();
                  }, child: Text('no'))
                ],
              )

            ],
          ),),
      ));
   // }
  }
  bool checkValidation(){
    if(productname.isEmpty)
    {
      HelperCodes.showToast(context, 'please enter product name');
      return false;
    }
   else if(productname.isEmpty)
    {
      HelperCodes.showToast(context, 'please enter product name');
      return false;
    }
   else if(productname.isEmpty)
    {
      HelperCodes.showToast(context, 'please enter product name');
      return false;
    }
   else if(productname.isEmpty)
    {
      HelperCodes.showToast(context, 'please enter product name');
      return false;
    }
  }
  List<String> getSubCatList(int index){
   if(index==0)
     return electrics;
   else if(index==1)
     return electronics;
   else
     return furniture;
  }
  loadImages()async{
  List<Asset> resultlist=await MultiImagePicker.pickImages(maxImages: 5,selectedAssets: images,enableCamera: true);
  setState(() {
    images=resultlist;
  });
  }
}
/*
IconButton(
                    tooltip: 'camera',
                    color: Colors.blue,
                    iconSize: 50,
                    onPressed: ()async {
                  chooseImages(context,  ImageSource.camera);

                  },icon: Icon(Icons.camera),),
 */