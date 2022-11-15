
// ignore_for_file: prefer_const_constructors
import 'package:blood_donor/models/app_user.dart';
import 'package:blood_donor/screens/add_donor/add_donor.dart';
import 'package:blood_donor/screens/chat_screen/chat_screen.dart';
import 'package:blood_donor/screens/urgent_post/urgent_post.dart';
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

class DonorsListOld extends StatefulWidget {
  const DonorsListOld({ Key? key }) : super(key: key);

  @override
  State<DonorsListOld> createState() => _DonorsListState();
}

class _DonorsListState extends State<DonorsListOld> {

  List donorsList = [];
  //Feature
  int currentIndex = 0;
  SwiperController swiperController = SwiperController();
  List banners = [];

  @override
  void initState() {
    super.initState();
    //getAllDonors();
    getAllPosts();
  }

  void getAllDonors() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().getAllDonors(donorsList);
    EasyLoading.dismiss();     
    
    if (result['Status'] == "Success") 
    {
      setState(() {
        donorsList = result['DonorsList'];
        getAllPosts();
      });
    } 
    else {
      //Fail Cases Show String
      Constants.showDialog(result['ErrorMessage'],);
    }
  }

  void getAllPosts() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().getAllPosts(banners);
    EasyLoading.dismiss();     
    
    if (result['Status'] == "Success") 
    {
      setState(() {
        banners = result['Posts'];
        banners = banners;
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
        centerTitle: true,
        title: Text(
          'All Posts',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*2, SizeConfig.blockSizeVertical*0, SizeConfig.blockSizeHorizontal*2, SizeConfig.blockSizeVertical*2),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: banners.length,
            itemBuilder: (context, index){
              return featuredAdView(banners[index]);
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(UrgentPost());
        },
        backgroundColor: Constants.appThemeColor,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget featuredAdView(Map post){
    return GestureDetector(
      onTap: (){
        AppUser user = AppUser(userId: post['userId'], email: post['email'], userName: post['name']);
        Get.to(ChatScreen(chatUser: user));
      },
      child: Container(
        height: SizeConfig.blockSizeVertical*23,
        margin: EdgeInsets.only(left: 10, right: 10, top: SizeConfig.blockSizeVertical*3),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*7, vertical: SizeConfig.blockSizeVertical*2),
        decoration: BoxDecoration(
          color: Constants.appThemeColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(),
            Text(
              post['description'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: SizeConfig.fontSize * 2.0,
                color: Colors.white,
                fontWeight: FontWeight.w500
              ),
            ),
            Text(
              'By ${post['name']}',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: SizeConfig.fontSize * 1.5,
                color: Colors.white,
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }
}