class UserModel{
  final String id;
  final String fullName;
  final String email;
  final String password;

  UserModel({
    required this.id, // Initialize 'id' in the constructor
    required this.fullName,
    required this.email,
    required this.password,
  });
  

  toJson(){
    return{
      "FullName" : fullName,
      "Email": email,
      "Password": password,
    };
  }
}