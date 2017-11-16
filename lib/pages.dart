import 'package:flutter/material.dart';





class AnimatedListView {

  final Widget _icon;
  final Widget _listView;
  final BottomNavigationBarItem tabBarButton;
  final AnimationController controller;
  CurvedAnimation _animation;

  AnimatedListView ({
    Widget icon,
    Widget title,
    Widget widget,
    TickerProvider vsync,
  }) :
    _icon = icon,
    _listView = widget,
    tabBarButton = new BottomNavigationBarItem(
      icon: icon,
      title: title,
    ),
    controller = new AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    ) {
      _animation = new CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn
      );
    }


  Widget transition(BottomNavigationBarType type, BuildContext context) {

    return new FadeTransition(
      opacity: _animation,
      child: _listView
    );


  }
}



class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget title,
    Color color,
    TickerProvider vsync,
  }) : _icon = icon,
        _color = color,
        item = new BottomNavigationBarItem(
          icon: icon,
          title: title,
          backgroundColor: color,
        ),
        controller = new AnimationController(
          duration: const Duration(milliseconds: 500),
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn
    );
  }

  final Widget _icon;
  final Color _color;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 0.02), // Slightly down.
          end: Offset.zero,
        ).animate(_animation),
        child: new IconTheme(
          data: new IconThemeData(
            color: iconColor,
            size: 120.0,
          ),
          child: _icon,
        ),
      ),
    );
  }
}