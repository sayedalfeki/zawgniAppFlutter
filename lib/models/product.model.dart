import 'package:flutter/material.dart';

class Product
{
  String id;
  String productname;
  String details;
  String category;
  String subcategory;
  String seller;
  int price;
  int quantity;

  List<String> productPhoto;
  Product({this.id,@required this.productname,@required this.price,@required this.quantity,@required this.seller,
    this.category,this.subcategory,this.details,this.productPhoto});
  Map<String, Object> toMap(){
    return
    {
      'productname':productname,
      'price':price,
      'quantity':quantity,
      'details':details,
      'category':category,
      'subcategory':subcategory,

  };

  }

}