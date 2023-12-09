// 385. Build sign in page.
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/controllers/auth_controller.dart';
import 'package:food_app_firebase/pages/auth/sign_up_page.dart';
import 'package:food_app_firebase/utils/dimensions.dart';
import 'package:food_app_firebase/widgets/app_text_field.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/colors.dart';
import '../../widgets/big_text.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    // 386. Copy the design from the sign up page and make some changes.
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: Dimensions.screenHeight*0.05),
              // app logo (may be also the user profile logo)
              Container(
                height: Dimensions.screenHeight*0.25,
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: Dimensions.height20*4,
                    backgroundImage: AssetImage(
                        "assets/image/food_logo.png"
                    ),
                  ),
                ),
              ),
              // 387. Make welcome part
              Container(
                margin: EdgeInsets.only(left: Dimensions.width20),
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello", style: TextStyle(fontSize: Dimensions.font20*3.5,
                        fontWeight: FontWeight.bold
                    ),),
                    Text("Sign into your account", style: TextStyle(fontSize: Dimensions.font20,
                    color: Colors.grey[500]),)
                  ],
                )
              ),
              SizedBox(height: Dimensions.height20),
              // 388. Only email/phone and password are required.
              AppTextField(textController: emailController,
                  hintText: "Email",
                  icon: Icons.email),
              SizedBox(height: Dimensions.height20),
              AppTextField(textController: passwordController,
                  hintText: "Password",
                  // 412. Set Password Input to be obscure
                  isObscure: true,
                  icon: Icons.password_sharp),
              SizedBox(height: Dimensions.height20),

              // 389. Make the tag line part.
              Row(
                children: [
                  Expanded(child: Container()),
                  RichText(text: TextSpan(
                      text: "Sign into your account",
                      style: TextStyle(color: Colors.grey[500], fontSize: Dimensions.font16)
                    ),
                  ),
                  SizedBox(width: Dimensions.width20)
                ],
              ),
              SizedBox(height: Dimensions.screenHeight/20),

              // sign in button
              // 411. Wrap the sign in button with gesture detector to do the sign in function.
              GestureDetector(
                onTap: () {
                  AuthController.instance.login(emailController.text.trim(), passwordController.text.trim());
                },
                child: Container(
                    width: Dimensions.screenWidth/2,
                    height: Dimensions.screenHeight/14,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius30),
                        color: AppColors.mainColor
                    ),
                    child: Center(
                      child: BigText(
                        text: "Sign In", size: Dimensions.font20+Dimensions.font20/2,
                        color: Colors.white,
                      ),
                    )
                ),
              ),

              SizedBox(height: Dimensions.screenHeight/20,),

              // 390. Create routing to sign up page if don't have an account.
              RichText(text: TextSpan(
                  text: "Don\'t have an account? ",
                  style: TextStyle(color: Colors.grey[500], fontSize: Dimensions.font20),
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>SignUpPage(),
                        transition: Transition.fade),
                        text: " Create",
                        style: TextStyle(color: Colors.black, fontSize: Dimensions.font20,
                            fontWeight: FontWeight.bold))
                  ]
              )
              ),

            ],
          ),
        )
    );
  }
}
