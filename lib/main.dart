import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/animation.dart';

void main() => runApp(MyApp());

class Fav with ChangeNotifier {
  int _count = 0;
  bool _isFav = false;
  double _scale = 300;
  bool get status => _isFav;
  int get count => _count;
  double get scale => _scale;

  void update() {
    _isFav ? _isFav = false : _isFav = true;
    _count++;

    notifyListeners();
  }

  void reset() {
    _isFav = false;
    _count = 0;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => Fav(),
        )
      ],
      child: Consumer<Fav>(
        builder: (context, counter, _) {
          return MaterialApp(
            theme: ThemeData(primarySwatch: Colors.pink),
            debugShowCheckedModeBanner: false,
            home: HomePage(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Fav Button + Counter"),
      ),
      body: FavButton(),
    );
  }
}

class FavButton extends StatefulWidget {
  const FavButton({Key key}) : super(key: key);

  @override
  _FavButtonState createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  double size = 300;

  FavIcon favIcon;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      lowerBound: 0.0,
      upperBound: 1.5,
    );

    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.fling();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final fav = Provider.of<Fav>(context);
    double scale = 1.0;

    return Container(
      color: Colors.pink,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTapDown: (td) {
                _onTapDown(td);
                size = 330;
              },
              onTapUp: (tu) {
                _onTapUp(tu);
                fav.update();
                size = 300;
              },
              onLongPress: () => Provider.of<Fav>(context).reset(),
              child: FavIcon(fav.status, scale, size),
            ),
            CounterLabel(),
          ],
        ),
      ),
    );
  }
}

class CounterLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fav = Provider.of<Fav>(context);
    const textStyle = TextStyle(fontSize: 24, color: Colors.white);

    return fav.count > 0
        ? Text(
            "You've clicked ${fav.count} times...",
            style: textStyle,
          )
        : Text(" ", style: textStyle);
  }
}

class FavIcon extends StatelessWidget {
  final bool fav;
  final double scaleNum;
  final double size;
  const FavIcon(this.fav, this.scaleNum, this.size);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scaleNum,
      child: Icon(
        fav != null && fav == true ? Icons.favorite : Icons.favorite_border,
        size: size,
        color: Colors.white,
      ),
    );
  }
}
