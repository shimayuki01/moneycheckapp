import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  List<Thing> items = List<Thing>.generate(5, (i) => new Thing());
  double _sum = 0;
  double _tax = 10;



  void _incrementList() {
    setState(() {
      items.add(Thing());
    });
  }

  void _handleMoney(String money) {
    setState(() {
      items[0]._money = double.parse(money);
    });
    _handleSum();
  }


  void _handleSum() {
    double sum = 0;
    for (int i = 0; i < items.length; i++) {
      sum += items[i]._money * items[i]._quantity;
    }
    setState(() {
      _sum = sum;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: Text("合計"),
        middle: Text(
            _sum.toString() + "(税込み:" + (_sum * _tax).toString() + ")"),
        trailing: GestureDetector(
          child: Text("クリア"),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text("削除しますか？"),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text("いいえ"),
                      isDestructiveAction: true,
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoDialogAction(
                        child: Text("はい"),
                        isDefaultAction: true,
                        onPressed: () {
                          items = new List<Thing>()
                            ..length = 5;
                          Navigator.pop(context);
                        })
                  ],
                );
              },
            );
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text("金額"),
              Text("メモ"),
              Text("個数"),
            ],
          ),
          Expanded(
            child: ListView.separated(
                itemCount: items.length + 1,
                separatorBuilder: (BuildContext context, index) =>
                    Divider(
                      color: Colors.black,
                    ),
                itemBuilder: (context, index) {
                  if (index < items.length) {
                    return Dismissible(
                      key: Key(index.toString()),
                      background: Container(color: Colors.red),
                      child: ListTile(
                        leading: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: TextFormField(
                            initialValue: items[index]._money.toString(),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'))
                            ],
                            onChanged: _handleMoney,
                          ),
                        ),
                        title: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: TextFormField(
                            initialValue: items[index]._name,
                            //onChanged:,
                          ),
                        ),
                        trailing: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Row(
                            children: [
                              GestureDetector(
                                child: Icon(CupertinoIcons.minus_circled),
                                //onTap:,
                              ),
                              Text(items[index]._quantity.toString()),
                              GestureDetector(
                                child: Icon(CupertinoIcons.add_circled),
                                //onTap:,
                              )
                            ],
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          items.removeAt(index);
                        });
                      },
                    );
                  } else {
                    return ListTile(
                      leading: GestureDetector(
                        child: Icon(CupertinoIcons.add),
                        onTap: _incrementList,
                      ),
                    );
                  }
                }),
          ),
          Text("広告を載せる"),
        ],
      ),
    );
  }
}

class Thing {
  double _money;
  String _name;
  int _quantity;

  Thing(){
    _money = 0;
   _quantity = 1;
  }

  String toString() {
    return 'money: $_money name: $_name quantity: $_quantity';
  }

}
