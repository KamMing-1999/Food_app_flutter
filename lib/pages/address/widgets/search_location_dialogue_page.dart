// 500. Great. Now create a widget to show the Location Dialog.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:food_app_firebase/controllers/location_controller.dart';
import 'package:food_app_firebase/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/src/places.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class LocationDialog extends StatelessWidget {
  final GoogleMapController mapController;
  const LocationDialog({Key? key, required this.mapController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    // 503. Build text box.
    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20/2),
        ),
        child: SizedBox(
          width: Dimensions.screenWidth,
          child: SingleChildScrollView(
            child: TypeAheadField(
              // 504. Set the style of the text box.
              textFieldConfiguration: TextFieldConfiguration(
                controller: _controller,
                textInputAction: TextInputAction.search,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: "Search Location",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      style: BorderStyle.none, width: 0
                    )
                  )
                )
              ),
              // 505. For the suggestion callback, as we are typing it gives suggestions.
              suggestionsCallback: (String pattern) async {
                // 512. Call the searchLocation method here.
                return await Get.find<LocationController>().searchLocation(context, pattern);
              },
              // 518. For the suggestion selected, call the set location function here.
              onSuggestionSelected: (Prediction suggestion) {
                Get.find<LocationController>().setLocation(suggestion.placeId!, suggestion.description!, mapController);
                Get.back();
              },
              // 513. For the item builder, display the suggested list.
              itemBuilder: (context, Prediction suggestion) {
                return Padding(
                  padding: EdgeInsets.all(Dimensions.width10),
                  child: Row(
                    children: [
                      Icon(Icons.location_on),
                      Expanded(child:
                      Text(suggestion.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis
                      )
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        )
      )
    );
  }
}
