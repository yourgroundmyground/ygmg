import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/bottomnavbar.dart';
import 'package:app/utils/map.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData{
  ChartData(this.x, this.y1, this.y2, this.y3, this.y4);
  final String x;
  final String y1;
  final String y2;
  final String y3;
  final String y4;
}
class Mypage extends StatelessWidget {
  const Mypage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('China', 12, 10, 14, 20),
      ChartData('USA', 14, 11, 18, 23),
      ChartData('UK', 16, 10, 15, 20),
      ChartData('Brazil', 18, 16, 18, 24)
    ];
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // 닉네임
    var nickname = '달려달려';
    // 결과

    return  Scaffold(
      // appBar: AppBar(title: Text('마이페이지')),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            image : DecorationImage(
              image : AssetImage('assets/images/mypage-bg.png'),
              fit : BoxFit.fitWidth,
              alignment: Alignment.topLeft,
              repeat: ImageRepeat.noRepeat
            )
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                  width: double.infinity,
                    height: mediaWidth*0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 252, 99, 99),
                          Color.fromRGBO(255, 66, 41, 1.0),
                        ]
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),
                  Positioned(
                    top: mediaHeight*0.12,
                    child: Container(
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            '안녕하세요, ${nickname} 님!',
                            style: TextStyle(
                                fontSize: mediaWidth*0.04,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(255, 255, 255, 1)
                            ),
                          )),
                    ),
                  ),
                  Positioned(
                    left: mediaWidth*0.05,
                    top: mediaHeight*0.1,
                    child: Container(
                      width: mediaWidth*0.2,
                      height: mediaWidth*0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFFBCA92),
                                Color(0xFFEF7EC2)
                              ]
                          ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: const Offset(0,4),
                        )
                      ]
                    ),
                      child: Image.asset('assets/images/testProfile.png'),
                  )),
                  Positioned(
                    right: mediaWidth*0.05,
                    top: mediaHeight*0.125,
                    child: Container(
                      child: Image.asset('assets/images/Gear.png'),
                  )),
                  Positioned(
                    left: mediaWidth*0.05,
                    top: mediaHeight*0.03,
                    // margin: EdgeInsets.fromLTRB(mediaWidth*0.5, mediaHeight*0.1, 0, mediaHeight*0.1),
                    child: Text('마이페이지', style: TextStyle(
                        fontSize: mediaWidth*0.07,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                    ),),
                  ),
                ],
              ),
              Container(
                width: mediaWidth*0.9,
                height: mediaWidth*0.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(mediaWidth*0.08),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      // spreadRadius: 7,
                      blurRadius: 28,
                      // offset: Offset(0, 7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(23, 19, 23, 19),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('주간 결과', style: TextStyle(
                          fontSize: mediaWidth*0.04,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Container(
                          child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              series: <ChartSeries>[
                                StackedColumnSeries<ChartData, String>(
                                    groupName: 'Group A',
                                    dataSource: chartData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y1
                                ),
                                StackedColumnSeries<ChartData, String>(
                                    groupName: 'Group B',
                                    dataSource: chartData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y2
                                ),
                                StackedColumnSeries<ChartData, String>(
                                    groupName: 'Group A',
                                    dataSource: chartData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y3
                                ),
                                StackedColumnSeries<ChartData, String>(
                                    groupName: 'Group B',
                                    dataSource: chartData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y4
                                )
                              ]
                          )
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: mediaWidth*0.9,
                height: mediaWidth*0.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(mediaWidth*0.08),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      // spreadRadius: 7,
                      blurRadius: 28,
                      // offset: Offset(0, 7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(23, 19, 23, 19),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('주간 결과', style: TextStyle(
                          fontSize: mediaWidth*0.04,
                          fontWeight: FontWeight.w600
                      ),),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar:  MapSample(),
    );

  }

}
