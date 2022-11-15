// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../controllers/app_controller.dart';
import '../../helpers/user_view.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class MyReviews extends StatefulWidget {

  final String userId;
  const MyReviews({Key? key, required this.userId}) : super(key: key);

  @override
  State<MyReviews> createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
 
  List allReviews = [];
  TextEditingController commentField = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllMyReviews();
  }

  void getAllMyReviews()async{
    allReviews.clear();
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await AppController().getAllMyReviews(allReviews, widget.userId);
    EasyLoading.dismiss();
    if(result['Status'] == 'Success')
    {
     setState(() {
       print(allReviews.length);
     });
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
          'Reviews',
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
              child: (allReviews.isEmpty) ? Container(
                margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*5, left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
                child: Center(
                  child: Text(
                    'No Reviews',
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
                    itemCount: allReviews.length,
                    itemBuilder: (_, i) {
                      return commentCell(allReviews[i], i);
                    },
                    shrinkWrap: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commentCell(dynamic commentDetail, int index){
    return GestureDetector(
      onTap: (){
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingBar.builder(
                          initialRating: commentDetail['rating'],
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ignoreGestures: true,
                          itemSize: SizeConfig.blockSizeHorizontal*5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 3),
                      child: Text(
                        commentDetail['review'],
                        style: TextStyle(
                          fontSize: SizeConfig.fontSize*1.7,
                          color: Colors.grey[500]!
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        child: Text(
                          '${commentDetail['reviewAddedByName']}',
                          style: TextStyle(
                            fontSize: SizeConfig.fontSize*1.4,
                            color: Constants.appThemeColor,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            )
          ]
        ),
      )
    );
  }
}