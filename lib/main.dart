import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

import 'package:petrol_finder/data/PetrolStation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  final petrolStationsDatabase = FirebaseDatabase(databaseURL:"https://petrol-shortage-guide-default-rtdb.europe-west1.firebasedatabase.app/").reference().child('petrolstations');
  //final List<PetrolStation> petrolStations = <PetrolStation>[];
  final Set<Marker> markers = Set();

  bool _initialized = false;
  bool _error = false;

  final LatLng _center = const LatLng(51.5074, -0.1272);


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

// Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }
  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    _activateListeners();
  }
  void _activateListeners()
  {
    petrolStationsDatabase.onChildAdded.listen((event)
    {
      if(event.snapshot.key==null) {
        return;
      }

      final PetrolStation petrolStation = PetrolStation.fromJson(event.snapshot.value);
      debugPrint(event.snapshot.key);
      debugPrint(petrolStation.address);
      debugPrint(petrolStation.latitude.toString());

      markers.add(Marker(
        markerId: MarkerId(event.snapshot.key==null?"ERROR":event.snapshot.key!),
        position: LatLng(petrolStation.latitude, petrolStation.longitude),
        infoWindow: InfoWindow(
          title: petrolStation.operator+" petrol station at "+petrolStation.address,
          snippet: petrolStation.dieselavail?"Has diesel":"NO DIESEL",
        ),
          icon:BitmapDescriptor.defaultMarker,
      ));
      //petrolStations.add(petrolStation);
      //debugPrint(petrolStations.length.toString());
    });
  }

  Widget SomethingWentWrong()
  {
    return ErrorWidget("An error has occurred in initialising Firebase");
  }
  Widget Loading()
  {
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if(_error) {
      return SomethingWentWrong();
    }
    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Loading();
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Petrol Finder'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: this.markers,
        ),
      ),
    );
  }
}