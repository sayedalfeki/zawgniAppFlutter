import 'package:flutter/cupertino.dart';
import'package:image_picker/image_picker.dart';
import 'package:connectivity/connectivity.dart';
import 'package:toast/toast.dart';
class HelperCodes
{
  // CHECK INTERNET CONNECTION
 static Future<bool> checkConnection() async
  {
var connection_state = await Connectivity().checkConnectivity();
if(connection_state==ConnectivityResult.mobile||connection_state==ConnectivityResult.wifi)
  return true;
else
  return false;
  }
 static  Stream<ConnectivityResult> listenToConnection()
 {
   var mystream=Connectivity().onConnectivityChanged;
   return mystream;

 }
  static showToast(BuildContext context,String text){
   Toast.show(text, context,duration: Toast.LENGTH_LONG);
  }
  static Future<PickedFile> getimage(ImageSource src) async
  {
var image=await ImagePicker().getImage(source: src);
if(image!=null)
  return image;

  }
}