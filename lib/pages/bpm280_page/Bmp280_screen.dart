import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather_app/pages/bpm280_page/bmp280_cubit.dart';

import '../../components/data_list_item.dart';
import '../../components/error_component.dart';
import '../../components/footer_list_tile_component.dart';
import '../../components/list_date_header.dart';
import '../../components/scroll_up_component.dart';
import '../../components/temperature_tile.dart';
import '../../models/bmp280.dart';
import '../../models/device.dart';

class Bmp280Screen extends StatefulWidget {
  final Device device;

  const Bmp280Screen({Key? key, required this.device}) : super(key: key);

  @override
  State<Bmp280Screen> createState() => _Bmp280ScreenState();
}

class _Bmp280ScreenState extends State<Bmp280Screen> {
  bool _showScrollUpButton = false;
  bool _isLoading = false;
  bool _isEnd = false;
  final _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    context.read<Bmp280Cubit>().getData(widget.device.id, true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
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
        body: BlocBuilder<Bmp280Cubit, Bmp280State>(
          builder: (context, state) {
            context.loaderOverlay.hide();
            if (state is Bmp280Error) {
              context.loaderOverlay.hide();
              return ErrorComponent(
                  errorMessage: state.message, onRetry: _refresh);
            } else if (state is Bmp280Success) {
              _isEnd = state.isEnd;
              _isLoading = false;
              context.loaderOverlay.hide();
              return _buildCustomSliver(state.devices, state.isEnd);
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

  Widget _buildCustomSliver(List<List<BMP280>> list, bool isEnd) {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        for (var i in list) _sliverStickyBuilder(i),
        if (list.isNotEmpty)
          SliverToBoxAdapter(child: FooterListTileComponent(isEnd: isEnd)),
      ],
    );
  }

  SliverStickyHeader _sliverStickyBuilder(List<BMP280> list) =>
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

  Future _loadMore() async {
    _isLoading = true;
    context
        .read<Bmp280Cubit>()
        .getData(widget.device.id, false, needShowLoading: false);
  }

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

  Future _refresh() async {
    context.read<Bmp280Cubit>().getData(widget.device.id, true);
  }

  bool get _isBottom {
    if (!_controller.hasClients) return false;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    return currentScroll >= (maxScroll * 0.95);
  }
}
