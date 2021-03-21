import 'package:flutter/material.dart';
import 'package:todo_getx/widgets/size_config.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String timer;

  TaskCardWidget({this.title, this.description, this.timer});

  Widget header(String title) {
    return Text(
      title ?? 'Unnamed Title',
      style: TextStyle(
          color: Color(0xFF211551),
          fontSize: SizeConfig.safeBlockHorizontal * 4.2,
          fontWeight: FontWeight.bold),
    );
  }

  Widget bodyDescription(String desc) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.0),
      child: Text(
        desc ?? '(No description added)',
        style: TextStyle(
          color: Color(0xFF86829D),
          fontSize: SizeConfig.safeBlockHorizontal * 4.0,
        ),
      ),
    );
  }

  Widget timerInfo(String timer) {
    return Container(
      child: Text(
        timer,
        style: TextStyle(
            fontSize: SizeConfig.safeBlockHorizontal * 4.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget headerAndTimerInfo(String title, String timer) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [header(title), timerInfo(timer)]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1.0),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.safeBlockVertical * 2.7,
            horizontal: SizeConfig.safeBlockHorizontal * 4.9),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(SizeConfig.safeBlockHorizontal * 2.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerAndTimerInfo(title, timer),
            bodyDescription(description)
          ],
        ));
  }
}
