import 'package:flutter/material.dart';
import 'package:peliculas2/providers/movies_provider.dart';
import 'package:peliculas2/screens/screens.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => MoviesProvider(), lazy: false)
    ], child: MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Peliculas 2',
        initialRoute: 'home',
        theme: ThemeData.light()
            .copyWith(appBarTheme: AppBarTheme(color: Colors.indigo)),
        routes: {
          'home': (_) => HomeScreen(),
          'details': (_) => DetailsScreen()
        });
  }
}
