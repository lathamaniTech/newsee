import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:newsee/AppData/newscollections.dart';
import 'package:newsee/AppSamples/ReactiveForms/forms.dart';
import 'package:newsee/AppSamples/RouterApp/routerapp.dart';
import 'package:newsee/AppSamples/ToolBarWidget/toolbar.dart';
import 'package:newsee/DataProviders/db_service.dart';
import 'package:newsee/app.dart';
import 'package:newsee/widgets/counter.dart';
import 'package:newsee/widgets/news.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // runApp(MyApp()) // Default MyApp()
  // runApp(Counter()); // load CounterApp
  // runApp(App()); // timerApp
  // runApp(ToolBarSample()); // Toolbar App
  //runApp(LoginApp()); // Login Form App

  WidgetsFlutterBinding.ensureInitialized(); // Required to use async before runApp
  await DBService.database; // Initializes and creates tables

  // final DBService databaseService = DBService.instance;

  runApp(RouterApp()); // GoRouter Sample App
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    //return wordPair(theme, style);
    return NewsCard(news: news_collections.sublist(0, 7));
  }

  Widget wordPair(dynamic theme, TextStyle style, BuildContext context) {
    return Center(
      child: Column(
        children: [
          Card(
            color: theme.colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(pair.asLowerCase, style: style),
            ),
          ),
          Container(
            // constraints: BoxConstraints.expand(width: 100, height: 100),
            alignment: Alignment.center,
            padding: EdgeInsets.all(0.8),
            margin: EdgeInsets.all(2),
            child: Text(
              """This is a Sample Container,
              This is a Sample Container,This is a Sample Container,
              This is a Sample Container,This is a Sample Container""",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
