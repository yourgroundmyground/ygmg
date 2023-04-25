import 'package:flutter/material.dart';

class InGame extends StatelessWidget {
  const InGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Column(
                    children: [
                      Text('시간모달'),
                      Text('차지면적')
                    ],
                  ),
                ),
                SizedBox(
                  child: Column(
                    children: [
                      Text('실시간 순위')
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.pink,
                  child: Icon(Icons.stop),
                  onPressed: (){},
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}
