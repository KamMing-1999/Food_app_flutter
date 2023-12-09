// 0. Before building the app, make sure to connect the Google Firebase Service
// downloading the google.json file and generate the SHA1 key typing the command:
// keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
// 1. Build a stateful main food page, which allows users to interact with the app
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/controllers/auth_controller.dart';
import 'package:food_app_firebase/widgets/big_text.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/small_text.dart';
import 'food_page_body.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({Key? key}) : super(key: key);

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  @override
  Widget build(BuildContext context) {
    // 64. Get the current height of the device emulator
    // print("current height is "+MediaQuery.of(context).size.height.toString());
    // 7. Wrap the Main Food Page Container with Scaffold
    return Scaffold(
      // 9. Put the container of the first two elements (location and search button) in a row
      body: Column(
        children: [
          Container(
            child: Container(
                // 10. Lower the Row to make sure the row doesn't touch the topmost
                margin: EdgeInsets.only(top: Dimensions.height15*3, bottom: Dimensions.height15),
                // 11. Make sure the two elements doesn't touch the edges
                padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                // 2. Build the First Row of the Main Food Page
                child: Row(
                  // 8. make all elements in a row be spaced evenly |----|
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // 4. Build the left side of the Row displaying location
                  children: [
                    Column(
                      children: [
                        // 22. Use BigText and SmallText classes here
                        BigText(text: "United States", color: AppColors.mainColor),
                        Row(  // 24. Add a dropdown arrow sign beside the small text
                          children: [
                            SmallText(text: "Los Angeles", color: Colors.black54),
                            Icon(Icons.arrow_drop_down_rounded)
                          ],
                        )
                      ],
                    ),
                    // 3. Build the Search Button
                    // 12. Press Option+Return on Mac to wrap the whole container in Center

                    Center(
                      child: Container(
                        width: Dimensions.width15*3, height: Dimensions.height15*3,
                        // 12. Add Search icon to the Search button
                        child: Icon(Icons.search, color: Colors.white, size: Dimensions.iconSize24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius15),
                          color: AppColors.mainColor, //Colors.blue,
                        ),
                      ),
                    )
                  ],
                )
            ),

          ),
          // 28. Call FoodPageBody on MainFoodPage
          // 78. Wrap the Food Page Body with Expanded and SingleChildScrollView.
          // The whole page is scrollable.
          Expanded(child: SingleChildScrollView(
            child: FoodPageBody(),
          )),
        ],
      ),
    );
  }
}
