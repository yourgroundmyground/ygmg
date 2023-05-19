import 'package:app/const/colors.dart';
import 'package:app/screens/mypage/running_detail.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RunningChart extends StatefulWidget {
  final List<dynamic> runningList;

  const RunningChart({
    required this.runningList,
    Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RunningChartState();
}

class RunningChartState extends State<RunningChart> {
  List<Map<String, dynamic>> receiveRunningList = [];
  Map<String, Map<String, double>> chartGrouping = {};
  Map<String, List<int>> detailGrouping = {};
  int touchedIndex = -1;
  String weekDay = '';


  // 요일을 가져오는 함수
  String getDayOfWeek(String dateString) {
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
    return DateFormat('EEEE').format(dateTime);
  }

  // 이번 주에 포함되는 데이터 필터링
  List<dynamic> filterDataByCurrentWeek(List<dynamic> runningList) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - DateTime.monday +1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    return runningList.where((item) {
      DateTime runningDate = DateFormat('yyyy-MM-dd').parse(item['runningDate']);
      return runningDate.isAfter(startOfWeek) &&
          runningDate.isBefore(endOfWeek) &&
          runningDate.year == now.year &&
          runningDate.month == now.month;
    }).toList();
  }

  // 데이터 그룹화
  void groupData(List<dynamic> runningList) {
    Map<String, Map<String, double>> result = {};

    for (Map<String, dynamic> item in runningList) {
      String dayOfWeek = getDayOfWeek(item['runningDate']);
      String runningType = item['runningType'];
      double runningDistance = item['runningDistance'].toDouble();

      if (!result.containsKey(dayOfWeek)) {
        result[dayOfWeek] = {};
      }

      result[dayOfWeek]![runningType] ??= 0.0;
      result[dayOfWeek]![runningType] = (result[dayOfWeek]![runningType] ?? 0.0) + runningDistance;
    }

    setState(() {
      chartGrouping = result;
    });
  }

  // 요일별로 그룹핑하는 함수
  void groupRunningIdsByDayOfWeek(List<dynamic> runningList) {
    Map<String, List<int>> result = {};

    for (Map<String, dynamic> item in runningList) {
      String dayOfWeek = getDayOfWeek(item['runningDate']);

      if (!result.containsKey(dayOfWeek)) {
        result[dayOfWeek] = [];
      }

      result[dayOfWeek]!.add(item['runningId']);
    }

    setState(() {
      detailGrouping = result;
    });
  }

  @override
  void initState() {
    List<dynamic> filteredList = filterDataByCurrentWeek(widget.runningList);
    groupData(filteredList);
    groupRunningIdsByDayOfWeek(filteredList);
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
                            text: (rod.toY).toStringAsFixed(1),
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
                      if (detailGrouping[weekDay]!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                              RunningDetail(
                                weekDay: weekDay,
                                runningIds: detailGrouping[weekDay]!,
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
            toY: (chartGrouping['Monday']?['RUNNING'] ?? 0) + (chartGrouping['Monday']?['GAME'] ?? 0),
            rodStackItems: [
              BarChartRodStackItem(0, chartGrouping['Monday']?['RUNNING'] ?? 0, YGMG_BEIGE),
              BarChartRodStackItem(chartGrouping['Monday']?['RUNNING'] ?? 0, (chartGrouping['Monday']?['RUNNING'] ?? 0) + (chartGrouping['Monday']?['GAME'] ?? 0), YGMG_ORANGE),
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
            toY: (chartGrouping['Tuesday']?['RUNNING'] ?? 0) + (chartGrouping['Tuesday']?['GAME'] ?? 0),
            rodStackItems: [
              BarChartRodStackItem(0, chartGrouping['Tuesday']?['RUNNING'] ?? 0, YGMG_BEIGE),
              BarChartRodStackItem(chartGrouping['Tuesday']?['RUNNING'] ?? 0, (chartGrouping['Tuesday']?['RUNNING'] ?? 0) + (chartGrouping['Tuesday']?['GAME'] ?? 0), YGMG_ORANGE),
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
            toY: (chartGrouping['Wednesday']?['RUNNING'] ?? 0) + (chartGrouping['Wednesday']?['GAME'] ?? 0),
            rodStackItems: [
              BarChartRodStackItem(0, chartGrouping['Wednesday']?['RUNNING'] ?? 0, YGMG_BEIGE),
              BarChartRodStackItem(chartGrouping['Wednesday']?['RUNNING'] ?? 0, (chartGrouping['Wednesday']?['RUNNING'] ?? 0) + (chartGrouping['Wednesday']?['GAME'] ?? 0), YGMG_ORANGE),
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
              toY: (chartGrouping['Thursday']?['RUNNING'] ?? 0) + (chartGrouping['Thursday']?['GAME'] ?? 0),
              rodStackItems: [
                BarChartRodStackItem(0, chartGrouping['Thursday']?['RUNNING'] ?? 0, YGMG_BEIGE),
                BarChartRodStackItem(chartGrouping['Thursday']?['RUNNING'] ?? 0, (chartGrouping['Thursday']?['RUNNING'] ?? 0) + (chartGrouping['Thursday']?['GAME'] ?? 0), YGMG_ORANGE),
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
            toY: (chartGrouping['Friday']?['RUNNING'] ?? 0) + (chartGrouping['Friday']?['GAME'] ?? 0),
            rodStackItems: [
              BarChartRodStackItem(0, chartGrouping['Friday']?['RUNNING'] ?? 0, YGMG_BEIGE),
              BarChartRodStackItem(chartGrouping['Friday']?['RUNNING'] ?? 0, (chartGrouping['Friday']?['RUNNING'] ?? 0) + (chartGrouping['Friday']?['GAME'] ?? 0), YGMG_ORANGE),
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
            toY: (chartGrouping['Saturday']?['RUNNING'] ?? 0) + (chartGrouping['Saturday']?['GAME'] ?? 0),
            rodStackItems: [
              BarChartRodStackItem(0, chartGrouping['Saturday']?['RUNNING'] ?? 0, YGMG_BEIGE),
              BarChartRodStackItem(chartGrouping['Saturday']?['RUNNING'] ?? 0, (chartGrouping['Saturday']?['RUNNING'] ?? 0) + (chartGrouping['Saturday']?['GAME'] ?? 0), YGMG_ORANGE),
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
            toY: (chartGrouping['Sunday']?['RUNNING'] ?? 0) + (chartGrouping['Sunday']?['GAME'] ?? 0),
            rodStackItems: [
              BarChartRodStackItem(0, chartGrouping['Sunday']?['RUNNING'] ?? 0, YGMG_BEIGE),
              BarChartRodStackItem(chartGrouping['Sunday']?['RUNNING'] ?? 0, (chartGrouping['Sunday']?['RUNNING'] ?? 0) + (chartGrouping['Sunday']?['GAME'] ?? 0), YGMG_ORANGE),
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