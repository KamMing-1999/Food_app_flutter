import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/base/no_data_page.dart';
import 'package:food_app_firebase/controllers/cart_controller.dart';
import 'package:food_app_firebase/routes/route_helper.dart';
import 'package:food_app_firebase/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../models/cart_model.dart';
import '../../utils/colors.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';

// 335. Create cart history page.
class CartHistory extends StatelessWidget {
  const CartHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 340. get access to the cart history list by get builder from the latest to the earliest.
    var getCartHistoryList = Get.find<CartController>().getCartHistoryList().reversed.toList();

    // 336. Create cart items per order in order to list out which items (quantity) are included in the order.
    Map<String, int> cartItemsPerOrder = Map();

    for (int i=0; i < getCartHistoryList.length; i++) {
      // 337. If the number of time of the product in the cart order is more than one, update its frequency. Else set it to 1.
      if (cartItemsPerOrder.containsKey(getCartHistoryList[i].time!)) {
        cartItemsPerOrder.update(getCartHistoryList[i].time!,(value)=>++value);
      } else {
        cartItemsPerOrder.putIfAbsent(getCartHistoryList[i].time!,()=>1);
      }
    }

    // 338. Create a list to store the number of items inside each order.
    List<int> cartItemsPerOrderToList() {
      return cartItemsPerOrder.entries.map((e)=>e.value).toList();
    }

    // 350. Create a list to store the number of item keys inside each order.
    List<String> cartOrderTimeToList() {
      return cartItemsPerOrder.entries.map((e)=>e.key).toList();
    }

    List<int> orderTimes = cartItemsPerOrderToList();
    var listCounter = 0;

    // 361. Create a time widget to display the time.
    Widget timeWidget(int index) {
      var outputDate = DateTime.now().toString();
      if (index<getCartHistoryList.length) {
        DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(
            getCartHistoryList[listCounter].time!);
        var inputDate = DateTime.parse(parseDate.toString());
        var outputFormat = DateFormat("MM/dd/yyyy hh:mm a");
        outputDate = outputFormat.format(inputDate);
      }
      return BigText(text: outputDate);
    }

    return Scaffold(
      body: Column(
        children: [
          // 340. Part for the Cart History header.
          Container(
            height: Dimensions.height20*5,
            color: AppColors.mainColor,
            width: double.maxFinite,
            padding: EdgeInsets.only(top: Dimensions.height15*3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BigText(text: "Cart History", color: Colors.white),
                AppIcon(icon: Icons.shopping_cart_outlined, iconColor: AppColors.mainColor,
                  backgroundColor: AppColors.yellowColor,)
              ],
            ),
          ),
          // 341. Part for showing the cart history list. Wrap with expanded widget
          // 360. Show empty cart history page if the cart doesn't have any checkout.
          GetBuilder<CartController>(builder: (_cartController) {
            return _cartController.getCartHistoryList().length>0?Expanded(
              child: Container(
                  margin: EdgeInsets.only(
                      top: Dimensions.height20,
                      left: Dimensions.width20,
                      right: Dimensions.width20
                  ),
                  child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView(
                        children: [
                          // 342. List the order here
                          for (int i=0; i<orderTimes.length; i++)
                            Container(
                              height: Dimensions.height20*6,
                              margin: EdgeInsets.only(bottom: Dimensions.height20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 343. This is the order time in formatted form.
                                  // BigText(text:getCartHistoryList[listCounter].time!),
                                  // 347. Use immediately invoked function (IIF) which code is to be executed immediately.
                                  /*((){
                                    // 348. First parse the getCartHistory date string to suitable date format.
                                    // Then parse it to string for converting to another date format.
                                    DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(getCartHistoryList[listCounter].time!);
                                    var inputDate = DateTime.parse(parseDate.toString());
                                    var outputFormat = DateFormat("MM/dd/yyyy hh:mm a");
                                    var outputDate = outputFormat.format(inputDate);
                                    return BigText(text: outputDate);
                                  }()),*/
                                  // 362. Call the time widget here.
                                  timeWidget(listCounter),
                                  SizedBox(height: Dimensions.height10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Wrap(
                                          direction: Axis.horizontal,
                                          // 344. Here list out the items pics.
                                          children: List.generate(orderTimes[i], (index) {
                                            if (listCounter < getCartHistoryList.length) {
                                              listCounter++;
                                            }
                                            // 345. Add condition checking to check if the order contains more than three items
                                            return index<=2?Container(
                                              height: Dimensions.height20*4,
                                              width: Dimensions.height20*4,
                                              margin: EdgeInsets.only(right: Dimensions.width10/2),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(Dimensions.radius15/2),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(getCartHistoryList[listCounter-1].img!)
                                                  )
                                              ),
                                            ):Container();
                                          })
                                      ),
                                      // 346. Show the total number of items.
                                      Container(
                                        // color: Colors.red,
                                          height: Dimensions.height20*4,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              SmallText(text: "Total", color: AppColors.titleColor),
                                              BigText(text: orderTimes[i].toString()+((orderTimes[i]>1)?" Items":" Item"), color: AppColors.titleColor),
                                              // 349. Wrap the "one more" button with gesture detector to route back to the order list.
                                              GestureDetector(
                                                onTap: () {
                                                  // 351. Tapping this will show the order time as key.
                                                  var orderTime = cartOrderTimeToList();
                                                  Map<int, CartModel> moreOrder = {};
                                                  for (int j=0; j<getCartHistoryList.length; j++) {
                                                    if (getCartHistoryList[j].time == orderTime[i]) {
                                                      // 352. get the order time and product id for debugging purpose.
                                                      // print("my order time is: "+orderTime[i]);
                                                      // print("The cart or product id is: "+getCartHistoryList[j].product!.id.toString());
                                                      // print("Product info is "+jsonEncode(getCartHistoryList[j]));
                                                      moreOrder.putIfAbsent(getCartHistoryList[j].id!, () =>
                                                          CartModel.fromJson(jsonDecode(jsonEncode(getCartHistoryList[j])))
                                                      );
                                                    }
                                                  }
                                                  print("Order time "+orderTime[i].toString());
                                                  // 354. Call the setItem function and addtoCartList functions for recovering cart here.
                                                  Get.find<CartController>().setItems = moreOrder;
                                                  Get.find<CartController>().addToCartList();
                                                  // 356. Route to the cart page after recovering it.
                                                  Get.toNamed(RouteHelper.getCartPage());
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width10, vertical: Dimensions.height10/2),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(Dimensions.height15/2),
                                                    border: Border.all(width: 1, color: AppColors.mainColor),
                                                  ),
                                                  child: SmallText(text: "one more", color: AppColors.mainColor),
                                                ),
                                              )
                                            ],
                                          )
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                        ],
                      )
                  )
              ),
            ):
            Container(height: MediaQuery.of(context).size.height/1.5,
              child: const Center(child: NoDataPage(text: "Your didn't buy anything so far!", imgPath: "assets/image/empty_box.png",)));
          })
        ],
      )
    );
  }
}
