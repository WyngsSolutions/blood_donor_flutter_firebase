// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers
import 'package:blood_donor/utils/constants.dart';
import 'package:blood_donor/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/app_controller.dart';
import '../../helpers/user_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({ Key? key }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  
  List donorsList = [];
  List filterDonorsList = [];

  int bloodGroup = 0;

  @override
  void initState() {
    super.initState();
  }


  ///******* UTIL METHOD ****************///
  void userProfileView(Map personDetail)async
  {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc){
        return UserDetailView(personDetail : personDetail);
      }
    );
  }

  void searchDonor() async {
    donorsList.clear();
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().searchDonor(donorsList, bloodGroup);
    EasyLoading.dismiss();     
    if (result['Status'] == "Success") 
    {
      setState(() {
        donorsList = result['DonorsList'];
        filterDonorsList = List.from(donorsList);
      });
    } 
    else {
      //Fail Cases Show String
      Constants.showDialog(result['ErrorMessage'],);
    }
  }

  void showFilterDialog() {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              width: SizeConfig.blockSizeHorizontal*80,
              margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
              child: MediaQuery.removePadding(
                removeTop: true,
                removeBottom: true,
                context: context,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: Icon(Icons.close)
                      )
                    ),
              
                    Container(
                      child: Center(
                        child: Text(
                          'Filters',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: SizeConfig.fontSize* 2.2,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
              
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2, bottom: SizeConfig.blockSizeVertical*2),
                      child: Text(
                        'Blood group',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          color: Color(0XFFA5A5A5),
                          fontSize: SizeConfig.fontSize* 2,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Radio(value: 0, groupValue: bloodGroup, onChanged: (val){
                          setState((){
                            bloodGroup = 0;
                          });
                        }),
                        Container(
                          child: Text(
                            'A+',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: SizeConfig.fontSize* 1.8,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Radio(value: 1, groupValue: bloodGroup, onChanged: (val){
                          setState((){
                            bloodGroup = 1;
                          });
                        }),
                        Container(
                          child: Text(
                            'A-',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: SizeConfig.fontSize* 1.8,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Radio(value: 2, groupValue: bloodGroup, onChanged: (val){
                          setState((){
                            bloodGroup = 2;
                          });
                        }),
                        Container(
                          child: Text(
                            'B+',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: SizeConfig.fontSize* 1.8,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Radio(value: 3, groupValue: bloodGroup, onChanged: (val){
                          setState((){
                            bloodGroup = 3;
                          });
                        }),
                        Container(
                          child: Text(
                            'B-',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: SizeConfig.fontSize* 1.8,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(value: 4, groupValue: bloodGroup, onChanged: (val){
                          setState((){
                            bloodGroup = 4;
                          });
                        }),
                        Container(
                          child: Text(
                            'O+',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: SizeConfig.fontSize* 1.8,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Radio(value: 5, groupValue: bloodGroup, onChanged: (val){
                          setState((){
                            bloodGroup = 5;
                          });
                        }),
                        Container(
                          child: Text(
                            '0-',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: SizeConfig.fontSize* 1.8,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Radio(value: 6, groupValue: bloodGroup, onChanged: (val){
                          setState((){
                            bloodGroup = 6;
                          });
                        }),
                        Container(
                          child: Text(
                            'AB+',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: SizeConfig.fontSize* 1.8,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Radio(value: 7, groupValue: bloodGroup, onChanged: (val){
                          setState((){
                            bloodGroup = 7;
                          });
                        }),
                        Container(
                          child: Text(
                            'AB-',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: SizeConfig.fontSize* 1.8,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: (){
                        Get.back();
                        searchDonor();
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical* 0, left: SizeConfig.blockSizeHorizontal * 2, right: SizeConfig.blockSizeHorizontal * 2, top:  SizeConfig.blockSizeVertical* 5),
                        height: SizeConfig.blockSizeVertical * 6,
                        decoration: BoxDecoration(
                          color: Constants.appThemeColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Apply Filter',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: SizeConfig.fontSize* 1.8,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
            
                  ],
                ),
              ),
            )
          );
        }
      )
    );
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*4, SizeConfig.blockSizeVertical*2, SizeConfig.blockSizeHorizontal*4,0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: SizeConfig.blockSizeVertical * 6,
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
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (val){
                              setState(() {
                                filterDonorsList = donorsList.where((element) => element['name'].toString().toLowerCase().contains(val)).toList();
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search....',
                              prefixIcon: Icon(Icons.search, color: Colors.grey,),
                              border: InputBorder.none
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: showFilterDialog,
                      child: Container(
                        margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2),
                        width: SizeConfig.blockSizeVertical*6,
                        height: SizeConfig.blockSizeVertical*6,
                        decoration: BoxDecoration(
                          color: Constants.appThemeColor,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Icon(Icons.filter_list_outlined, color: Colors.white, size: SizeConfig.blockSizeVertical*3.5,),
                      ),
                    )
                  ],
                ),
              ),
              
              (filterDonorsList.isEmpty) ? Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2, left: SizeConfig.blockSizeHorizontal*2),
                  child: Center(
                    child: Text(
                      'No Donors Found',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 1.8,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ) : 
              Expanded(
                child: Container(
                  child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filterDonorsList.length,
                  itemBuilder: (context, index){
                    return donorCell(filterDonorsList[index], index);
                  }
                ),
              ),
            ),
          ],
        )
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
}