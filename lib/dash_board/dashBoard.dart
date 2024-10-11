import 'package:flutter/material.dart';
import 'package:tlbilling/dash_board/uploaded_statements.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Center(
                  child: Text('Dashboard Sections'),
                )),
                SizedBox(width: 16),
                Expanded(
                  child: Center(child: UploadedStatements()),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
