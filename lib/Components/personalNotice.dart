//a flutter widget that displays all elements of a list stored in a firebase collection named Notifications in a document with the Name Notifications in a field named Notifications which has a type of array using future builder and list tiles
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'NavBar.dart';
import 'mapread.dart';
class NotificationsPrivate extends StatefulWidget {
  const NotificationsPrivate({super.key});

  @override
  State<NotificationsPrivate> createState() => _NotificationsPrivateState();
}

class _NotificationsPrivateState extends State<NotificationsPrivate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('#111111'),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("NOTIFICATIONS",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: HexColor('#ffffff')),),
        ),
        drawer: const NavBar(),
        body: FutureBuilder(
            future: FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData)
              {
                final event = snapshot.data!;
                if(event['Notifications'].isEmpty)
                {
                  return const Center(child: Text("No Notifications", style: TextStyle(color: Colors.white, fontSize: 25),),);
                }
                return MapListWidget(dataMap: event['Notifications']);
              }
              else{
                return const Center(child: CircularProgressIndicator());
              }
            })
    );
  }
}
