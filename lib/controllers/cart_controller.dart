// 186. create a class called Cart Controller to make several shopping cart function

import 'package:flutter/material.dart';
import 'package:food_app_firebase/data/repository/cart_repo.dart';
import 'package:food_app_firebase/models/cart_model.dart';
import 'package:food_app_firebase/models/product_model.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';

class CartController extends GetxController {
  // 187. Initialize cart controller
  final CartRepo cartRepo;
  CartController({required this.cartRepo});

  // 189. Make a map to link the cart with items chosen
  Map<int, CartModel> _items = {};

  // 321. Create a variable called storageItems. Only for storage and shared preferences.
  List<CartModel> storageItems = [];

  // 202. Create a cart model key-pair values which allows items to be publicly accessed.
  Map<int, CartModel> get items => _items;

  // 191. Create function to add items to a shopping cart and map the fields
  void addItem(ProductModel product, int quantity) {
    // 201. Check if item key (product id) is included in the items array. If yes, update the quantity
    // 213. Set the local total quantity here.
    var totalQuantity = 0;
    if (_items.containsKey(product.id!)) {
      _items.update(product.id!, (value) {
        // 214. sum up the add item quantity and original quantity of the product in the cart
        totalQuantity = value.quantity!+quantity;

        return CartModel(
          id: value.id,
          name: value.name,
          price: value.price,
          img: value.img,
          quantity: value.quantity! + quantity,  // update the quantity
          isExist: true,
          time: DateTime.now().toString(),
          // 251. Add and get/set product attribute for cart model here
          product: product,
        );
      });

      if (totalQuantity <= 0) {
        // 215. if the total quantity of product in cart is zero or less, remove the product by id from the cart
        _items.remove(product.id);
      }
    } else {
      // 211. Add condition checking to check if the product in cart quantity is greater than zero, then add the product into cart
      if (quantity > 0) {
        _items.putIfAbsent(product.id!, () {
          // print("adding item to the cart "+product.id!.toString()+" quantity "+quantity.toString()+" and price "+product.price.toString());
          return CartModel(
            id: product.id,
            name: product.name,
            price: product.price,
            img: product.img,
            quantity: quantity,
            isExist: true,
            time: DateTime.now().toString(),
            product: product,
          );
        });
      } else {
        Get.snackbar("Item count", "You should at least add an item in the cart.",
            backgroundColor: AppColors.mainColor,
            colorText: Colors.white
        );
      }
    }

    // 200. check whether the add item functions normally in cart controller by debugging
    // print("length of the items is "+_items.length.toString());
    print(_items.toString());
    _items.forEach((key, value) {
      // print("quantity is "+value.quantity.toString());
    });

    // 254. Call the update() function to immediately update the quantity once clicked the button.
    // 309. Call the addToCartList function of CartRepo here.
    cartRepo.addToCartList(getItems);
    update();
  }

  // 203. Create a function to check if the product exists in the shopping cart
  bool existInCart(ProductModel product) {
    if (_items.containsKey(product.id)) {
      return true;
    }
    return false;
  }

  // 205. Create a function to check the quantity of a specific product in the cart.
  int getQuantity(ProductModel product) {
    var quantity = 0;
    if (_items.containsKey(product.id)) {
      _items.forEach((key, value) {
        if (key == product.id) {
          quantity = value.quantity!;
        }
      });
    }
    return quantity;
  }

  // 216. Create a function to get number of total items in the cart
  int get totalItems {
    var totalQuantity = 0;
    _items.forEach((key, value) {
      totalQuantity += value.quantity!;
    });
    return totalQuantity;
  }

  // 233. Create a functions to get all items in the cart.
  List<CartModel> get getItems {
    return _items.entries.map((e) {
      return e.value;
    }).toList();
  }

  // 272. Create a function to get the total amounts to pay for the products in the cart.
  int get totalAmount {
    var total = 0;
    _items.forEach((key, value) {
      total += value.quantity! * value.price!;
    });
    return total;
  }

  // 320. Create a function called getCartData so that the cart data can be saved even the app is killed.
  List<CartModel> getCartData() {
    setCart = cartRepo.getCartList();
    return storageItems;
  }

  // 322. create a setter for cart items to let it publicly accessed and altered.
  set setCart(List<CartModel> items) {
    storageItems=items;
    print("Length of cart items "+storageItems.length.toString());
    // 323. Put all the storage items in the _items variable, which makes the cart data exists even killed the app.
    for (int i=0; i<storageItems.length; i++) {
      _items.putIfAbsent(storageItems[i].product!.id!, () => storageItems[i]);
    }
  }

  // 326. create a function for the checkout button to add the cart record to the history page.
  void addToHistory() {
    cartRepo.addToCartHistoryList();
    // 329. Once added to cart history, should empty out the cart items.
    clear();
  }

  void clear() {
    _items = {};
    update();
  }

  // 339. Create a function to get the cart history list
  List<CartModel> getCartHistoryList() {
    return cartRepo.getCartHistoryList();
  }

  // 353. Create a function to set the items for cart history page routing to order list.
  set setItems(Map<int, CartModel> setItems) {
    _items = {};
    _items = setItems;
  }

  // 355. Create add to cart list function to be get called.
  void addToCartList() {
    cartRepo.addToCartList(getItems);
    update();
  }

}