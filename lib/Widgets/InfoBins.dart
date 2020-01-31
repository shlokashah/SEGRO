import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SingleBin {
  final int lat;
  final int long;
  SingleBin({this.lat, this.long});

  Map<String, String> toJson() => {
        "latitude": lat.toString(),
        "longitude": long.toString(),
      };
}

class Bin {
  int latitude;
  int longitude;
  String locationName;
  double garbageValue;
  String wasteType;
  bool needsToBeCollected;
  bool binFull;
  bool wasteCollected;

  Bin({
    this.latitude,
    this.longitude,
    this.locationName,
    this.garbageValue,
    this.wasteType,
    this.needsToBeCollected,
    this.binFull,
    this.wasteCollected,
  });

  factory Bin.fromJson(Map<String, dynamic> json) {
    return Bin(
      latitude: json['latitude'],
      longitude: json['longitude'],
      locationName: json['location_name'],
      garbageValue: json['garbage_value'],
      wasteType: json['waste_type'],
      needsToBeCollected: json['needs_to_be_collected'],
      binFull: json['bin_full'],
      wasteCollected: json['waste_collected'],
    );
  }
}

String postToJson(SingleBin pointCoordiantes) {
  final cord = {
    'latitude': pointCoordiantes.lat,
    'longitude': pointCoordiantes.long,
  };
  return json.encode(cord);
}

Future<Bin> sendCords(SingleBin pointCoordiantes) async {
  print('@@@@@@@@@@ ${postToJson(pointCoordiantes)}');
  final response = await http.post(
    'https://204902f0.ngrok.io/bins/bin_information/',
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: postToJson(pointCoordiantes),
  );
  print('####### ${response.body.toString()}');
  if (response.statusCode == 200) {
    print(json.decode(response.body));
    return Bin.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class InfoBins extends StatefulWidget {
  @override
  _InfoBinsState createState() => _InfoBinsState();
}

class _InfoBinsState extends State<InfoBins> {
  Widget binInfo(String infoText, String data) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              infoText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(data),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    SingleBin sb = SingleBin(lat: 50, long: 45);
    return FutureBuilder<Bin>(
      future: sendCords(
        sb,
      ), //sets the getCloudPredict method as the expected Future
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //checks if the response returns valid data
          return Container(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'Longitude : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(snapshot.data.longitude.toString()),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'Latitude : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(snapshot.data.latitude.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
                binInfo("location : ", snapshot.data.locationName.toString()),
                binInfo("garbage level : ", snapshot.data.garbageValue.toString()),
                binInfo("type of sector : ", snapshot.data.wasteType.toString()),
              ],
            ),
            // mainAxisAlignment: MainAxisAlignment.center,
            width: double.infinity,
            // margin: const EdgeInsets.all(15.0),
            // padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 3.5,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          //checks if the response throws an error
          return Text("${snapshot.error}");
        }
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          ),
          // mainAxisAlignment: MainAxisAlignment.center,
          width: double.infinity,
          height: 350,
          // margin: const EdgeInsets.all(15.0),
          // padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
              width: 3.5,
            ),
          ),
        );
      },
    );
  }
}

/*

Future<Bin> getBinsInfo() async {
  print("############################################################################################################################################################################################################");
  String url = 'https://204902f0.ngrok.io/bins/simulation';
  final response = await http.get(url, headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    print(json.decode(response.body));
    return Bin.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}
 */
