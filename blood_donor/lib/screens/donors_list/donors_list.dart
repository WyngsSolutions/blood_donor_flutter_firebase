// ignore_for_file: prefer_const_constructors
import 'package:blood_donor/screens/add_donor/add_donor.dart';
import 'package:blood_donor/utils/constants.dart';
import 'package:blood_donor/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../helpers/user_view.dart';

class DonorsList extends StatefulWidget {
  const DonorsList({ Key? key }) : super(key: key);

  @override
  State<DonorsList> createState() => _DonorsListState();
}

class _DonorsListState extends State<DonorsList> {

  List donorsList = [];

  @override
  void initState() {
    super.initState();
    getAllDonors();
  }

  void getAllDonors() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().getAllDonors(donorsList);
    EasyLoading.dismiss();     
    
    if (result['Status'] == "Success") 
    {
      setState(() {
        donorsList = result['DonorsList'];
      });
    } 
    else {
      //Fail Cases Show String
      Constants.showDialog(result['ErrorMessage'],);
    }
  }
  ///******* UTIL METHOD ****************///
  void userProfileView(Map personDetail)async
  {
    dynamic result = await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc){
        return UserDetailView(personDetail : personDetail);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          'Donors List',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*2, SizeConfig.blockSizeVertical*2, SizeConfig.blockSizeHorizontal*2, SizeConfig.blockSizeVertical*2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

              Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2, left: SizeConfig.blockSizeHorizontal*2),
                child: Text(
                  'All Donors',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: SizeConfig.fontSize * 2.2,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
               Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*3, SizeConfig.blockSizeVertical*1, SizeConfig.blockSizeHorizontal*3,0),
                  child: (donorsList.isNotEmpty) ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: donorsList.length,
                  itemBuilder: (context, index){
                    return donorCell(donorsList[index], index);
                  }
                ) : Center(
                  child: Text(
                    'No Donor Found',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: SizeConfig.fontSize*2
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
      floatingActionButton: (Constants.appUser.isDonor) ? Container() : FloatingActionButton(
        onPressed: (){
          Get.to(AddDonor());
        },
        backgroundColor: Constants.appThemeColor,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget donorCell (Map donor, int index){
    return GestureDetector(
      onTap: (){
        userProfileView(donor);
      },
      child: Container(
        height: SizeConfig.blockSizeVertical*11,
        //margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Constants.appThemeColor,
              width: 0.2
            )
          )
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*3),
              height: SizeConfig.blockSizeVertical*8,
              width: SizeConfig.blockSizeVertical*8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: (donor['picture'].isEmpty) ? AssetImage('assets/user_bg.png') : CachedNetworkImageProvider(donor['picture']) as ImageProvider,
                  fit: BoxFit.cover
                )
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${donor['name']}',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: SizeConfig.fontSize * 2.0,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*0.5),
                    child: Text(
                      '${donor['city']}',
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 1.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${donor['bloodGroup']}',
              textAlign: TextAlign.start,
              maxLines: 1,
              style: TextStyle(
                fontSize: SizeConfig.fontSize * 2.0,
                color: Constants.appThemeColor,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget featuredAdView(){
  //   return Container(
  //     child : Stack(
  //      // mainAxisAlignment: MainAxisAlignment.center,
  //       children: [        
  //         Container(
  //           //color: Colors.black,
  //           width: SizeConfig.blockSizeHorizontal * 100,
  //           height: SizeConfig.blockSizeVertical * 22,
  //           child: Swiper(
  //             controller: swiperController,
  //             itemBuilder: (BuildContext context, int index) {
  //               return subView(banners[currentIndex]);
  //             },
  //             onIndexChanged: (value){
  //               print('index value = $value');
  //               setState(() {
  //                 currentIndex = value;                      
  //               });
  //             },
  //             autoplay: (banners.length == 1) ? false : true,
  //             itemCount: banners.length,
  //             scrollDirection: Axis.horizontal,
  //             pagination: SwiperPagination(
  //               alignment: Alignment.centerRight,
  //               builder: SwiperPagination.rect
  //             ),
  //             control: SwiperControl(
  //               color: Colors.transparent
  //             ),
  //           ),
  //         ),

  //         Container(
  //           alignment: Alignment.center,
  //           padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 19),
  //           child: DotsIndicator(
  //             dotsCount: banners.length,
  //             position: currentIndex.toDouble(),
  //             decorator: DotsDecorator(
  //               activeColor: Colors.white,
  //               color: Colors.grey[400]!,
  //               size: Size.square(9.0),
  //               activeSize: Size(18.0, 9.0),
  //               activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
  //             ),
  //           ),
  //         )
  //       ]
  //     ),
  //   );
  // }

  // Widget subView(Map postData){
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       border: Border.all(
  //         color: Colors.grey[300]!,
  //         width: 1
  //       )
  //     ),
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*3),
  //               height: SizeConfig.blockSizeVertical*6,
  //               width: SizeConfig.blockSizeVertical*6,
  //               decoration: BoxDecoration(
  //                 color: Colors.red,
  //                 shape: BoxShape.circle,
  //                 image: DecorationImage(
  //                   image: AssetImage('assets/user_bg.png'),
  //                   fit: BoxFit.cover
  //                 )
  //               ),
  //             ),
  //             Expanded(
  //               child: Text(
  //                 postData['name'],
  //                 textAlign: TextAlign.left,
  //                 style: TextStyle(
  //                   fontSize: SizeConfig.fontSize * 2.0,
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.w500
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*5),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   Icon(Icons.location_on, color: Constants.appThemeColor, size : SizeConfig.blockSizeVertical*2.5),
  //                   Icon(Icons.comment, color: Constants.appThemeColor, size : SizeConfig.blockSizeVertical*2.5)
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),

  //         Container(
  //           child: Text(
  //             //'B+ urgently needed at National Hospital. Contact at 111-222-333',
  //             postData['description'],
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontSize: SizeConfig.fontSize * 2.0,
  //               color: Colors.black,
  //               fontWeight: FontWeight.w500
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}