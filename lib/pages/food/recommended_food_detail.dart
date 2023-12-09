import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/controllers/popular_product_controller.dart';
import 'package:food_app_firebase/utils/colors.dart';
import 'package:food_app_firebase/utils/dimensions.dart';
import 'package:food_app_firebase/widgets/big_text.dart';
import 'package:food_app_firebase/widgets/expandable_text.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../models/product_model.dart';
import '../../routes/route_helper.dart';
import '../../widgets/app_icon.dart';

// 127. Import the Firebase related libraries
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../cart/cart_page.dart';

class RecommendedFoodDetail extends StatelessWidget {
  // 166. Add and set pageId just like popular Food Detail
  int pageId;
  String page;
  // 269. Add input 'page' for recommended food page routing.
  RecommendedFoodDetail({Key? key, required this.pageId, required this.page}) : super(key: key);

  // 167. Grab the product here from the Firestore
  // 168. Call the collection reference named 'recommended' inside _FoodPageBodyState
  final CollectionReference _recommended = FirebaseFirestore.instance.collection('recommended');

  @override
  Widget build(BuildContext context) {
    // 169. Wrap the Scaffold with StreamBuilder and make the static inputs dynamic
    return StreamBuilder(
      stream: _recommended.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          // 170. Make DocumentSnapshot by retrieving streamSnapshot data using this.Id
          final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[this.pageId];
          String imageUrl = documentSnapshot['img'];
          // 227. Insert the information into the Product Model
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

          // 228. Pass the cart object inside the product controller to initialize cart
          Get.find<PopularProductController>().initProduct(product, Get.find<CartController>());

          return Scaffold(
            backgroundColor: Colors.white,
            // 107. Make CustomScrollView of recommended food page
            body: CustomScrollView(
              slivers: [
                // 108. Make Sliver App Bar which shows the upper part
                SliverAppBar(
                  // 150. Set automaticallyImplyLeading: false here
                  automaticallyImplyLeading: false,
                  // 111. Add Cart and Clear buttons
                  toolbarHeight: Dimensions.height20*4,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 151. Add gesture detector on the back button
                      GestureDetector(
                          onTap: () {
                            // 270. Add conditional check for page routing.
                            if (page=="cartpage") {
                              Get.toNamed(RouteHelper.getCartPage());
                            } else {
                              Get.toNamed(RouteHelper.getInitial());
                            }
                          },
                          child: AppIcon(icon: Icons.clear)
                      ),

                      // 229. Copy and paste the getbuilder small circle on the cart button logic.
                      GetBuilder<PopularProductController>(builder: (controller){
                        return GestureDetector(
                          // 244. Wrap the cart button stack with items with Gesture Detector so that the button can route to the cart page.
                          onTap: () {
                            // 247. Applies the dynamic cart page routing to here as well.
                            if (controller.totalItems >= 1) {
                              Get.toNamed(RouteHelper.getCartPage());
                            }
                          },
                          child: Stack(
                            children: [
                              AppIcon(icon: Icons.shopping_cart_outlined,),
                              controller.totalItems >= 1?
                              Positioned(
                                right: 0, top: 0,
                                  child: AppIcon(icon: Icons.circle, size: 20,
                                    iconColor: Colors.transparent, backgroundColor: AppColors.mainColor,),
                              ):
                              Container(),
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
                  bottom: PreferredSize(
                    // 110. This part builds the title part between picture and description
                    preferredSize: Size.fromHeight(20),
                    child: Container(
                      child: Center(child: BigText(size: Dimensions.font26,
                          text: documentSnapshot['name'])),
                      width: double.maxFinite,
                      padding: EdgeInsets.only(top: 5, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.height20),
                              topRight: Radius.circular(Dimensions.height20)
                          )
                      ),
                    ),
                  ),
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: AppColors.yellowColor,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                        imageUrl,
                        width: double.maxFinite,
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                // 109. Make sliver to box adapter to load long text using Expandable text
                SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: Dimensions.width20,
                              right: Dimensions.width20
                          ),
                          child: ExpandableText(
                              //text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent venenatis vestibulum massa at placerat. Quisque et sollicitudin ipsum. In pretium efficitur tincidunt. Nullam vehicula diam magna, quis interdum mauris accumsan eget. Fusce lorem nisl, auctor vitae convallis eu, consequat sed ipsum. Nulla interdum consectetur quam vitae vehicula. Integer semper tellus quis eros facilisis luctus. Suspendisse eu diam ipsum. Suspendisse potenti. Suspendisse pulvinar semper tincidunt. In tempus, nisi ut tincidunt commodo, ex risus ornare dolor, quis congue neque ipsum sed lectus. Proin condimentum metus vitae laoreet imperdiet. Ut quis massa sagittis, pharetra nulla sed, facilisis libero. Phasellus semper ultrices volutpat. Quisque elementum velit ante, sed vestibulum nibh euismod ac.Nam viverra massa id ipsum posuere varius. Proin ac tortor magna. Nullam tempor, ex eget ullamcorper blandit, ligula enim pretium erat, eu sollicitudin orci nulla ut purus. Etiam vehicula sem nec mollis suscipit. Sed odio metus, porttitor ac erat eget, consequat viverra metus. Maecenas gravida leo sapien, a sodales turpis consectetur ac. Nam imperdiet venenatis posuere. Aenean maximus lobortis nulla vitae consequat. Donec fermentum massa ipsum, vel consequat metus fermentum ut. Curabitur elementum urna in massa laoreet, non molestie magna vulputate.Sed varius arcu velit, non placerat ex finibus eu. Donec commodo nisl quis erat dignissim finibus. Proin placerat at lorem ut pharetra. Duis tincidunt facilisis eros, vel faucibus metus sollicitudin non. Sed nec lectus tincidunt, tincidunt elit at, vehicula dolor. Maecenas eget pharetra orci, eu varius erat. Praesent aliquam dolor nec iaculis vulputate. Quisque blandit malesuada molestie. In eu magna a ex consequat semper id congue ligula. Integer luctus quam velit, at facilisis dolor tincidunt quis. Sed blandit eget felis et varius.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent vitae sagittis tellus, sed ultricies ipsum. Etiam quam nisi, rhoncus quis pretium quis, cursus quis enim. Pellentesque ut est a mauris auctor porttitor. In efficitur blandit viverra. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Duis eu dignissim mauris. Fusce sed eros turpis.Proin non vulputate nulla. Pellentesque quis commodo massa. Integer tincidunt ipsum odio. Ut egestas mauris in tellus pharetra sollicitudin. Morbi varius vitae arcu sed luctus. Aliquam accumsan, orci eget venenatis pellentesque, lacus odio porttitor erat, ac hendrerit nisl nisi nec orci. Nullam molestie finibus sollicitudin. Suspendisse posuere justo eget diam consequat malesuada. Donec in est quis felis fringilla porta quis eget dolor. Donec ipsum nisl, egestas at ex aliquet, imperdiet vestibulum urna. Suspendisse maximus volutpat semper. Donec eu metus sit amet erat euismod suscipit. Donec iaculis tempor porttitor. Nulla pellentesque nulla tellus, id dignissim est imperdiet sit amet. Pellentesque dui lectus, tempor a metus id, hendrerit efficitur massa. Sed feugiat, lorem ut consequat gravida, risus mauris vehicula nibh, eu suscipit arcu elit non dolor."
                              text: documentSnapshot['description']
                          ),
                        )
                      ],
                    )
                )
              ],
            ),
            // 112. Build Row with add/minus buttons and price times quantity
            // 222. Reuse the functions in popular_product_controller to manage cart for recommended food details
            bottomNavigationBar: GetBuilder<PopularProductController>(builder: (controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: Dimensions.width20 * 2.5,
                        right: Dimensions.width20 * 2.5
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 224. Set Gesture Detector on remove button on recommended food details
                        GestureDetector(
                          onTap: () {
                            controller.setQuantity(false);
                          },
                          child: AppIcon(icon: Icons.remove,
                            backgroundColor: AppColors.mainColor,
                            iconColor: Colors.white,
                            iconSize: Dimensions.iconSize24,),
                        ),
                        // 225. Insert the inCartItems value at the quantity place
                        BigText(text: "\$ ${documentSnapshot['price'].toString()} x ${controller.inCartItems} ",
                            color: AppColors.mainBlackColor,
                            size: Dimensions.font26),
                        // 223. Set Gesture Detector on add button on recommended food details
                        GestureDetector(
                          onTap: () {
                            controller.setQuantity(true);
                          },
                          child: AppIcon(icon: Icons.add,
                            backgroundColor: AppColors.mainColor,
                            iconColor: Colors.white,
                            iconSize: Dimensions.iconSize24,),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.height10,),
                  // 113. Build Row with quantity add/minus buttons and Add to favorite button
                  // Step 113. End of building the food items UI part.
                  Container(
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
                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                              color: Colors.white
                          ),
                          child: Icon(
                            Icons.favorite, color: AppColors.mainColor,
                          ),
                        ),
                        // 226. Insert Add to cart function to the add to cart button
                        GestureDetector(
                          onTap: () {
                            controller.addItem(product);
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: Dimensions.height20,
                                bottom: Dimensions.height20,
                                left: Dimensions.width20,
                                right: Dimensions.width20),
                            child: BigText(
                                text: "\$ ${documentSnapshot['price'].toString()} | Add to cart", color: Colors.white),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions
                                    .radius20),
                                color: AppColors.mainColor
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
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
