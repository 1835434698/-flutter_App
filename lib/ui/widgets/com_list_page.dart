import 'package:flutter/material.dart';
import 'package:flutter_app/common/component_index.dart';

class ComListPage extends StatelessWidget {
  const ComListPage({Key key, this.labelId, this.cid}) : super(key: key);
  final String labelId;
  final int cid;

  @override
  Widget build(BuildContext context) {
    LogUtil.e("ComListPage build......");
    RefreshController _controller = new RefreshController();
    final ComListBloc bloc = BlocProvider.of<ComListBloc>(context);
    bloc.comListEventStream.listen((event) {
      if (cid == event.cid) {
        _controller.sendBack(false, event.status);
      }
    });

    return new StreamBuilder(
        stream: bloc.comListStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ReposModel>> snapshot) {
          if (bloc.comList == null) {
            bloc.onRefresh(labelId: labelId, cid: cid);
//            Observable.just(1)
//                .delay(new Duration(milliseconds: 500))
//                .listen((_) {
//
//            });
          }

          return new RefreshScaffold(
            labelId: cid.toString(),
            isLoading: snapshot.data == null,
            controller: _controller,
            onRefresh: () {
              return bloc.onRefresh(labelId: labelId, cid: cid);
            },
            onLoadMore: (up) {
              bloc.onLoadMore(labelId: labelId, cid: cid);
            },
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              ReposModel model = snapshot.data[index];
              return labelId == Ids.titleReposTree
                  ? new ReposItem(model)
                  : new ArticleItem(model);
            },
          );
        });
  }
}
