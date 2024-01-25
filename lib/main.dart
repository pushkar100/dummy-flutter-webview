// import 'package:web_view_package/web_view_package.dart';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:webview_flutter/webview_flutter.dart';
// webview_flutter import for Android features:
import 'package:webview_flutter_android/webview_flutter_android.dart';
// webview_flutter import for iOS features:
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
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

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.access_time),
                  label: Text('Web View Test'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
                print('selected: $value');
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase,
            style: style, semanticsLabel: pair.asPascalCase),
      ),
    );
  }
}

// class FancyScreen extends StatefulWidget {
//   const FancyScreen({Key? key}) : super(key: key);

//   @override
//   State<FancyScreen> createState() => _FancyScreenState();
// }

// class _FancyScreenState extends State<FancyScreen> {
//   var message = '';
//   final IFrameElement _iFrameElement = IFrameElement();

//   @override
//   void initState() {
//     _iFrameElement.style.height = '50%';
//     _iFrameElement.style.width = '50%';
//     _iFrameElement.src =
//         'https://champagne-grapes-orgs.thoughtspotdev.cloud/?embedApp=true&hostAppUrl=adjswk--run.stackblitz.io&viewPortHeight=865&viewPortWidth=1283&sdkVersion=1.26.2&authType=None&blockNonEmbedFullAppAccess=true&hideAction=["reportError"]&isLiveboardEmbed=true&isLiveboardHeaderSticky=true#/embed/viz/419830c7-9f52-4679-bcfc-93b70e6c7372';
//     _iFrameElement.style.border = 'none';

//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry
//         .registerViewFactory('iframeElement', (int ViewId) => _iFrameElement);

//     super.initState();
//   }

//   Widget _iframeWidget = HtmlElementView(
//     viewType: 'iframeElement',
//     key: UniqueKey(),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [SizedBox(height: 500, width: 500, child: _iframeWidget)],
//     ));
//   }
//   /*
//   @override
//   Widget build(BuildContext context) {
//     var controller = WebViewController()

//       // ..loadFlutterAsset("assets/web_view.html")
//       // ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       // ..addJavaScriptChannel(
//       //   "messageHandler",
//       //   onMessageReceived: (JavaScriptMessage javaScriptMessage) {
//       //     print("message from the web view=\"${javaScriptMessage.message}\"");
//       //     setState(() {
//       //       message = javaScriptMessage.message;
//       //     });
//       //   },
//       // );
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             // Update loading bar.
//           },
//           onPageStarted: (String url) {},
//           onPageFinished: (String url) {},
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )

//       // // Sage embed:
//       // ..loadRequest(Uri.parse(
//       //     'https://champagne-grapes-orgs.thoughtspotdev.cloud/?sdkVersion=1.26.2&authType=None&blockNonEmbedFullAppAccess=true&hideAction=["reportError","save","pin","editACopy","saveAsView","updateTSL","editTSL","onDeleteAnswer","share"]&embedApp=true&isSageEmbed=true&disableWorksheetChange=false&hideWorksheetSelector=false&hideEurekaSuggestions=false&hideSampleQuestions=false&isProductTour=false&hideSearchBarTitle=false&hideSageAnswerHeader=false#/embed/eureka?query=total%20sales%20by%20region&worksheet=cd252e5c-b552-49a8-821d-3eadaa049cca&source=TYPED'));

//       // // LB embed:
//       // ..loadRequest(Uri.parse(
//       //     'https://champagne-grapes-orgs.thoughtspotdev.cloud/?embedApp=true&hostAppUrl=sh4acm--run.stackblitz.io&viewPortHeight=865&viewPortWidth=1283&sdkVersion=1.26.2&authType=None&blockNonEmbedFullAppAccess=true&hideAction=["reportError"]&isLiveboardEmbed=true&isLiveboardHeaderSticky=true#/embed/viz/07e595b9-52a9-4190-84d6-30ab480b72f6'));

//       // Large LB embed (>30 vizzes):
//       ..loadRequest(Uri.parse(
//           'https://champagne-grapes-orgs.thoughtspotdev.cloud/?embedApp=true&hostAppUrl=adjswk--run.stackblitz.io&viewPortHeight=865&viewPortWidth=1283&sdkVersion=1.26.2&authType=None&blockNonEmbedFullAppAccess=true&hideAction=["reportError"]&isLiveboardEmbed=true&isLiveboardHeaderSticky=true#/embed/viz/419830c7-9f52-4679-bcfc-93b70e6c7372'));

//     // Widget buildWebView() {
//     //   return WebViewWidget(
//     //     controller: controller,
//     //   );
//     // }

//     // return Scaffold(
//     //     appBar: AppBar(
//     //       title: const Text("HTML-FLUTTER"),
//     //     ),
//     //     body: Column(
//     //       children: [
//     //         SizedBox(height: 300, child: buildWebView()),
//     //         Text("Message from html:$message"),
//     //       ],
//     //     ),
//     //     floatingActionButton: FloatingActionButton(
//     //       child: const Icon(Icons.send),
//     //       onPressed: () {
//     //         controller.runJavaScript(
//     //             'receiveMessageFromFlutter("Hello from Flutter");');
//     //       },
//     //     ));

//     return Scaffold(
//       appBar: AppBar(title: const Text('TSE Flutter Web View')),
//       body: WebViewWidget(controller: controller),
//     );
//   }
//   */
// }
