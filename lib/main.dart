//import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype_cashier/Provider.dart';
import 'package:prototype_cashier/Dummies.dart';
import 'package:prototype_cashier/LoadingView.dart';


//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:intl/intl.dart';
int itemCounter=0;
double finalSum=0;
double percent=0.01;
String uid='lon5kfHtDcVMLn1f5uzth9ZGBFA3'; //Should come from biometric drive
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prototype Cashier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//      home: LoadingPreview(state: 1),
      home: HomePage(),
//      initialRoute: '/loading',
    routes: {
//      '/loading': (BuildContext context) => LoadingPreview(state: 0),
      '/home': (BuildContext context) => HomePage(),
    });
  }
}
class HomePage extends StatelessWidget {

  DummyVariables dummy;
  final db=Firestore.instance;

  Map<dynamic, dynamic> Sorting(){
    List list=[1,3,5,6,2,2,3,1,1,1];
    list.sort();
    var map=Map();
    for(int i=0; i<list.length;i++){
      int counter=1;
      list[i];
      for(int j=i+1; j<list.length;j++){
        if(list[i]==list[j]){
          counter++;
          list.removeAt(j);
        }
      }
      map.addAll({list[i]:counter});
    }
    return map;
  }

  Widget topWidget(double width, double height){
    Color textColor=Colors.grey[700];
    double minfontsize=15;
    return Container(
      height: 20 ,
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 0.4*width,
              child: AutoSizeText('Название продукта',
                textAlign: TextAlign.center,
                maxLines: 1,
                minFontSize: minfontsize,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: textColor
                ),),
            ),
            Container(
              width: 0.20*width,
              child: AutoSizeText('Цена'.toString(),
                textAlign: TextAlign.center,
                maxLines: 1,
                minFontSize: minfontsize,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: textColor
                ),),
            ),
            Container(
              width: 0.20*width,
              child: AutoSizeText('Количество',
                textAlign: TextAlign.center,
                maxLines: 1,
                minFontSize: minfontsize,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: textColor
                ),),
            ),
            Container(
              width: 0.20*width,
              child: AutoSizeText('Сумма',
                textAlign: TextAlign.center,
                maxLines: 1,
                minFontSize: minfontsize,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: textColor
                ),),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomWidget(BuildContext context, double width, double height){
    Color textColor=Colors.grey[100];
    double minfontsize=25;
    return Container(
      color: Colors.lightGreen[600],
      height: height*0.163 ,
      child: Row(
        children: [
          Container(
            width: 0.6*width,
            child: Column(
              children: [
                AutoSizeText('Всего товаров: $itemCounter',
              textAlign: TextAlign.center,
              maxLines: 1,
              minFontSize: minfontsize,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: textColor),),
                AutoSizeText('Кэшбек: +${percent*finalSum} T',
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  minFontSize: minfontsize,
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: textColor),),
              ],
            ),
          ),
          GestureDetector(
            onTap:() async {
              if(true){//Payment confirmation
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>LoadingPreview(state: 1)),
                );
              await db.collection('UserData').document(uid).collection('history').add({
                'cashback': (percent*finalSum).toString(),
                'date': DateTime.now(),
                'sum': finalSum.toString(),
              });
                finalSum=0;
                itemCounter=0;
              }
              else{
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>LoadingPreview(state: 2))
                );
                finalSum=0;
                itemCounter=0;
              }
            },
            child: Container(
              width: 0.4*width,
              child: AutoSizeText('ИТОГО\n $finalSum'.toString(),
                textAlign: TextAlign.center,
                maxLines: 2,
                minFontSize: minfontsize-2,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: textColor
                ),),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var map = Sorting();
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: SafeArea(

        child: Container(

          child: Column(
            children: [
              AutoSizeText('Ваша корзина: ',
                textAlign: TextAlign.left,
                maxLines: 1,
                minFontSize: 20,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                ),),
              topWidget(_width, _height),
              Container(height: _height*0.65,child: ItemListWidget(map: Sorting(),)),
              bottomWidget(context, _width, _height),

            ],
          ),
        ),
      ),
    );
  }
}


class ItemListWidget extends StatefulWidget {

  ItemListWidget({
    @required this.map,
  });
  final Map map;
  @override
  _ItemListWidgetState createState() => _ItemListWidgetState(map: map);
}

class _ItemListWidgetState extends State<ItemListWidget> {

  _ItemListWidgetState({
    @required this.map,
  });

  final Map map;
  Key key = UniqueKey();

  void restartItemListWidget() {
    setState(() {
      key = UniqueKey();
    });
  }

  Widget build(BuildContext context) {
    var keys=widget.map.keys;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return ListView.builder(
              itemCount: widget.map.length,
              itemBuilder: (BuildContext context, int index){
                return ItemCardWidget(context: context, id: keys.elementAt(index), count: widget.map[keys.elementAt(index)],);
              }
          );
  }
}


class ItemCardWidget extends StatelessWidget {
  const ItemCardWidget({
    Key key,
    @required this.context,
//    @required this.item,
  this.id, this.count,
  }) : super(key: key);
//  final DocumentSnapshot item;
  final int id, count;
  final BuildContext context;

  BoxDecoration TileBoxDecoration() {
    return BoxDecoration(
      color: Colors.white70,
      border: Border(
        top: BorderSide(
          color: Colors.grey[300],
          width: 1.5,
        ),
        bottom: BorderSide(
          color: Colors.grey[300],
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Color textColor=Colors.grey[700];

    return StreamBuilder(
      stream: Firestore.instance.collection('PriceData').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
          return new Text("Loading");
          }
          var item = snapshot.data.documents[id-1];
          if (snapshot.hasData){
            itemCounter=itemCounter + count;
            finalSum=finalSum+item['price']*count;//sum
          }
        return Container(
          height: height*0.13 ,
          width: width,
          decoration: TileBoxDecoration(),
          child: SafeArea(
            child: Row(
              children: [
                Container(
                  width: 0.4*width,
                  child: AutoSizeText(item['name'],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  minFontSize: 20,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: textColor
                  ),),
                ),
                Container(
                  width: 0.20*width,
                  child: AutoSizeText(item['price'].toString(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    minFontSize: 20,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: textColor
                    ),),
                ),
                Container(
                  width: 0.20*width,
                  child: AutoSizeText(count.toString(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    minFontSize: 20,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: textColor
                    ),),
                ),
                Container(
                  width: 0.20*width,
                  child: AutoSizeText((item['price']*count).toDouble().toString(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    minFontSize: 20,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: textColor
                    ),),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

