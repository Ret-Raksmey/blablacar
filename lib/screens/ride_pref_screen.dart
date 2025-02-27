import 'package:flutter/material.dart';

import '../../model/ride_pref/ride_pref.dart';
import '../../service/ride_prefs_service.dart';
import '../../theme/theme.dart';
import '../screens/ride_pref/widgets/ride_pref_form.dart';
import '../screens/ride_pref/widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

class RidePrefScreen extends StatefulWidget {
  const RidePrefScreen({super.key});

  @override
  State<RidePrefScreen> createState() => _RidePrefScreenState();
}

class _RidePrefScreenState extends State<RidePrefScreen> {
  void onRidePrefSelected(RidePref ridePref) {
    // Navigate to the rides screen with a bottom-to-top animation
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RidesScreen(ridePref: ridePref),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1 - Background Image
        const BlaBackground(),

        // 2 - Foreground content
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                "Your pick of rides at low price",
                style: BlaTextStyles.heading.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 100),
              Container(
                margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 2.1 Display the Form to input the ride preferences
                    RidePrefForm(initRidePref: RidePrefService.currentRidePref),
                    const SizedBox(height: BlaSpacings.m),

                    // 2.2 Optionally display a list of past preferences
                    SizedBox(
                      height: 200, // Set a fixed height
                      child: ListView.builder(
                        shrinkWrap: true, // Fix ListView height issue
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: RidePrefService.ridePrefsHistory.length,
                        itemBuilder: (ctx, index) => RidePrefHistoryTile(
                          ridePref: RidePrefService.ridePrefsHistory[index],
                          onPressed: () => onRidePrefSelected(RidePrefService.ridePrefsHistory[index]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}

class RidesScreen extends StatelessWidget {
  final RidePref ridePref;

  const RidesScreen({required this.ridePref, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rides for ${ridePref.destination}'),
      ),
      body: Center(
        child: Text('Displaying rides for ${ridePref.destination}'),
      ),
    );
  }
}