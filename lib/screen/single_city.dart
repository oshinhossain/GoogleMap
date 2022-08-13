import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';

class SingleCity extends StatefulWidget {
  final Map cityData;
  const SingleCity({Key? key, required this.cityData}) : super(key: key);

  @override
  _SingleCityState createState() => _SingleCityState();
}

class _SingleCityState extends State<SingleCity> {
  BitmapDescriptor? pinLocationIcon;

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/markericon.png',
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMapPin();
  }

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _markers.clear();
    setState(() {
      final marker = Marker(
        icon: pinLocationIcon!,
        markerId: MarkerId(widget.cityData['id']),
        position: LatLng(widget.cityData['lat'], widget.cityData['lng']),
        infoWindow: InfoWindow(
            title: widget.cityData['name'],
            snippet: widget.cityData['address'],
            onTap: () {
              print("${widget.cityData['lat']}, ${widget.cityData['lng']}");
            }),
        onTap: () {
          print("Clicked on marker");
        },
      );
      print("${widget.cityData['lat']}, ${widget.cityData['lng']}");
      _markers[widget.cityData['name']] = marker;
    });
  }

  lanchMap(lat, long) {
    MapsLauncher.launchCoordinates(37.4220041, -122.0862462);
  }
  // launchMap(lat, long) {
  //   MapsLauncher.launchCoordinates(lat!, long!);
  //   //  MapLauncher.launchCoordinates(lat!, long!);
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About ${widget.cityData['name']}')),
      body: Column(
        children: [
          Card(
            elevation: 5,
            child: Column(
              children: [
                Image.network(
                  widget.cityData['image'],
                  height: 200,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        widget.cityData['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        lanchMap(
                            widget.cityData['lat'], widget.cityData['lng']);
                      },
                      child: const Text("Direction"),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.cityData['lat'], widget.cityData['lng']),
                zoom: 7,
              ),
              markers: _markers.values.toSet(),
            ),
          )
        ],
      ),
    );
  }
}
