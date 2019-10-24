import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arts_demos_app/bloc/bloc_provider.dart';
import 'package:flutter_arts_demos_app/colsed/fuli_bloc.dart';
import 'package:flutter_arts_demos_app/colsed/fuli_model.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';

class FuliPage extends StatefulWidget {
  @override
  _FuliPageState createState() => _FuliPageState();
}

class _FuliPageState extends State<FuliPage> {
  ScrollController _controller = ScrollController();
  GlobalKey<EasyRefreshState> _refreshKey = GlobalKey();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey();
  FuliBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<FuliBloc>(context);
    _request();
  }

  _request() async {
    List<FuliModel> fulis = await _bloc.requestFuli(_bloc.page);
    _bloc.page == 1 ? _bloc.refreshFuli(fulis) : _bloc.loadMoreFuli(fulis);
    _bloc.increasePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        builder: (_, AsyncSnapshot<List<FuliModel>> snapshot) => Container(
              alignment: Alignment.center,
              child: !snapshot.hasData
                  ? CupertinoActivityIndicator(radius: 12.0)
                  : EasyRefresh(
                      key: _refreshKey,
                      refreshFooter: BallPulseFooter(key: _footerKey),
                      loadMore: () {
                        _request();
                      },
                      child: GridView.count(
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 4.0,
                        childAspectRatio: 0.5,
                        controller: _controller,
                        crossAxisCount: 2,
                        children: snapshot.data
                            .map(
                              (p) => Column(
                                    children: <Widget>[
                                      FadeInImage.assetNetwork(
                                        placeholder: 'images/ali.jpg',
                                        image: '${p.thumb_src}',
                                        fit: BoxFit.cover,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child:
                                              Text('${p.title}', style: TextStyle(fontSize: 14.0, color: Colors.black)))
                                    ],
                                  ),
                            )
                            .toList(),
                      )),
            ),
        stream: _bloc.stream,
        initialData: _bloc.fuLi,
      ),
    );
  }
}
