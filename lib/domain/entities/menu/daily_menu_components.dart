import 'dart:convert';

class DailyMenuComponents {
  List<String> menuIds;
  String dateTime;
  int menuType;

  DailyMenuComponents({
    required this.menuIds,
    required this.menuType,
  }) : dateTime = "01/03/2024"; // Always set this date

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "menuIds": menuIds,
      "menuType": menuType,
    };
  }

  // Convert from JSON (optional)
  factory DailyMenuComponents.fromJson(Map<String, dynamic> json) {
    return DailyMenuComponents(
      menuIds: List<String>.from(json["menuIds"]),
      menuType: json["menuType"],
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
