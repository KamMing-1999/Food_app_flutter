import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/models/address_model.dart';
import 'package:food_app_firebase/pages/address/pick_address_map.dart';
import 'package:food_app_firebase/widgets/app_text_field.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/location_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';

// 434. Create add address page class.
class AddAddressPage extends StatefulWidget {
  AddAddressPage({Key? key}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {

  TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _contactPersonNumber = TextEditingController();
  // 435. Check if the user has logged in or not
  late bool _isLogged;
  CameraPosition _cameraPosition = const CameraPosition(target: const LatLng(
    45.51563, -122.677433
  ), zoom: 17);
  late LatLng _initialPosition = LatLng(45.51563, -122.677433);

  @override
  void initState() {
    super.initState();

    // 436. Check if user has logged in.
    final currentUser = Get.find<AuthController>().currentUser;
    String? uid = currentUser?.uid;

    // 437. Check if the address list is empty [] or not.
    if (Get.find<LocationController>().addressList.isNotEmpty) {
      // 478. Call the getCurrentUserAddress function here.
      Get.find<LocationController>().getCurrentUserAddressModel();
      _cameraPosition = CameraPosition(target: LatLng(
          double.parse(Get.find<LocationController>().getAddress['latitude']),
          double.parse(Get.find<LocationController>().getAddress['longitude'])
      ));
      _initialPosition = LatLng(
          double.parse(Get.find<LocationController>().getAddress['latitude']),
          double.parse(Get.find<LocationController>().getAddress['longitude'])
      );
    } else {
      Get.find<LocationController>().getCurrentUserAddressModel();
      print("here now");
    }
  }

  // 416. Suppose the user is logged in using Firebase Auth, retrieve the data by authController.
  final currentUser = Get.find<AuthController>().currentUser;

  @override
  Widget build(BuildContext context) {

    // 419. Get user account info by the auto generated uid.
    String uid = currentUser!.uid.trim();

    Get.find<LocationController>().getCurrentUserAddressModel();

    return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.data();
              // 455. Check if user exist and contact person name is empty and address list is not empty.
              if (data is Map<String, dynamic> && _contactPersonName.text.isEmpty) {
                final name = data['name'];
                final phone = data['phone'];
                _contactPersonName.text = name;
                _contactPersonNumber.text = phone;
                _addressController.text = Get.find<LocationController>().getUserAddress().address;
                if (Get.find<LocationController>().addressList.isNotEmpty) {
                  _addressController.text = Get.find<LocationController>().getUserAddress().address;
                  //print(_addressController.text);
                } else {
                  final name = data['name'];
                  final phone = data['phone'];
                  _contactPersonName.text = name;
                  _contactPersonNumber.text = phone;
                  _addressController.text = Get.find<LocationController>().getUserAddress().address;
                }
              } else {
                Map<String, dynamic> convertedData = {};
                convertedData = data as Map<String, dynamic>;
                //print(convertedData);
                final name = convertedData['name'];
                final phone = convertedData['phone'];
                _contactPersonName.text = name;
                _contactPersonNumber.text = phone;
                // _addressController.text = Get.find<LocationController>().getUserAddress().address;
                // print("Case 3");
              }
            } else {
              final data = snapshot.data?.data();
              final name = "Name";
              final phone = "Phone";
              _contactPersonName.text = name;
              _contactPersonNumber.text = phone;
            }
            return Scaffold(
              appBar: AppBar(
                  title: Text("Address page"),
                  backgroundColor: AppColors.mainColor
              ),
              // 445. Wrap the controller with get builder to get access to the location controller.
              body: GetBuilder<LocationController>(
                  builder: (locationController) {
                    _addressController.text =
                    '${locationController.placemark.name ?? ''}'
                        '${locationController.placemark.locality ?? ''}'
                        '${locationController.placemark.postalCode ?? ''}'
                        '${locationController.placemark.country ?? ''}';
                    // print("Address in my view is "+_addressController.text);

                    print(_addressController.text);
                    // 460. Wrap the column with SingleChildScrollView to prevent bottom overflow after keyboard pop up.
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 443. This is the google map part.
                          Container(
                              height: Dimensions.height20 * 7,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              margin: const EdgeInsets.only(
                                  left: 5, right: 5, top: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 2, color: Theme
                                      .of(context)
                                      .primaryColor
                                  )
                              ),
                              child: Stack(
                                  children: [
                                    GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                          target: _initialPosition, zoom: 17),
                                      onTap: (laglng) {
                                        // 481. Tap the Google map to route to the pick address page.
                                        Get.toNamed(
                                            RouteHelper.getPickAddressPage(),
                                            arguments: PickAddressMap(
                                              fromSignup: false,
                                              fromAddress: true,
                                              googleMapController: locationController
                                                  .mapController,
                                            )
                                        );
                                      },
                                      zoomControlsEnabled: false,
                                      compassEnabled: false,
                                      indoorViewEnabled: true,
                                      mapToolbarEnabled: false,
                                      myLocationEnabled: true,
                                      // 447. call the update position function and set map controller here.
                                      onCameraIdle: () {
                                        locationController.updatePosition(
                                            _cameraPosition, true);
                                      },
                                      onCameraMove: ((position) =>
                                      _cameraPosition = position),
                                      onMapCreated: (
                                          GoogleMapController controller) {
                                        locationController.setMapController(
                                            controller);
                                      },
                                    )
                                  ]
                              )
                          ),
                          // 454. Create Delivery Address Text field which can dynamically show the place address.
                          // 459. Create 3 buttons for choosing place type.
                          Padding(
                            padding: EdgeInsets.only(left: Dimensions.width20,
                                top: Dimensions.height20),
                            child: SizedBox(height: Dimensions.height20 * 2.5,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: locationController
                                        .addressTypeList.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: () {
                                            locationController
                                                .setAddressTypeIndex(index);
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions
                                                      .width20,
                                                  vertical: Dimensions
                                                      .height10),
                                              margin: EdgeInsets.only(
                                                  right: Dimensions.width10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(
                                                      Dimensions.radius20 / 4),
                                                  color: Theme
                                                      .of(context)
                                                      .cardColor,
                                                  boxShadow: [
                                                    BoxShadow(color: Colors
                                                        .grey[200]!,
                                                        spreadRadius: 1,
                                                        blurRadius: 5)
                                                  ]
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                      index == 0
                                                          ? Icons.home_filled
                                                          : index == 1 ? Icons
                                                          .work : Icons
                                                          .location_on,
                                                      color: locationController
                                                          .addressTypeIndex ==
                                                          index
                                                          ?
                                                      AppColors.mainColor
                                                          : Theme
                                                          .of(context)
                                                          .disabledColor
                                                  )
                                                ],
                                              )
                                          )
                                      );
                                    })),
                          ),
                          SizedBox(height: Dimensions.height20,),
                          Padding(
                            padding: EdgeInsets.only(left: Dimensions.width20),
                            child: BigText(text: "Delivery address"),
                          ),
                          SizedBox(height: Dimensions.height10,),
                          AppTextField(textController: _addressController,
                              hintText: "Your address",
                              icon: Icons.map),
                          SizedBox(height: Dimensions.height20,),
                          Padding(
                            padding: EdgeInsets.only(left: Dimensions.width20),
                            child: BigText(text: "Contact name"),
                          ),
                          SizedBox(height: Dimensions.height10,),
                          AppTextField(textController: _contactPersonName,
                              hintText: "Your name",
                              icon: Icons.person),
                          SizedBox(height: Dimensions.height20,),
                          Padding(
                            padding: EdgeInsets.only(left: Dimensions.width20),
                            child: BigText(text: "Your number"),
                          ),
                          SizedBox(height: Dimensions.height10,),
                          AppTextField(textController: _contactPersonNumber,
                              hintText: "Your phone",
                              icon: Icons.phone),
                        ],
                      ),
                    );
                  }),
              // 461. Create bottom navigation bar for the address page to create the save location button.
              bottomNavigationBar: GetBuilder<LocationController>(
                  builder: (locationController) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: Dimensions.height20 * 8,
                          padding: EdgeInsets.only(top: Dimensions.height15 * 2,
                              bottom: Dimensions.height15 * 2,
                              left: Dimensions.width10 * 2,
                              right: Dimensions.width10 * 2),
                          decoration: BoxDecoration(
                              color: AppColors.buttonBackgroundColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      Dimensions.radius20 * 2),
                                  topRight: Radius.circular(
                                      Dimensions.radius20 * 2)
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 464. call the save address function from location controller by tapping save button.
                              GestureDetector(
                                onTap: () {
                                  AddressModel _addressModel = AddressModel(
                                      addressType: locationController
                                          .addressTypeList[locationController
                                          .addressTypeIndex],
                                      contactPersonName: _contactPersonName
                                          .text,
                                      contactPersonNumber: _contactPersonNumber
                                          .text,
                                      address: _addressController.text,
                                      latitude: locationController.position
                                          .latitude.toString(),
                                      longitude: locationController.position
                                          .longitude.toString()
                                  );
                                  locationController.addAddress(_addressModel);
                                  //Get.toNamed(RouteHelper.getInitial());
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: Dimensions.height20,
                                      bottom: Dimensions.height20,
                                      left: Dimensions.width20,
                                      right: Dimensions.width20),
                                  child: BigText(text: "Save Address",
                                      color: Colors.white,
                                      size: 26),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radius20),
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
          }
      );
  }
}
