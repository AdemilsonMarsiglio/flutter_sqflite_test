
import 'package:flutter/material.dart';
import 'package:test_floor/client.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Floor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Client> peoples = [];

  void _incrementCounter() async {
    int id = await Client.getNextSequence();
    Client(id: id, firstName: "ade $id").insert();

    atualizaLista();
  }

  atualizaLista() async {
    List<Client> lista = await Client.getAll();  

    setState(() {
      peoples = lista;
    });
  }

  deleteAll() {
    Client.deleteAll();
    atualizaLista();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(onPressed: atualizaLista, icon: Icon(Icons.refresh),),
          IconButton(onPressed: deleteAll, icon: Icon(Icons.delete_forever),)
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: peoples.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${peoples[index].id} - ${peoples[index].firstName}'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), 
    );
  }
}
