// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_map/flutter_map.dart';

/// Global variables accessible throughout the app
String globalEmail = '';
String backendBase = 'hackathons/aavishkar/users';
Map<String, dynamic> globalUser = {};

/// Initialize safely (Option 1 recommended for simplicity)
MapController mapController = MapController();
