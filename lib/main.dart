import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = -1;
  late List<G7DebtData> _g7DebtData;

  @override
  void initState() {
    _g7DebtData = [
      G7DebtData(
          'USA', 123.3, 133.9, 10.6, const Color.fromARGB(255, 24, 109, 255)),
      G7DebtData(
          'UK', 104.3, 110.1, 5.8, const Color.fromARGB(255, 187, 0, 255)),
      G7DebtData(
          'Italy', 139.2, 144.9, 5.7, const Color.fromARGB(255, 40, 255, 133)),
      G7DebtData(
          'France', 111.6, 115.2, 3.6, const Color.fromARGB(255, 39, 194, 255)),
      G7DebtData(
          'Japan', 254.6, 251.7, -2.9, const Color.fromARGB(255, 255, 38, 89)),
      G7DebtData(
          'Germany', 63.7, 57.7, -6.0, const Color.fromARGB(255, 153, 255, 1)),
      G7DebtData(
          'Canada', 104.3, 95.4, -9.3, const Color.fromARGB(255, 255, 33, 33)),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCartesianChart(
        title: ChartTitle(
          text: 'G7 Government Debt Projections (2024-2029)',
          textStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        primaryXAxis: CategoryAxis(
          isVisible: false,
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: 'Percentage Point Change 2024 to 2029'),
          labelAlignment: LabelAlignment.center,
          plotOffsetEnd: 10,
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(width: 0),
          majorGridLines: MajorGridLines(width: 0.5, color: Colors.grey),
          minimum: -14,
          maximum: 14,
          opposedPosition: true,
        ),
        plotAreaBorderWidth: 0,
        annotations: <CartesianChartAnnotation>[
          CartesianChartAnnotation(
            widget: Container(
              height: 100,
              width: 320,
              decoration: BoxDecoration(
                  color: ThemeData().canvasColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.black)),
              alignment: Alignment.center,
              child: Text(
                'Each bar shows the projected change in \ngovernment debt (% of GDP) from 2024 to 2029.\nBars above zero indicate an increase in debt, \nwhile those below zero show a decrease.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            x: 670,
            y: 120,
            coordinateUnit: CoordinateUnit.logicalPixel,
          ),
        ],
        tooltipBehavior: TooltipBehavior(
          enable: true,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            final G7DebtData debtData = data;
            final Color darkSegmentColor =
                Color.lerp(debtData.segmentColor, Colors.black, 0.70)!;
            final Color lightSegmentColor =
                Color.lerp(debtData.segmentColor, Colors.white, 0.60)!;
            return Container(
              width: 155,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: lightSegmentColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: darkSegmentColor),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: darkSegmentColor, width: 2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.asset(
                            'Image/${debtData.country}.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          debtData.country,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: darkSegmentColor),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      color: darkSegmentColor,
                      thickness: 1,
                      height: 10,
                      indent: 5,
                      endIndent: 5),
                  ...[
                    'Debt in 2024: ${debtData.year2024Debt.round()}%',
                    'Debt in 2029: ${debtData.year2029Debt.round()}%',
                    'Difference: ${(debtData.percentageChange).round()}pp',
                  ].map(
                    (text) => Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: darkSegmentColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        series: [
          RangeColumnSeries<G7DebtData, String>(
            width: 0.6,
            dataSource: _g7DebtData,
            xValueMapper: (G7DebtData data, int index) => data.country,
            lowValueMapper: (G7DebtData data, int index) =>
                data.percentageChange > 0 ? 0 : data.percentageChange,
            highValueMapper: (G7DebtData data, int index) =>
                data.percentageChange > 0 ? data.percentageChange : 0,
            pointColorMapper: (G7DebtData data, int index) => data.segmentColor,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                final bool isDifferentIndex = pointIndex != index;
                index = pointIndex;

                final Widget content = isDifferentIndex
                    ? Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Image.asset(
                          'Image/${data.country}.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Text(
                        '${data.country}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      );

                return Padding(
                  padding: EdgeInsets.only(
                      bottom: isDifferentIndex ? 50 : 0,
                      top: isDifferentIndex ? 0 : 50),
                  child: content,
                );
              },
            ),
            onCreateRenderer: (series) {
              return _CustomRangeColumnSeriesRenderer();
            },
          ),
        ],
      ),
    );
  }
}

class _CustomRangeColumnSeriesRenderer
    extends RangeColumnSeriesRenderer<G7DebtData, String> {
  _CustomRangeColumnSeriesRenderer();

  @override
  RangeColumnSegment<G7DebtData, String> createSegment() {
    return _RangeColumnCustomPainter();
  }
}

class _RangeColumnCustomPainter extends RangeColumnSegment<G7DebtData, String> {
  _RangeColumnCustomPainter();

  void paintText(Canvas canvas, String text, Offset position, double fontSize,
      {bool isCenter = false, Color baseColor = Colors.black}) {
    final TextSpan span = TextSpan(
      style: TextStyle(
        color:
            isCenter ? Color.lerp(baseColor, Colors.black, 0.50)! : baseColor,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
      text: text,
    );
    final TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas,
        Offset(position.dx - tp.width / 2, position.dy - tp.height / 2));
  }

  void drawCustomCircle(Canvas canvas, Offset center, double radius,
      Paint fillPaint, Paint strokePaint) {
    canvas.drawCircle(center, radius, fillPaint);
    canvas.drawCircle(center, radius - 1, strokePaint);
  }

  @override
  void onPaint(Canvas canvas) {
    if (segmentRect == null) return;

    final double center = segmentRect!.center.dx;
    final double top = segmentRect!.top;
    final double bottom = segmentRect!.bottom;
    final segment = series.dataSource![currentSegmentIndex];
    final double centerText = segment.percentageChange;

    final bool isPositiveChange = centerText > 0;
    final double topText =
        isPositiveChange ? segment.year2029Debt : segment.year2024Debt;
    final double bottomText =
        isPositiveChange ? segment.year2024Debt : segment.year2029Debt;

    final Paint customPaint = Paint()
      ..color = Color.lerp(fillPaint.color, Colors.white, 0.40)!
      ..style = PaintingStyle.fill;

    final Gradient gradient = LinearGradient(
      colors: [fillPaint.color, customPaint.color],
      begin: isPositiveChange ? Alignment.bottomCenter : Alignment.topCenter,
      end: isPositiveChange ? Alignment.topCenter : Alignment.bottomCenter,
    );

    final Paint gradientPaint = Paint()
      ..shader = gradient.createShader(segmentRect!.outerRect);

    final Paint strokePaint = Paint()
      ..color = fillPaint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRRect(segmentRect!, gradientPaint);

    drawCustomCircle(canvas, Offset(center, top), segmentRect!.width / 2,
        isPositiveChange ? customPaint : fillPaint, strokePaint);
    drawCustomCircle(canvas, Offset(center, bottom), segmentRect!.width / 2,
        isPositiveChange ? fillPaint : customPaint, strokePaint);

    paintText(canvas, '${topText.round()}%', Offset(center, top), 20);
    paintText(canvas, '${bottomText.round()}%', Offset(center, bottom), 20);

    if (centerText.abs() > 5) {
      paintText(
        canvas,
        '${centerText >= 0 ? '+' : ''}${centerText.round()}pp',
        segmentRect!.center,
        25,
        isCenter: true,
        baseColor: fillPaint.color,
      );
    }
  }
}

class G7DebtData {
  G7DebtData(this.country, this.year2024Debt, this.year2029Debt,
      this.percentageChange, this.segmentColor);
  final String country;
  final double year2024Debt;
  final double year2029Debt;
  final double percentageChange;
  final Color segmentColor;
}
