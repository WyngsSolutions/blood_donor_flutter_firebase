// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures
import 'package:blood_donor/screens/home_screen/home_screen.dart';
import 'package:blood_donor/screens/urgent_post/post_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class EditUrgentPost extends StatefulWidget {

  final Map postDetail;
  const EditUrgentPost({ Key? key, required this.postDetail}) : super(key: key);

  @override
  State<EditUrgentPost> createState() => _EditUrgentPostState();
}

class _EditUrgentPostState extends State<EditUrgentPost> {

  TextEditingController urgentText = TextEditingController();
  double latitude = 0;
  double longitude = 0;

  @override
  void initState() {
    super.initState();
    latitude = double.parse(widget.postDetail['latitude']);
    longitude = double.parse(widget.postDetail['longitude']);
    urgentText.text = widget.postDetail['description'];
  }

  void submitPressed() async {
    if (urgentText.text.isEmpty)
      Constants.showDialog("Please enter description");
    else if (latitude == 0)
      Constants.showDialog("Please set location");
    else
    {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
      dynamic result = await AppController().editPostRequest(widget.postDetail, urgentText.text, latitude, longitude);
      EasyLoading.dismiss();     
      if (result['Status'] == "Success")
      {
        Get.offAll(HomeScreen(defaultPage: 0));
        Constants.showDialog('Post edited successfully');
      }
      else 
      {
        Constants.showDialog(result['ErrorMessage']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          'Urgent Post',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*6, right: SizeConfig.blockSizeHorizontal*6, top: SizeConfig.blockSizeVertical * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
      
              Container(
                margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*2),
                child: Center(
                  child: Text(
                    'You can enter any urgent or emergency post regarding blood requirements and once approved by Admin they will be posted. Please avoid posting any other posts as they might cause account blockage.',
                    style: TextStyle(
                      color: Constants.appThemeColor,
                      fontSize: SizeConfig.fontSize * 2.0,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 1
                  )
                ),
                child: Center(
                  child: TextField(
                    maxLines: 6,
                    minLines: 6,
                    controller: urgentText,
                    maxLength: 150,
                    decoration: InputDecoration(
                      hintText: 'Enter description',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*4, vertical: SizeConfig.blockSizeVertical*2)
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal*40,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.appThemeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                      )
                    ),
                    onPressed: () async {
                      dynamic result = await Get.to(PostLocation());
                      if(result != null)
                      {
                        latitude = result.latitude;
                        longitude = result.longitude;
                      }
                    },
                    child: Center(
                      child: Text(
                        'Set Location',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.fontSize * 1.7,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: SizeConfig.blockSizeVertical * 7,
        margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 4, left: 30, right: 30),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Constants.appThemeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            )
          ),
          onPressed: submitPressed,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'POST',
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.fontSize * 2.0,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      )
    );
  }
}