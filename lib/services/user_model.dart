class UserModel{
  String? uid;
  String? username;
  String? email;
  String? phone;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.phone,
  });

  Map<String , dynamic> toMap(){
    return {
      'uid' : uid,
      'username' : username,
      'email' : email,
      'phone' : phone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      username: data['username'],
      phone: data['phoneNo'],
    );
  }
}