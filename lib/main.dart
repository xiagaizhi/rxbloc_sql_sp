import 'package:flutter/material.dart';
import 'package:rxbloc_sql_sp/base/BlocProvider.dart';
import 'package:rxbloc_sql_sp/bean/TestData.dart';
import 'package:rxbloc_sql_sp/bloc/TestBloc.dart';
import 'package:rxbloc_sql_sp/pages/FirstPage.dart';
import 'package:rxbloc_sql_sp/util/SpUtil.dart';
import 'package:rxbloc_sql_sp/util/SqlUtil.dart';

void main() => runApp(BlocProvider<TestBloc>(
  bloc: TestBloc(),
  child: MyApp(),
));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestPage(),
    );
  }
}
class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TestPageState();
  }
}

class TestPageState extends State<TestPage>{
  List<TestData> _datas = new List();
  var db = DatabaseHelper();
  TestData spData=TestData();
  Future<Null> _refresh() async {
    _query();
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDb();
    _initAsync();
    spData.data="来自sp的数据";
    spData.id=0;
    spData.time= DateTime.now().millisecondsSinceEpoch;

  }
  void _initAsync() async {
    await SpUtil.getInstance();
  }

  _getDataFromDb() async {
    List datas = await db.getTotalList();
    if (datas.length > 0) {
      //数据库有数据
      datas.forEach((user) {
        TestData item = TestData.fromMap(user);
        _datas.add(item);
      });
    } else {
      //数据库没有数据
      TestData data1 = new TestData();
      data1.data = "来自数据库";
      data1.time = new DateTime.now().millisecondsSinceEpoch;
      data1.id = 1;

      TestData data2 = new TestData();
      data2.data ="来自数据库";
      data2.time = new DateTime.now().millisecondsSinceEpoch;
      data2.id = 2;

      await db.saveItem(data1);
      await db.saveItem(data2);

      _datas.add(data1);
      _datas.add(data2);
    }

    setState(() {});
  }

//数据库添加
  Future<Null> _add() async {
    TestData data = new TestData();
    data.data = "新增一条测试数据";
    data.time = new DateTime.now().millisecondsSinceEpoch;;
    await db.saveItem(data);
    _query();
  }

//数据库删除,默认删除第一条数据
  Future<Null> _delete() async {
    List datas = await db.getTotalList();
    if (datas.length > 0) {
      //修改第一条数据
      TestData data = TestData.fromMap(datas[0]);
      db.deleteItem(data.id);
      _query();
    }

  }

//数据库修改，默认修改第一条数据
  Future<Null> _update() async {
    List datas = await db.getTotalList();
    if (datas.length > 0) {
      //修改第一条数据
      TestData data = TestData.fromMap(datas[0]);
      data.data = "我被修改了";
      db.updateItem(data);
      _query();
    }
  }

//数据库查询
  Future<Null> _query() async {
    _datas.clear();
    List datas = await db.getTotalList();
    if (datas.length > 0) {
      //数据库有数据
      datas.forEach((user) {
        TestData dataListBean = TestData.fromMap(user);
        _datas.add(dataListBean);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("sp and splite"),
        centerTitle: true,
        actions: <Widget>[
          new PopupMenuButton(
              onSelected: (String value) {
                switch (value) {
                  case "增加":
                    _add();
                    break;
                  case "删除":
                    _delete();
                    break;
                  case "修改":
                    _update();
                    break;
                  case "查询":
                    _query();
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                new PopupMenuItem(value: "增加", child: new Text("增加")),
                new PopupMenuItem(value: "删除", child: new Text("删除")),
                new PopupMenuItem(value: "修改", child: new Text("修改")),
                new PopupMenuItem(value: "查询", child: new Text("查询")),
              ])
        ],
        leading: PopupMenuButton(
            onSelected: (String value) {
              switch (value) {
                case "增加":
                  SpUtil.putObject("data", spData);
                  setState(() {
                    _datas.add(TestData.fromJson(SpUtil.getObject("data")));
                  });
                  break;
                case "删除":
                  SpUtil.remove("data");
                  setState(() {
                    _datas.forEach((data) {
                      _datas.remove(data);
                    });
                  });
                  break;
                case "修改":
                  spData.data="sp修改后的数据";
                  SpUtil.putObject("data",spData);
                  setState(() {
                    _datas.add(TestData.fromJson(SpUtil.getObject("data")));
                  });
                  break;
                case "查询":
                  setState(() {
                    _datas.add(TestData.fromJson(SpUtil.getObject("data")));
                  });
                  break;
              }
              print(SpUtil.getObject("data"));
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              new PopupMenuItem(value: "增加", child: new Text("增加")),
              new PopupMenuItem(value: "删除", child: new Text("删除")),
              new PopupMenuItem(value: "修改", child: new Text("修改")),
              new PopupMenuItem(value: "查询", child: new Text("查询")),
            ]),
      ),
      body: RefreshIndicator(
        displacement: 15,
        onRefresh: _refresh,
        child: ListView.separated(
            itemBuilder: _renderRow,
            physics: new AlwaysScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 0.5,
                color: Colors.black38,
              );
            },
            itemCount: _datas.length),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.navigate_next),
          onPressed: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FirstPage()))),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(5),
            child: Text("data：" + _datas[index].data)),
        Padding(
            padding: EdgeInsets.all(5),
            child: Text("time：" + _datas[index].time.toString())),
      ],
    );
  }
}
