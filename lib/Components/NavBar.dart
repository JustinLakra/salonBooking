// ignore_for_file: file_names
//nav bar drawer

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../GeneralNotice.dart';
import '../main.dart';
import 'Navigators.dart';
import 'personalNotice.dart';
import 'utils.dart';
import 'package:salon/home/home.dart';
import 'package:salon/home/reviews.dart';
import 'package:salon/home/viewReviews.dart';
import 'package:salon/home/mainPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String? name = FirebaseAuth.instance.currentUser?.displayName == null
        ? "Guest"
        : FirebaseAuth.instance.currentUser!.displayName.toString();
    String email = user!.email != null ? user.email.toString() : "N/A";
    return Drawer(
      backgroundColor: HexColor("#4d4d4d"),
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.black,
              child: ClipOval(
                  child: Image.asset(
                "assets/salonLogo.jpg",
                fit: BoxFit.contain,
                width: 90,
                height: 90,
              )),
            ),
            decoration: BoxDecoration(
              color: HexColor("#080808"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('Home', style: TextStyle(fontFamily: "Open Sans",color: Colors.white)),
            onTap: () => {navigation().navigateToPage(context, const mainPage())
               },
          ),
          /*ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text('Profile', style: TextStyle(fontFamily: "Open Sans",color: Colors.white)),
            onTap: ()
                {if(FirebaseAuth.instance.currentUser!.email != "guest@salon.com"){
                  //navigation().navigateToPage(context, const Profile());
                }
            else{
              Navigator.pop(context);
              Utils.showSnackBar("Please login to view profile");
                  }},
          ),*/
          ExpansionTile(
            leading: const Icon(FontAwesomeIcons.scissors, color: Colors.white),
            title: const Text('Services', style: TextStyle(fontFamily: "Open Sans",color: Colors.white),
          ),
          children: [
          ListTile(
          title: const Text("Male", style: TextStyle(fontFamily: "Open Sans",color: Colors.white)),
          onTap: () {
            if(FirebaseAuth.instance.currentUser!.email != "guest@xavcomsociety.com"){
              navigation().navigateToPage(
                  context, const Home(gender: "male"));
            }
            else{
              Navigator.pop(context);
              Utils.showSnackBar("Please login to book an appointment");
            }

          },
          ),
          ListTile(
          title: const Text('Female', style: TextStyle(fontFamily: "Open Sans",color: Colors.white)),
            onTap: () {
              if(FirebaseAuth.instance.currentUser!.email != "guest@xavcomsociety.com"){
                navigation().navigateToPage(
                    context, const Home(gender: "female"));
              }
              else{
                Navigator.pop(context);
                Utils.showSnackBar("Please login to book an appointment");
              }

            },
          ),
          ],
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.white),
            title: const Text('Notifications',
                style: TextStyle(fontFamily: "Open Sans",color: Colors.white)),
            onTap: (){
              if(FirebaseAuth.instance.currentUser!.email != "guest@xavcomsociety.com"){
                  navigation().navigateToPage(context, const NotificationsPrivate());
              }
              else{
                Navigator.pop(context);
                Utils.showSnackBar("Please login to view notifications");
              }


            },
          ),
          ExpansionTile(
              leading: const Icon(Icons.book_online, color: Colors.white),
              title:
                  const Text('Reviews', style: TextStyle(fontFamily: "Open Sans",color: Colors.white)),
              children: [
                ListTile(
                    title: const Text('Write a Review',
                        style: TextStyle(fontFamily: "Open Sans",color: Colors.white)),
                    onTap: ()  {
                      navigation().navigateToPage(context, ReviewPage());
                        }),
                ListTile(
                    title: const Text('View Reviews',
                        style: TextStyle(fontFamily: "Open Sans",color: Colors.white)),
                    onTap: ()  {
                      navigation().navigateToPage(context, ReviewsViewPage());
                        }),
              ]),
          ListTile(
            title: const Text('Log Out', style: TextStyle(fontFamily: "Open Sans",color: Colors.white)),
            leading: const Icon(Icons.exit_to_app, color: Colors.white),
            onTap: () {
              navigatorKey.currentState!.popUntil((route) => route.isFirst);
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
