import 'package:flutter/material.dart';
import 'package:todo_getx/widgets/size_config.dart';

class SensorData extends StatelessWidget {
  final String title;
  final String data;

  SensorData({this.title, this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.safeBlockVertical * 1,
          horizontal: SizeConfig.safeBlockHorizontal * 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title == null ? "Untitled" : title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockHorizontal * 4.2,
                color: Colors.black87),
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical * 1.0,
          ),
          Text(
            data == null ? "Undetected" : data,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockHorizontal * 4.1,
                color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
