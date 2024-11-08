class User {
  final String email;
  final String username;

  User({
    required this.email,
    required this.username,
  });

  // Factory method to create a User from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      username: json['username'] as String,
    );
  }

  // Method to convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
    };
  }
}
