import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather_app/components/components.dart';
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
  bool _showScrollUpButton = false;
  bool _isFirstLoading = true;
  bool _isLoading = false;
  bool _isEnd = false;
  late ZoomPanBehavior _zoomPanBehavior;
  final _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
    );
    context.read<Ds18b20Cubit>().getDs18b20(true);
    super.initState();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_loadMore)
      ..dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _controller.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).backgroundColor,
      onRefresh: _refresh,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.device.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        floatingActionButton: _showScrollUpButton
            ? ScrollToUpComponent(scrollToTop: _scrollToTop)
            : null,
        body: BlocBuilder<Ds18b20Cubit, Ds18b20State>(
          builder: (context, state) {
            context.loaderOverlay.hide();
            if (state is Ds18b20Error) {
              context.loaderOverlay.hide();
              return ErrorComponent(
                  errorMessage: state.message.errorMessage!, onRetry: _refresh);
            } else if (state is Ds18b20Success) {
              _isEnd = state.isEnd;
              _isLoading = false;
              context.loaderOverlay.hide();
              return _buildCustomSliver(state.device, state.isEnd);
            } else {
              _isLoading = true;
              context.loaderOverlay.show();
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _buildCustomSliver(List<List<Ds18b20>> list, bool isEnd) {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverToBoxAdapter(child: _buildChart(list.last)),
        for (var i in list) _sliverStickyBuilder(i),
        if (list.isNotEmpty)
          SliverToBoxAdapter(child: FooterListTileComponent(isEnd: isEnd)),
      ],
    );
  }

  Future _refresh() async {
    _zoomPanBehavior.reset();
    _isFirstLoading = true;
    context.read<Ds18b20Cubit>().getDs18b20(true);
  }

  Widget _buildChart(List<Ds18b20> list) => SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.minutes,
        dateFormat: DateFormat('HH:mm\ndd/MM'),
        autoScrollingDelta: 1,
        autoScrollingDeltaType: DateTimeIntervalType.hours,
        autoScrollingMode:
            _isFirstLoading ? AutoScrollingMode.end : AutoScrollingMode.start,
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

  Future _loadMore() async {
    _isFirstLoading = false;
    _isLoading = true;
    context.read<Ds18b20Cubit>().getDs18b20(false, needShowLoading: false);
  }

  List<ChartSeries<Ds18b20, DateTime>> _getSplieAreaSeries(
          List<Ds18b20> list) =>
      <ChartSeries<Ds18b20, DateTime>>[
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

  SliverStickyHeader _sliverStickyBuilder(List<Ds18b20> list) =>
      SliverStickyHeader.builder(
        builder: ((context, state) => ListDateHeader(dateTime: list[0].date)),
        sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                ((context, index) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: DataListItem(
                      time: list[index].date,
                      children: [
                        TemperatureTile(temperature: list[index].temperature),
                      ],
                    ))),
                childCount: list.length)),
      );

  void _onScroll() {
    if (_isBottom && !_isLoading && !_isEnd) {
      _loadMore();
    }
    bool isScrolled = _controller.offset >= 400;
    if (isScrolled != _showScrollUpButton) {
      setState(() {
        _showScrollUpButton = isScrolled;
      });
    }
  }

  bool get _isBottom {
    if (!_controller.hasClients) return false;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    return currentScroll >= (maxScroll * 0.95);
  }
}
