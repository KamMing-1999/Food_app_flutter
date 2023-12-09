import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/controllers/cart_controller.dart';
import 'package:food_app_firebase/controllers/popular_product_controller.dart';
import 'package:food_app_firebase/models/product_model.dart';
import 'package:food_app_firebase/pages/home/main_food_page.dart';
import 'package:food_app_firebase/utils/dimensions.dart';
import 'package:food_app_firebase/widgets/app_column.dart';
import 'package:food_app_firebase/widgets/app_icon.dart';
import 'package:food_app_firebase/widgets/expandable_text.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_and_text_widget.dart';
import '../../widgets/small_text.dart';

// 127. Import the Firebase related libraries
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../cart/cart_page.dart';

class PopularFoodDetail extends StatelessWidget {
  // 155. On popular food detail page, set up the popular food id here
  int pageId;
  // 267. Add one more input 'page' for popular food detail page routing.
  final String page;
  PopularFoodDetail({Key? key, required this.pageId, required this.page}) : super(key: key);

  // 156. Grab the product here from the Firestore
  // 157. Call the collection reference named 'products' inside _FoodPageBodyState
  final CollectionReference _products = FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {

    // 158. Wrap the Scaffold with StreamBuilder
    return StreamBuilder(
      stream: _products.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          // 159. Make DocumentSnapshot by retrieving streamSnapshot data using this.Id
          final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[this.pageId];
          String imageUrl = documentSnapshot['img'];
          // 198. Insert the information into the Product Model
          var product = ProductModel(
            id: documentSnapshot['id'],
            name: documentSnapshot['name'],
            description: documentSnapshot['description'],
            img: documentSnapshot['img'],
            location: documentSnapshot['location'],
            price: documentSnapshot['price'],
            stars: documentSnapshot['stars'],
            typeId: documentSnapshot['type_id'],
            updatedAt: documentSnapshot['updated_at'].toString(),
            createdAt: documentSnapshot['created_at'].toString(),
          );

          // 182. Call the initProduct function to set quantity to zero here
          // 193. Pass the cart object inside the product controller
          Get.find<PopularProductController>().initProduct(product, Get.find<CartController>());

          return Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  // 88. start building the food details page
                  Positioned(
                      left: 0, right: 0,
                      child: Container(
                        width: double.maxFinite,
                        height: Dimensions.popularFoodImgSize,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            // 89. Cover the whole upper part with image
                              fit: BoxFit.cover,
                              // 160. Use Network Image here
                              image: NetworkImage(imageUrl)
                          ),
                        ),
                      )
                  ),
                  // 90. Build Upper row part for storing back and cart buttons
                  Positioned(
                    top: Dimensions.height15 * 3,
                    left: Dimensions.width20, right: Dimensions.width20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 92. Build Back to HomePage and Shopping cart icons using self-built AppIcon widget
                        // 142. Wrap the back button with gesture detector to route back to the home page
                        GestureDetector(
                            onTap: () {
                              // 268. Add conditional check for page routing.
                              if (page=="cartpage") {
                                Get.toNamed(RouteHelper.getCartPage());
                              } else {
                                Get.toNamed(RouteHelper.getInitial());
                              }
                            },
                            child: AppIcon(icon: Icons.arrow_back_ios)
                        ),
                        // 218. Use get builder to access the total number of items in the cart.
                        GetBuilder<PopularProductController>(builder: (controller){
                          // 219. Use Stack Widget to build the small circle showing the number of items in the cart on thecart icon
                          return GestureDetector(
                              // 242. Wrap the cart button stack with items with Gesture Detector so that the button can route to the cart page.
                              onTap: () {
                                // 246. Once created a getCartPage route, use get.toNamed for routing here. Use condition checking for clicking.
                                if (controller.totalItems >= 1) {
                                  Get.toNamed(RouteHelper.getCartPage());
                                }
                              },
                            child: Stack(
                              children: [
                                AppIcon(icon: Icons.shopping_cart_outlined,),
                                controller.totalItems >= 1?
                                Positioned(
                                  // 220. Wrap the small circle with the Positioned widget to move it at upper-right position
                                  right: 0, top: 0,
                                  child: AppIcon(icon: Icons.circle, size: 20,
                                    iconColor: Colors.transparent, backgroundColor: AppColors.mainColor,),
                                ):
                                Container(),

                                // 221. Build the cart number item inside the small circle and center it.
                                Get.find<PopularProductController>().totalItems >= 1?
                                Positioned(
                                  right: 3, top: 3,
                                  child: BigText(
                                    text: Get.find<PopularProductController>().totalItems.toString(),
                                    size: 12, color: Colors.white,
                                  ),
                                ):
                                Container(),
                              ],
                            ),
                          );
                        },)

                      ],
                    ),
                  ),
                  // 93. Build food description part
                  Positioned(
                    left: 0, right: 0, bottom: 0,
                    top: Dimensions.popularFoodImgSize - 20,
                    // 94. Copy the Food title, rating, type, distance and time set from food page body dart file
                    child: Container(
                        padding: EdgeInsets.only(left: Dimensions.width20,
                            right: Dimensions.width20,
                            top: Dimensions.height20),
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(Dimensions.radius20), color: Colors.white
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimensions.radius20),
                              topLeft: Radius.circular(Dimensions.radius20),
                            ),
                            color: Colors.white
                        ),
                        // 96. Call AppColumn here
                        // 99. Wrap AppColumn with Column widget and make Introduction Part
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 161. Retrieve the name and description from the Firestore
                            AppColumn(text: documentSnapshot['name'],),
                            SizedBox(height: Dimensions.height20,),
                            BigText(text: "Introduce"),
                            SizedBox(height: Dimensions.height20,),
                            // 105. Place Expandable Text here and wrap with scrollable and expanded class
                            Expanded(
                                child: SingleChildScrollView(
                                  child: ExpandableText(text: documentSnapshot['description']),
                                )
                            )
                          ],
                        )
                    ),
                  ),
                ],
              ),
              // 100. Make bottom navigation bar here
              // 173. Wrap the Container under bottom navigation bar with getBuilder
              bottomNavigationBar: GetBuilder<PopularProductController>(
                builder: (popularProduct) {
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
                    // 101. Make add/minus buttons and Add to Cart button
                    child: Row(
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
                              GestureDetector(
                                  onTap: () {
                                    // 179. apply the setQuantity function to minus button
                                    popularProduct.setQuantity(false);
                                  },
                                  child: Icon(Icons.remove, color: AppColors.signColor,)
                              ),
                              SizedBox(width: Dimensions.width10 / 2,),
                              // 178. Get access to the popular product quantity inside the controller
                              // 207. Print out the inCartItems quantity value here
                              BigText(text: popularProduct.inCartItems.toString()),
                              SizedBox(width: Dimensions.width10 / 2,),
                              // 172. Wrap the add button with Gesture detector
                              GestureDetector(
                                  onTap: () {
                                    // 174. After using getBuilder, can call the setQuantity function inside controller
                                    popularProduct.setQuantity(true);
                                    // print(product.toString());
                                  },
                                  child: Icon(Icons.add, color: AppColors.signColor,)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: Dimensions.height20,
                              bottom: Dimensions.height20,
                              left: Dimensions.width20,
                              right: Dimensions.width20),
                          // 197. Call the addItem function when typing Add to cart button.
                          child: GestureDetector(
                            onTap: () {
                              // 199. put the product object into add item function.
                              popularProduct.addItem(product);
                            },
                            child: BigText(
                              // 162. Make the price dynamically changed by retrieving id
                                text: "\$ ${documentSnapshot['price'].toString()} "+"| Add to cart", color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radius20),
                              color: AppColors.mainColor
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}
