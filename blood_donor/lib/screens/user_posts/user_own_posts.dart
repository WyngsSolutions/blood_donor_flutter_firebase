// ignore_for_file: prefer_const_constructors
import 'package:blood_donor/screens/urgent_post/urgent_post.dart';
import 'package:blood_donor/screens/user_posts/post_location.dart';
import 'package:blood_donor/utils/constants.dart';
import 'package:blood_donor/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../urgent_post/edit_urgent_post.dart';
import 'post_comments.dart';
import 'post_helper_selection.dart';

class UserOwnPostsScreen extends StatefulWidget {
  const UserOwnPostsScreen({Key? key}) : super(key: key);

  @override
  State<UserOwnPostsScreen> createState() => _UserOwnPostsScreenState();
}

class _UserOwnPostsScreenState extends State<UserOwnPostsScreen> {
 
  List posts = [];

  @override
  void initState() {
    super.initState();
    getAllPosts();
  }

  void getAllPosts() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().getAllMyPosts(posts);
    EasyLoading.dismiss();     
    
    if (result['Status'] == "Success") 
    {
      setState(() {
        posts = result['Posts'];
      });
    } 
    else
    {
      Constants.showDialog(result['ErrorMessage'],);
    }
  }

  void showUserHelpDialog(Map postDetail, int index) {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text('Close Post'),
        content: Text('Did anyone of the post commented users help?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              deleteUserPost(postDetail, index);
            },
            child: Text('No')
          ),
          TextButton(
            onPressed: () {
              Get.back();
              loadUserSelectionScreen(postDetail, index);
            },
            child: Text('Yes')
          )
        ],
      )
    );
  } 

  void loadUserSelectionScreen (Map postDetail, int index) async {
    dynamic result = await Get.to(PostHelperSelection(postDetails: postDetail,));
  }

  void deleteUserPost(Map postDetail, int index) async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().deleteMyPost(postDetail);
    EasyLoading.dismiss();     
    if (result['Status'] == "Success") 
    {
      setState(() {
        posts.removeAt(index);
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
          'My Posts',
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
            'No Posts Yet',
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
                Container(
                  child: Icon(Icons.share, color: Constants.appThemeColor, size : SizeConfig.blockSizeVertical*3),
                ),
                GestureDetector(
                  onTap: (){
                    showUserHelpDialog(postData, index);
                  },
                  child: Container(
                    child: Icon(Icons.delete_outline, color: Constants.appThemeColor, size : SizeConfig.blockSizeVertical*3),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    dynamic result = await Get.to(EditUrgentPost(postDetail: postData,));
                    if(result != null)
                      getAllPosts();
                  },
                  child: Container(
                    child: Icon(Icons.edit, color: Constants.appThemeColor, size : SizeConfig.blockSizeVertical*3),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}