// ignore_for_file: prefer_const_constructors
import 'package:blood_donor/screens/add_donor/add_donor.dart';
import 'package:blood_donor/screens/urgent_post/urgent_post.dart';
import 'package:blood_donor/screens/user_posts/post_location.dart';
import 'package:blood_donor/utils/constants.dart';
import 'package:blood_donor/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import '../../controllers/app_controller.dart';
import '../../helpers/user_view.dart';
import '../urgent_post/post_location.dart';
import 'post_comments.dart';

class UserPostsScreen extends StatefulWidget {
  const UserPostsScreen({Key? key}) : super(key: key);

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen> {
 
  List posts = [];

  @override
  void initState() {
    super.initState();
    getAllPosts();
  }

  void getAllPosts() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().getAllPosts(posts);
    EasyLoading.dismiss();     
    
    if (result['Status'] == "Success") 
    {
      setState(() {
        posts = result['Posts'];
      });
    } 
    else {
      //Fail Cases Show String
      Constants.showDialog(result['ErrorMessage'],);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      backgroundColor: Constants.appThemeColor,
        title: Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
    body: Container(
      margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*5, SizeConfig.blockSizeVertical*0, SizeConfig.blockSizeHorizontal*5, SizeConfig.blockSizeVertical*2),
      child: (posts.isNotEmpty) ? ListView.builder(
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (context, index){
          return postCell(posts[index], index);
        }
      ) : Center(
          child: Text(
            'No Posts Found',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: SizeConfig.fontSize*2
            ),
          ),
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

   Widget postCell(Map postData, int index){
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
      padding: EdgeInsets.symmetric(horizontal:SizeConfig.blockSizeHorizontal*2, vertical: SizeConfig.blockSizeHorizontal*2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*3),
                height: SizeConfig.blockSizeVertical*6,
                width: SizeConfig.blockSizeVertical*6,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/user_bg.png'),
                    fit: BoxFit.cover
                  )
                ),
              ),
              Expanded(
                child: Text(
                  postData['name'],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: SizeConfig.fontSize * 1.8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.to(UserPostLocation(eventDetail: postData,));
                      },
                      child: Icon(Icons.location_on, color: Constants.appThemeColor, size : SizeConfig.blockSizeVertical*3)),
                  ],
                ),
              ),
            ],
          ),

          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
            child: Text(
              postData['description'],
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: SizeConfig.fontSize * 2.0,
                color: Colors.black,
                fontWeight: FontWeight.w500
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1),
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1
                )
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (){
                    Get.to(PostComments(postDetails: postData,));
                  },
                  child: Container(
                    child: Icon(Icons.comment, color: Constants.appThemeColor, size : SizeConfig.blockSizeVertical*3),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Share.share(postData['description']);
                  },
                  child: Container(
                    child: Icon(Icons.share, color: Constants.appThemeColor, size : SizeConfig.blockSizeVertical*3),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    showReportView(postData);
                  },
                  child: Container(
                    child: Icon(Icons.report_gmailerrorred_outlined, color: Constants.appThemeColor, size : SizeConfig.blockSizeVertical*3),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///******* UTIL METHOD ****************///
  void showReportView(Map commentDetail)async
  {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*7, vertical: SizeConfig.blockSizeVertical*3),
          height: SizeConfig.blockSizeVertical*52,
          decoration: BoxDecoration(
            color: Constants.appThemeColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40)
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Report Comment To Admin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.fontSize * 2.3,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
                child: Text(
                  'Let the admin know what\'s wrong with this post. Your details will be kept anonymous for this report',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: SizeConfig.fontSize * 1.8,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),

              GestureDetector(
                onTap: (){
                  Get.back();
                  AppController().reportComment(commentDetail, 'Other');
                  Constants.showDialog('You have reported the comment to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
                  height: SizeConfig.blockSizeVertical*5.5,
                  width: SizeConfig.blockSizeHorizontal*80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Spam',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                        color: Constants.appThemeColor,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                  AppController().reportComment(commentDetail, 'Harassment');
                  Constants.showDialog('You have reported the comment to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
                  height: SizeConfig.blockSizeVertical*5.5,
                  width: SizeConfig.blockSizeHorizontal*80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Harassment',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                        color: Constants.appThemeColor,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                  AppController().reportComment(commentDetail, 'Hate Speech');
                  Constants.showDialog('You have reported the comment to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
                  height: SizeConfig.blockSizeVertical*5.5,
                  width: SizeConfig.blockSizeHorizontal*80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Hate Speech',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                        color: Constants.appThemeColor,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                  AppController().reportComment(commentDetail, 'Other');
                  Constants.showDialog('You have reported the comment to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
                  height: SizeConfig.blockSizeVertical*5.5,
                  width: SizeConfig.blockSizeHorizontal*80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Other',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                        color: Constants.appThemeColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}