import 'package:flutter/material.dart';
import 'package:food_app_firebase/controllers/cart_controller.dart';
import 'package:food_app_firebase/utils/colors.dart';
import 'package:get/get.dart';
import '../data/repository/popular_product_repo.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

// 298. Import the Firebase related libraries
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// 121. Create Popular Product Controller and its instance
class PopularProductController extends GetxController {
  final PopularProductRepo popularProductRepo;

  PopularProductController({required this.popularProductRepo});

  // 257. Create empty popular product list and recommended product list with private and public ones
  List<dynamic> _popularProductList=[];
  List<dynamic> get popularProductList => _popularProductList;

  List<dynamic> _recommendedProductList=[];
  List<dynamic> get recommendedProductList => _recommendedProductList;

  // 258. Create a setter each for both popular product list and recommended product list.
  set popularProductList(List<dynamic> value) {
    _popularProductList = value;
  }

  set recommendedProductList(List<dynamic> value) {
    _recommendedProductList = value;
  }

  // 299. Create function to load the resources from the firebase.
  Future<List<dynamic>> loadDataFromFirebase() async {
    try {
      final _productsSnapshot = await FirebaseFirestore.instance.collection('products').get();
      final _recommendedSnapshot = await FirebaseFirestore.instance.collection('recommended').get();

      // 300. Prepare the data array to be returned by processing the snapshot data.
      List<dynamic> firebaseProductList = [];
      for (final docProduct in _productsSnapshot.docs) {
        final productData = docProduct.data();
        // 301. Insert the information into the Product Model
        var product = ProductModel(
          id: productData['id'],
          name: productData['name'],
          description: productData['description'],
          img: productData['img'],
          location: productData['location'],
          price: productData['price'],
          stars: productData['stars'],
          typeId: productData['type_id'],
          updatedAt: productData['updated_at'].toString(),
          createdAt: productData['created_at'].toString(),
        );
        firebaseProductList.add(product);
      }
      List<dynamic> firebaseRecommendedList = [];
      for (final docRecommended in _recommendedSnapshot.docs) {
        final recommendedData = docRecommended.data();
        // 301. Insert the information into the Product Model
        var product = ProductModel(
          id: recommendedData['id'],
          name: recommendedData['name'],
          description: recommendedData['description'],
          img: recommendedData['img'],
          location: recommendedData['location'],
          price: recommendedData['price'],
          stars: recommendedData['stars'],
          typeId: recommendedData['type_id'],
          updatedAt: recommendedData['updated_at'].toString(),
          createdAt: recommendedData['created_at'].toString(),
        );
        firebaseRecommendedList.add(product);
      }

      List<dynamic> returnData = [];
      returnData.add(firebaseProductList);
      returnData.add(firebaseRecommendedList);
      return returnData;

    } catch (error) {
      // Handle any error
      print('Error loading data: $error');
      return [[],[]];
    }
  }

  Future<void> getPopularProductList() async {
    Response response = await popularProductRepo.getPopularProductList();

    if (response.statusCode==200){
      _popularProductList=[];
      _popularProductList.addAll(Product.fromJson(response.body).products as Iterable);
      update();
    } else {

    }
  }

  // 302. create a function to allow other classes to access the popular and recommended food list
  Future<void> getPopularProductListFromFirebase() async {
    List<dynamic> productList = await loadDataFromFirebase();
    if (productList.isEmpty || productList.every((innerList) => innerList.isEmpty)) {
      _popularProductList=[];
    } else {
      _popularProductList=[];
      _popularProductList.addAll(productList[0]);
      update();
    }
  }

  Future<void> getRecommendedProductListFromFirebase() async {
    List<dynamic> productList = await loadDataFromFirebase();
    if (productList.isEmpty || productList.every((innerList) => innerList.isEmpty)) {
      _popularProductList=[];
    } else {
      _popularProductList=[];
      _popularProductList.addAll(productList[1]);
      update();
    }
  }

  // 171. check quantity increments for shopping cart function
  int _quantity = 0;
  // 177. create a quantity which allows public access.
  int get quantity => _quantity;

  // 183. set up inCartItems variable to save the previous set quantity
  int _inCartItems = 0;
  int get inCartItems => _inCartItems+_quantity;

  void setQuantity(bool isIncrement) {
    // 181. use the checkQuantity() function here
    if(isIncrement){
      _quantity = checkQuantity(_quantity+1);
      // print("number of items: "+_quantity.toString());
      // 176. test whether the controller is accessed successfully
    }else{
      _quantity = checkQuantity(_quantity-1);
      // print("number of items: "+_quantity.toString());
    }
    // 178. call the update() function to tell the application to update the value immediately.
    update();
  }

  // 180. add check _quantity function and pop up snack-bar message (range 0-20)
  int checkQuantity(int quantity) {
    // 208. Check the sum of (inCartItems + quantity) instead of just quantity
    // Explanation: quantity is the change of product quantity which can be negative
    // while the inCartItems value mustn't be negative
    if ((_inCartItems + quantity)<0){
      Get.snackbar("Item count", "You can't reduce more!",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white
      );
      // 230. If _inCartItems is positive while sum of (_inCartItems + quantity) is negative,
      // make _quantity value equals to minus _inCartItems and then return _quantity
      // This helps solves the bug when successive reduce product number and once drop to zero,
      // then it comes back to positive _inCartItems.
      if (_inCartItems > 0) {
        _quantity = -_inCartItems;
        return _quantity;
      }
      return 0;
    }else if((_inCartItems + quantity)>20){
      Get.snackbar("Item count", "You can't add more!",
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white
      );
      return 20;
    }else{
      return quantity;
    }
  }

  // 194. Call the cart controller in popular product controller
  late CartController _cart;
  // 181. initialize product quantity to zero once opened a new page
  void initProduct(ProductModel product, CartController cart) {
    _quantity = 0;
    _inCartItems = 0;
    // 184. Check if the previous page has quantity saved. If yes, get from storage inCartItems
    // 195. set the cart controller inside init Product
    _cart = cart;
    // 204. Create a flag to check if the product exists in the cart.
    var exist = false;
    exist = _cart.existInCart(product);
    // print("exist or not "+exist.toString());

    // 206. Check if the product exists in the cart, then get its quantity in the cart.
    if (exist) {
      _inCartItems = _cart.getQuantity(product);
    }
    // print("the quantity in the cart is "+_inCartItems.toString());
  }

  // 192. Create a function addItem to popular product controller
  void addItem(ProductModel product) {
    // 196. Call the cart controller add item function inside popular product controller add item function here
    // 201. Add a conditional checking to see if the quantity is greater than 0.
    // 212. Remove the condition checking inside addItem function. And the checking is moved to cart controller addItem function.
    // if (quantity > 0) {
      _cart.addItem(product, _quantity);
      // 210. Reset the quantity to zero and get back the value of inCartItems from the cart
      _quantity = 0;
      _inCartItems = _cart.getQuantity(product);

      _cart.items.forEach((key, value) {
        // print("The id is "+value.id.toString()+" The quantity is "+value.quantity.toString());
      });
    /*} else {
      Get.snackbar("Item count", "You should at least add an item in the cart.",
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white
      );
    }*/
    update();   // 220. Update (set state) the cart items number immediately.
  }

  // 217. Get the total number of items from the cart controller
  int get totalItems {
    return _cart.totalItems;
  }

  // 234. In popular product controller, create a function to get all cart items by calling the getItems function in cart controller.
  List<CartModel> get getItems {
    return _cart.getItems;
  }
}