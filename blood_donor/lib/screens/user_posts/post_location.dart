// ignore_for_file: avoid_print
import 'dart:async';
import 'package:blood_donor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/size_config.dart';

class UserPostLocation extends StatefulWidget {

  final Map eventDetail;
  const UserPostLocation({ Key? key, required this.eventDetail }) : super(key: key);

  @override
  State<UserPostLocation> createState() => _UserPostLocationState();
}

class _UserPostLocationState extends State<UserPostLocation> {
  
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition defaultPos;
  late double unitHeightValue;
  late LatLng markerPos;
  double lat = 0;
  double lon = 0;

  @override
  void initState() {
    super.initState();
    lat = double.parse(widget.eventDetail['latitude']);
    lon = double.parse(widget.eventDetail['longitude']);
    defaultPos = CameraPosition(
      target: LatLng(lat,lon ),
      zoom: 15,
    );
     markerPos =  LatLng(lat,lon);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
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
                position: LatLng(lat, lon),
                draggable: false,
                markerId: const MarkerId("1"),
                icon: BitmapDescriptor.defaultMarker,
                infoWindow: InfoWindow(
                  title: 'Post Location',
                  snippet: ''
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
                      icon: Icon(Icons.arrow_back_ios, color: Constants.appThemeColor, size: SizeConfig.blockSizeVertical * 4,),
                    ),
                  ],
                )
              ],
            ),
          ),

          
       ],
      ),
    );
  }
}