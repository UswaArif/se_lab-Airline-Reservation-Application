class UserModel{
  final String id;
  final String fullName;
  final int phone;
  final String address;
  final String email;
  final String password;
  final String role;
  final String created_at;
  final String updated_at;
  final bool active;

  UserModel({
    required this.id, // Initialize 'id' in the constructor
    required this.fullName,
    required this.phone,
    required this.address,
    required this.email,
    required this.password,
    required this.role,
    required this.created_at,
    required this.updated_at,
    required this.active,
  });
  

  toJson(){
    return{
      "FullName" : fullName,
      "Phone" : phone,
      "Address" : address,
      "Email": email,
      "Password": password,
      "Role" : role,
      "Created_At" : created_at,
      "Updated_At" : updated_at,
      "Active" : active,
    };
  }
}