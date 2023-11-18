// This file contains the custom app bar used in the website
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
   final Size preferredSize =
      const Size.fromHeight(65); // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      toolbarHeight: 65,
      title: SizedBox(
        height: kToolbarHeight,
        child:  Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Image.asset("images/appbar.png"),
        ),
      ),
      centerTitle: true,

    );
  }
}
