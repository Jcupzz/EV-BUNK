import 'dart:async';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import '../static/Circular_Loading.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showDetailsButton = false;
  late GoogleMapController mapController;
  List<Marker> myMarker = [];
  late DocumentSnapshot documentSnapshot;
  late String sd = "";
  var icon;
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

//
  late LatLng currentPostion = LatLng(11.783657, 75.514773);

  // late LatLng currentPostion;

  void _getUserLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((position) {
      setState(() {
        currentPostion = LatLng(position.latitude, position.longitude);
      });
    });

    // if (position != null) {

    // } else {
    //   // setState(() {
    //   //   currentPostion = LatLng(11.783657, 75.514773);
    //   // });
    // }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  getIcons() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/ev_bunk.png', 200);
    icon = BitmapDescriptor.fromBytes(markerIcon);
  }

  void _getAllLatLongFromFb() async {
    var ref = FirebaseFirestore.instance.collection('ev_bunks');

    var res = await ref
        // .where('isRequested', isEqualTo: true)
        .get()
        .then(
            (QuerySnapshot querySnapshot) => querySnapshot.docs.forEach((doc) {
                  print("\n\n#############################: " +
                      doc.get('lat').toString());
                  setState(() {});
                  myMarker.add(
                    Marker(
                      markerId: MarkerId(
                          LatLng(doc.get('lat'), doc.get('long')).toString()),
                      icon: icon,
                      onTap: () {
                        setState(() {
                          showDetailsButton = true;
                          documentSnapshot = doc;
                          sd = getTitle(doc.id, ref);
                          print("CURRENT DOCUMENT IS: " + doc.id.toString());
                        });
                      },
                      position: LatLng(doc.get('lat'), doc.get('long')),
                      infoWindow: InfoWindow(
                        title: sd,
                      ),
                      // InfoWindow(title: doc.get('field'), snippet: "Ather: " doc.get('field')),
                    ),
                  );
                }));
  }

  String getTitle(String id, CollectionReference<Map<String, dynamic>> ref) {
    print("SUCESSEFEFDFDFDF: " + id.toString());
    var snapshot;

    ref.doc(id).collection("port").get().then((QuerySnapshot querySnapshot) {
      print("SUCESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS: " +
          querySnapshot.docs[0].data().toString());

      snapshot = querySnapshot.docs[0].data();
    });

    return snapshot.toString();
  }

  @override
  void initState() {
    super.initState();
    _getUserLocationPermission();
    _getUserLocation();
    _getAllLatLongFromFb();
    getIcons();
  }

//
  late Set<Marker> marker;
  late LatLng latLngs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: currentPostion != null
          ? SafeArea(
              child: Stack(
                children: [
                  GoogleMap(
                    mapToolbarEnabled: true,
                    buildingsEnabled: true,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    markers: Set.from(myMarker),
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: currentPostion,
                      zoom: 6,
                    ),
                  ),
                  (showDetailsButton)
                      ? Positioned(
                          bottom: 18,
                          left: 0,
                          child: Container(
                            height: 38,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (documentSnapshot != null) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            elevation: 24,
                                            backgroundColor:
                                                Theme.of(context).cardColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            title: Text("Confirmation",
                                                style: h3_bold),
                                            content: Text(
                                                "Confirm the booking?",
                                                style: h2),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Theme.of(context)
                                                        .cardColor,
                                                    elevation: 0),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "No",
                                                  style: TextStyle(
                                                      color: Colors.greenAccent,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Theme.of(context)
                                                        .cardColor,
                                                    elevation: 0),
                                                onPressed: () async {
                                                  BotToast.showText(
                                                      text:
                                                          "Confirmed...your auto is on the way!");
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.redAccent),
                                                ),
                                              ),
                                            ],
                                          );
                                        });

                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (_) =>
                                    //             Details(documentSnapshot)));
                                  }
                                },
                                child: Text(
                                  "Book",
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white70,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                            ),
                          ))
                      : Container(),
                ],
              ),
            )
          : Circular_Loading(),
    );
  }

  //functions
  //functions
  //functions

  Future _getUserLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      BotToast.showText(text: 'Location services are disabled');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      BotToast.showText(
          text:
              'Location permissions are permantly denied, we cannot request permissions');
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        BotToast.showText(
            text:
                'Location permissions are denied (actual value: $permission)');
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
  }
}

TextStyle h3_bold = TextStyle(
  fontSize: 30,
  fontFamily: GoogleFonts.poppins().fontFamily,
  fontWeight: FontWeight.bold,
);
TextStyle h2_bold = TextStyle(
  fontSize: 20,
  fontFamily: GoogleFonts.poppins().fontFamily,
  fontWeight: FontWeight.bold,
);
TextStyle h14_bold = TextStyle(
  fontSize: 10,
  fontFamily: GoogleFonts.poppins().fontFamily,
  fontWeight: FontWeight.bold,
);
TextStyle h3 = TextStyle(
  fontSize: 30,
  fontFamily: GoogleFonts.poppins().fontFamily,
  fontWeight: FontWeight.normal,
);
TextStyle h2 = TextStyle(
  fontSize: 20,
  fontFamily: GoogleFonts.poppins().fontFamily,
  fontWeight: FontWeight.normal,
);
TextStyle h14 = TextStyle(
  fontSize: 14,
  color: Colors.black,
  fontFamily: GoogleFonts.poppins().fontFamily,
  fontWeight: FontWeight.normal,
);
