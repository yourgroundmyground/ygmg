import 'package:app/screens/game/weekly_game.dart';
import 'package:app/widgets/countdown_clock.dart';
import 'package:flutter/material.dart';


class WeeklyGameIntro extends StatelessWidget {
  const WeeklyGameIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: mediaWidth,
        height: mediaHeight,
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/gamemapgj.jpg'),
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: CountDownClock()
            ),
            const SizedBox(height: 15),
            Flexible(
                flex: 5,
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                  width: mediaWidth * 0.8,
                  height: mediaHeight * 0.6,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        //여기에 네비게이터
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => WeeklyGame(),
                            ), (route) => false);
                        
                      },
                      child: Image.asset(
                          'assets/images/resultbutton.png'),
                    ),
                  )
                )
            )
          ],
        ),
      ),
    );
  }
}
