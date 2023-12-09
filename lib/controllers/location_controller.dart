import 'package:flutter/material.dart';
import 'package:food_app_firebase/data/api/api_checker.dart';
import 'package:food_app_firebase/utils/app_constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/api/api_client.dart';
import '../data/repository/location_repo.dart';
import '../models/address_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

// 463. Add the necessary packages first.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import '../models/response_model.dart';
import '../routes/route_helper.dart';
import '../utils/colors.dart';
import 'auth_controller.dart';

// 509. Import the necessary google location predictions library manually.
import 'package:google_maps_webservice/src/places.dart';

// 431. Create Location Controller.

class LocationController extends GetxController implements GetxService
{
  LocationRepo locationRepo;
  LocationController({required this.locationRepo});
  bool _loading = false;
  // 432. Create placemark models for pickPosition and placemark.
  late Position _position;
  late Position _pickPosition;
  Placemark _placemark = Placemark();
  Placemark _pickPlacemark = Placemark();
  Placemark get placemark => _placemark;
  Placemark get pickPlacemark => _pickPlacemark;
  List<AddressModel> _addressList = [];
  List<AddressModel> _allAddressList = [];
  List<AddressModel> get addressList => _addressList;

  late ApiClient apiClient;

  // 474. Create a setter for the address list.
  set addressList(List<AddressModel> list) {
    _addressList = list;
  }
  List<String> _addressTypeList = ["home", "office", "others"];
  List<String> get addressTypeList => _addressTypeList;
  int _addressTypeIndex = 0;
  int get addressTypeIndex => _addressTypeIndex;
  late Map<String, dynamic> _getAddress;
  Map get getAddress => _getAddress;

  // 444. Set map controller here.
  late GoogleMapController _mapController;
  void setMapController(GoogleMapController googleMapController) {
    _mapController = googleMapController;
  }

  // 446. Create a function to update the google map position while dragging.
  bool _updateAddressData = true;
  bool _changeAddress = true;

  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;
  GoogleMapController get mapController=>_mapController;

  // 493. Set up variables for the location-based services.
  bool _isLoading = false;
  bool _buttonDisabled = true;   // showing and hiding the button as the map loads.
  bool get isLoading => _isLoading;
  bool _inZone = false;
  bool get inZone => _inZone; // whether the user is in service zone or not.
  bool get buttonDisabled => _buttonDisabled;

  // 508. Here we save the google map suggestions here.
  List<Prediction> _predictionList = [];

  void updatePosition(CameraPosition position, bool fromAddress) async {
    if (_updateAddressData) {
      _loading = true;
      update();
      try {
        if (fromAddress) {
          _position = Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
              altitudeAccuracy: 1, headingAccuracy: 1
          );
          _loading = false;
        } else {
          // 453. Save the position where the place-mark is located.
          _pickPosition = Position(
              latitude: position.target.latitude,
              longitude: position.target.longitude,
              timestamp: DateTime.now(),
              heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
              altitudeAccuracy: 1, headingAccuracy: 1
          );
        }

        // 493. Call the response model and disabled button here.
        ResponseModel _responseModel =
        await getZone(position.target.latitude.toString(), position.target.longitude.toString(), false);
        // 494. If button value is false we are in the service area.
        _buttonDisabled = !_responseModel.isSuccess;

        if (_changeAddress) {
          String _address = await getAddressFromGeocode(
            LatLng(position.target.latitude, position.target.longitude)
          );
          _loading = false;
          fromAddress? _placemark = Placemark(name: _address):
          _pickPlacemark=Placemark(name: _address);
        } else {
          // 519. Enable the change address flag to true so that once picked address from search list,
          // the address can be updated instantly.
          _changeAddress = true;
        }
      } catch(e) {
        print(e);
      }
      update();
    } else {
      _updateAddressData = true;
      _loading = false;
    }

  }

  // 447. Create a function to get Address from geocode for address picked.
  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String _address = "Unknown Location Found";
    http.Response response = await locationRepo.getAddressfromGeocode(latLng);
    final decodedResponse = json.decode(response.body);
    // print(decodedResponse);

    // 452. Find if the response is returned successfully.
    if (response.statusCode ==  200) {
      // Successful API Call.
      final results = decodedResponse['results'];
      if (results.isNotEmpty) {
        final formattedAddress = results[0]['formatted_address'];
        _address = formattedAddress;
      } else {
        // print(results);
      }
    }
    /*if (response.body["status"]=='OK') {
      _address = response.body["results"][0]["formatted_address"].toString();
      print("printing address "+_address);
    } else {
      print("Error getting the google api");
    }*/
    return _address;
  }

  // 456. Create get User Address function.
  AddressModel getUserAddress() {
    late AddressModel _addressModel;
    _getAddress = jsonDecode(locationRepo.getUserAddress());
    try {
      _addressModel = AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));
    }catch(e){
      print(e);
    }
    return _addressModel;
  }

  // 458. Create function to set the address type index.
  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    update();
  }

  // 462. Create a method called addAddress to save the address user to the Firestore database.
  void addAddress(AddressModel addressModel) async {
    _loading = true;
    // 465. Save the address type, contact person name, contact person number, address, latitude, longitude
    // 466. Create a Geopoint object using the latitude and longitude coordinates.
    GeoPoint geoPoint = GeoPoint(double.parse(addressModel.latitude), double.parse(addressModel.longitude));

    // 467. Get a reference to the Firestore collection where you want to save the user's address.
    CollectionReference<Map<String, dynamic>> collectionRef
      = FirebaseFirestore.instance.collection('user_addresses');

    // 468. Get current user and get the uid.
    final currentUser = Get.find<AuthController>().currentUser;
    String? uid = currentUser?.uid;

    // 469. Save the user address object to the Firestore and do the checking.
    try {
      await collectionRef.doc(uid).set({
        'address': addressModel.address,
        'address_type': addressModel.addressType,
        'contact_person_name': addressModel.contactPersonName,
        'contact_person_number': addressModel.contactPersonNumber,
        'position': geoPoint,
      });
      Get.toNamed(RouteHelper.getInitial());
      Get.snackbar('Success', 'Address saved!', backgroundColor: AppColors.mainColor, colorText: Colors.white);
      // 472. Call the getCurrentUserAddress function here.
      getCurrentUserAddress();
    } catch (error) {
      Get.snackbar('Error', 'Failed to save address.', backgroundColor: Colors.redAccent, colorText: Colors.white);
    }

    update();
  }

  // 470. Create a method to get the user address using uid and push the address to private _addressList.
  getCurrentUserAddress() async {
    // 471. Get a reference to the Firestore collection and get the user address document using user id.
    final currentUser = Get.find<AuthController>().currentUser;
    String? uid = currentUser?.uid;
    CollectionReference<Map<String, dynamic>> collectionRef = FirebaseFirestore.instance.collection('user_addresses');
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await collectionRef.doc(uid).get();

    String address = documentSnapshot.data()!['address'];
    GeoPoint geoPoint = documentSnapshot.data()!['position'];
    String latitude = geoPoint.latitude.toString();
    String longitude = geoPoint.longitude.toString();
    String address_type = documentSnapshot.data()!['address_type'];
    String contact_person_name = documentSnapshot.data()!['contact_person_name'];
    String contact_person_number = documentSnapshot.data()!['contact_person_number'];

    AddressModel addressModel = AddressModel(
      addressType: address_type,
      address: address,
      contactPersonNumber: contact_person_number,
      contactPersonName: contact_person_name,
      latitude: latitude,
      longitude: longitude
    );

    _addressList.add(addressModel);
    update();
  }

  Future<AddressModel> getCurrentUserAddressModel() async {
    final currentUser = Get.find<AuthController>().currentUser;
    String? uid = currentUser?.uid;
    CollectionReference<Map<String, dynamic>> collectionRef = FirebaseFirestore.instance.collection('user_addresses');
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await collectionRef.doc(uid).get();

    String address = documentSnapshot.data()!['address'];
    GeoPoint geoPoint = documentSnapshot.data()!['position'];
    String latitude = geoPoint.latitude.toString();
    String longitude = geoPoint.longitude.toString();
    String address_type = documentSnapshot.data()!['address_type'];
    String contact_person_name = documentSnapshot.data()!['contact_person_name'];
    String contact_person_number = documentSnapshot.data()!['contact_person_number'];

    AddressModel addressModel = AddressModel(
        addressType: address_type,
        address: address,
        contactPersonNumber: contact_person_number,
        contactPersonName: contact_person_name,
        latitude: latitude,
        longitude: longitude
    );

    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = uid??"";
    data["address_type"] = address_type??"";
    data["contact_person_number"] = contact_person_number??"";
    data["contact_person_name"] = contact_person_name??"";
    data["longitude"] = longitude??"";
    data["latitude"] = latitude??"";

    _getAddress = data;

    return addressModel;
  }

  // 475. Create another function to solely get the user address string.
  String getUserAddressString() {
    final currentUser = Get.find<AuthController>().currentUser;
    String? uid = currentUser?.uid;
    CollectionReference<Map<String, dynamic>> collectionRef = FirebaseFirestore.instance.collection('user_addresses');
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = collectionRef.doc(uid).get() as DocumentSnapshot<Map<String, dynamic>>;

    String address = documentSnapshot.data()!['address'];

    print(address);
    return address;
  }

  // 490. Create a function to pick the address and save the data.
  void setAddAddressData () {
    _position = _pickPosition;
    _placemark = _pickPlacemark;
    _updateAddressData=false;
    update();
  }

  // 492. Get the zone loaded by marker to ensure the zone is appropriate to be called.
  Future<ResponseModel> getZone(String lat, String lng, bool markerLoad) async {
    late ResponseModel _responseModel;

    if (markerLoad) {
      _loading = true;
    } else {
      _isLoading = true;
    }
    update();

    Response response = await locationRepo.getZone(lat, lng);
    // 496. Remove the below section as it is dummy.
    /*await Future.delayed(Duration(seconds: 2),() {
      _responseModel = ResponseModel(true, "success");
      if (markerLoad) {
        _loading = false;
      } else {
        _isLoading = false;
      }
      _inZone = true;
    });*/
    if (response.statusCode == 200) {
      _inZone = true;
      _responseModel = ResponseModel(true, response.body["zone_id"].toString());
      /*if (response.body["zone_id"]!=2) {
        _responseModel = ResponseModel(false, response.body["zone_id"].toString());
        _inZone = false;
      } else {
        _responseModel = ResponseModel(true, response.body["zone_id"].toString());
        _inZone = true;
      }*/
    } else {
      _inZone = false;
      _responseModel = ResponseModel(true, response.statusText!);
    }
    if (markerLoad) {
      _loading = false;
    } else {
      _isLoading = false;
    }
    // for debugging
    print(response.statusCode);
    update();
    return _responseModel;
  }

  // 507. Create a search Location method here to pass the text typed for searching.
  Future<List<Prediction>> searchLocation (BuildContext context, String text) async {
    if (text.isNotEmpty) {
      http.Response response = await locationRepo.searchLocation(text);

      final decodedResponse = json.decode(response.body);
      // print(decodedResponse);

      // 452. Find if the response is returned successfully.
      if (response.statusCode ==  200) {
        // Successful API Call.
        final predictions = decodedResponse['predictions'];
        // print(predictions);
        if (predictions.isNotEmpty) {
          _predictionList = [];
          predictions.forEach((prediction) => _predictionList.add(Prediction.fromJson(prediction)));
        } else {
          // 511. Call the api checker here.
          ApiChecker.checkApi(response as Response);
        }
      }
    }
    return _predictionList;
  }

  // 517. Create setLocation function to choose the place.
  setLocation(String placeId, String address, GoogleMapController mapController) async {
    // _loading = true;
    PlacesDetailsResponse detail;
    http.Response response = await locationRepo.setLocation(placeId);
    final jsonResponse = json.decode(response.body);
    detail = PlacesDetailsResponse.fromJson(jsonResponse);
    _pickPosition=Position(
      latitude: detail.result.geometry!.location.lat,
      longitude: detail.result.geometry!.location.lng,
      timestamp: DateTime.now(),
      accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1
    );
    _pickPlacemark = Placemark(name: address);
    _changeAddress=false;
    if (!mapController.isNull) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(detail.result.geometry!.location.lat, detail.result.geometry!.location.lng),
          zoom: 17
        )
      ));
    }
    _loading=false;
    update();
  }

}