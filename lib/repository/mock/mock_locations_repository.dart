import '../../model/ride/locations.dart';
import '../locations_repository.dart';
import '../../dummy_data/dummy_data.dart';

class MockLocationsRepository extends LocationsRepository {
  @override
  List<Location> getLocations() {
    return fakeLocations; // returns the list of fake locations
  }
}