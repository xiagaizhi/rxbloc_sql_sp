import 'package:rxbloc_sql_sp/base/BlocBase.dart';
import 'package:rxbloc_sql_sp/bean/TestData.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class TestBloc extends BlocBase{
  int _count = 0;

  //接收来自view的请求,传递给model
  var presenter=BehaviorSubject();
  Sink get sink => presenter.sink;

  //接收来自model的请求,处理业务逻辑，传回结果给view
  var model=BehaviorSubject<int>();
  StreamSink<int> get _modelSink => model.sink;
  Stream<int> get modelStream => model.stream;
// 构造器
  TestBloc(){
    _count = 0;
    presenter.stream
        .listen(_handleLogic);
  }
  void _handleLogic(data){
    _count = _count + 1;
    _modelSink.add(_count);
  }
  int get value =>_count;
  @override
  void dispose() {
    // TODO: implement dispose
    presenter.close();
    model.close();
  }
}