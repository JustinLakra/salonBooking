import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MapListWidget extends StatelessWidget {
  final Map<String, dynamic> dataMap;

  const MapListWidget({super.key, required this.dataMap});

  @override
  Widget build(BuildContext context) {
    final reversedEntries = dataMap.entries.toList().reversed;
     return ListView(
      children: reversedEntries.map((entry) {
        return ListTile(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          tileColor: HexColor('#4d4d4d'),
          textColor: HexColor('#ffffff'),
          title: Text(entry.key.replaceAll("forbidden_character_period", '.')),
          subtitle: Text(  "~" + entry.value.toString(),textAlign: TextAlign.end,),
        );
      }).toList(),
    );
  }
}