// ignore_for_file: prefer_const_constructors
import 'package:blood_donor/models/app_user.dart';
import 'package:blood_donor/screens/chat_screen/chat_screen.dart';
import 'package:blood_donor/screens/my_reviews/my_reviews.dart';
import 'package:blood_donor/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';

class UserDetailView extends StatefulWidget {

  final Map personDetail;
  const UserDetailView({ Key? key, required this.personDetail}) : super(key: key);

  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  
  late AppUser userDetail;

  @override
  void initState() {
    super.initState();
    userDetail = AppUser();
    userDetail.userId = widget.personDetail['userId'];
    userDetail.userName = widget.personDetail['name'];
    userDetail.userPicture = widget.personDetail['picture'];
    userDetail.oneSignalUserId = '';
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical*40,
      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50)
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*3),
              height: SizeConfig.blockSizeVertical*10,
              width: SizeConfig.blockSizeVertical*10,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: (widget.personDetail['picture'].isEmpty) ? AssetImage('assets/user_bg.png') : CachedNetworkImageProvider(widget.personDetail['picture']) as ImageProvider,
                  fit: BoxFit.cover
                )
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1),
            child: Center(
              child: Text(
                '${widget.personDetail['name']}',
                textAlign: TextAlign.start,
                maxLines: 2,
                style: TextStyle(
                  fontSize: SizeConfig.fontSize * 2.2,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*0.3),
            child: Center(
              child: Text(
                '${widget.personDetail['city']}',
                textAlign: TextAlign.start,
                maxLines: 2,
                style: TextStyle(
                  fontSize: SizeConfig.fontSize * 1.8,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          
          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1),
            child: Center(
              child: Text(
                '${widget.personDetail['bloodGroup']}',
                textAlign: TextAlign.start,
                maxLines: 2,
                style: TextStyle(
                  fontSize: SizeConfig.fontSize * 6,
                  color: Constants.appThemeColor,
                ),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    launchUrl(Uri.parse('tel://${widget.personDetail['phone']}'));
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Constants.appThemeColor,
                      shape: BoxShape.circle
                    ),
                    child: Icon(Icons.call, size: SizeConfig.blockSizeVertical*3, color: Colors.white,),
                  ),
                ),                
                SizedBox(width: SizeConfig.blockSizeHorizontal*4,),
                GestureDetector(
                  onTap: (){
                    Get.back();
                    Get.to(ChatScreen(chatUser: userDetail,));
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Constants.appThemeColor,
                      shape: BoxShape.circle
                    ),
                    child: Icon(Icons.mail, size: SizeConfig.blockSizeVertical*3, color: Colors.white,),
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal*4,),
                GestureDetector(
                  onTap: (){
                    Get.to(MyReviews(userId: userDetail.userId,));
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Constants.appThemeColor,
                      shape: BoxShape.circle
                    ),
                    child: Icon(Icons.star, size: SizeConfig.blockSizeVertical*3.1, color: Colors.white,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}