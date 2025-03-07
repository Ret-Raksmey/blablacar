
import '../model/ride/locations.dart';

import '../dummy_data/dummy_data.dart';
import '../repository/mock/locations_repository.dart';

////
///   This service handles:
///   - The list of available rides
///
class LocationsService {

  static LocationsService? _instance;

  final LocationsRepository repository;

  static const List<Location> availableLocations = fakeLocations; 
 
 /// Private constructor
  LocationsService._internal(this.repository);

  /// Initialize
  static void initialize(LocationsRepository repository) {
    if (_instance == null) {
      _instance = LocationsService._internal(repository);
    } else {
      throw Exception("Location Service is already initialized.");
    }
  }

  /// Singleton accessor
  static LocationsService get instance {
    if (_instance == null) {
      throw Exception(
          "Location service is not initialized. Call initialize() first.");
    }
    return _instance!;
  }

  List<Location> getLocations() {
    return repository.getLocations();
  }

  List<Location> getLocationsFor(String text) {
    return repository
        .getLocations()
        .where((location) =>
            location.name.toUpperCase().contains(text.toUpperCase()))
        .toList();
  }
}