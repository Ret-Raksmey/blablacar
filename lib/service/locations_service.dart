// lib/service/locations_service.dart
import 'package:week_3_blabla_project/model/ride/locations.dart';
import '../repository/locations_repository.dart';

class LocationsService {
  static late LocationsRepository repository; // Make this a late variable

  static List<Location> get availableLocations {
    return repository.getLocations();
  }

  static void initialize(LocationsRepository repo) {
    repository = repo;
  }
}