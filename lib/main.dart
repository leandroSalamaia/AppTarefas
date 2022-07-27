import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color.fromRGBO(98, 114, 164, 1)),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  // ignore: deprecated_member_use
  var items = <Item>[];

  HomePage() {
    items = [];
    // items.add(Item(title: "Item 1", done: false));
    // items.add(Item(title: "Item 2", done: true));
    // items.add(Item(title: "Item 3", done: false));
    // items.add(Item(title: "Leandro", done: false));
  }

  @override
  // ignore: no_logic_in_create_state
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var novatarefa = TextEditingController();
  var descricao = TextEditingController();

  void add() {
    setState(() {
      widget.items.add(Item(title: novatarefa.text, done: false));
      novatarefa.text = "";
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  Future loadData() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("data");
    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  _HomePageState() {
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas'),
        backgroundColor: Color.fromRGBO(40, 42, 54, 1),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final item = widget.items[index];
          return Dismissible(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.greenAccent),
                    borderRadius: BorderRadius.circular(20),
                  ), //BoxDecoration

                  /** CheckboxListTile Widget **/
                  child: CheckboxListTile(
                    title: Text(item.title.toString(),
                        style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Segunda e sexta dia de tirar o lixo',
                        style: TextStyle(color: Colors.white)),
                    secondary: const Icon(Icons.ad_units_rounded),
                    autofocus: false,
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    value: item.done,
                    onChanged: (value) {
                      setState(() {
                        item.done = value;
                      });
                    },
                  ), //CheckboxListTile
                ), //Container
              ), //Padding
            ),
            key: Key(item.title.toString()),
            background: Container(
              color: Colors.lightBlue.shade50,
            ),
            onDismissed: (direction) => remove(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          //
          child: Icon(Icons.add,
              size: 40.0,
              color: Color.fromRGBO(248, 248, 242, 1),
              textDirection: TextDirection.ltr,
              semanticLabel: 'Icon'),
          backgroundColor: Color.fromRGBO(40, 42, 54, 1),
          elevation: 12,
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 500,
                  color: Color.fromRGBO(40, 42, 54, 1),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: novatarefa,
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(20.0),
                                isDense: true,
                                hintText: 'Nova Tarefa',
                                border: OutlineInputBorder()),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe uma tarefa';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: descricao,
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(20.0),
                                isDense: true,
                                hintText: 'Descrição da Tarefa',
                                border: OutlineInputBorder()),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe uma tarefa';
                              }
                              return null;
                            },
                          ),
                        ),
                        ElevatedButton(
                          child: const Text('Salvar nova Tarefa'),
                          onPressed: () {
                            add();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(189, 147, 249, 1),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              textStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
