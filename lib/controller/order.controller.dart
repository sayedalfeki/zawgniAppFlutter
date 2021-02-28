
import 'dart:convert';

import 'package:hp_flutter_lablet/controller/entrypoints.dart';
import 'package:hp_flutter_lablet/models/order.model.dart';
import 'package:http/http.dart'as http;
class OrderDatabase
{
  Future addOrder(Order order)async
  {
var response=await http.post(EntryPoints.ADD_ORDER_URL, headers: {"Content-Type":"application/json"},body:jsonEncode( order.tomap()));
if(response.statusCode==200)
{
  var added=jsonDecode(response.body);
  if(added['added'])
    return true;
  else
    return false;
}
else
  return false;
  }
  Future getAllBuyerOrders(String buyer)async
  {
    var response=await http.get("${EntryPoints.GET_BUYERORDERS_URL}$buyer");
    if(response.statusCode==200)
    return jsonDecode(response.body);
    else
      return null;
  }
}