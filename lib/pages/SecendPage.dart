import 'package:flutter/material.dart';
import 'package:rxbloc_sql_sp/base/BlocProvider.dart';
import 'package:rxbloc_sql_sp/bloc/TestBloc.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TestBloc bloc = BlocProvider.of<TestBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('secen Page'),
      ),
      body: Center(
        child: StreamBuilder(
            stream: bloc.modelStream,
            initialData: bloc.value,
            builder: (context, snapshot) => Text(
              "secend page: ${snapshot.data}",
              style: Theme.of(context).textTheme.display1,
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bloc.sink.add(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
