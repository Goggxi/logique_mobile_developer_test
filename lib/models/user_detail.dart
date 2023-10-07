class UserDetail {
  final String id;
  final String title;
  final String firstName;
  final String lastName;
  final String picture;
  final String gender;
  final String email;
  final DateTime dateOfBirth;
  final String phone;
  final Location location;
  final DateTime registerDate;
  final DateTime updatedDate;

  UserDetail({
    required this.id,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.picture,
    required this.gender,
    required this.email,
    required this.dateOfBirth,
    required this.phone,
    required this.location,
    required this.registerDate,
    required this.updatedDate,
  });

  factory UserDetail.empty() => UserDetail(
        id: "",
        title: "",
        firstName: "",
        lastName: "",
        picture: "",
        gender: "",
        email: "",
        dateOfBirth: DateTime(0),
        phone: "",
        location: Location.empty(),
        registerDate: DateTime(0),
        updatedDate: DateTime(0),
      );

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json["id"] ?? "",
        title: json["title"] ?? "",
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        picture: json["picture"] ?? "",
        gender: json["gender"] ?? "",
        email: json["email"] ?? "",
        dateOfBirth: json["dateOfBirth"] != null
            ? DateTime.parse(json["dateOfBirth"])
            : DateTime(0),
        phone: json["phone"] ?? "",
        location: json["location"] != null
            ? Location.fromJson(json["location"])
            : Location.empty(),
        registerDate: json["registerDate"] != null
            ? DateTime.parse(json["registerDate"])
            : DateTime(0),
        updatedDate: json["updatedDate"] != null
            ? DateTime.parse(json["updatedDate"])
            : DateTime(0),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "firstName": firstName,
        "lastName": lastName,
        "picture": picture,
        "gender": gender,
        "email": email,
        "dateOfBirth": dateOfBirth.toIso8601String(),
        "phone": phone,
        "location": location.toJson(),
        "registerDate": registerDate.toIso8601String(),
        "updatedDate": updatedDate.toIso8601String(),
      };
}

class Location {
  final String street;
  final String city;
  final String state;
  final String country;
  final String timezone;

  Location({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.timezone,
  });

  factory Location.empty() => Location(
        street: "",
        city: "",
        state: "",
        country: "",
        timezone: "",
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        street: json["street"] ?? "",
        city: json["city"] ?? "",
        state: json["state"] ?? "",
        country: json["country"] ?? "",
        timezone: json["timezone"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "city": city,
        "state": state,
        "country": country,
        "timezone": timezone,
      };
}
