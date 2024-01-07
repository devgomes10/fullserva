import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

import 'appointment_point.dart';

class LineChartAppointment extends StatelessWidget {
  final List<AppointmentPoint> points;

  const LineChartAppointment(this.points, {super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
                isCurved: true,
                dotData: FlDotData(show: true),
                barWidth: 6,
                belowBarData: BarAreaData(
                  show: true,
                ),
              ),
            ],
            minX: 0,
            maxX: 11,
            minY: 0,
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    String text = '';
                    switch (value.toInt()) {
                      case 0:
                        text = 'Jan';
                        break;
                      case 1:
                        text = 'Fev';
                        break;
                      case 2:
                        text = 'Mar';
                        break;
                      case 3:
                        text = 'Abr';
                        break;
                      case 4:
                        text = 'Mai';
                        break;
                      case 5:
                        text = 'Jun';
                        break;
                      case 6:
                        text = 'Jul';
                        break;
                      case 7:
                        text = 'Ago';
                        break;
                      case 8:
                        text = 'Set';
                        break;
                      case 9:
                        text = 'Out';
                        break;
                      case 10:
                        text = 'Nov';
                        break;
                      case 11:
                        text = 'Dez';
                        break;
                    }
                    return Text(text);
                  },
                ),
              ),
              topTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: false,
              )),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
            ),
            gridData: const FlGridData(
              show: false,
            ),
            borderData: FlBorderData(
              show: false,
            )),
      ),
    );
  }
}
