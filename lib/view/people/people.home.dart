import 'package:flutter/material.dart';
import 'package:test_floor/model/client.dart';
import 'package:dio/dio.dart';
import 'package:test_floor/model/ws.uiname.model.dart';
import 'package:load/load.dart';

class PeopleHomeWidget extends StatefulWidget {
  PeopleHomeWidget({Key key}) : super(key: key);
  @override
  _PeopleHomeWidgetState createState() => _PeopleHomeWidgetState();
}

class _PeopleHomeWidgetState extends State<PeopleHomeWidget> {

  List<Client> peoples = [];
  List<UIName> webNames = [];

  @override
  void initState() {
    super.initState();
    atualizaLista();
  }

  void _addClient() async {
    if (webNames.isEmpty) {
      showLoadingDialog();
    
      Response response = await Dio().get("https://uinames.com/api/?amount=25&region=brazil");
      webNames = List<UIName>.from(response.data.map<UIName>((json) => UIName.fromJson(json)).toList());

      hideLoadingDialog();
    }

    String name = "";
    if (webNames.isNotEmpty) {
      UIName webName = webNames[0];
      name = webName.name + " " + webName.surname;
      webNames.removeAt(0);
    } else {
      name = "No web name";
    }

    int id = await Client.getNextSequence();
    Client(id: id, firstName: name).insert();

    atualizaLista();
  }


  Future atualizaLista() async {
    List<Client> lista = await Client.getAll();  

    setState(() {
      peoples = lista;
    });
  }


  deleteAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Remove All Peoples?"),
        actions: <Widget>[
          FlatButton(
            child: Text("Yes", style: TextStyle(color: Colors.red),),
            onPressed: () {
              Client.deleteAll();
              atualizaLista();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      )
    );
  }

  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Peoples"),
        actions: <Widget>[
          IconButton(onPressed: deleteAll, icon: Icon(Icons.delete_forever),)
        ],
      ),
      body: RefreshIndicator(
        onRefresh: atualizaLista,
        child: ListView.builder(
          padding: EdgeInsets.only(top: 10, bottom: 50),
          itemCount: peoples.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              elevation: 3,
              child: ListTile(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc){
                      return Container(
                        child: Wrap(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("Options for people #${peoples[index].id}"),
                          ),
                          ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Edit'),
                            onTap: () {
                              Navigator.pop(context);
                              peoples[index].firstName += " edited"; 
                              peoples[index].update();
                              atualizaLista();
                            }          
                          ),
                          ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete'),
                            onTap: () {
                              peoples[index].delete();
                              atualizaLista();
                            },          
                          ),
                        ],
                      ),
                      );
                    }
                  );
                },
                title: Text(peoples[index].firstName),
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  child: Text(peoples[index].id.toString()),
                ),
              ),
            );
          },
        ),
      ),
      
            
          
        
      
      floatingActionButton: FloatingActionButton(
        onPressed: _addClient,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ), 
    );
  }
}