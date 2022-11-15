// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../helpers/user_view.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class PostHelperSelection extends StatefulWidget {

  final Map postDetails;
  const PostHelperSelection({ Key? key, required this.postDetails }) : super(key: key);

  @override
  State<PostHelperSelection> createState() => _PostHelperSelectionState();
}

class _PostHelperSelectionState extends State<PostHelperSelection> {
  
  List allPostComments = [];
  int selectedUser = -1;

  @override
  void initState() {
    super.initState();
    getAllEventComments();
  }

  void getAllEventComments()async{
    allPostComments.clear();
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await AppController().getAllPostComments(allPostComments, widget.postDetails);
    EasyLoading.dismiss();
    if(result['Status'] == 'Success')
    {
     setState(() {
       print(allPostComments.length);
     });
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
  }

  void showUserRatingDialog() {
    TextEditingController feedback = TextEditingController();
    double userRating = 5;

    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Center(child: Text('Rate User')),
        content: Container(
          width: SizeConfig.blockSizeHorizontal*90,
          child: MediaQuery.removePadding(
            removeTop: true,
            removeBottom: true,
            context: context,
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: RatingBar.builder(
                    initialRating: userRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                      userRating = rating;
                    },
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey[400]!
                    )
                  ),
                  child: Center(
                    child: TextField(
                      controller: feedback,
                      minLines: 1,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Any feedback',
                        border: InputBorder.none
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel')
          ),
          TextButton(
            onPressed: () {
              Get.back();
              enterUserPostRating(userRating,feedback.text);
              //loadUserSelectionScreen(postDetail, index);
            },
            child: Text('Submit')
          )
        ],
      )
    );
  } 

  Future<void> enterUserPostRating(double rating, String review) async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await AppController().addPostRatingForUser(widget.postDetails, rating, review, allPostComments[selectedUser]);
    EasyLoading.dismiss();
    if(result['Status'] == 'Success')
    {
      Get.back(result: true);
      Constants.showDialog('Your review has been added successfully');
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
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
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          'Select Helper User',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
                        
            Expanded(
              child: (allPostComments.isEmpty) ? Container(
                margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*5, left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
                child: Center(
                  child: Text(
                    'No Comments',
                    style: TextStyle(
                      fontSize: SizeConfig.fontSize*2.2,
                      color: Colors.grey[400]!
                    ),
                  ),
                ),
              ): Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1.5, left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: allPostComments.length,
                    itemBuilder: (_, i) {
                      return userCell(allPostComments[i], i);
                    },
                    shrinkWrap: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: SizeConfig.blockSizeVertical * 7,
        margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 3, left: 30, right: 30, top: SizeConfig.blockSizeVertical * 2),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Constants.appThemeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            )
          ),
          onPressed: (){
            if(selectedUser == -1)
              Constants.showDialog('Please select a user to rate');
            else
              showUserRatingDialog();
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Rate',
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

  Widget userCell(dynamic commentDetail, int index){
    return GestureDetector(
      onTap: (){
        setState(() {
          if(selectedUser != index)
            selectedUser = index;
          else
            selectedUser = -1;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*4, vertical: SizeConfig.blockSizeVertical*1.5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!,
              width: 0.5
            )
          )
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*2),
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
              child: Container(
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2, top: SizeConfig.blockSizeVertical*0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          commentDetail['userName'],
                          style: TextStyle(
                            fontSize: SizeConfig.fontSize*1.8,
                            color: Colors.black
                          ),
                        ),                        
                      ],
                    ),
                  ],
                ),
              )
            ),
            GestureDetector(
              onTap: () async {
                // EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
                // dynamic userData = await AppUser.getDonorDetailByUserId(commentDetail['userId']);
                // EasyLoading.dismiss();
                // userProfileView(userData);
              },
              child: Icon((selectedUser == index) ?  Icons.check_circle : Icons.check_circle_outline_outlined, size: SizeConfig.blockSizeVertical*3, color: (selectedUser == index) ? Constants.appThemeColor : Colors.grey[400],)
            )
          ]
        ),
      )
    );
  }
}