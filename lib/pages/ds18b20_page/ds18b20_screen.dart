import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather_app/models/device.dart';
import 'package:weather_app/pages/ds18b20_page/ds18b20_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui' as ui;

import '../../models/ds18b20.dart';

class Ds18b20Screen extends StatefulWidget {
  const Ds18b20Screen({Key? key, required this.device}) : super(key: key);
  final Device device;
  @override
  State<Ds18b20Screen> createState() => _Ds18b20ScreenState();
}

class _Ds18b20ScreenState extends State<Ds18b20Screen> {
  bool _isFirstLoading = true;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
    );
    context.read<Ds18b20Cubit>().getDs18b20(widget.device.id, true, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.device.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: BlocBuilder<Ds18b20Cubit, Ds18b20State>(
        builder: (context, state) {
          context.loaderOverlay.hide();
          if (state is Ds18b20Error) {
            context.loaderOverlay.hide();
            return Container();
          } else if (state is Ds18b20Success) {
            context.loaderOverlay.hide();
            return _buildContent(state.device);
          } else {
            context.loaderOverlay.show();
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildContent(List<Ds18b20> list) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildHeader(widget.device.description),
              _buildChart(list),
              _buildSubsciption(list)
            ],
          ),
        ),
      ),
    );
  }

  Future _refresh() async {
    _zoomPanBehavior.reset();
    _isFirstLoading = true;
    context.read<Ds18b20Cubit>().getDs18b20(widget.device.id, true, true);
  }

  Widget _buildChart(List<Ds18b20> list) {
    return SfCartesianChart(
        loadMoreIndicatorBuilder: (context, direction) {
          if (direction == ChartSwipeDirection.start) {
            return FutureBuilder(
              future: _loadMore(),
              builder: (BuildContext futureContext, AsyncSnapshot snapShot) {
                return snapShot.connectionState != ConnectionState.done
                    ? const CircularProgressIndicator()
                    : Container();
              },
            );
          } else {
            return Container();
          }
        },
        zoomPanBehavior: _zoomPanBehavior,
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.minutes,
          dateFormat: DateFormat('HH:mm\ndd/MM'),
          autoScrollingDelta: 1,
          autoScrollingDeltaType: DateTimeIntervalType.hours,
          autoScrollingMode: _isFirstLoading
              ? AutoScrollingMode.end
              : AutoScrollingMode.start,
          labelStyle: Theme.of(context).textTheme.headline3,
          interval: 10,
          majorTickLines: const MajorTickLines(size: 2),
          majorGridLines: const MajorGridLines(width: 2),
        ),
        primaryYAxis: NumericAxis(
            maximum: 30.0,
            minimum: 15.0,
            labelStyle: Theme.of(context).textTheme.headline3,
            labelAlignment: LabelAlignment.center,
            labelFormat: '{value} °C',
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0)),
        series: _getSplieAreaSeries(list),
        tooltipBehavior: TooltipBehavior(enable: true));
  }

  Future _loadMore() async {
    _isFirstLoading = false;
    context.read<Ds18b20Cubit>().getDs18b20(widget.device.id, false, false);
  }

  List<ChartSeries<Ds18b20, DateTime>> _getSplieAreaSeries(List<Ds18b20> list) {
    return <ChartSeries<Ds18b20, DateTime>>[
      SplineAreaSeries(
          name: AppLocalizations.of(context)!.temperature,
          dataSource: list,
          color: const Color.fromARGB(120, 233, 22, 22),
          borderColor: const Color.fromARGB(148, 255, 255, 255),
          borderWidth: 2,
          xValueMapper: (Ds18b20 value, _) => value.date,
          yValueMapper: (Ds18b20 value, _) => value.temperature,
          onCreateShader: (details) {
            return ui.Gradient.linear(
                details.rect.bottomCenter,
                details.rect.topCenter,
                [Colors.blue, Colors.yellow, Colors.red],
                <double>[0.1, 0.5, 0.9]);
          }),
    ];
  }

  Widget _buildSubsciption(List<Ds18b20?> list) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.showed_time_range,
          style: Theme.of(context).textTheme.headline2,
        ),
        Text(
          getRange(list),
          style: Theme.of(context).textTheme.headline2,
        ),
      ],
    );
  }

  Widget _buildHeader(String description) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        description,
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
      ),
    );
  }

  String getRange(List<Ds18b20?> list) {
    final first = DateFormat('kk:mm dd.MM.yyyy').format(list.first!.date);
    final last = DateFormat('kk:mm dd.MM.yyyy').format(list.last!.date);
    return '$first - $last';
  }

}
