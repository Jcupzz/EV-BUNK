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
  late String? info_window_title = "sample_info";
  late String? info_window_snippet;
  List<String> timings = [
    "01:00 - 02:00",
    "02:00 - 03:00",
    "03:00 - 04:00",
    "04:00 - 05:00",
    "05:00 - 06:00",
    "06:00 - 07:00",
    "07:00 - 08:00",
    "08:00 - 09:00",
    "09:00 - 10:00",
    "10:00 - 11:00",
    "11:00 - 12:00",
    "12:00 - 13:00",
    "13:00 - 14:00",
    "14:00 - 15:00",
    "15:00 - 16:00",
    "16:00 - 17:00",
    "17:00 - 18:00",
    "18:00 - 19:00",
    "19:00 - 20:00",
    "20:00 - 21:00",
    "21:00 - 22:00",
    "22:00 - 23:00",
    "23:00 - 00:00",
    "00:00 - 01:00"
  ];

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
    // final Uint8List markerIcon =
    await getBytesFromAsset('assets/ev_bunk.png', 200).then((value) {
      setState(() {
        icon = BitmapDescriptor.fromBytes(value);
      });
    });
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
                          showSheet(doc);
                        });
                      },
                      position: LatLng(doc.get('lat'), doc.get('long')),
                      visible: true,
                      // InfoWindow(title: doc.get('field'), snippet: "Ather: " doc.get('field')),
                    ),
                  );
                }));
  }

  // String getTitle(String id, CollectionReference<Map<String, dynamic>> ref) {
  //   print("SUCESSEFEFDFDFDF: " + id.toString());
  //   var snapshot;

  //   ref.doc(id).collection("port").get().then((QuerySnapshot querySnapshot) {
  //     print("SUCESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS: " +
  //         querySnapshot.docs[0].data().toString());

  //     snapshot = querySnapshot.docs[0].data();
  //   });

  //   return snapshot.toString();
  // }

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
                    mapToolbarEnabled: false,
                    buildingsEnabled: true,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    markers: Set.from(myMarker),
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: currentPostion,
                      zoom: 6,
                    ),
                  ),
                  (showDetailsButton)
                      ? Container()

                      // Positioned(
                      //     bottom: 10,
                      //     left: 10,
                      //     right: 10,
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       height: MediaQuery.of(context).size.width * 0.45,
                      //       width: MediaQuery.of(context).size.width,
                      //       child: Padding(
                      //         padding:
                      //             const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      //         child: SingleChildScrollView(
                      //           child: Column(
                      //             children: [

                      //               Text(
                      //                 documentSnapshot.get('name').toString(),
                      //                 style: h2_bold,
                      //               ),
                      //               Text(
                      //                 documentSnapshot.get('name').toString(),
                      //                 style: h2_bold,
                      //               ),
                      //               Text(
                      //                 documentSnapshot.get('name').toString(),
                      //                 style: h2_bold,
                      //               ),
                      //               Text(
                      //                 documentSnapshot.get('name').toString(),
                      //                 style: h2_bold,
                      //               ),
                      //               Text(
                      //                 documentSnapshot.get('name').toString(),
                      //                 style: h2_bold,
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ))
                      : Container(),
                ],
              ),
            )
          : Circular_Loading(),
    );
  }

  void showSheet(QueryDocumentSnapshot<Object?> doc) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(20),
            right: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (BuildContext b) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.25,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.get('name').toString(),
                      style: h2_bold,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "CCS: ",
                        style: h14.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          (doc.get('CCS').toString() == "Available")
                              ? TextSpan(
                                  text: doc.get('CCS').toString(),
                                  style: h14.copyWith(color: Colors.green),
                                )
                              : TextSpan(
                                  text: doc.get('CCS').toString(),
                                  style: h14.copyWith(color: Colors.red),
                                )
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "CHadeMo: ",
                        style: h14.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          (doc.get('CHadeMo').toString() == "Available")
                              ? TextSpan(
                                  text: doc.get('CHadeMo').toString(),
                                  style: h14.copyWith(color: Colors.green),
                                )
                              : TextSpan(
                                  text: doc.get('CHadeMo').toString(),
                                  style: h14.copyWith(color: Colors.red),
                                )
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Type2: ",
                        style: h14.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          (doc.get('Type2').toString() == "Available")
                              ? TextSpan(
                                  text: doc.get('Type2').toString(),
                                  style: h14.copyWith(color: Colors.green),
                                )
                              : TextSpan(
                                  text: doc.get('Type2').toString(),
                                  style: h14.copyWith(color: Colors.red),
                                )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: (doc.get('CCS').toString() == "Available")
                                ? ElevatedButton(
                                    onPressed: () async {},
                                    child: Text("CCS"),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green.shade300,
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red.shade300,
                                    ),
                                    child: Text("CCS"),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child:
                                (doc.get('CHadeMo').toString() == "Available")
                                    ? ElevatedButton(
                                        onPressed: () {},
                                        child: Text("CHadeMo"),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green.shade300,
                                        ),
                                      )
                                    : ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red.shade300,
                                        ),
                                        child: Text("CHadeMo"),
                                      ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: (doc.get('Type2').toString() == "Available")
                                ? ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green.shade300,
                                    ),
                                    child: Text("Type2"),
                                  )
                                : ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red.shade300,
                                    ),
                                    child: Text("Type2"),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: ListView.separated(
                        itemCount: timings.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(timings[index].toString()),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green.shade300,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 10,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
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
  fontSize: 14,
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
