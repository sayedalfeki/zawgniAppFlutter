class EntryPoints
{
  static bool address_type=true;
  static final String BASE_URL=address_type?"http://192.168.1.2:3333":"http://192.168.43.11:3333";
  static final String IS_USERNAME_URL="$BASE_URL/user/isusername";
  static final String IS_EMAIL_URL="$BASE_URL/user/isemail";
  static final String REGISTER_USER_URL="$BASE_URL/user/adduser";
  static final String UPDATE_USER_URL="$BASE_URL/user/updateuser";
  static final String UPDATE_PROFILE_IMAGE_URL="$BASE_URL/user/updateprofileimage";
  static final String LOGIN_USER_URL="$BASE_URL/user/isuser";
  static final String ADD_PHONE_URL="$BASE_URL/user/addphone";
  static final String DELETE_PHONE_URL="$BASE_URL/user/deletephone";
  static final String CHANGE_PASSWORD_URL="";
  static final String CHANGE_EMAIL_URL="";
  static final String CHANGE_USERNAME__URL="";
  static final String CHNGE_NAMES_USER_URL="$BASE_URL/user/updatename";
  static final String ADD_CHAT_URL="$BASE_URL/user/chat";
  static final String GET_USERID_URL="$BASE_URL/user/getuserid";
  static final String GET_USER_URL="$BASE_URL/user/getuser";
  static final String IMAGE_URL="${BASE_URL}/";
  static final String ADD_PRODUCT_URL="$BASE_URL/product/addproduct";
  static final String DELETE_PRODUCT_URL="$BASE_URL/product/deleteproduct";
  static final String ADD_PRODUCT_PHOTO_URL="$BASE_URL/product/addproductphoto";
  static final String DELETE_PRODUCT_PHOTO_URL="$BASE_URL/product/deleteproductphoto";
  static final String DELETE_FILE_URL="$BASE_URL/product/deletefile";
  static final String UPDATE_PRODUCT_URL="$BASE_URL/product/updateproduct";
  static final String ADD_COMMENT_URL="$BASE_URL/comment/addcomment";
  static final String GET_ALLCOMMENTS_URL="$BASE_URL/comment/allcomments";
  static final String ADD_LIKE_URL="$BASE_URL/product/hitlike";
  static final String DELETE_LIKE_URL="$BASE_URL/product/unlike";
  static final String ADD_DISLIKE_URL="$BASE_URL/product/dislike";
  static final String DELETE_DISLIKE_URL="$BASE_URL/product/undislike";
  static final String ADD_RATE_URL="$BASE_URL/rate/addrate";
  static final String DELETE_RATE_URL="$BASE_URL/rate/deleterate";
  static final String GET_RATE_URL="$BASE_URL/rate/getrate";
  static final String GET_USER_RATE_URL="$BASE_URL/rate/getuserrate";
  static final String BUY_PRODUCT_URL="$BASE_URL/product/buyproduct";
  static final String GET_ALLPRODUCTS_URL="$BASE_URL/product/allproducts";
  static final String GET_SELLERPRODUCTS_URL="$BASE_URL/product/sellerproducts";
  static final String GET_PRODUCT_URL="$BASE_URL/product/getproduct";
  static final String SEARCH_PRODUCT_URL="$BASE_URL/product/searchproduct";
  static final String SEARCH_SELLER_PRODUCT_URL="$BASE_URL/product/searchproductbyseller";
  /////////////////////////////////////////////////////////////////////////////////////////
  static final String ADD_ORDER_URL="$BASE_URL/order/addorder";
  static final String GET_BUYERORDERS_URL="$BASE_URL/order/allbuyerorder";
  /////////////////////////////////////////////////////////////////////////////////////////////
  static final String SEND_MESSAGE_URL="$BASE_URL/message/sendmessage";
  static final String GET_ALL_USER_MESSAGE_URL="$BASE_URL/message/getallusermessages";
  static final String GRT_ALL_BET_MESSAGE_URL="$BASE_URL/message/getallbetweenmessages";
  static String getBaseurl(int type){
    if(type==1)
      return "http://192.168.1.2:3333/";
    else
      return "http://192.168.43.11:3333/";
  }
}