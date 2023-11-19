import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';


import '../Components/NavBar.dart';
import '../Components/Navigators.dart';
import '../Components/utils.dart';

class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  final List<String> images = [
    "https://img.freepik.com/free-photo/young-man-barbershop-trimming-hair_1303-26256.jpg?w=996&t=st=1700427583~exp=1700428183~hmac=fd998e0b62fb42ba7a8c036154d53dded8ed316e5aa6dfcf605a455a9572fb0e",
    "https://img.freepik.com/free-photo/female-hairdresser-using-hairbrush-hair-dryer_329181-1929.jpg?w=996&t=st=1700427610~exp=1700428210~hmac=a791f1942313fdfc42a893582696c40a48b667371d0d1cbfc046cf5728190b34",
    "https://img.freepik.com/free-photo/client-doing-hair-cut-barber-shop-salon_1303-20710.jpg?w=996&t=st=1700427637~exp=1700428237~hmac=4d0c0b62af7b20edd6332449e047650b9be8d2c4b2657502431deec6f805cda4",
    "https://img.freepik.com/free-photo/beautician-with-brush-applies-white-moisturizing-mask-face-young-girl-client-spa-beauty-salon_343596-4247.jpg?w=996&t=st=1700427676~exp=1700428276~hmac=bb0492633c5622d54bca78974007e22dcebcebf514dd33cdbbe8b0b5b0275d39",
    //"https://firebasestorage.googleapis.com/v0/b/xcode-xcs.appspot.com/o/GD.jpeg.jpg?alt=media&token=fc2d83e7-fe80-40d0-8159-6239bf115aca",
    //"https://firebasestorage.googleapis.com/v0/b/xcode-xcs.appspot.com/o/Board%20Game.JPG?alt=media&token=48a4df2d-abce-4c69-81fd-2c7f7bd69710",
  ];
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _stopTimer();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.jumpToPage(
        _currentPage,
      );
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 65,
            title: const Text(
              "SHADOWZ",
              style: TextStyle(
                fontFamily: "Open Sans",
                fontSize: 40,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
        ),
        drawer: const NavBar(),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: ListView(
              scrollDirection: Axis.vertical,
              primary: true,
              padding: const EdgeInsets.only(top: 0),
              children: [
                SizedBox(
                  height: width < 800
                      ? 0.00 * MediaQuery.of(context).size.height
                      : 0,
                ),
                SizedBox(
                  height: width < 800 ? 0.6 * height : 0.8 * height,
                  // Adjust the height according to your needs
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      PageView.builder(
                        physics: const ScrollPhysics(),
                        controller: _pageController,
                        itemCount: images.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.network(
                            images[index],
                            fit: BoxFit.cover,
                          )
                              .animate()
                              .scale(
                              duration: const Duration(milliseconds: 500),
                              begin: const Offset(1.25, 1.25))
                              .fadeIn();
                        },
                        onPageChanged: (int index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                      ),
                      Positioned(
                        bottom: 10.0,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(images.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                _pageController.jumpToPage(index);
                              },
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  shape: BoxShape.circle,
                                  color: _currentPage == index
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                /*Padding(
                   padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                   child: Center(
                       child: ElevatedButton(
                     onPressed: () {
                       if (FirebaseAuth.instance.currentUser!.email !=
                           "guest@xavcomsociety.com") {
                         //click to open link in browser
                         launchUrl(Uri.parse( "https://tinyurl.com/Inductions-2023"), mode: LaunchMode.externalApplication);
                       } else {
                         Utils.showSnackBar(
                             "Please login to register for events.");
                       }
                     },
                         style:  ElevatedButton.styleFrom(
                           backgroundColor: HexColor("#565656"),
                         ),
                     child: const Text(
                       "REGISTER FOR INDUCTIONS '23",
                       textAlign: TextAlign.center,
                       style: TextStyle(
                         fontFamily: "Open Sans",
                         letterSpacing: 1,
                         color: Colors.white,
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),
                     )
                   )),
                 ),
                 SizedBox(height: MediaQuery.of(context).size.height * 0.025),*/
                const Padding(
                  padding: EdgeInsets.only(left: 2.0, right: 2.0),
                  child: Center(
                      child: Text(
                        "Welcome to SHADOWS: Your Gateway to Effortless Elegance!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Open Sans",
                          letterSpacing: 1,
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                        child: const Text(
                          """ 
Discover a world where beauty meets convenience, where your perfect style is just a tap away. Experience seamless bookings, expert advice, and exclusive offers. Join us Dear Thaparites on this journey to redefine your beauty experience. 
Open:Monday-Sunday 11am - 8:30pm""",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Open Sans",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ).animate().fadeIn(
                            duration: const Duration(milliseconds: 700))),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                const SizedBox(height: 20),
              ]),
        ));
  }
}