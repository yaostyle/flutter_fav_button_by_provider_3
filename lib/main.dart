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

class FavButton extends StatelessWidget {
  const FavButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fav = Provider.of<Fav>(context);
    return Container(
      color: Colors.pink,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: Provider.of<Fav>(context).update,
              child: Icon(
                fav.status != null && fav.status == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                size: 300.0,
                color: Colors.white,
              ),
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
