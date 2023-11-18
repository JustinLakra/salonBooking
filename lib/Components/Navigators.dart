// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class navigation
{
  Future<void> navigateToPage(context , Widget page) async {
    Navigator.push(
        context,
        PageTransition(
          child:  page,
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 1000),
        ));
  }
}