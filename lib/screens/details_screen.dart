import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/constants.dart';
import 'package:meditation_app/widgets/bottom_nav_bar.dart';
import 'package:meditation_app/widgets/search_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:snapshot/snapshot.dart';

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final DatabaseReference _medRef =
      FirebaseDatabase.instance.reference().child('med');
  final DatabaseReference _speedRef =
      FirebaseDatabase.instance.reference().child('med/speed');
  final DatabaseReference _timesRef =
      FirebaseDatabase.instance.reference().child('med/times');
  final DatabaseReference _smoothRef =
      FirebaseDatabase.instance.reference().child('med/smooth');

  String _kTestKey = 'Key';
  String _kTestValue = 'Value';
  int _counter = 0;
  String _times = '';
  Map<dynamic, dynamic> _timesMaps;
  Map<dynamic, dynamic> _speedMaps;
  Map<dynamic, dynamic> _smoothMaps;

  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);
    _speedRef.keepSynced(true);
  }

  //获取firebase数据
  Future<Null> _increment() async {
    await _speedRef.once().then((snapshot) {
      _speedMaps = snapshot.value;
    });
    await _timesRef.once().then((snapshot) {
      _timesMaps = snapshot.value;
    });
    await _smoothRef.once().then((snapshot) {
      _smoothMaps = snapshot.value;
    });

    //动态刷新数据(自增)
    setState(() {
      _counter++;
    });

    // _speedRef.set(_counter); // 单个
    _timesRef.push().set(_counter); // 多个
    _speedRef.push().set(_counter);
    _smoothRef.push().set(_counter);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var size = MediaQuery.of(context).size;

    List<Widget> _getWidgetList(Map<dynamic,dynamic> maps){
      List<Widget>listWidget=[];
      maps.forEach((k,v){
        listWidget.add(Text(v.toString()));
      });
      return listWidget;
    }

    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .45,
            decoration: BoxDecoration(
              color: kBlueLightColor,
              image: DecorationImage(
                image: AssetImage("assets/images/meditation_bg.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Text(
                      "Meditation",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "3-10 MIN Course",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: size.width * .6, // it just take 60% of total width
                      child: Text(
                        "Live happier and healthier by learning the fundamentals of meditation and mindfulness",
                      ),
                    ),
                    SizedBox(
                      width: size.width * .5, // it just take the 50% width
                      child: SearchBar(),
                    ),
                    SizedBox(
                      width: 0.1,
                      height: 80.0,
                      child: VerticalDivider(),
                    ),
                    FloatingActionButton(
                      onPressed: _increment,
                      tooltip: '添加数据',
                      child: new Icon(Icons.add),
                    ),
                    SizedBox(
                      width: 0.1,
                      height: 10.0,
                      child: VerticalDivider(),
                    ),
                    _timesMaps!=null ? Row(
                      children: [
                        Text("times:"),
                        Container(
                          width: 300,
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 20.0,
                            padding: EdgeInsets.all(10.0),
                            crossAxisCount: 6,
                            childAspectRatio: 2.0,
                            children: _getWidgetList(_timesMaps),
                          ),
                        )
                      ],
                    ):Text("no data"),
                    _speedMaps!=null ? Row(
                      children: [
                        Text("speed:"),
                        Container(
                          width: 300,
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 20.0,
                            padding: EdgeInsets.all(10.0),
                            crossAxisCount: 6,
                            childAspectRatio: 2.0,
                            children: _getWidgetList(_speedMaps),
                          ),
                        )
                      ],
                    ):Text("no data"),
                    _smoothMaps!=null ? Row(
                      children: [
                        Text("smooth:"),
                        Container(
                            width: 300,
                            child: GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 20.0,
                              padding: EdgeInsets.all(10.0),
                              crossAxisCount: 6,
                              childAspectRatio: 2.0,
                              children: _getWidgetList(_smoothMaps),
                            ),
                        )
                      ],
                    ):Text("no data"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SeassionCard extends StatelessWidget {
  final int seassionNum;
  final bool isDone;
  final Function press;

  const SeassionCard({
    Key key,
    this.seassionNum,
    this.isDone = false,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: constraint.maxWidth / 2 - 10,
          // constraint.maxWidth provide us the available with for this widget
          // padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 17),
                blurRadius: 23,
                spreadRadius: -13,
                color: kShadowColor,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: press,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 42,
                      width: 43,
                      decoration: BoxDecoration(
                        color: isDone ? kBlueColor : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: kBlueColor),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: isDone ? Colors.white : kBlueColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Session $seassionNum",
                      style: Theme.of(context).textTheme.subtitle,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
