class UserModel {
  final String name;
  final String city;
  final String country;
  final String imageUrl;
  final int age;
  bool isLiked;

  UserModel({
    required this.name,
    required this.city,
    required this.country,
    required this.imageUrl,
    required this.age,
    this.isLiked = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name']['first'],
      city: json['location']['city'],
      country: json['location']['country'],
      imageUrl: json['picture']['large'],
      age: json['dob']['age'],
    );
  }
}
