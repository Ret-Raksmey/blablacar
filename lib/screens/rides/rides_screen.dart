import 'package:flutter/material.dart';
import '../rides/widgets/ride_pref_bar.dart';
import '../../dummy_data/dummy_data.dart';
import '../../model/ride/ride.dart';
import '../../model/ride_pref/ride_pref.dart';
import '../../service/rides_service.dart';
import '../../theme/theme.dart';
 
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

// lib/screens/rides/rides_screen.dart
class _RidesScreenState extends State<RidesScreen> {
  RidePreference currentPreference = fakeRidePrefs[0];

  RideFilter selectedFilter = RideFilter.all;
  RideSortType selectedSortType = RideSortType.departureTime;

  List<Ride> get matchingRides => RidesService.getRidesFor(
    currentPreference,
    filter: selectedFilter,
    sortType: selectedSortType,
  );

  // Add methods to handle filter and sort changes
  void onFilterChanged(RideFilter filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  void onSortChanged(RideSortType sortType) {
    setState(() {
      selectedSortType = sortType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(BlaSpacings.m),
        child: Column(
          children: [
            // Dropdowns or buttons for filtering and sorting
            Row(
              children: [
                DropdownButton<RideFilter>(
                  value: selectedFilter,
                  items: RideFilter.values.map((filter) {
                  return DropdownMenuItem<RideFilter>(
                    value: filter,
                    child: Text(filter.toString().split('.').last),
                  );
                  }).toList(),
                  onChanged: (RideFilter? filter) {
                  if (filter != null) {
                    onFilterChanged(filter);
                  }
                  },
                ),
                DropdownButton<RideSortType>(
                  value: selectedSortType,
                  items: RideSortType.values.map((sortType) {
                  return DropdownMenuItem<RideSortType>(
                    value: sortType,
                    child: Text(sortType.toString().split('.').last),
                  );
                  }).toList(),
                  onChanged: (RideSortType? sortType) {
                  if (sortType != null) {
                    onSortChanged(sortType);
                  }
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) => RideTile(
                  ride: matchingRides[index],
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
