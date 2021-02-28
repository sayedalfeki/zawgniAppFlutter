import'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
String id='';
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) =>
        setState(() {
        id=value.getString('user_id');
        })

    );
    Future.delayed(Duration(seconds: 5)).then((value) =>
    id==null||id.isEmpty?Navigator.pushReplacementNamed(context,'/mainpage'):Navigator.pushReplacementNamed(context,'/homepage')
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List fit=[BoxFit.fitHeight,BoxFit.fitWidth];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/zawage.jpg'),
            fit: BoxFit.fill
          )
        ),
        child: Center(
          child: Text('Welcome to Zawage App',style: TextStyle(color: Colors.indigo,fontSize: 30,fontWeight: FontWeight.bold),)
        ),
      ),
    );
  }
}
