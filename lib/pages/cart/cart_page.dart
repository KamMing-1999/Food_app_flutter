// 231. Create a page to show cart items
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/base/no_data_page.dart';
import 'package:food_app_firebase/controllers/popular_product_controller.dart';
import 'package:food_app_firebase/pages/home/main_food_page.dart';
import 'package:food_app_firebase/utils/dimensions.dart';
import 'package:food_app_firebase/widgets/app_icon.dart';
import 'package:food_app_firebase/widgets/small_text.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/location_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../widgets/big_text.dart';


class CartPage extends StatelessWidget {
  CartPage({Key? key}) : super(key: key);

  // 438. Suppose the user is logged in using Firebase Auth, retrieve the data by authController.
  final currentUser = Get.find<AuthController>().currentUser;

  @override
  Widget build(BuildContext context) {

    // 439. Get user account info by the auto generated uid.
    String? uid = currentUser?.uid;

    // 440. Wrap the Account page with stream builder.
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: Dimensions.height20*3,
                left: Dimensions.width20,
                right: Dimensions.width20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 232. Create back, home and cart buttons on cart page.
                    AppIcon(icon: Icons.arrow_back_ios,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.iconSize24,
                    ),
                    SizedBox(width: Dimensions.width20*5,),
                    GestureDetector(
                      // 243. Add gesture detector for home button to route to homepage.
                      onTap: () {
                        Get.toNamed(RouteHelper.getInitial());
                      },
                      child: AppIcon(icon: Icons.home_outlined,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.mainColor,
                        iconSize: Dimensions.iconSize24,
                      ),
                    ),
                    AppIcon(icon: Icons.shopping_cart,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.iconSize24,
                    )
                  ],
                )
              ),
              // 235. Create the area of placing the product list in the cart.
              // 358. Check whether the cart is empty. If it is empty, show the empty cart message.
              GetBuilder<CartController>(builder: (_cartController) {
                return _cartController.getItems.length>0?
                Positioned(
                  top: Dimensions.height20*5, left: Dimensions.width20, right: Dimensions.width20, bottom: 0,
                  child: Container(
                      margin: EdgeInsets.only(top: Dimensions.height15),
                      //color: Colors.red,
                      // 236. Create the list design and structure.
                      // 238. Remove the top padding of the list.
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        // 241. Use GetBuilder to access the cart info and make the static inputs dynamic by filling the spaces.
                        child: GetBuilder<CartController>(builder: (cartController){
                          // 248. Declare the cart list here for easier data retrieval.
                          var _cartList = cartController.getItems;

                          return ListView.builder(
                              itemCount: _cartList.length,
                              itemBuilder: (_, index) {
                                return Container(
                                  height: Dimensions.height20*5,
                                  width: double.maxFinite,
                                  // 237. Create the inner structure of each product in the cart.
                                  child: Row(
                                    children: [
                                      // 255. Wrap the Image Container in Cart Page with Gesture Detector
                                      GestureDetector(
                                        onTap: () {
                                          // 256. Find whether the product comes from popular or recommended.
                                          // 261. Find if popularIndex or recommendedIndex is positive. Then route to the popular/recommended food page.
                                          print(index);
                                          var popularIndex = Get.find<PopularProductController>()
                                              .popularProductList.indexOf(_cartList[index].product!);
                                          var recommendedIndex = Get.find<PopularProductController>()
                                              .recommendedProductList.indexOf(_cartList[index].product!);

                                          // 262. The above method seems not working. Then we try to prepare 2 arrays to store the product ids.
                                          List<int> p_idx_array = [];
                                          List<int> r_idx_array = [];
                                          int p_index = 0;
                                          int r_index = 0;
                                          for (p_index = 0; p_index < Get.find<PopularProductController>().popularProductList.length; p_index++) {
                                            p_idx_array.add(Get.find<PopularProductController>().popularProductList[p_index].id);
                                          }
                                          for (r_index = 0; r_index < Get.find<PopularProductController>().recommendedProductList.length; r_index++) {
                                            r_idx_array.add(Get.find<PopularProductController>().recommendedProductList[r_index].id);
                                          }

                                          print(p_idx_array);
                                          print(r_idx_array);

                                          print(p_index);
                                          print(r_index);

                                          var id_picked = _cartList[index].product!.id;

                                          // 263. Then check whether the id exists in popular index or recommended index.
                                          popularIndex = p_idx_array.indexOf(id_picked!);
                                          recommendedIndex = r_idx_array.indexOf(id_picked!);

                                          if (popularIndex >= 0) {
                                            Get.toNamed(RouteHelper.getPopularFood(popularIndex, "cartpage"));
                                          } else {
                                            if (recommendedIndex >= 0) {
                                              Get.toNamed(RouteHelper.getRecommendedFood(recommendedIndex, "cartpage"));
                                            } else {
                                              Get.snackbar("History product", "Product review is not available!",
                                                  backgroundColor: AppColors.mainColor, colorText: Colors.white);
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: Dimensions.height20*5,
                                          height: Dimensions.height20*5,
                                          margin: EdgeInsets.only(bottom: Dimensions.height10),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(cartController.getItems[index].img!)
                                              ),
                                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                                              color: Colors.white
                                          ),
                                        ),
                                      ),

                                      // 239. Use Expanded widget to construct the right info bar next to the image.
                                      SizedBox(width: Dimensions.width10),
                                      Expanded(child: Container(
                                          height: Dimensions.height20*5,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              BigText(text: _cartList[index].name!, color: Colors.black54,),
                                              SmallText(text: "Spicy"),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  BigText(text: "\$ ${_cartList[index].price.toString()}", color: Colors.redAccent),
                                                  // 240. Copy the add/reduce button from the popular product controller and adjust height ans width to 10
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: Dimensions.height10,
                                                        bottom: Dimensions.height10,
                                                        left: Dimensions.width10,
                                                        right: Dimensions.width10),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(
                                                            Dimensions.radius20),
                                                        color: Colors.white
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () {
                                                              // 252. Call the cart controller addItem here and set quantity to -1 for reduction
                                                              cartController.addItem(_cartList[index].product!, -1);
                                                            },
                                                            child: Icon(Icons.remove, color: AppColors.signColor,)
                                                        ),
                                                        SizedBox(width: Dimensions.width10 / 2,),
                                                        // 249. get the cart items quantities here
                                                        BigText(text: '${_cartList[index].quantity.toString()}'),
                                                        SizedBox(width: Dimensions.width10 / 2,),
                                                        // 172. Wrap the add button with Gesture detector
                                                        GestureDetector(
                                                            onTap: () {
                                                              // 253. Call the cart controller addItem here and set quantity to 1 for addition
                                                              cartController.addItem(_cartList[index].product!, 1);
                                                            },
                                                            child: Icon(Icons.add, color: AppColors.signColor,)
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          )
                                      ))
                                    ],
                                  ),
                                );
                              });
                        }),
                      )
                  ),
                ):NoDataPage(text: "Your cart is empty");
              })
            ],
          ),
          // 271. Copy and paste the navigation bar from popular food detail. Remove the add/reduce buttons.
          // 273. Change get builder controller to cart controller to get access to its functions.
          bottomNavigationBar: GetBuilder<CartController>(
              builder: (cartController) {
                return Container(
                  height: Dimensions.height20 * 6,
                  padding: EdgeInsets.only(top: Dimensions.height15 * 2,
                      bottom: Dimensions.height15 * 2,
                      left: Dimensions.width10 * 2,
                      right: Dimensions.width10 * 2),
                  decoration: BoxDecoration(
                      color: AppColors.buttonBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.radius20 * 2),
                          topRight: Radius.circular(Dimensions.radius20 * 2)
                      )
                  ),
                  // 359. Check whether there are cart items in the cart.
                  child: cartController.getItems.length>0?Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: Dimensions.height20,
                            bottom: Dimensions.height20,
                            left: Dimensions.width20,
                            right: Dimensions.width20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.radius20),
                            color: Colors.white
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: Dimensions.width10 / 2,),
                            // 275. Print the total amount here.
                            BigText(text: "\$ "+cartController.totalAmount.toString()),
                            SizedBox(width: Dimensions.width10 / 2,),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: Dimensions.height20,
                            bottom: Dimensions.height20,
                            left: Dimensions.width20,
                            right: Dimensions.width20),
                        child: GestureDetector(
                          onTap: () {
                            //popularProduct.addItem(product);
                            // 327. Call the addToHistory function on the Checkout button on cart page.
                            //cartController.addToHistory();
                            // 426. Add checking to see if a user has logged in. If not route to SignIn Page.
                            if (snapshot.hasData) {
                              final data = snapshot.data!.data();
                              if (data is Map<String, dynamic>) {
                                // cartController.addToHistory();
                                // 441. Check if the address list is empty or not. If is empty go to the address page.
                                if (Get.find<LocationController>().addressList.isEmpty) {
                                  Get.toNamed(RouteHelper.getAddressPage());
                                } else {
                                  // 473. Else empty out the address List, checkout and get back to the main home page.
                                  // Get.find<LocationController>().addressList = [];
                                  // Get.find<CartController>().addToHistory();
                                  // Get.offNamed(RouteHelper.getInitial());
                                  // 526. Create a route to go to the Payment Page.
                                  Get.offNamed(RouteHelper.getPaymentPage("100127", 1));
                                }
                              } else {
                                Get.toNamed(RouteHelper.getSignInPage());
                              }
                            } else {
                              Get.toNamed(RouteHelper.getSignInPage());
                            }
                          },
                          child: BigText(
                            // 274. Change the button to "Check out"
                              text: "Check out", color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.radius20),
                            color: AppColors.mainColor
                        ),
                      )
                    ],
                  ):Container(),
                );
              },
            ),
        );
      }
    );
  }
}
