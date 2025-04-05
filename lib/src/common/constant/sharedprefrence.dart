import 'dart:convert';

import 'package:fitbitter/fitbitter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
// Save FitbitCredentials to SharedPreferences
  Future<void> saveFitbitCredentials(FitbitCredentials credentials) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert to JSON string manually
    String jsonData = jsonEncode({
      'userID': credentials.userID,
      'fitbitAccessToken': credentials.fitbitAccessToken,
      'fitbitRefreshToken': credentials.fitbitRefreshToken,
    });

    await prefs.setString('fitbit_credentials', jsonData);
  }

// Load FitbitCredentials from SharedPreferences
  Future<FitbitCredentials?> loadFitbitCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('fitbit_credentials');

    if (jsonData != null) {
      // Decode JSON manually
      Map<String, dynamic> data = jsonDecode(jsonData);
      return FitbitCredentials(
        userID: data['userID'],
        fitbitAccessToken: data['fitbitAccessToken'],
        fitbitRefreshToken: data['fitbitRefreshToken'],
      );
    }
    return null;
  }

// Delete FitbitCredentials from SharedPreferences
  Future<void> deleteFitbitCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('fitbit_credentials');
  }
}
