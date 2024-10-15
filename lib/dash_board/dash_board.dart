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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                'Dashboard Sections',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(width: 16),
            UploadedStatements(),
          ],
        ),
      ),
    );
  }
}
