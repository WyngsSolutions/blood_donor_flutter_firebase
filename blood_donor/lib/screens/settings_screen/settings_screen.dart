// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures
import 'dart:io';
import 'package:blood_donor/models/app_user.dart';
import 'package:blood_donor/screens/delete_account/delete_account.dart';
import 'package:blood_donor/screens/my_reviews/my_reviews.dart';
import 'package:blood_donor/screens/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../home_screen/home_screen.dart';
import '../urgent_post/urgent_post.dart';
import '../user_posts/user_own_posts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({ Key? key }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text('Settings', style: TextStyle(color: Colors.white, fontSize: SizeConfig.fontSize*2.2),),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*5, vertical: SizeConfig.blockSizeVertical*1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            listCell('My Post', Icons.list_alt, 1),
            if(Constants.appUser.isDonor)
            listCell('My Reviews', Icons.star, 7),
            listCell('Contact Us', Icons.call, 2),
            listCell('Privacy Policy', Icons.policy_rounded, 3),
            listCell('Share app', Icons.share, 4),
            listCell('Delete account', Icons.delete_outline, 5),
            listCell('Logout', Icons.logout, 6),
          ],
        ),
      ),
    );
  }

  Widget listCell(String title, IconData icon, int listId){
    return GestureDetector(
      onTap: (){
        if(listId == 1)
          Get.to(UserOwnPostsScreen());

        if(listId == 2)
          launchUrl(Uri.parse('http://wyngslogistics.com/'));
        
        if(listId == 3)
          launchUrl(Uri.parse('http://wyngslogistics.com/#/policy'));

        if(listId == 4)
          Share.share('Get KV Donors App\n${(Platform.isIOS) ? Constants.iosAppLink : Constants.androidAppLink}');

        if(listId == 5)
          Get.to(DeleteAccount());

        if(listId == 6)
        {
          AppUser.deleteUserAndOtherPreferences();
          Get.offAll(SignInScreen());
        }

        if(listId == 7)
          Get.to(MyReviews(userId: Constants.appUser.userId,));
      },
      child: Container(
        height: SizeConfig.blockSizeVertical*8,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black,
              width: 0.2
            )
          )
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: SizeConfig.blockSizeVertical*3,
              color: Colors.black.withOpacity(0.7),
            ),
            Container(
              margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.fontSize*1.8,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}