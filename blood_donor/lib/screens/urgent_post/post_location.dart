// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use, prefer_const_constructors, avoid_print
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class PostLocation extends StatefulWidget {
  const PostLocation({Key? key}) : super(key: key);

  @override
  State<PostLocation> createState() => _PostLocationState();
}

class _PostLocationState extends State<PostLocation> {
 
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _controller = Completer();
  static CameraPosition defaultPos = CameraPosition(
    target: LatLng(34.7, 71.4),
    zoom: 12,
  );
  late double unitHeightValue;
  LatLng markerPos  = LatLng(34.7, 71.4);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      showInSnackBar('Press and hold the marker to set it to your event location');
    });

  }
  
  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Constants.appThemeColor,
        content: new Text(value, style: TextStyle(color : Colors.white, fontSize: 1.8 * unitHeightValue),)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    unitHeightValue = MediaQuery.of(context).size.height * 0.01;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Stack(
          children: [
            
            GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              initialCameraPosition: defaultPos,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: <Marker>{
                Marker(
                  position: LatLng(34.7, 71.4),
                  draggable: true,
                  markerId: const MarkerId("1"),
                  icon: BitmapDescriptor.defaultMarker,
                  infoWindow: const InfoWindow(
                    title: 'Request Location',
                  ),
                  onDragEnd: (val){
                    print(val.latitude);
                    print(val.longitude);
                    markerPos = val;
                  }
                )
              },
            ),
            
            Container(
              height: SizeConfig.blockSizeVertical* 15,
              padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6, right: SizeConfig.blockSizeHorizontal * 6, top: SizeConfig.blockSizeVertical * 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: (){
                          Get.back();
                        },
                        icon: Icon(Icons.arrow_back_ios, color: Constants.appThemeColor, size: SizeConfig.blockSizeVertical*3,),
                      ),
                    ],
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context, markerPos);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Constants.appThemeColor,
                        borderRadius: new BorderRadius.circular(30.0)
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("SET EVENT LOCATION", style: TextStyle(fontSize: 1.8 * unitHeightValue, color: Colors.white),),
                        ),
                      ),
                    ),
                  )

                ],
              ),
            )

         ],
        ),
      ),
    );
  }
}