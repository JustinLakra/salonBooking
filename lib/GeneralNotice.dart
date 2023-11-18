//a flutter widget that displays all elements of a list stored in a firebase collection named Notifications in a document with the Name Notifications in a field named Notifications which has a type of array using future builder and list tiles
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:salon/Components/mapread.dart';

import 'Components/NavBar.dart';
class NotificationsGeneral extends StatefulWidget {
  const NotificationsGeneral({super.key});

  @override
  State<NotificationsGeneral> createState() => _NotificationsGeneralState();
}

class _NotificationsGeneralState extends State<NotificationsGeneral> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('#111111'),
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text("ANNOUNCEMENTS",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: HexColor('#ffffff')),),
        ),
      drawer: const NavBar(),
      body: FutureBuilder(
                future: FirebaseFirestore.instance.collection("Notifications").doc("Notifications").get(),
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
                        return const Center(child: Text("No Announcements", style: TextStyle(color: Colors.white, fontSize: 25),),);
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
