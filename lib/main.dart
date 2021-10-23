import 'package:flutter/material.dart';

class Giorno {
  final int n;
  String task;

  Giorno(this.n){
    task = '??';
  }
}

class Mese {
  final String nomeMese;
  List<Giorno> giorni;
  Mese(this.nomeMese, int nGiorni) {
    giorni = List.generate(nGiorni, (index) => Giorno(index + 1));
  }
}

final mesi = [
  new Mese('Gennaio', 31),
  new Mese('Febbraio', 28),
  new Mese('Marzo', 31),
  new Mese('Aprile', 30),
  new Mese('Maggio', 31),
  new Mese('Giugno', 30),
  new Mese('Luglio', 31),
  new Mese('Agosto', 31),
  new Mese('Settembre', 30),
  new Mese('Ottobre', 31),
  new Mese('Novembre', 31),
  new Mese('Dicembre', 31),
];

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Calendario(),
      theme: new ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.blue,
      ),
    );
  }
}

class Calendario extends StatefulWidget {
  @override
  _CalendarioState createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  int _selectMeseIndex = 0;
  final TextEditingController _taskController = new TextEditingController();

  void meseSelezionato(int i) {
    print('primo: ${_selectMeseIndex}');
    setState(() => _selectMeseIndex = i);
    print('mese selezionato: ${_selectMeseIndex}');
    Navigator.of(context).pop();
  }

  void notaSubmit(Giorno x) {
    String nota = _taskController.text.trim();
    setState(() {
      x.task = nota;
      _taskController.clear();
    });
    Navigator.of(context).pop();
  }

  void giornoSelezionato(BuildContext context, Giorno day) {
    showBottomSheet(
        context: context,
        builder: (_) {
          return new Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              height: 300,
              color: Colors.grey.shade200,
              child: new Column(mainAxisSize: MainAxisSize.min, children: [
                new ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: new Text(
                    day.n.toString(),
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  subtitle: new Text(
                    mesi[_selectMeseIndex].nomeMese.toString(),
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                new SizedBox(height: 32),
                new TextField(
                  controller: _taskController,
                  decoration:
                      new InputDecoration(hintText: 'Write a note here'),
                ),
                new SizedBox(
                  height: 32,
                ),
                new MaterialButton(
                  onPressed: () {
                    notaSubmit(day);
                  },
                  color: Colors.deepPurpleAccent,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(100)),
                  child: new Text(
                    'submit note',
                    style: new TextStyle(color: Colors.white),
                  ),
                  minWidth: double.infinity,
                )
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new Drawer(
          child: new SafeArea(
        child: ListView.separated(
          itemCount: mesi.length,
          separatorBuilder: (BuildContext context, int index) {
            return new Divider(
              thickness: 1,
              height: 1,
              color: Colors.purpleAccent.shade100,
              indent: 20,
              endIndent: 20,
            );
            /** avrei potto utilizzare Container **/
            /* new Container(
              height: 1,
              width: double.infinity,
              color: Colors.purpleAccent.shade100,
            );*/
          },
          itemBuilder: (BuildContext context, int index) {
            return new Container(
                color: index == _selectMeseIndex
                    ? Colors.deepPurpleAccent.shade100
                    : Colors.transparent,
                child: ListTile(
                  title: new Text(mesi[index].nomeMese),
                  onTap: () => meseSelezionato(index),
                ));

            /*InkWell(
                onTap: (){
                  setState(() {
                    _selectMeseIndex = index;
                  });
                  Navigator.of(context).pop();
                },
                child: new Container(
                  padding: EdgeInsets.all(16),
                  child: new Text('${mesi[index].nomeMese}'),
                ),
              );*/
          },
        ),
      )),
      appBar: new AppBar(
          centerTitle: true,
          title: new ListTile(
            contentPadding: EdgeInsets.all(80),
            title: new Text(
              'Calendario 2020',
              style: new TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              mesi[_selectMeseIndex].nomeMese.toString(),
              textAlign: TextAlign.center,
            ),
          )),
      body: new Builder(
          builder: (context) => new GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.4,
              children:
                  List.generate(mesi[_selectMeseIndex].giorni.length, (index) {
                return new Card(
                    child: new ListTile(
                  title: new Text(
                    mesi[_selectMeseIndex].giorni[index].n.toString(),
                  ),
                  subtitle: new InkWell(
                      onTap: () {
                        giornoSelezionato(
                            context, mesi[_selectMeseIndex].giorni[index]);
                      },
                      child: new Text(
                        mesi[_selectMeseIndex].giorni[index].task,
                        style: mesi[_selectMeseIndex].giorni[index].task ==
                                '??'
                            ? new TextStyle(
                                fontWeight: FontWeight.bold,)
                            : new TextStyle(fontWeight: FontWeight.bold,color: Colors.red),
                      )),
                ));
                ;
              }))),

      /************************ qui utilizzo il ListView */
      /* body: new ListView.builder(
        itemCount: mesi[_selectMeseIndex].giorni.length,
        padding: EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          return new Card(
              child: new ListTile(
            title: new Text(mesi[_selectMeseIndex].giorni[index].n.toString()),
            subtitle: new InkWell(
                onTap: () {
                  giornoSelezionato(
                      context, mesi[_selectMeseIndex].giorni[index]);
                },
                child: new Text(
                    mesi[_selectMeseIndex].giorni[index].task ?? 'No task')),
          ));
        },
      ),*/
    );
  }
}
