import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'bar_data.dart';
import 'package:digital_wellbeing/service/format_time.dart';

class MyBarGraph extends StatelessWidget {
  final List<double> weeklySummary;

  const MyBarGraph({Key? key, required this.weeklySummary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Find the maximum value in the weeklySummary list
    double max = weeklySummary.reduce((value, element) => value > element ? value : element);

    // Add 1000 to the maximum value to set maxY
    double maxY = max + 1000;

    BarData myBarData = BarData(
      sun: weeklySummary[0],
      mon: weeklySummary[1],
      tue: weeklySummary[2],
      wed: weeklySummary[3],
      thu: weeklySummary[4],
      fri: weeklySummary[5],
      sat: weeklySummary[6],
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: -8,
            getTooltipColor: (_) => Theme.of(context).colorScheme.primary.withOpacity(0.05),
            tooltipHorizontalAlignment: FLHorizontalAlignment.center,
    getTooltipItem: (group, groupIndex, rod, rodIndex) {
    String weekDay;
    switch (group.x) {
    case 0:
      weekDay = 'Sunday';
      break;
    case 1:
    weekDay = 'Monday';
    break;
    case 2:
    weekDay = 'Tuesday';
    break;
    case 3:
    weekDay = 'Wednesday';
    break;
    case 4:
    weekDay = 'Thursday';
    break;
    case 5:
    weekDay = 'Friday';
    break;
    case 6:
    weekDay = 'Saturday';
    break;
    default:
    throw Error();
    }
    return BarTooltipItem(
    '$weekDay\n', TextStyle(
    color: Theme.of(context).colorScheme.primary,
    fontWeight: FontWeight.normal,
    fontSize: 16,
    ),
    children: <TextSpan>[
    TextSpan(
    text: formatTime(rod.toY.toInt()),
    style: const TextStyle(
    color: Colors.black87, //widget.touchedBarColor,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    ),
    ),
    ],
    );
    },
          ),
        ),
        maxY: maxY,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        barGroups: myBarData.barData.map((data) {
          return BarChartGroupData(
            x: data.x,
            barRods: [
              BarChartRodData(
                toY: data.y,
                color: Theme.of(context).colorScheme.primary,
                width: 26,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY, // Set a default value for the back draw rod
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('S', style: style);
      break;
    case 1:
      text = const Text('M', style: style);
      break;
    case 2:
      text = const Text('T', style: style);
      break;
    case 3:
      text = const Text('W', style: style);
      break;
    case 4:
      text = const Text('T', style: style);
      break;
    case 5:
      text = const Text('F', style: style);
      break;
    case 6:
      text = const Text('S', style: style);
      break;
    default:
      text = const Text('');
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
