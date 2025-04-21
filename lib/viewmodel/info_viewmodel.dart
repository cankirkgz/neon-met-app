import 'package:flutter/material.dart';
import 'package:neon_met_app/data/models/location_info.dart';

class InfoViewModel extends ChangeNotifier {
  final List<LocationInfo> locations = [
    LocationInfo(
      title: "The Met Fifth Avenue",
      imageUrl: "assets/images/img_info_02.png",
      hours: "Sunday–Tuesday and Thursday: 10 am–5 pm",
      extendedHours: "Friday and Saturday: 10 am–9 pm",
      address: "1000 Fifth Avenue, New York, NY 10028",
      phone: "212-535-7710",
    ),
    LocationInfo(
      title: "The Met Cloisters",
      imageUrl: "assets/images/img_info_03.png",
      hours: "Thursday–Tuesday: 10 am–5 pm",
      extendedHours: "Closed: Wednesday",
      address: "99 Margaret Corbin Drive, Fort Tryon Park, New York, NY 10040",
      phone: "212-923-3700",
    ),
  ];
}
