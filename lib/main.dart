import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class Fav with ChangeNotifier {
  int _count = 0;
  bool _isFav = false;
  bool get status => _isFav;
  int get count => _count;

  void update() {
    _isFav ? _isFav = false : _isFav = true;
    _count++;
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
        title: Text("Fav Button"),
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

  FavIcon favIcon;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
      lowerBound: 0.2,
      upperBound: 1.5,
    );

    _animationController.addListener(() {
      setState(() {});
    });
  }

  void _onTapDown(TapDownDetails details, bool status) {
    setState(() {
      favIcon = FavIcon(status, 1.3);
    });
    _animationController.fling();
  }

  void _onTapUp(TapUpDetails details, bool status) {
    setState(() {
      favIcon = FavIcon(status, 1.0);
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final fav = Provider.of<Fav>(context);
    favIcon = FavIcon(fav.status, 1.0);
    return Container(
      color: Colors.pink,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: Provider.of<Fav>(context).update,
              onTapDown: (td) => _onTapDown(td, fav.status),
              onTapUp: (tu) => _onTapUp(tu, fav.status),
              child: favIcon,
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
    return Text(
      "You've clicked ${fav.count} times...",
      style: TextStyle(fontSize: 24, color: Colors.white),
    );
  }
}

class FavIcon extends StatelessWidget {
  final bool fav;
  final double scaleNum;
  const FavIcon(this.fav, this.scaleNum);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scaleNum,
      child: Icon(
        fav != null && fav == true ? Icons.favorite : Icons.favorite_border,
        size: 300.0,
        color: Colors.white,
      ),
    );
  }
}
