import 'package:app/const/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample4 extends StatefulWidget {
  BarChartSample4({super.key});

  final Color dark = YGMG_BEIGE;
  final Color normal = YGMG_ORANGE;

  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {
  int touchedIndex = -1;
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
            final barsSpace = 10.0 * constraints.maxWidth / 400;
            final barsWidth = 30.0 * constraints.maxWidth / 400;
            return BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey,
                    tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                    tooltipMargin: -10,
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
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          barTouchResponse == null ||
                          barTouchResponse.spot == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                    });
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
                      showTitles: true,
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
              BarChartRodStackItem(0, 2, widget.dark),
              BarChartRodStackItem(2, 12, widget.normal),
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
              BarChartRodStackItem(0, 13, widget.dark),
              BarChartRodStackItem(13, 14, widget.normal),
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
              BarChartRodStackItem(0, 3, widget.dark),
              BarChartRodStackItem(3, 10, widget.normal),
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
              BarChartRodStackItem(0, 3, widget.dark),
              BarChartRodStackItem(3, 5, widget.normal),
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
              BarChartRodStackItem(0, 15, widget.dark),
              BarChartRodStackItem(15, 17, widget.normal),
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
              BarChartRodStackItem(0, 11, widget.dark),
              BarChartRodStackItem(11, 20, widget.normal),
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
              BarChartRodStackItem(0, 10, widget.dark),
              BarChartRodStackItem(10, 30, widget.normal),
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
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
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