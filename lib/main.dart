import '../repository/mock/mock_ride_preferences_repository.dart';
import '../service/locations_service.dart';
import '../repository/mock/locations_repository.dart';
void main() {

  // Initialize LocationService with Mock Repository
  LocationsService.initialize(MockLocationsRepository());

 // Test 
  print(LocationsService.instance.getLocations());

  
}