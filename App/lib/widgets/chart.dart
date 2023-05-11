import 'package:app/const/colors.dart';
import 'package:app/screens/mypage/running_detail.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RunningChart extends StatefulWidget {
  final List<Map<String, dynamic>> runningList;

  const RunningChart({
    required this.runningList,
    Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RunningChartState();
}

class RunningChartState extends State<RunningChart> {
  Map<String, List<int>> groupingDay = {};
  int touchedIndex = -1;
  String weekDay = '';


  // 요일을 가져오는 함수
  String getDayOfWeek(String dateString) {
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
    return DateFormat('EEEE').format(dateTime);
  }

  // 요일별로 그룹핑하는 함수
  void groupRunningIdsByDayOfWeek(List<Map<String, dynamic>> runningList) {
    Map<String, List<int>> result = {};

    for (Map<String, dynamic> item in runningList) {
      String dayOfWeek = getDayOfWeek(item['runningDate']);

      if (!result.containsKey(dayOfWeek)) {
        result[dayOfWeek] = [];
      }

      result[dayOfWeek]!.add(item['runningId']);
    }

    setState(() {
      groupingDay = result;
    });
  }

  final testList = [
    {
      "runningDate": "2023-05-08",
      "runningDistance": 1.2,
      "runningId": 0,
      "runningType": "RUNNING"
    },
    {
      "runningDate": "2023-05-09",
      "runningDistance": 3,
      "runningId": 1,
      "runningType": "RUNNING"
    },
    {
      "runningDate": "2023-05-10",
      "runningDistance": 2,
      "runningId": 2,
      "runningType": "RUNNING"
    },
    {
      "runningDate": "2023-05-08",
      "runningDistance": 1.5,
      "runningId": 3,
      "runningType": "RUNNING"
    },
    {
      "runningDate": "2023-05-08",
      "runningDistance": 4,
      "runningId": 4,
      "runningType": "GAME"
    },
    {
      "runningDate": "2023-05-09",
      "runningDistance": 3.2,
      "runningId": 5,
      "runningType": "GAME"
    },
    {
      "runningDate": "2023-05-10",
      "runningDistance": 4,
      "runningId": 6,
      "runningType": "RUNNING"
    },
    {
      "runningDate": "2023-05-11",
      "runningDistance": 5,
      "runningId": 7,
      "runningType": "GAME"
    },
  ];

  @override
  void initState() {
    // groupRunningIdsByDayOfWeek(widget.runningList);
    groupRunningIdsByDayOfWeek(testList);
    super.initState();
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 18,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barsSpace = 25.0 * constraints.maxWidth / 400;
            final barsWidth = 30.0 * constraints.maxWidth / 400;
            return BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(
                  touchExtraThreshold: EdgeInsets.symmetric(vertical: 100),
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey,
                    tooltipHorizontalAlignment: FLHorizontalAlignment.center,
                    tooltipMargin: 0,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String weekDay;
                      switch (group.x) {
                        case 0:
                          weekDay = 'Monday';
                          break;
                        case 1:
                          weekDay = 'Tuesday';
                          break;
                        case 2:
                          weekDay = 'Wednesday';
                          break;
                        case 3:
                          weekDay = 'Thursday';
                          break;
                        case 4:
                          weekDay = 'Friday';
                          break;
                        case 5:
                          weekDay = 'Saturday';
                          break;
                        case 6:
                          weekDay = 'Sunday';
                          break;
                        default:
                          throw Error();
                      }
                      return BarTooltipItem(
                        '$weekDay\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: (rod.toY - 1).toString(),
                            style: TextStyle(
                              color: YGMG_YELLOW,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  touchCallback: (FlTouchEvent event, BarTouchResponse? barTouchResponse) {
                    if (event is FlLongPressEnd && barTouchResponse != null && barTouchResponse.spot != null) {
                      switch (barTouchResponse.spot!.touchedBarGroupIndex) {
                        case 0:
                          weekDay = 'Monday';
                          break;
                        case 1:
                          weekDay = 'Tuesday';
                          break;
                        case 2:
                          weekDay = 'Wednesday';
                          break;
                        case 3:
                          weekDay = 'Thursday';
                          break;
                        case 4:
                          weekDay = 'Friday';
                          break;
                        case 5:
                          weekDay = 'Saturday';
                          break;
                        case 6:
                          weekDay = 'Sunday';
                          break;
                        default:
                          throw Error();
                      }
                      if (groupingDay[weekDay]!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                              RunningDetail(
                                weekDay: weekDay,
                                runningIds: groupingDay[weekDay]!,
                                // value: (barTouchResponse.spot.y - 1).toString(),
                              ),
                          ),
                        );
                      }
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: getTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 40,
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 10 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white,
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                groupsSpace: barsSpace,
                barGroups: getData(barsWidth, barsSpace),
              ),
            );
          },
        ),
      ),
    );
  }
  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 12,
            rodStackItems: [
              BarChartRodStackItem(0, 2, YGMG_BEIGE),
              BarChartRodStackItem(2, 12, YGMG_ORANGE),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ]
      ),
      BarChartGroupData(
          x: 1,
          barsSpace: barsSpace,
          barRods: [
          BarChartRodData(
            toY: 14,
            rodStackItems: [
              BarChartRodStackItem(0, 13, YGMG_BEIGE),
              BarChartRodStackItem(13, 14, YGMG_ORANGE),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          ]
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 10,
            rodStackItems: [
              BarChartRodStackItem(0, 3, YGMG_BEIGE),
              BarChartRodStackItem(3, 10, YGMG_ORANGE),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          ]
      ),
      BarChartGroupData(
          x: 3,
          barsSpace: barsSpace,
          barRods: [
          BarChartRodData(
            toY: 5,
            rodStackItems: [
              BarChartRodStackItem(0, 3, YGMG_BEIGE),
              BarChartRodStackItem(3, 5, YGMG_ORANGE),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          ]
      ),
      BarChartGroupData(
        x: 4,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 17,
            rodStackItems: [
              BarChartRodStackItem(0, 15, YGMG_BEIGE),
              BarChartRodStackItem(15, 17, YGMG_ORANGE),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ]
      ),
      BarChartGroupData(
          x: 5,
          barsSpace: barsSpace,
          barRods: [
          BarChartRodData(
            toY: 20,
            rodStackItems: [
              BarChartRodStackItem(0, 11, YGMG_BEIGE),
              BarChartRodStackItem(11, 20, YGMG_ORANGE),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          ]
      ),
      BarChartGroupData(
          x: 6,
          barsSpace: barsSpace,
          barRods: [
          BarChartRodData(
            toY: 30,
            rodStackItems: [
              BarChartRodStackItem(0, 10, YGMG_BEIGE),
              BarChartRodStackItem(10, 30, YGMG_ORANGE),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
    ];
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Mon', style: style);
        break;
      case 1:
        text = const Text('Tue', style: style);
        break;
      case 2:
        text = const Text('Wed', style: style);
        break;
      case 3:
        text = const Text('Thr', style: style);
        break;
      case 4:
        text = const Text('Fri', style: style);
        break;
      case 5:
        text = const Text('Sat', style: style);
        break;
      case 6:
        text = const Text('Sun', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}