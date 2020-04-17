import 'dart:math';

import 'package:app_covid_dash/covid/index.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'widgets/listtile-estado.dart';

class VisaoGeralScreen extends StatefulWidget {
  const VisaoGeralScreen({
    Key key,
  }) : super(key: key);

  @override
  VisaoGeralScreenState createState() {
    return VisaoGeralScreenState();
  }
}

class VisaoGeralScreenState extends State<VisaoGeralScreen> {
  CovidBloc _covidBloc;
  @override
  void initState() {
    _covidBloc = BlocProvider.of<CovidBloc>(context);
    _covidBloc.add(LoadDataCovid());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CovidBloc, CovidState>(
      condition: (current, prev) => current is DataCovidLoaded,
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: false,
                delegate: AppBarHead(
                  letalidade:
                      (state as DataCovidLoaded).countryModel.totalLetalidade,
                  totalCases:
                      (state as DataCovidLoaded).countryModel.totalConfirmado,
                  totalDeaths:
                      (state as DataCovidLoaded).countryModel.totalObitos,
                ),
              ),
              SliverFixedExtentList(
                  itemExtent: 150.0,
                  delegate: SliverChildBuilderDelegate((context, index) {
                    var estado = (state as DataCovidLoaded).states[index];
                    var countryModel = (state as DataCovidLoaded).countryModel;
                    return ListTileEstado(
                      casos: estado.qtdConfirmado,
                      estado: estado.nome,
                      mortes: estado.qtdObito,
                      total: int.parse(
                          countryModel.totalConfirmado.replaceAll('.', '')),
                      ranking: index + 1,
                    );
                  }, childCount: (state as DataCovidLoaded).states.length)),
            ],
          ),
        );
      },
    );
  }
}

class AppBarHead extends SliverPersistentHeaderDelegate {
  final String totalCases;
  final String totalDeaths;

  final String letalidade;

  AppBarHead({this.totalCases, this.letalidade, this.totalDeaths});

  double scrollAnimationValue(double shrinkOffset) {
    double maxScrollAllowed = maxExtent - minExtent;
    return ((maxScrollAllowed - shrinkOffset) / maxScrollAllowed)
        .clamp(0, 1)
        .toDouble();
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double visibleMainHeight = max(maxExtent - shrinkOffset, minExtent);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        height: visibleMainHeight,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(33),
                      bottomRight: Radius.circular(33))),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        LineAwesomeIcons.heartbeat,
                        color: Colors.white,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 5),
                          child: Text(
                            'BRASIL',
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w100),
                          ),
                        ),
                      ),
                      Icon(
                        LineAwesomeIcons.info_circle,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                Center(
                    child: Container(
                        height: height / 5,
                        width: width,
                        child: BlocBuilder<CovidBloc, CovidState>(
                          builder: (context, state) {
                            return BezierChart(
                              bezierChartScale: BezierChartScale.WEEKLY,
                              fromDate: DateTime(2020, 1, 1),
                              toDate: DateTime.now(),
                              selectedDate: state.dateSelected,
                              onDateTimeSelected: (date) {
                                BlocProvider.of<CovidBloc>(context)
                                    .add(SetDateCovidAccumulated(date));
                              },
                              onValueSelected: (d) {
                                print(d);
                              },
                              //this is optional
                              footerDateTimeBuilder:
                                  (DateTime value, BezierChartScale scaleType) {
                                final newFormat = DateFormat('dd/MMM', 'pt');
                                return newFormat.format(value);
                              },
                              bubbleLabelDateTimeBuilder:
                                  (DateTime value, BezierChartScale scaleType) {
                                final newFormat = DateFormat('EEE d', 'pt');
                                return "${newFormat.format(value)}\n";
                              },

                              series: [
                                BezierLine(
                                    label: "Casos",
                                    onMissingValue: (dateTime) {
                                      if (dateTime.month.isEven) {
                                        return 10.0;
                                      }
                                      return 5.0;
                                    },
                                    data: (state as DataCovidLoaded)
                                        .covidAccumulated
                                        .map((f) => DataPoint<DateTime>(
                                            value: double.parse(
                                                f.qtdConfirmado.toString()),
                                            xAxis: f.date))
                                        .toList()

                                    // [
                                    //   DataPoint<DateTime>(
                                    //       value: 10, xAxis: date1),
                                    //   DataPoint<DateTime>(
                                    //       value: 50, xAxis: date2),
                                    //   DataPoint<DateTime>(
                                    //       value: 20, xAxis: date3),
                                    //   DataPoint<DateTime>(
                                    //       value: 80, xAxis: date4),
                                    //   DataPoint<DateTime>(
                                    //       value: 14, xAxis: date5),
                                    //   DataPoint<DateTime>(
                                    //       value: 30, xAxis: date6),
                                    // ],
                                    ),
                              ],
                              config: BezierChartConfig(
                                verticalIndicatorStrokeWidth: 3.0,
                                verticalIndicatorColor: Colors.black26,
                                showVerticalIndicator: true,
                                verticalIndicatorFixedPosition: false,
                                showDataPoints: true,
                                contentWidth:
                                    MediaQuery.of(context).size.width * 2,
                              ),
                            );

                            // return BezierChart(
                            //   bezierChartScale: BezierChartScale.CUSTOM,
                            //   xAxisCustomValues: const [
                            //     0,
                            //     3,
                            //     10,
                            //     15,
                            //     20,
                            //     25,
                            //     30,
                            //     35
                            //   ],
                            //   series: const [
                            //     BezierLine(
                            //       data: const [
                            //         DataPoint<double>(value: 5, xAxis: 0),
                            //         DataPoint<double>(value: 10, xAxis: 5),
                            //         DataPoint<double>(value: 35, xAxis: 10),
                            //         DataPoint<double>(value: 40, xAxis: 15),
                            //         DataPoint<double>(value: 40, xAxis: 20),
                            //         DataPoint<double>(value: 40, xAxis: 25),
                            //         DataPoint<double>(value: 9, xAxis: 30),
                            //         DataPoint<double>(value: 11, xAxis: 35),
                            //       ],
                            //     ),
                            //   ],
                            //   config: BezierChartConfig(
                            //     verticalIndicatorStrokeWidth: 2.0,
                            //     verticalIndicatorColor: Colors.black12,
                            //     showVerticalIndicator: true,
                            //     contentWidth:
                            //         MediaQuery.of(context).size.width * 2,
                            //     // backgroundColor: Colors.red,
                            //   ),
                            // );
                          },
                        ))),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: IndicadoresCovid(
                      totalCases: this.totalCases,
                      totaldeaths: this.totalDeaths,
                      letalidade: this.letalidade,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 400.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class IndicadoresCovid extends StatelessWidget implements PreferredSizeWidget {
  final String totalCases;
  final String totaldeaths;
  final String letalidade;

  const IndicadoresCovid(
      {Key key, this.totalCases, this.totaldeaths, this.letalidade})
      : super(key: key);
  @override
  Size get preferredSize => Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 89,
      margin: EdgeInsets.only(bottom: 30, left: 21, right: 21),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0, // has the effect of softening the shadow
              spreadRadius: 6, // has the effect of extending the shadow
              offset: Offset(
                0, // horizontal, move right 10
                3, // vertical, move down 10
              ),
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Indicador(
              title: 'Casos',
              value: totalCases.toString(),
            ),
            VerticalDivider(),
            Indicador(
              title: 'Mortes',
              value: totaldeaths.toString(),
            ),
            VerticalDivider(),
            Indicador(
              title: 'Letalidade',
              value: letalidade,
            ),
          ],
        ),
      ),
    );
  }
}

class Indicador extends StatelessWidget {
  final String title;
  final String value;
  const Indicador({
    Key key,
    this.title,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            this.title.toUpperCase(),
            style: TextStyle(
                fontSize: 11,
                decoration: TextDecoration.none,
                color: Theme.of(context).primaryColor,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w100),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 22,
                decoration: TextDecoration.none,
                fontFamily: 'Poppins',
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
