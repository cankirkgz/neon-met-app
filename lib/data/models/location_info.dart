class LocationInfo {
  final String title;
  final String imageUrl;
  final String hours;
  final String? extendedHours;
  final String address;
  final String phone;

  LocationInfo({
    required this.title,
    required this.imageUrl,
    required this.hours,
    this.extendedHours,
    required this.address,
    required this.phone,
  });
}
