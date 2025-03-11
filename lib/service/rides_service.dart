import 'package:week_3_blabla_project/model/ride_pref/ride_pref.dart';

import '../dummy_data/dummy_data.dart';
import '../model/ride/ride.dart';

enum RideFilter { all, upcoming, past }
enum RideSortType { departureTime, price }

class RidesService {
  static List<Ride> availableRides = fakeRides;  

  static List<Ride> getRidesFor(RidePreference preferences, 
                                  {RideFilter filter = RideFilter.all, 
                                   RideSortType sortType = RideSortType.departureTime}) {
    List<Ride> matchingRides = availableRides.where((ride) {
      return ride.departureLocation == preferences.departure && 
             ride.arrivalLocation == preferences.arrival;
    }).toList();

    // Filter rides based on the filter type
    if (filter == RideFilter.upcoming) {
      matchingRides = matchingRides.where((ride) => ride.departureDate.isAfter(DateTime.now())).toList();
    } else if (filter == RideFilter.past) {
      matchingRides = matchingRides.where((ride) => ride.departureDate.isBefore(DateTime.now())).toList();
    }

    // Sort rides based on the sort type
    if (sortType == RideSortType.departureTime) {
      matchingRides.sort((a, b) => a.departureDate.compareTo(b.departureDate));
    } else if (sortType == RideSortType.price) {
      matchingRides.sort((a, b) => a.pricePerSeat.compareTo(b.pricePerSeat));
    }

    return matchingRides;
  }
}