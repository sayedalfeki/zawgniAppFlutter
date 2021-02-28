import 'package:flutter/material.dart';
import 'package:hp_flutter_lablet/controller/helper.dart';
import 'package:hp_flutter_lablet/controller/order.controller.dart';
import 'package:hp_flutter_lablet/controller/user.controller.dart';
import 'package:hp_flutter_lablet/models/order.model.dart';
import 'package:hp_flutter_lablet/views/projectvies/homepage.dart';
import 'package:connectivity/connectivity.dart';
class OrderHome extends StatefulWidget {
  @override
  _OrderHomeState createState() => _OrderHomeState();
}

class _OrderHomeState extends State<OrderHome> {
  Map args;
  String product_id,seller,user_id,product_name;
  int price,quantity;
  TextEditingController quan=TextEditingController();
  bool isconnected=false;
  var source;


  @override
  void initState() {
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
    args=ModalRoute.of(context).settings.arguments as Map;
    product_id=args[HomePage.PRODUCT_ID];
    product_name=args[HomePage.PRODUCT_NAME];
    seller=args[HomePage.PRODUCT_SELLER];
    price=args[HomePage.PRODUCT_PRICE];
    quantity=args[HomePage.PRODUCT_QUANTITY];
    user_id=args[HomePage.USER_ID];
    return !isconnected||source==ConnectivityResult.none?Scaffold(
      appBar: AppBar(title: Text('no connection available'),),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text('check your connection and try again'),
        ],
      ),),
    ):Scaffold(
      appBar: AppBar(title: Text('order page'),),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 30),
         decoration: BoxDecoration(),
         child: Column(
           //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    margin:EdgeInsets.only(bottom: 70),
                    child: Image.asset('assets/images/buying.jfif'),
                  ),
                  Text("product name: $product_name",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Text('price : $price LE',style: TextStyle(color: Colors.blue,fontSize: 25,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Text('quantity: $quantity piece',style: TextStyle(color: Colors.blue,fontSize: 25,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  FutureBuilder(
                      future: UserDataBase().getUser(seller),
                      builder:(_,usnap)=> Text('seller : ${usnap.data['username']}',style: TextStyle(color: Colors.black,fontSize: 25))),
                ],
              ),
            ),
            SizedBox(height: 50,),
            Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey)),
                child: TextField(

                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.red,fontSize: 25),
                  decoration: InputDecoration(
                      hintText: 'enter quantity',labelText: 'quantity'),controller: quan,)),
            Center(
              child: RaisedButton(
                color: Colors.blue,
                child: Text('buy',style: TextStyle(color: Colors.white,fontSize: 25),),onPressed: ()async{
                  if(quan.text.isEmpty)
                  {
                    HelperCodes.showToast(context, 'you must enter quantity');
                    return;
                  }
                  if(int.parse(quan.text)>quantity)
                  {
                    HelperCodes.showToast(context, 'un available quantity ');
                    return;
                  }
            Order order=Order(product: product_id,buyer: user_id,orderstatus: 'shipped',quantity: int.parse( quan.text));
                bool buyed=await OrderDatabase().addOrder(order);
                if(buyed)
                  HelperCodes.showToast(context, 'congratulation you buyed this product wait for transporting this product');
                else
                  HelperCodes.showToast(context, 'some thing wrong');
              },),
            )


          ],
          )
        ),
      ),
    );
  }
}
