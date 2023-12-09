import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/controllers/location_controller.dart';
import 'package:food_app_firebase/models/signup_body_model.dart';
import 'package:food_app_firebase/utils/colors.dart';
import 'package:food_app_firebase/widgets/account_widget.dart';
import 'package:food_app_firebase/widgets/big_text.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';

// 363. Create an Account Page and list out all the input fields.
class AccountPage extends StatelessWidget {
  // 410. Go to account page to add three extra parameters: name, email, phone.
  // String name, email, phone;
  AccountPage({Key? key}) : super(key: key);

  // 416. Suppose the user is logged in using Firebase Auth, retrieve the data by authController.
  final currentUser = Get.find<AuthController>().currentUser;

  // 476. Get the string of the user address.

  final addressString = Get.find<LocationController>().addressList.length == 0 ? "Fill in your address" : Get.find<LocationController>().addressList[0];

  @override
  Widget build(BuildContext context) {
    // 419. Get user account info by the auto generated uid.
    String? uid = currentUser?.uid;
    // 420. Wrap the Account page with stream builder.
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!.data();
          // 421. Need to cast the data object to a Map type explicitly.
          if (data is Map<String, dynamic>) {
            final name = data['name'];
            final phone = data['phone'];
            final email = data['email'];
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.mainColor,
                  title: BigText(
                    text: "Profile", size: 24, color: Colors.white,
                  ),
                ),
                body: Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(top:Dimensions.height20),
                  child: Column(
                    children: [
                      // 365. Include profile icon, name, phone, email, address, message
                      AppIcon(icon: Icons.person, backgroundColor: AppColors.mainColor,
                        iconColor: Colors.white, iconSize: Dimensions.height15*5, size: Dimensions.height15*10,
                      ),
                      SizedBox(height: Dimensions.height15*2,),
                      // 366. Make the long list of input fields scrollable.
                      Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                AccountWidget(appIcon: AppIcon(icon: Icons.person, backgroundColor: AppColors.mainColor,
                                  iconColor: Colors.white, iconSize: Dimensions.height10*5/2, size: Dimensions.height10*5,
                                ), bigText: BigText(text: name)),
                                SizedBox(height: Dimensions.height20,),
                                AccountWidget(appIcon: AppIcon(icon: Icons.phone, backgroundColor: AppColors.yellowColor,
                                  iconColor: Colors.white, iconSize: Dimensions.height10*5/2, size: Dimensions.height10*5,
                                ), bigText: BigText(text: phone)),
                                SizedBox(height: Dimensions.height20,),
                                AccountWidget(appIcon: AppIcon(icon: Icons.email, backgroundColor: AppColors.yellowColor,
                                  iconColor: Colors.white, iconSize: Dimensions.height10*5/2, size: Dimensions.height10*5,
                                ), bigText: BigText(text: email)),
                                SizedBox(height: Dimensions.height20,),
                                // 477. Wrap the Fill in your address text field with Get Builder to choose which route to got to.
                                GetBuilder<LocationController>(builder: (locationController) {
                                  if (locationController.addressList.isEmpty) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.toNamed(RouteHelper.getAddressPage());
                                      },
                                      child: AccountWidget(appIcon: AppIcon(icon: Icons.location_on, backgroundColor: AppColors.yellowColor,
                                        iconColor: Colors.white, iconSize: Dimensions.height10*5/2, size: Dimensions.height10*5,
                                      ), bigText: BigText(text: "Fill in your address")),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.toNamed(RouteHelper.getAddressPage());
                                      },
                                      child: AccountWidget(appIcon: AppIcon(icon: Icons.location_on, backgroundColor: AppColors.yellowColor,
                                        iconColor: Colors.white, iconSize: Dimensions.height10*5/2, size: Dimensions.height10*5,
                                      ), bigText: BigText(text: "Your address")),
                                    );
                                  }
                                }),
                                SizedBox(height: Dimensions.height20,),
                                AccountWidget(appIcon: AppIcon(icon: Icons.message_outlined, backgroundColor: Colors.redAccent,
                                  iconColor: Colors.white, iconSize: Dimensions.height10*5/2, size: Dimensions.height10*5,
                                ), bigText: BigText(text: "Message")),
                                SizedBox(height: Dimensions.height20,),
                                // 409. Create sign out button for firebase auth to signout.
                                GestureDetector(
                                  onTap: () {
                                    AuthController.instance.logout();
                                  },
                                  child: AccountWidget(appIcon: AppIcon(icon: Icons.logout, backgroundColor: Colors.redAccent,
                                    iconColor: Colors.white, iconSize: Dimensions.height10*5/2, size: Dimensions.height10*5,
                                  ), bigText: BigText(text: "Logout")),
                                ),
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                )
            );
          }
          // 422. If user cannot be loaded, ask user to login.
          else {
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: double.maxFinite, height: Dimensions.height20*5,
                        margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                            image: DecorationImage(image: AssetImage('assets/image/house.jpg'))
                        ),
                        // child: Center(child: BigText(text: "Sign In", color: Colors.white, size: Dimensions.font20)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getSignInPage());
                      },
                      child: Container(
                        width: double.maxFinite, height: Dimensions.height20*5,
                        margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                        decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                        ),
                        child: Center(child: BigText(text: "Sign In", color: Colors.white, size: Dimensions.font20)),
                      ),
                    ),
                  ],
                )
              )
            );
          }
        }
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

      }
    );
  }
}
