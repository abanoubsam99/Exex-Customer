import 'dart:math' as math;

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class MyExpandable extends StatelessWidget {
  const MyExpandable({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ScrollOnExpand(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ExpandablePanel(
                  theme: ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToExpand: true,
                    tapBodyToCollapse: true,
                    hasIcon: false,
                  ),
                  header: Container(
                    color: Colors.indigoAccent,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          ExpandableIcon(
                            theme: ExpandableThemeData(
                              expandIcon: Icons.arrow_right,
                              collapseIcon: Icons.arrow_downward,
                              iconColor: Colors.white,
                              iconSize: 28,
                              iconRotationAngle: math.pi / 2,
                              iconPadding: EdgeInsets.only(right: 5),
                              hasIcon: false,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Items",
                              style: TextStyle(color: Colors.amber),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  collapsed: SizedBox(),
                  expanded: Text("Hello"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
