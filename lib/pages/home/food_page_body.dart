import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/pages/food/popular_food_detail.dart';
import 'package:food_app_firebase/widgets/big_text.dart';
import 'package:food_app_firebase/widgets/icon_and_text_widget.dart';
import 'package:food_app_firebase/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/popular_product_controller.dart';
import '../../models/product_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_column.dart';

// 125. Import the Firebase related libraries
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../widgets/small_text_overflow.dart';

// 25. Build Food Page Body to display the food info on the Main page
class FoodPageBody extends StatefulWidget {
  const FoodPageBody({Key? key}) : super(key: key);

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  // 126. Call the collection reference named 'products' inside _FoodPageBodyState
  final CollectionReference _products = FirebaseFirestore.instance.collection('products');
  // 137. Call the collection reference named 'recommended' inside _FoodPageBodyState
  final CollectionReference _recommended = FirebaseFirestore.instance.collection('recommended');

  // 33. Declare a page controller to make effects on switching page view containers
  PageController pageController = PageController(viewportFraction: 0.85);

  // 44. Initiate page controller by declaring a page value.
  var _currPageValue=0.0;
  // 49. Declare a constant to decide the scale factor
  double _scaleFactor=0.8;
  // 52. declare height
  // 67. Find all height valued 220 and define the height using dimensions value
  double _height = Dimensions.pageViewContainer;

  @override
  void initState(){
    super.initState();   // 45. initState function returns a pointer to the previous state info array
    pageController.addListener(() {
      setState(() {
        // 46. setState allows switching between state arrays
        _currPageValue = pageController.page!;
        // print("Current page value "+_currPageValue.toString());
      });
    });
  }

  // 47. Dispose page controller page value to save memory
  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 60. Wrap the PageView Builder with Column
    // 124. To load the data from the Firestore, wrap the column below with StreamBuilder
    return StreamBuilder(
      // 127. builder connection with the Firestore database collection named 'products'
      stream: _products.snapshots(),
      // 129. Instead of using original snapshot, use AsyncSnapshot<QuerySnapshot> streamSnapshot instead
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        // 130. Check if the snapshot has data. If not keep circling.
        // 131. Replace the length of data with streamSnapshot.data!.docs.length
        if (streamSnapshot.hasData) {
          // 259. Push the popular products into empty popular product list.
          int index = 0;
          Get.find<PopularProductController>().popularProductList = [];

          for (index=0; index < streamSnapshot.data!.docs.length; index++) {
            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
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
            Get.find<PopularProductController>().popularProductList.add(product);
          }

          return Column(
            children: [
              // Slider section
              Container(
                // 26. PageView builder builds sliders
                // color: Colors.redAccent,
                // 70. Use pageView here
                height: Dimensions.pageView,
                // 141. Wrap the PageView with touch gesture detector widget to route to food detail page
                  child: PageView.builder(
                    // 34. Call the page controller here
                      controller: pageController,
                      itemCount: streamSnapshot.data!.docs.length<=0?1:streamSnapshot.data!.docs.length,
                      itemBuilder: (context, position) {
                        // 132. Pass the streamSnapshot by creating a new parameter inside function _buildPageItem
                        return _buildPageItem(position, streamSnapshot);
                      }),
              ),
              // 61. Copy Dots Indicator from: https://pub.dev/packages/dots_indicator
              DotsIndicator(
                dotsCount: streamSnapshot.data!.docs.length<=0?1:streamSnapshot.data!.docs.length,
                // 62. set dotsCount value and position value to current page value
                position: _currPageValue,
                decorator: DotsDecorator(
                  activeColor: AppColors.mainColor,
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
              // 73. Make "Popular" text
              SizedBox(height: Dimensions.height15 * 2),
              Container(
                margin: EdgeInsets.only(left: Dimensions.width15 * 2),
                child: Row(
                  // 74. CrossAxisAlignment makes everything stay at bottom line
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BigText(text: "Popular",),
                    SizedBox(width: Dimensions.width10,),
                    Container(
                      margin: const EdgeInsets.only(bottom: 3),
                      child: BigText(text: ".", color: Colors.black26,),
                    ),
                    SizedBox(width: Dimensions.width10,),
                    Container(
                      margin: const EdgeInsets.only(bottom: 2),
                      child: SmallText(text: "Food pairing"),
                    )
                  ],
                ),
              ),
              // 75. Build list of Food and Images
              // 77. Wrap the List view with container of height 700 px and Apply scrollable attributes here
              // 85. Remove the container wrapped ListView. shrinkWrap set to true

              // 138. Wrap the List View with StreamBuilder to display recommended list
              StreamBuilder(
                stream: _recommended.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshotRecom) {
                  if (streamSnapshotRecom.hasData) {
                    // 260. Push the recommended products into empty recommended product list.
                    int index = 0;
                    Get.find<PopularProductController>().recommendedProductList = [];

                    for (index=0; index < streamSnapshotRecom.data!.docs.length; index++) {
                      final DocumentSnapshot documentSnapshot = streamSnapshotRecom.data!.docs[index];
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
                      Get.find<PopularProductController>().recommendedProductList.add(product);
                    }

                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        //AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: streamSnapshotRecom.data!.docs.length<=0?1:streamSnapshotRecom.data!.docs.length,
                        itemBuilder: (context, index) {
                          // 140. Make DocumentSnapshot by retrieving streamSnapshotRecom data
                          final DocumentSnapshot documentSnapshotRecom = streamSnapshotRecom.data!.docs[index];
                          String imageUrl = documentSnapshotRecom['img'];
                          // 149. Use Gesture Detector for recommended food list
                          return GestureDetector(
                            onTap: (){
                              // 163. Pass the page index inside getRecommendedFood
                              Get.toNamed(RouteHelper.getRecommendedFood(index, "home"));
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: Dimensions.width20,
                                  right: Dimensions.height20,
                                  bottom: Dimensions.height10),
                              child: Row(
                                children: [
                                  // image section
                                  Container(
                                    // 83. Set width of image of list view dynamically
                                    width: Dimensions.listViewImgSize,
                                    height: Dimensions.listViewImgSize,
                                    // 76. Show the food image in the list on the left side (with width and height)
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radius20),
                                        color: Colors.white38,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            // 139. Display network image
                                            image: NetworkImage(imageUrl)
                                        )
                                    ),
                                  ),
                                  // text section
                                  // 79. Build text section container and wrap with Expanded widget to take max. possible width
                                  Expanded(
                                    child: Container(
                                      height: Dimensions
                                          .listViewTextContainerSize,
                                      // 84. Set width of the text content dynamically
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                Dimensions.radius20),
                                            bottomRight: Radius.circular(
                                                Dimensions.radius20),
                                          ),
                                          color: Colors.white
                                      ),
                                      // 80. Add padding besides the image
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: Dimensions.width10,
                                            right: Dimensions.width10),
                                        // 81. Details section part of the food list
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            BigText(
                                                text: documentSnapshotRecom['name']),
                                            SizedBox(
                                              height: Dimensions.height10,),
                                            SmallTextOverflow(
                                                text: documentSnapshotRecom['description']),
                                            // 82. Copy the Normal-Distance-Time Row below
                                            SizedBox(
                                              height: Dimensions.height10,),
                                            Row(
                                              // 43. call the created IconAndTextWidget here and use mainAxisAlignment
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                IconAndTextWidget(
                                                    icon: Icons.circle_sharp,
                                                    text: "Normal",
                                                    iconColor: AppColors
                                                        .iconColor1),
                                                IconAndTextWidget(
                                                    icon: Icons.location_on,
                                                    text: "1.7km",
                                                    iconColor: AppColors
                                                        .mainColor),
                                                IconAndTextWidget(
                                                    icon: Icons
                                                        .access_alarm_rounded,
                                                    text: "32min",
                                                    iconColor: AppColors
                                                        .iconColor2),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              ),

            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  // 27. create a widget to construct the structure inside each page item
  Widget _buildPageItem(int index, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
    // 48. Use Matrix4 here
    Matrix4 matrix = new Matrix4.identity();
    // 50. Dynamic current scale while switching the items
    if(index == _currPageValue.floor()){   // 54. referring to the middle/current item
      var currScale = 1-(_currPageValue-index)*(1-_scaleFactor);
      // 53. Deal with the height difference issue and set translation scaling
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }else if(index == _currPageValue.floor()+1){   // 55. referring to the right item
      var currScale = _scaleFactor+(_currPageValue-index+1)*(1-_scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }else if(index == _currPageValue.floor()-1){   // 56. referring to the left item
      var currScale = 1-(_currPageValue-index)*(1-_scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }else{  // 57. Deal with the remaining condition to make swiping to right action be smooth when scaling
      var currScale=0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _height*(1-_scaleFactor)/2, 0);
    }

    // 29. Wrap Container with Stack, so that the current Container stack on the previous container
    // 51. Wrap the Stack with Transform and pass the matrix value
    // 133. Make DocumentSnapshot by retrieving streamSnapshot data
    final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
    // 135. Retrieve the image URL from Firestore
    // Image URL format: https://storage.googleapis.com/firestorequickstarts.appspot.com/food_3.png
    String imageUrl = documentSnapshot['img'];
    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          // 152. Add Gesture Detector here, and pass the page index (Step 141 Abandoned)
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteHelper.getPopularFood(index, "home"));
            },
            child: Container(
                height: Dimensions.height20*11,
                margin: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    color: index.isEven?Color(0xFF69c5df):Color(0xFF9294cc),
                    // 28. Add Image in the Page Item Container Widget. Call the image source path.
                    // BoxFit makes sure the image covers the whole container
                    // 136. For loading images by the url, use NetworkImage instead of AssetImage.
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(imageUrl)
                        /*image: AssetImage(
                            "assets/image/food_3.png"
                        )*/
                    )
                )
            ),
          ),
          // 30. Copy the above Container and paste below. Then Wrap it with Alignment
          Align(
            // 31. Set Alignment to bottomCenter to drag the container to the bottom
            alignment: Alignment.bottomCenter,
            child: Container(
                // 68. Find all height valued 120 and define the height using dimensions value
                height: Dimensions.pageViewTextContainer,
                margin: EdgeInsets.only(left: Dimensions.width30, right: Dimensions.width30, bottom: Dimensions.width30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    // 32. Set the color to white and delete the image attribute
                    color: Colors.white,
                    // 58. Apply Box shadows to the white container
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFe8e8e8), blurRadius: 5.0, offset: Offset(0,5)
                      ),
                      BoxShadow(
                        color: Colors.white, offset: Offset(-5,0)
                      ),
                      BoxShadow(
                          color: Colors.white, offset: Offset(5,0)
                      ),
                    ]
                ),
                // 35. In the white box, build the rows
                child: Container(
                  padding: EdgeInsets.only(top: Dimensions.height15, left: Dimensions.width15, right: Dimensions.width15),
                    // 97. Call AppColumn here
                    // 134. Call the string(text) input field "name" here
                    child: AppColumn(text: documentSnapshot['name'],)
                ),
            ),
          )
        ],
      ),
    );
  }
}
