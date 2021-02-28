
import 'package:flutter/material.dart';
import'package:shared_preferences/shared_preferences.dart';
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Color btncolor=Colors.blue;

  Color textcolor=Colors.white;

  var textsize=14.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('main page'),),
      body: Container(
        child: Center(
          child: Row(
            children: [
              Expanded(child: SizedBox()),
              Expanded(
                child: RaisedButton(onPressed: ()async{
                  SharedPreferences pref=await SharedPreferences.getInstance();
                  pref.setString('user_type', 'customer');
                  Navigator.pushReplacementNamed(context, '/homepage');
                },child: Text('customer',style: TextStyle(color: textcolor,fontSize: textsize),),color: btncolor,),
              ),
SizedBox(width: 10,),
             Expanded(child:  RaisedButton(onPressed: ()async{
               SharedPreferences pref=await SharedPreferences.getInstance();
               pref.setString('user_type', 'seller');
              String id= pref.get('user_id');
             id==null?Navigator.pushNamed(context,  '/loginpage'):id.isEmpty?Navigator.pushNamed(context,'/loginpage'):Navigator.pushReplacementNamed(context, '/homepage');
             },child: Text('seller',style: TextStyle(color: textcolor,fontSize: textsize)),color: btncolor,))
             ,
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

}
