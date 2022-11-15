// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures, invalid_return_type_for_catch_error, avoid_function_literals_in_foreach_calls
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:http/http.dart';
import '../models/app_user.dart';
import '../utils/constants.dart';

class AppController {

  final firestoreInstance = FirebaseFirestore.instance;

  //SIGN UP
  Future signUpUser(String userName, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential.user?.uid);
      AppUser newUser = AppUser(
        userId: userCredential.user!.uid,
        email: email,
        userName: userName,
        isAdmin: false,
        password: password,
      );
      dynamic resultUser = await newUser.signUpUser(newUser);
      if (resultUser != null) 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['User'] = resultUser;
        Constants.appUser = resultUser;
        await Constants.appUser.saveUserDetails();
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] ="User cannot signup at this time. Try again later";
        return finalResponse;
      }
    } on FirebaseAuthException catch (e) {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        finalResponse['ErrorMessage'] = "No user found for that email";
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        finalResponse['ErrorMessage'] = "Wrong password provided for that user";
      }
      return finalResponse;
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //SIGN IN
  Future signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      print(userCredential.user!.uid);
       AppUser newUser = AppUser(
        userId: userCredential.user!.uid,
        email: email,
        userName: '',
        isAdmin: false,
        password: password,
      );
      dynamic resultUser = await AppUser.getLoggedInUserDetail(newUser);
      if (resultUser != null)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['User'] = resultUser;
        Constants.appUser = resultUser;
        await Constants.appUser.saveUserDetails();
        return finalResponse;
      }
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "User cannot login at this time. Try again later";
        return finalResponse;
      }
    } on FirebaseAuthException catch (e) {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        finalResponse['ErrorMessage'] = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        finalResponse['ErrorMessage'] =
            "The account already exists for that email";
      } else {
        finalResponse['ErrorMessage'] = e.code;
      }
      return finalResponse;
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
  
  //FORGOT PASSWORD
  Future forgotPassword(String email) async {
    try {
      String result = "";
      await FirebaseAuth.instance
      .sendPasswordResetEmail(email: email).then((_) async {
        result = "Success";
      }).catchError((error) {
        result = error.toString();
        print("Failed emailed : $error");
      });

      if (result == "Success") {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } else {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = result;
        return finalResponse;
      }
    } on FirebaseAuthException catch (e) {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      finalResponse['ErrorMessage'] = e.code;
      return finalResponse;
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
  
  //EDIT USER NAME
  Future editUserProfile() async {
    final firestoreInstance = FirebaseFirestore.instance;
    try {
      dynamic result = await firestoreInstance.collection("users").doc(Constants.appUser.userId).update({
        //'cryptos': Constants.appUser.cryptos,
      }).then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return null;
      });

      if (result != null) 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "User profile picture cannot be updated at this time. Try again later";
        return finalResponse;
      }    
    }
    catch (e) {
      print(e.toString());
      return setUpFailure();
    }  
  }

  //SIGN IN
  Future addDonor(String name, String phone, String bloodGroup, String city, File? userPicture) async {
    try {
      //UPLOAD ON FIREBASE
      String userImage1FirebasePath = "";
      if(userPicture != null)
        userImage1FirebasePath = await uploadFile(userPicture);
      
      final firestoreInstance = FirebaseFirestore.instance;
      dynamic result = await firestoreInstance.collection("donors").add({
        'name': name,
        'phone': phone,
        'bloodGroup': bloodGroup,
        'city': city,
        'picture': userImage1FirebasePath,
        'email' : Constants.appUser.email,
        'userId' : Constants.appUser.userId,
        'addedTime' : FieldValue.serverTimestamp()
      }).then((_) async {
        print("success!");
        await AppUser().updateUserProfileToDonor();
        Constants.appUser.isDonor = true;
        await Constants.appUser.saveUserDetails();
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return null;
      });

      if (result != null)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Place cannot be added at this time. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future<String> uploadFile(File uploadImage) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + basename(uploadImage.path);
    final _firebaseStorage = FirebaseStorage.instance;
    //Upload to Firebase
    var snapshot = await _firebaseStorage.ref().child("donor_pictures").child(fileName).putFile(File(uploadImage.path));
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }


  Future getAllDonors(List donorsList) async {
    try {
      dynamic result = await firestoreInstance.collection("donors").get().then((value) {
      value.docs.forEach((result) 
      {
          print(result.data);
          Map donor = result.data();
          donor['donorId'] = result.id;
          if(donor['userId'] != Constants.appUser.userId)
            donorsList.add(donor);
        });
        return true;
      });

      if (result)
      {
        if(donorsList.length>1) //SORT BY TIME
        {
          donorsList.sort((a,b) {
            var adate = a['name'];
            var bdate = b['name'];
            return bdate.compareTo(adate);
          });
        }

        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['DonorsList'] = donorsList;
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

   Future getAllPosts(List posts) async {
    try {
      dynamic result = await firestoreInstance.collection("urgent_post").get().then((value) {
      value.docs.forEach((result) 
      {
          print(result.data);
          Map post = result.data();
          post['postId'] = result.id;
          posts.add(post);
        });
        return true;
      });

      if (result)
      {
        if(posts.length>1) //SORT BY TIME
        {
          posts.sort((a,b) {
            var adate = a['postTime'];
            var bdate = b['postTime'];
            return bdate.compareTo(adate);
          });
        }

        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['Posts'] = posts;
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future getAllMyPosts(List posts) async {
    try {
      dynamic result = await firestoreInstance.collection("urgent_post")
      .where('userId', isEqualTo: Constants.appUser.userId)
      .get().then((value) {
      value.docs.forEach((result) 
      {
          print(result.data);
          Map post = result.data();
          post['postId'] = result.id;
          posts.add(post);
        });
        return true;
      });

      if (result)
      {
        if(posts.length>1) //SORT BY TIME
        {
          posts.sort((a,b) {
            var adate = a['postTime'];
            var bdate = b['postTime'];
            return bdate.compareTo(adate);
          });
        }

        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['Posts'] = posts;
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //POST
  Future postRequest(String description, double latitude, double longitude) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      dynamic result = await firestoreInstance.collection("urgent_post").add({
        'name': Constants.appUser.userName,
        'email' : Constants.appUser.email,
        'latitude' : latitude.toStringAsFixed(3),
        'longitude': longitude.toStringAsFixed(3),
        'description': description,
        'userId' : Constants.appUser.userId,
        'status' : "Pending",
        'postTime' : FieldValue.serverTimestamp()
      }).then((_) async {
        print("success!");
        await AppUser().updateUserProfileToDonor();
        Constants.appUser.isDonor = true;
        await Constants.appUser.saveUserDetails();
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return null;
      });

      if (result != null)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Place cannot be added at this time. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future editPostRequest(Map postDetails, String description, double latitude, double longitude) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      dynamic result = await firestoreInstance.collection("urgent_post")
      .doc(postDetails['postId'])
      .update({
        'latitude' : latitude.toStringAsFixed(3),
        'longitude': longitude.toStringAsFixed(3),
        'description': description,
      }).then((_) async {
        print("success!");
        await AppUser().updateUserProfileToDonor();
        Constants.appUser.isDonor = true;
        await Constants.appUser.saveUserDetails();
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return null;
      });

      if (result != null)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Place cannot be added at this time. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future deleteMyPost(Map postDetail) async {
    try {
      dynamic result = await FirebaseFirestore.instance.collection("urgent_post").
        doc(postDetail['postId']).delete().then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to update: $error");
        return false;
      });

      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Error'] = "Error";
      finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
      return finalResponse;
    }
  }

  //SEARCH
  Future searchDonor(List donorsList, int bloodGroup) async {
    try {
      String bloodType = Constants.bGroups[bloodGroup];
      dynamic result = await firestoreInstance.collection("donors")
      .where('bloodGroup', isEqualTo: bloodType)
      .get().then((value) {
      value.docs.forEach((result) 
      {
          print(result.data);
          Map donor = result.data();
          donor['donorId'] = result.id;
          donorsList.add(donor);
        });
        return true;
      });

      if (result)
      {
        if(donorsList.length>1) //SORT BY TIME
        {
          donorsList.sort((a,b) {
            var adate = a['name'];
            var bdate = b['name'];
            return bdate.compareTo(adate);
          });
        }

        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['DonorsList'] = donorsList;
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  ///COMMENTS EVENTS
  Future getAllPostComments(List allComments, Map postDetail) async {
    try {
      dynamic result = await firestoreInstance.collection("post_comments")
      .where('postId', isEqualTo: postDetail['postId'])
      .get().then((value) {
      value.docs.forEach((result) 
        {
          print(result.data);
          Map taskData = result.data();
          taskData['commentId'] = result.id;
          allComments.add(taskData);
        });
        return true;
      });

      if (result)
      {
        allComments.sort((a, b) => a['commentAddedTime'].toDate().compareTo(b['commentAddedTime'].toDate()));
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future addEventComment(Map postDetail, String eventComment) async {
    try {   
      dynamic result = await firestoreInstance.collection("post_comments").add({
        'postId': postDetail['postId'],
        'postDescription': postDetail['description'],
        'userComment' : eventComment,
        'userEmail': Constants.appUser.email,
        'userId': Constants.appUser.userId,
        'userImage': Constants.appUser.userPicture,
        'userName': Constants.appUser.userName,
        'commentAddedTime' : FieldValue.serverTimestamp()
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future reportComment(Map commentDetail, String reportReaon) async {
    try {   
      dynamic result = await firestoreInstance.collection("reported_posts").add({
        'postId': commentDetail['postId'],
        'postDescription': commentDetail['description'],
        'userEmail' : commentDetail['email'],
        'userId': commentDetail['userId'],
        'userName': commentDetail['name'],
        'reportedById': Constants.appUser.userId,
        'reportedByEmail': Constants.appUser.email,
        'reportedReason': reportReaon,
        'reportedCommentTime' : FieldValue.serverTimestamp()
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future addPostRatingForUser(Map postDetail, double rating ,String review, Map userDetail) async {
    try {   
      dynamic result = await firestoreInstance.collection("user_post_reviews").add({
        'postId': postDetail['postId'],
        'postDescription': postDetail['description'],
        'userComment' : userDetail['userComment'],
        'userEmail': userDetail['userEmail'],
        'userId': userDetail['userId'],
        'userName': userDetail['userName'],
        'reviewAddedTime' : FieldValue.serverTimestamp(),
        'rating' : rating,
        'review' : review,
        'reviewAddedByName' : Constants.appUser.userName
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future getAllMyReviews(List allReviews, String userId) async {
    try {
      dynamic result = await firestoreInstance.collection("user_post_reviews")
      .where('userId', isEqualTo: userId)
      .get().then((value) {
      value.docs.forEach((result) 
        {
          print(result.data);
          Map taskData = result.data();
          taskData['commentId'] = result.id;
          allReviews.add(taskData);
        });
        return true;
      });

      if (result)
      {
        allReviews.sort((a, b) => a['reviewAddedTime'].toDate().compareTo(b['reviewAddedTime'].toDate()));
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future sendChatNotificationToUser(AppUser user) async {
    try {
      Map<String, String> requestHeaders = {
        "Content-type": "application/json", 
        "Authorization" : "Basic ${Constants.oneSignalRestKey}"
      };

      //if(user.oneSignalUserId.isEmpty)
      user = await AppUser.getUserDetailByUserId(user.userId);
      var url = 'https://onesignal.com/api/v1/notifications';
      final Uri _uri = Uri.parse(url);
      //String json = '{ "include_player_ids" : ["${user.oneSignalUserID}"], "app_id" : "${Constants.oneSignalId}", "small_icon" : "app_icon", "headings" : {"en" : "New Message"}, "contents" : {"en" : "You have a message from ${Constants.appUser.fullName}"}, "data" : { "userID" : "${Constants.appUser.userID}" } }';
      String json = '{ "include_player_ids" : ["${user.oneSignalUserId}"] ,"app_id" : "${Constants.oneSignalId}", "small_icon" : "app_icon", "headings" : {"en" : "New Request"},"contents" : {"en" : "You have received a request message from ${Constants.appUser.userName}"}}';
      Response response = await post(_uri, headers: requestHeaders, body: json);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    
      if (response.statusCode == 200) {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } else {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server at this time. Please try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
  
  Map setUpFailure() {
    Map finalResponse = <dynamic, dynamic>{}; //empty map
    finalResponse['Status'] = "Error";
    finalResponse['ErrorMessage'] = "Please try again later. Server is busy.";
    return finalResponse;
  }
}
