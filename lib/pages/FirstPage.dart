import 'package:flutter/material.dart';
import 'package:rxbloc_sql_sp/base/BlocProvider.dart';
import 'package:rxbloc_sql_sp/bloc/TestBloc.dart';
import 'package:rxbloc_sql_sp/pages/SecendPage.dart';
class FirstPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final TestBloc bloc = BlocProvider.of<TestBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('first Page'),
      ),
      body: Center(
        child: StreamBuilder<int>(
            stream: bloc.modelStream,
            initialData: bloc.value,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Text(
                'first page: ${snapshot.data}',
                style: Theme.of(context).textTheme.display1,
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.navigate_next),
          onPressed: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SecondPage()))),
    );
  }
}
