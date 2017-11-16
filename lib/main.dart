import 'package:flutter/material.dart';
import 'pages.dart';
import 'todo_list.dart';
import "asset_detail.dart";


const title = "Houses";

void main() {
  runApp(new MaterialApp(
      title: title,
      home: new BottomNavigationDemo(),
      routes: <String, WidgetBuilder> {
      '/detail': (BuildContext context) => new AssetDetailView(),
    }
  ));
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return new Container(
      margin: const EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      color: iconTheme.color,
    );
  }
}

class BottomNavigationDemo extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';

  @override
  _BottomNavigationDemoState createState() => new _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.fixed;
  List<NavigationIconView> _navigationViews;
  List<AnimationController> animationControllers;
  AnimatedListView lv;
  @override
  void initState() {
    print("tab view init State");
    super.initState();
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: const Icon(Icons.access_alarm),
        title: const Text('Alarm'),
        color: Colors.deepPurple,
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.favorite),
        title: const Text('Favorites'),
        color: Colors.indigo,
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.event_available),
        title: const Text('Event'),
        color: Colors.pink,
        vsync: this,
      )
    ];

    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;


//    => const ListDemo(),
    lv = new AnimatedListView(
        icon: const Icon(Icons.access_alarm),
        title: const Text('Alarm'),
        widget: const AssetListView(key:const Key("assetList")),
        vsync: this
    );


    lv.controller.addListener(_rebuild);
    lv.controller.value = 1.0;
    animationControllers = [lv.controller, _navigationViews[1].controller];


  }

  @override
  void dispose() {
    print("tab view dispose");
    for (NavigationIconView view in _navigationViews)
      view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    print("tab view rebuild ");
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews) {
      transitions.add(view.transition(_type, context));
    }

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.listenable;
      final Animation<double> bAnimation = b.listenable;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });


    var stackChildren = [lv.transition(_type, context), _navigationViews[1].transition(_type, context)];
///transitions

    return new Stack(children: stackChildren);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
         animationControllers[_currentIndex].reverse();
          _currentIndex = index;
         animationControllers[_currentIndex].forward();
        });
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: const Text(title),
        centerTitle: true,
        actions: <Widget>[
          new PopupMenuButton<BottomNavigationBarType>(
            onSelected: (BottomNavigationBarType value) {
              setState(() {
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<BottomNavigationBarType>>[
              const PopupMenuItem<BottomNavigationBarType>(
                value: BottomNavigationBarType.fixed,
                child: const Text('Settings'),
              ),
              const PopupMenuItem<BottomNavigationBarType>(
                value: BottomNavigationBarType.shifting,
                child: const Text('Login'),
              )
            ],
          )
        ],
      ),
      body: new Center(
          child: _buildTransitionsStack()
      ),
      bottomNavigationBar: botNavBar,
    );
  }

}
