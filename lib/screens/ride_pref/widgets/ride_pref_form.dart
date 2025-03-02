import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../theme/theme.dart';
import '../../../dummy_data/dummy_data.dart';  // Import dummy data

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
  
  // Controller for the search fields
  final TextEditingController _departureSearchController = TextEditingController();
  final TextEditingController _arrivalSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initRidePref != null) {
      departure = widget.initRidePref!.departure;
      arrival = widget.initRidePref!.arrival;
      departureDate = widget.initRidePref!.departureDate;
      requestedSeats = widget.initRidePref!.requestedSeats;
    }
    
    // Initialize controllers with current values
    _departureSearchController.text = departure.name;
    _arrivalSearchController.text = arrival.name;
  }
  
  @override
  void dispose() {
    _departureSearchController.dispose();
    _arrivalSearchController.dispose();
    super.dispose();
  }

  void _selectDeparture() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSearchScreen(
          initialQuery: departure.name,
          title: 'Leaving from',
        ),
      ),
    );
    
    if (result != null && result is Location) {
      setState(() {
        departure = result;
        _departureSearchController.text = departure.name;
      });
    }
  }

  void _selectArrival() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSearchScreen(
          initialQuery: arrival.name,
          title: 'Going to',
        ),
      ),
    );
    
    if (result != null && result is Location) {
      setState(() {
        arrival = result;
        _arrivalSearchController.text = arrival.name;
      });
    }
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
      
      // Also swap the text in controllers
      final tempText = _departureSearchController.text;
      _departureSearchController.text = _arrivalSearchController.text;
      _arrivalSearchController.text = tempText;
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
                      Row(
                        children: [
                          Icon(Icons.circle_outlined, color: BlaColors.neutralLight , size: 20),
                          SizedBox(width: 8),
                        g  Text(
                            departure.name,
                            style: BlaTextStyles.label,
                          ),
                        ],
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
                  child: Row(
                    children: [
                      Icon(Icons.circle_outlined, color: BlaColors.neutralLight , size: 20),
                      SizedBox(width: 8),
                      Text(
                        arrival.name,
                        style: BlaTextStyles.label,
                      ),
                    ],
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
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: BlaColors.neutralLight , size: 20),
                      SizedBox(width: 8),
                      Text(
                        DateFormat('EEE d MMM').format(departureDate),
                        style: BlaTextStyles.label,
                      ),
                    ],
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
                  child: Row(
                    children: [
                      Icon(Icons.person, color: BlaColors.neutralLight , size: 20),
                      SizedBox(width: 8),
                      Text(
                        '$requestedSeats',
                        style: BlaTextStyles.label,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: BlaSpacings.m),

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
                child: Text('Search', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Location search screen using fakeLocations from dummy_data.dart
class LocationSearchScreen extends StatefulWidget {
  final String initialQuery;
  final String title;

  const LocationSearchScreen({
    Key? key,
    required this.initialQuery,
    required this.title,
  }) : super(key: key);

  @override
  _LocationSearchScreenState createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  late TextEditingController _searchController;
  List<Location> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _performSearch(widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
    });

    // Simulate network delay
    Future.delayed(Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        _searchResults = fakeLocations;
      } else {
        _searchResults = fakeLocations
            .where((location) =>
                location.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      setState(() {
        _isSearching = false;
      });
    });
  }

  String _getCountryName(Country country) {
    switch (country) {
      case Country.france:
        return 'France';
      case Country.uk:
        return 'United Kingdom';
      default:
        return country.toString().split('.').last;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for a city or station...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade800),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade800),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: BlaColors.primary),
                ),
                filled: true,
                fillColor: Colors.grey.shade900,
              ),
              onChanged: _performSearch,
              autofocus: true,
            ),
          ),
          
          // Current location option
          ListTile(
            leading: Icon(Icons.my_location, color: Colors.blue),
            title: Text('Use current location', style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              // In a real app, we would get the current location here
              Navigator.pop(context, Location(name: 'Current Location', country: Country.france));
            },
          ),
          
          Divider(color: Colors.grey.shade800),
          
          _isSearching
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(color: BlaColors.primary),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final location = _searchResults[index];
                      return ListTile(
                        title: Text(location.name, 
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(
                            _getCountryName(location.country),
                            style: TextStyle(color: Colors.grey)),
                        onTap: () {
                          Navigator.pop(context, location);
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}