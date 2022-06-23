class AppUser {
  AppUser({this.uid, this.email, this.username});

  String? uid;
  String? email;
  String? username;

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'username': username
    };
  }

  AppUser.fromJson(Map<String, dynamic> json): this(
    email: json['email']! ,
    username: json['username']!,
  );


}

