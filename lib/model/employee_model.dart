class EmployeeModel {
  String id;
  String fullName;
  String role;
  DateTime joinedDate;
  DateTime? resignedDate;

  EmployeeModel({
    required this.id,
    required this.fullName,
    required this.role,
    required this.joinedDate,
    this.resignedDate,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      fullName: json['fullName'],
      role: json['role'],
      joinedDate: DateTime.parse(json['joinedDate']),
      resignedDate: json['resignedDate'] != null
          ? DateTime.parse(json['resignedDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'role': role,
        'joinedDate': joinedDate.toIso8601String(),
        'resignedDate': resignedDate?.toIso8601String(),
      };
}
