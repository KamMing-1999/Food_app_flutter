// 188. Create Cart Model which includes fields id, name, price and image
// Also, we add quantity, isExist and time for the cart.
import 'package:food_app_firebase/models/product_model.dart';

class CartModel {
  int? id;
  String? name;
  int? price;
  String? img;
  int? quantity;
  bool? isExist;
  String? time;
  // 250. Add product model attribute here
  ProductModel? product;

  CartModel(
    {
      this.id,
      this.name,
      this.price,
      this.img,
      this.quantity,
      this.isExist,
      this.time,
      this.product,
    }
  );

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    img = json['img'];
    quantity = json['quantity'];
    isExist = json['isExist'];
    time = json['time'];
    product = ProductModel.fromJson(json['product']);
  }

  // 313. create a toJson function to convert the cart product list to json string.
  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "price": this.price,
      "img": this.img,
      "quantity": this.quantity,
      "isExist": this.isExist,
      "time": this.time,
      // 319. Call the toJson() created for Product Model function here.
      "product": this.product!.toJson()
    };
  }
}