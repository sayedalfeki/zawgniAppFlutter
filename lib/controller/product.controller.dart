import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hp_flutter_lablet/controller/entrypoints.dart';
import 'package:hp_flutter_lablet/controller/helper.dart';
import 'package:hp_flutter_lablet/models/product.model.dart';
import 'package:http/http.dart'as http;
class ProductDatabase
{
  BuildContext context;
  ProductDatabase({this.context});
  deleteFile(String path) async
  {
    var response=await http.delete('${EntryPoints.DELETE_FILE_URL}?path=$path');
    if(response.statusCode==200)
    {
      var deleted=jsonDecode(response.body);
      if(deleted['deleted'])
        return true;
      else
        return false;
    }
  }
  Future addProduct(Product prod) async
  {
    var request= await http.MultipartRequest('POST',Uri.parse(EntryPoints.ADD_PRODUCT_URL));
    request.headers['Conten-Type']='multiform/form-data';
    request.fields['productname']=prod.productname;
    request.fields['price']=prod.price.toString() ;
    request.fields['quantity']=prod.quantity.toString() ;
    request.fields['details']=prod.details;
    request.fields['seller']=prod.seller;
    request.fields['category']=prod.category;
    request.fields['subcategory']=prod.subcategory;
    request.files.add(await http.MultipartFile.fromPath('image', prod.productPhoto[0]));
    var response=await http.Response.fromStream(await request.send());
    if(response.statusCode==200)
      {
        var adding=jsonDecode(response.body);
        if(adding['added']) {
          HelperCodes.showToast(context, "product added");
          return adding['id'];
        }
        else
          {
            HelperCodes.showToast(context, "some thing wrong");
            return '';
          }
      }
    else
    {
      HelperCodes.showToast(context, "no response from server");
      return '';
    }
  }
 Future updateProduct(String id,Product product) async
 {
http.Response response= await http.put("${EntryPoints.UPDATE_PRODUCT_URL}$id",headers: {'Content-Type':'application/json'},body: jsonEncode(product.toMap()));
if(response.statusCode==200)
{
  var updating=jsonDecode(response.body);
  if(updating['updated']) {
    HelperCodes.showToast(context, "product updated");
    return true;
  }
  else
  {
    HelperCodes.showToast(context, "some thing wrong");
    return false;
  }
}
else
{
  HelperCodes.showToast(context, "no response from server");
  return false;
}
 }
  Future deleteProduct(String id) async
  {
    http.Response response= await http.delete("${EntryPoints.DELETE_PRODUCT_URL}$id");
    if(response.statusCode==200)
    {
      var deleting=jsonDecode(response.body);
      if(deleting['deleted']) {
        HelperCodes.showToast(context, "product updated");
        return true;
      }
      else
      {
        HelperCodes.showToast(context, "some thing wrong");
        return false;
      }
    }
    else
    {
      HelperCodes.showToast(context, "no response from server");
      return false;
    }
  }

  Future<bool> addLike(String id,String by) async
  {
    var mymap={'likedby':by};
    http.Response response= await http.put("${EntryPoints.ADD_LIKE_URL}$id",headers: {'Content-Type':'application/json'},
        body: jsonEncode(mymap));
    if(response.statusCode==200)
    {
      var updating=jsonDecode(response.body);
      if(updating['liked']) {
        //HelperCodes.showToast(context, "like added");
        return true;
      }
      else
      {
        HelperCodes.showToast(context, "some thing wrong");
        return false;
      }
    }
    else
    {
      HelperCodes.showToast(context, "no response from server");
      return false;
    }
  }
  Future<bool> unLike(String id,String by) async
  {
    var mymap={'unlikedby':by};
    http.Response response= await http.put("${EntryPoints.DELETE_LIKE_URL}$id",headers: {'Content-Type':'application/json'},
        body: jsonEncode(mymap));
    if(response.statusCode==200)
    {
      var updating=jsonDecode(response.body);
      if(updating['removed']) {
        //HelperCodes.showToast(context, "like removed");
        return true;
      }
      else
      {
        HelperCodes.showToast(context, "some thing wrong");
        return false;
      }
    }
    else
    {
      HelperCodes.showToast(context, "no response from server");
      return false;
    }
  }
  Future<bool> addDisLike(String id,String by) async
  {
    var mymap={'dislikedby':by};
    http.Response response= await http.put("${EntryPoints.ADD_DISLIKE_URL}$id",headers: {'Content-Type':'application/json'},
        body: jsonEncode(mymap));
    if(response.statusCode==200)
    {
      var updating=jsonDecode(response.body);
      if(updating['disliked']) {
        HelperCodes.showToast(context, "dislike added");
        return true;
      }
      else
      {
        HelperCodes.showToast(context, "some thing wrong");
        return false;
      }
    }
    else
    {
      HelperCodes.showToast(context, "no response from server");
      return false;
    }
  }
  Future<bool> unDisLike(String id,String by) async
  {
    var mymap={'undislikedby':by};
    http.Response response= await http.put("${EntryPoints.DELETE_DISLIKE_URL}$id",headers: {'Content-Type':'application/json'},
        body: jsonEncode(mymap));
    if(response.statusCode==200)
    {
      var updating=jsonDecode(response.body);
      if(updating['removed']) {
        HelperCodes.showToast(context, "dislike removed");
        return true;
      }
      else
      {
        HelperCodes.showToast(context, "some thing wrong");
        return false;
      }
    }
    else
    {
      HelperCodes.showToast(context, "no response from server");
      return false;
    }
  }
  Future giveRate(String id,String by,int percent) async
  {
    var mymap={'ratedon':id,'ratedby':by,'percent':percent.toString()};
    http.Response response= await http.post("${EntryPoints.ADD_RATE_URL}",headers: {'Content-Type':'application/json'},
        body: jsonEncode(mymap));
    if(response.statusCode==200)
    {
      var adding=jsonDecode(response.body);
      if(adding['added']) {
        HelperCodes.showToast(context, "rate added");
        return true;
      }
      else
      {
        HelperCodes.showToast(context, "error in adding");
        return false;
      }
    }
    else
    {
      HelperCodes.showToast(context, "no response from server");
      return false;
    }
  }
  Future RemoveRate(String id) async
  {
    //var mymap={'ratedon':id,'ratedby':by,'percent':percent.toString()};
    http.Response response= await http.delete("${EntryPoints.DELETE_RATE_URL}$id");
    if(response.statusCode==200)
    {
      var deleting=jsonDecode(response.body);
      if(deleting['deleted']) {
        HelperCodes.showToast(context, "rate deleted");
        return true;
      }
      else
      {
        HelperCodes.showToast(context, "error in adding");
        return false;
      }
    }
    else
    {
      HelperCodes.showToast(context, "no response from server");
      return false;
    }
  }
  Future getProductRate(String id) async
  {
    //var mymap={'ratedon':id,'ratedby':by,'percentage':percent};
    http.Response response= await http.get("${EntryPoints.GET_RATE_URL}$id");
    if(response.statusCode==200)
    {
      return jsonDecode(response.body);
      }
      else
      {
        HelperCodes.showToast(context, "some thing wrong");
        throw('error');
      }


  }
  Future getUserRateOnProduct(String prodid,String userid) async
  {
    //var mymap={'ratedon':id,'ratedby':by,'percentage':percent};
    http.Response response= await http.get("${EntryPoints.GET_USER_RATE_URL}?product=$prodid&user=$userid");
    if(response.statusCode==200)
    {
      return jsonDecode(response.body);
    }
    else
    {
      HelperCodes.showToast(context, "some thing wrong");
      throw('error');
    }


  }
  Future buyProduct(String id,String seller,String buyer,String status) async
  {
    var mymap={'selledby':seller,'buyedby':buyer,'orderstatus':status};
    http.Response response= await http.put("${EntryPoints.BUY_PRODUCT_URL}$id",headers: {'Content-Type':'application/json'},
        body: jsonEncode(mymap));
    if(response.statusCode==200)
    {
      var updating=jsonDecode(response.body);
      if(updating['buying']) {
        HelperCodes.showToast(context, "buying $status");
        return true;
      }
      else
      {
        HelperCodes.showToast(context, "some thing wrong");
        return false;
      }
    }
    else
    {
      HelperCodes.showToast(context, "no response from server");
      return false;
    }
  }
  Future addProductPhoto(String id,String path) async
  {
    var request= await http.MultipartRequest('PUT',Uri.parse("${EntryPoints.ADD_PRODUCT_PHOTO_URL}$id"));
    request.headers['Conten-Type']='multiform/form-data';
    request.files.add(await http.MultipartFile.fromPath('image', path));
    var response=await http.Response.fromStream(await request.send());
    if(response.statusCode==200)
    {
      var adding=jsonDecode(response.body);
      if(adding['added']) {
        HelperCodes.showToast(context, "product photo added");
        return true;
      }
      else
      {
        HelperCodes.showToast(context, "some thing wrong");
        return false;
      }
    }
  }
  Future deleteProductPhoto(String id,String path) async
  {
    var pathmap={'path':path};
    var response=await http.put("${EntryPoints.DELETE_PRODUCT_PHOTO_URL}$id",headers: {"Content-Type":"application/json"},body:jsonEncode(pathmap) );
    if(response.statusCode==200)
    {
      var deleting=jsonDecode(response.body);
      if(deleting['deleted']) {
        HelperCodes.showToast(context, "product photo deleted");
        return true;
      }
      else
      {
        HelperCodes.showToast(context, "some thing wrong");
        return false;
      }
    }
  }
   Future getAllProducts()async
  {
var response= await http.get(EntryPoints.GET_ALLPRODUCTS_URL);
if(response.statusCode==200)
  {
    return jsonDecode(response.body);
   /* List<Product> productslist=[];
    for(int i=0;i<prods.length;i++)
     productslist.add(Product(productname: prods[i]['productname'], price: prods[i]['price'], quantity:prods[i]['quantity'], seller: prods[i]['addedby'],
         productPhoto: prods[i]['productphotos']));
    return productslist;*/
  }
else{
  HelperCodes.showToast(context, "no response from server due to ${response.body}");

}
  }
  Future getSellerProducts(String seller)async
  {
    var response= await http.get('${EntryPoints.GET_SELLERPRODUCTS_URL}?seller=$seller');
    if(response.statusCode==200)
    {
      return jsonDecode(response.body);
      /* List<Product> productslist=[];
    for(int i=0;i<prods.length;i++)
     productslist.add(Product(productname: prods[i]['productname'], price: prods[i]['price'], quantity:prods[i]['quantity'], seller: prods[i]['addedby'],
         productPhoto: prods[i]['productphotos']));
    return productslist;*/
    }
    else{
      HelperCodes.showToast(context, "no response from server due to ${response.body}");

    }
  }
  Future searchProducts(String searched)async
  {
    var response= await http.get("${EntryPoints.SEARCH_PRODUCT_URL}?searched=$searched");
    if(response.statusCode==200)
    {
      return jsonDecode(response.body);

    }
    else{
      HelperCodes.showToast(context, "no response from server due to ${response.body}");

    }
  }
  Future searchProductsBySeller(String sellerid,String searched)async
  {
    var response= await http.get("${EntryPoints.SEARCH_SELLER_PRODUCT_URL}$sellerid?searched=$searched");
    if(response.statusCode==200)
    {
      return jsonDecode(response.body);

    }
    else{
      HelperCodes.showToast(context, "no response from server due to ${response.body}");

    }
  }
  Future getProduct(String prodId)async
  {
    var response= await http.get("${EntryPoints.GET_PRODUCT_URL}?id=$prodId");
    if(response.statusCode==200)
    {
     return  jsonDecode(response.body);
    }
    else{
      HelperCodes.showToast(context, "no response from server due to ${response.body}");
//return null;
    }
  }
  Future addComment(String id,String by,String content) async
  {
    var mymap={'commentedon':id,'commentedby':by,'content':content};
    http.Response response= await http.post("${EntryPoints.ADD_COMMENT_URL}",headers: {'Content-Type':'application/json'},
        body: jsonEncode(mymap));
    if(response.statusCode==200)
    {
      var comment=jsonDecode(response.body);
      if(comment['added']) {
        HelperCodes.showToast(context, "comment added");
        return true;
      }
      else
      {
        HelperCodes.showToast(context, "some thing wrong");
        return false;
      }
    }
    else
    {
      HelperCodes.showToast(context, "no response from server");
      return false;
    }
  }
  Future getAllComments(String id)async
  {
    var response=await http.get("${EntryPoints.GET_ALLCOMMENTS_URL}$id");
    if(response.statusCode==200)
    {
      return jsonDecode(response.body);
    }
    else
      {
        return null;
      }

  }
}