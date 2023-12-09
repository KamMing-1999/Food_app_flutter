// 185. create a class called CartRepo to make a shopping cart data structure

import 'dart:convert';

import 'package:food_app_firebase/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cart_model.dart';

class CartRepo {
  // 308. Create an instance called sharedPreferences and initialize it.
  final SharedPreferences sharedPreferences;
  CartRepo({ required this.sharedPreferences });

  List<String> cart = [];
  List<String> cartHistory = [];

  // 310. save the cart list here and convert cartList from List type to json encoded string type
  void addToCartList(List<CartModel> cartList) {
    var time = DateTime.now().toString();
    cart = [];
    // 328. remove the sharedPreference for debugging purpose only. Should comment it out in real app.
    // sharedPreferences.remove(AppConstants.CART_LIST);
    // sharedPreferences.remove(AppConstants.CART_HISTORY);

    // 311. Convert objects to string because sharedPreferences only accepts string (encoded json)
    cartList.forEach((element) {
      // 333. Record/reset the time now that all the products in the cart was submitted to the history list at the same time.
      element.time = time;
      return cart.add(jsonEncode(element));
    });
    // Shorthand form:
    // cartList.forEach((element) => cart.add(jsonEncode(element)));

    sharedPreferences.setStringList(AppConstants.CART_LIST, cart);
    // 312. print out the shared preference (cart) for debugging.
    print(sharedPreferences.getStringList(AppConstants.CART_LIST));

    // 317. call the get cart list function here
    getCartList();
  }

  // 315. Create a function to get the cart list history that is saved locally.
  List<CartModel> getCartList() {
    List<String> carts = [];
    if (sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      carts = sharedPreferences.getStringList(AppConstants.CART_LIST)!;
      // print("Inside getCartList: "+carts.toString());
    }
    List<CartModel> cartList=[];

    // 316. Get the cart list from the cart model string looping
    /* carts.forEach((element) {
      cartList.add(CartModel.fromJson(jsonDecode(element)));
    }); */
    // Shorthand form:
    carts.forEach((element) => cartList.add(CartModel.fromJson(jsonDecode(element))));

    return cartList;
  }

  // 325. Create a function to add the cart record to the history list.
  void addToCartHistoryList() {
    // 332. If the history has already been there in shared preference, cart history will be the shared preference one.
    if (sharedPreferences.containsKey(AppConstants.CART_HISTORY)) {
      cartHistory = sharedPreferences.getStringList(AppConstants.CART_HISTORY)!;
    }

    for (int i=0; i<cart.length; i++) {
      // print("history list: "+cart[i]);
      cartHistory.add(cart[i]);
    }
    removeCart();
    sharedPreferences.setStringList(AppConstants.CART_HISTORY, cartHistory);
    print("The length of history list is: "+getCartHistoryList().length.toString());

    // 334. debugging: find the cart history list order time
    for (int j=0; j<getCartHistoryList().length; j++) {
      print("The time for the order is " +
          getCartHistoryList()[j].time.toString());
    }
  }

  // 330. Create a function to empty out cart from the shared preferences.
  void removeCart() {
    cart = [];
    sharedPreferences.remove(AppConstants.CART_LIST);
  }

  // 331. create a function to get the cart history list.
  List<CartModel> getCartHistoryList() {
    if (sharedPreferences.containsKey(AppConstants.CART_HISTORY)) {
      cartHistory = [];
      cartHistory = sharedPreferences.getStringList(AppConstants.CART_HISTORY)!;
    }
    List<CartModel> cartListHistory=[];
    cartHistory.forEach((element) => cartListHistory.add(CartModel.fromJson(jsonDecode(element))));
    return cartListHistory;
  }
}