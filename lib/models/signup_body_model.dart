// 396. Create a Signup body model

class SignUpBody {
  String name;
  String phone;
  String email;
  String password;
  SignUpBody({
    required this.name, required this.phone, required this.email, required this.password
  });

  // 415. create a function toJson for signup body.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}
