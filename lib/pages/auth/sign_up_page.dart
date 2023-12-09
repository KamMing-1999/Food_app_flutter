import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/base/show_custom_snackbar.dart';
import 'package:food_app_firebase/controllers/auth_controller.dart';
import 'package:food_app_firebase/models/signup_body_model.dart';
import 'package:food_app_firebase/utils/dimensions.dart';
import 'package:food_app_firebase/widgets/app_text_field.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/colors.dart';
import '../../widgets/big_text.dart';

// 367. Build sign up page
class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 368. Declare controllers for the text editing fields.
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var password2Controller = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var SignUpImages = [
      'facebook.png', 'google.png', 'twitterX.png'
    ];

    // 392. Declare a function to implement the sign up function and input validation.
    void _registration() {
      String name = nameController.text.trim();
      String phone = phoneController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String password2 = password2Controller.text.trim();

      // 394. Regular expressions for each required character type
      RegExp capitalRegex = RegExp(r'[A-Z]');
      RegExp numberRegex = RegExp(r'[0-9]');
      RegExp specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

      // 395. Check if the password meets the requirements
      bool hasCapitalLetter = capitalRegex.hasMatch(password);
      bool hasNumber = numberRegex.hasMatch(password);
      bool hasSpecialChar = specialCharRegex.hasMatch(password);

      // 393. Check if the input fields are empty and check if the email format is valid.
      if (name.isEmpty) {
        showCustomSnackBar("Type in your name", title: "Name");
      } else if (phone.isEmpty) {
        showCustomSnackBar("Type in your phone number", title: "Phone Number");
      } else if (email.isEmpty) {
        showCustomSnackBar("Type in your email address", title: "Email Address");
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar("Type in a valid email address", title: "Email Address");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in your password", title: "Password");
      } else if (password.length < 8) {
        showCustomSnackBar("Password cannot be less than 8 characters", title: "Password");
      } else if (password != password2) {
        showCustomSnackBar("Retyped password is not the same as the original password", title: "Password");
      } else if (!hasCapitalLetter) {
        showCustomSnackBar("Password must contain at least one capital letter", title: "Capital Letter");
      } else if (!hasNumber) {
        showCustomSnackBar("Password must contain at least one number", title: "Number");
      } else if (!hasSpecialChar) {
        showCustomSnackBar("Password must contain at least one special characters", title: "Special Character");
      } else {
        // showCustomSnackBar("All went well", title: "Perfect");

        // 397. Call the signup body model to save the sign up info.
        SignUpBody signUpBody = SignUpBody(name: name, phone: phone, email: email, password: password);

        print("The signup info is here:");
        print(signUpBody.name);
        print(signUpBody.phone);
        print(signUpBody.email);
        print(signUpBody.password);

        // 414. Important: Call the register() function inside the auth controller here.
        AuthController.instance.register(email, password, name, phone);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      // 384. Use Single Child Scroll View to ensure the content is scrollable when
        // the height of the screen is reduced due to the keyboard popup.
        // For keyboard pop up: Shift + command + K.
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: Dimensions.screenHeight*0.05),
            Container(
              height: Dimensions.screenHeight*0.25,
              // app logo (may be also the user profile logo)
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
            // 380. Build the email, password, name, phone fields
            AppTextField(textController: emailController,
                hintText: "Email",
                icon: Icons.email),
            SizedBox(height: Dimensions.height20),
            AppTextField(textController: passwordController,
                isObscure: true,
                hintText: "Password",
                icon: Icons.password_sharp),
            SizedBox(height: Dimensions.height20),
            AppTextField(textController: password2Controller,
                isObscure: true,
                hintText: "Retype Password",
                icon: Icons.password_sharp),
            SizedBox(height: Dimensions.height20),
            AppTextField(textController: nameController,
                hintText: "Name",
                icon: Icons.person),
            SizedBox(height: Dimensions.height20),
            AppTextField(textController: phoneController,
                hintText: "Phone",
                icon: Icons.phone),
            SizedBox(height: Dimensions.height20),

            // 381. Build Sign Up Buttons here.
            // 391. Wrap the Sign Up button with gesture detector to grab the sign up info.
            GestureDetector(
              onTap: (){
                _registration();
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
                    text: "Sign Up", size: Dimensions.font20+Dimensions.font20/2,
                    color: Colors.white,
                  ),
                )
              ),
            ),

            SizedBox(height: Dimensions.height10,),
            // 382. Check if the user has an account or not
            RichText(text: TextSpan(
              recognizer: TapGestureRecognizer()..onTap=()=>Get.back(),
                text: "Have an account already?",
                style: TextStyle(color: Colors.grey[500], fontSize: Dimensions.font20)
              )
            ),
            SizedBox(height: Dimensions.screenHeight/20,),
            // 383. Sign Up using one of the following methods.
            RichText(text: TextSpan(
                text: "Sign Up using one of the following methods:",
                style: TextStyle(color: Colors.grey[500], fontSize: Dimensions.font16)
              )
            ),
            Wrap(
              children: List.generate(3, (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: Dimensions.radius30,
                  backgroundImage: AssetImage(
                    "assets/image/"+SignUpImages[index]
                  ),
                ),
              )),
            )
          ],
        ),
      )
    );
  }
}
