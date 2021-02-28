import 'package:flutter/material.dart';

class Order
{
  String product,buyer,orderstatus;
  int quantity;
  Order({@required this.product,@required this.buyer,@required this.quantity,@required this.orderstatus});
  Map<String, Object> tomap()
  {
    return {
      'product':product,
      'buyer':buyer,
      'quantity':quantity,
      'orderstatus':orderstatus

    };
  }
}