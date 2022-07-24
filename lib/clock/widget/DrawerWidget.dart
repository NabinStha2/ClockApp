import 'package:clock_app/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[800],
        child: ListView(
          shrinkWrap: true,
          dragStartBehavior: DragStartBehavior.start,
          children: [
            Container(
              // color: Colors.red,
              alignment: Alignment.center,
              child: DrawerHeader(
                decoration: BoxDecoration(),
                child: Text(
                  "Clock",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.aclonica().fontFamily,
                    fontSize: 30.0,
                  ),
                ),
                padding: EdgeInsets.only(
                  top: 70,
                  left: 10,
                ),
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Material(
              color: Colors.white.withOpacity(0.01),
              child: ListTile(
                title: Text(
                  "Home",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.aclonica().fontFamily,
                    fontSize: 16.0,
                  ),
                ),
                leading: Icon(
                  Icons.alarm,
                  color: Colors.white,
                ),
                selected: homePageState!.selectedTile == "Home",
                selectedTileColor: Colors.black26,
                onTap: () {
                  // setState(() {
                  //   selectedTile = "Home";
                  //   index = 0;
                  // });
                  homePageState!.setState(() {
                    homePageState!.selectedTile = "Home";
                    homePageState!.index = 0;
                  });
                  Navigator.of(context).pop();
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) => ClockView()),
                  // );
                },
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Material(
              color: Colors.white.withOpacity(0.01),
              child: ListTile(
                title: Text(
                  "Alarm",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.aclonica().fontFamily,
                    fontSize: 16.0,
                  ),
                ),
                leading: Icon(
                  Icons.alarm,
                  color: Colors.white,
                ),
                selected: homePageState?.selectedTile == "Alarm",
                selectedTileColor: Colors.black26,
                onTap: () {
                  homePageState?.setState(() {
                    homePageState?.selectedTile = "Alarm";
                    homePageState?.index = 1;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
            // ),
            Divider(
              color: Colors.white,
            ),
            Material(
              color: Colors.white.withOpacity(0.01),
              child: ListTile(
                title: Text(
                  "Timer",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.aclonica().fontFamily,
                    fontSize: 16.0,
                  ),
                ),
                leading: Icon(
                  Icons.timelapse,
                  color: Colors.white,
                ),
                selected: homePageState?.selectedTile == "Timer",
                selectedTileColor: Colors.black26,
                onTap: () {
                  homePageState?.setState(() {
                    homePageState?.selectedTile = "Timer";
                    homePageState?.index = 2;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Material(
              color: Colors.white.withOpacity(0.01),
              child: ListTile(
                title: Text(
                  "StopWatch",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.aclonica().fontFamily,
                    fontSize: 16.0,
                  ),
                ),
                leading: Icon(
                  Icons.timer,
                  color: Colors.white,
                ),
                selected: homePageState?.selectedTile == "StopWatch",
                selectedTileColor: Colors.black26,
                onTap: () {
                  homePageState?.setState(() {
                    homePageState?.selectedTile = "StopWatch";
                    homePageState?.index = 3;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
            Divider(
              color: Colors.white,
            ),
          ],
          physics: BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
