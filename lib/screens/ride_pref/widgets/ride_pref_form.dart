import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../theme/theme.dart';

class RidePrefForm extends StatefulWidget {
  final RidePref? initRidePref;

  const RidePrefForm({super.key, this.initRidePref});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location departure = const Location(name: 'Toulouse', country: Country.france);
  DateTime departureDate = DateTime.now();
  Location arrival = const Location(name: 'Bordeaux', country: Country.france);
  int requestedSeats = 1;

  @override
  void initState() {
    super.initState();
    if (widget.initRidePref != null) {
      departure = widget.initRidePref!.departure;
      arrival = widget.initRidePref!.arrival;
      departureDate = widget.initRidePref!.departureDate;
      requestedSeats = widget.initRidePref!.requestedSeats;
    }
  }

  void _selectDeparture() async {
    // Logic to select departure location
  }

  void _selectArrival() async {
    // Logic to select arrival location
  }

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        departureDate = pickedDate;
      });
    }
  }

  void _showSeatsDialog() {
    int tempSeats = requestedSeats;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              'Number of seats to book',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$tempSeats',
                    style: TextStyle(color: Colors.white, fontSize: 48),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.white),
                        onPressed: () {
                          if (tempSeats > 1) {
                            setState(() {
                              tempSeats--;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          if (tempSeats < 10) {
                            setState(() {
                              tempSeats++;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  requestedSeats = tempSeats;
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Confirm',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _swapLocations() {
    setState(() {
      final temp = departure;
      departure = arrival;
      arrival = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(  // Enable scrolling
        child: Container(
          decoration: BoxDecoration(
            color: BlaColors.white,
            borderRadius: BorderRadius.circular(BlaSpacings.radius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(BlaSpacings.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Your pick of rides at low price',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Departure Location
              GestureDetector(
                onTap: _selectDeparture,
                child: Container(
                  padding: const EdgeInsets.all(BlaSpacings.s),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: BlaColors.greyLight),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        departure.name,
                        style: BlaTextStyles.label,
                      ),
                      IconButton(
                        icon: Icon(Icons.swap_vert, color: BlaColors.primary),
                        onPressed: _swapLocations,
                        tooltip: 'Swap locations',
                      ),
                    ],
                  ),
                ),
              ),

              // Arrival Location
              GestureDetector(
                onTap: _selectArrival,
                child: Container(
                  padding: const EdgeInsets.all(BlaSpacings.s),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: BlaColors.greyLight),
                    ),
                  ),
                  child: Text(
                    arrival.name,
                    style: BlaTextStyles.label,
                  ),
                ),
              ),

              const SizedBox(height: BlaSpacings.s),

              // Date Picker
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(BlaSpacings.s),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: BlaColors.greyLight),
                    ),
                  ),
                  child: Text(
                    DateFormat('EEE d MMM').format(departureDate),
                    style: BlaTextStyles.label,
                  ),
                ),
              ),
              const SizedBox(height: BlaSpacings.s),

              // Number of Seats Button
              GestureDetector(
                onTap: _showSeatsDialog,
                child: Container(
                  padding: const EdgeInsets.all(BlaSpacings.s),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: BlaColors.greyLight),
                    ),
                  ),
                  child: Text(
                    'Number of seats: $requestedSeats',
                    style: BlaTextStyles.label,
                  ),
                ),
              ),
              const SizedBox(height: BlaSpacings.s),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  print(
                      'Searching rides from ${departure.name} to ${arrival.name} on ${departureDate.toLocal()} with $requestedSeats passengers.');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BlaColors.primary,
                  padding: const EdgeInsets.all(12),
                ),
                child: Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}