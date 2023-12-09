import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/pages/address/widgets/search_location_dialogue_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../base/custom_button.dart';
import '../../controllers/location_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class PickAddressMap extends StatefulWidget {
  // 482. Pass the required parameters here.
  final bool fromSignup;
  final bool fromAddress;
  final GoogleMapController? googleMapController;

  const PickAddressMap({Key? key, required this.fromSignup, required this.fromAddress, this.googleMapController}) : super(key: key);

  @override
  State<PickAddressMap> createState() => _PickAddressMapState();
}

class _PickAddressMapState extends State<PickAddressMap> {
  late LatLng _initialPosition;
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    super.initState();
    if (Get.find<LocationController>().addressList.isEmpty) {
      _initialPosition = LatLng(45.521563, -122.677433);
      _cameraPosition=CameraPosition(target: _initialPosition, zoom: 17);
    } else if (Get.find<LocationController>().addressList.isNotEmpty) {
      _initialPosition = LatLng(
        double.parse(Get.find<LocationController>().getAddress['latitude']),
        double.parse(Get.find<LocationController>().getAddress['longitude'])
      );
      _cameraPosition = CameraPosition(target: _initialPosition, zoom:17);

    }
  }

  @override
  Widget build(BuildContext context) {
    // 485. Wrap the Scaffold with GetBuilder location controller.
    return GetBuilder<LocationController>(builder: (locationController) {
      return Scaffold(
        // 483. Include a Google Map inside the safe area.
        body: SafeArea(
            child: Center(
                child: SizedBox(
                    width: double.maxFinite,
                    child: Stack(
                      children: [
                        GoogleMap(initialCameraPosition: CameraPosition(
                          target: _initialPosition, zoom: 17,
                        ),
                          zoomControlsEnabled: false,
                          onCameraMove: (CameraPosition cameraPosition) {
                            _cameraPosition = cameraPosition;
                          },
                          // 484. Update the position.
                          onCameraIdle: () {
                            Get.find<LocationController>().updatePosition(_cameraPosition, false);
                          },
                          onMapCreated: (GoogleMapController mapController) {
                            _mapController = mapController;
                          },
                        ),
                        Center(
                          child: !locationController.loading?Image.asset("assets/image/pick.png",
                            height: Dimensions.height20*2.5, width: Dimensions.width20*2.5
                          ):CircularProgressIndicator()
                        ),
                        // 486. Build a Positioned widget to show the picked address on the top of the map.
                        Positioned(
                          top: Dimensions.height15*3, left: Dimensions.width20, right: Dimensions.width20,
                            // 499. Make the location bar tappable.
                            child: InkWell(
                              // 501. Call the location dialog here.
                            onTap: () => Get.dialog(LocationDialog(mapController: _mapController,)),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                              height: Dimensions.height20 * 2.5,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(Dimensions.radius20/2)
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, size: 25, color: AppColors.yellowColor),
                                  Expanded(child: Text(
                                      '${locationController.pickPlacemark.name??''}',
                                      style: TextStyle(color: Colors.white, fontSize: Dimensions.font16),
                                      maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // 498. Add a search icon on the location bar.
                                  SizedBox(width: Dimensions.width10,),
                                  Icon(Icons.search,size:25,color:AppColors.yellowColor)
                                ],
                              )
                            ),
                          )
                        ),
                        Positioned(
                            bottom: Dimensions.height20*4, left: Dimensions.width20, right: Dimensions.width20,
                            // 495. Set up the condition here to check whether the button should be enabled or not.
                            child: locationController.isLoading?Center(
                              child: CircularProgressIndicator()
                            ):CustomButton(
                              // 489. Make a custom button to make the button attributes reusable.
                                buttonText: 'Pick Address',
                                onPressed: (locationController.buttonDisabled||locationController.loading)?null:() {
                                  if (locationController.pickPosition.latitude!=0&&
                                      locationController.pickPlacemark.name!=null) {
                                    if (widget.fromAddress) {
                                      if (widget.googleMapController!=null) {
                                        widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(
                                            CameraPosition(target: LatLng(
                                                locationController.pickPosition.latitude,
                                                locationController.pickPosition.longitude
                                            )))
                                        );
                                        // 491. Call the set address data function here and get back to the main page.
                                        locationController.setAddAddressData();
                                      }
                                      // 492. Get.back() creates update problem.
                                      Get.toNamed(RouteHelper.getAddressPage());
                                    } else {

                                    }
                                  }
                                }
                            )
                        ),
                      ],
                    )
                )
            )
        ),
      );
    });
  }
}
