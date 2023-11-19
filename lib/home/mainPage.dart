import 'package:flutter/material.dart';
import 'package:salon/Components/NavBar.dart';

class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 65,
          title: const Text(
            "SALON 33",
            style: TextStyle(
              fontFamily: "Open Sans",
              fontSize: 40,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
      ),
      drawer: const NavBar(),
      body: Container(
        child: const Column(
          children: [
            Text('Welcome to the main page')
          ],
        ),
      ),
    );
  }
}
