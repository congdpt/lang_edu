import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'controller/file_controller.dart';
import 'models/category.dart';
import 'models/vocabulary.dart';
import 'views/page/category_screen.dart';
import 'views/page/revew_screen.dart';
import 'views/page/vocabulary_screen.dart';
import 'views/value/app_theme.dart';

const List<Tab> menuItemIcon = <Tab>[
  Tab(text: 'Review'),
  Tab(text: 'Vocabulary'),
  Tab(text: 'Category')
];

class StaticVariable extends ChangeNotifier {
  static List<Category> listCategory = [];
  static List<String> listCateg = [];
  static Map<int, String> categMapData = {};
  static List<Vocabulary> allListVocabulary = [];
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ).then(
    (_) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login and Register UI',
      theme: AppTheme.themeData,
      initialRoute: AppRoutes.loginScreen,
      navigatorKey: AppConstants.navigationKey,
      routes: {
        AppRoutes.loginScreen: (context) => const LoginPage(),
        AppRoutes.registerScreen: (context) => const RegisterPage(),
      },
    );
  }
}

// void main() => runApp(ChangeNotifierProvider(
//       create: (context) => StaticVariable(),
//       child: MaterialApp(
//         title: "Lang Edu",
//         home: const HomePage(),
//         debugShowCheckedModeBanner: false,
//         // theme: ThemeData.light(useMaterial3: true),
//         theme: ThemeData(primarySwatch: Colors.deepOrange),
//       ),
//     ));

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int menuIndex = 0;

  static const drawerHeader = UserAccountsDrawerHeader(
    accountName: Text(
      'Amy Yang',
    ),
    accountEmail: Text(
      'amy.huynhtrang@gmail.com',
    ),
    currentAccountPicture: CircleAvatar(
      child: FlutterLogo(size: 42.0),
    ),
  );

  fetchData() async {
    if (StaticVariable.listCategory.isEmpty) {
      try {
        StaticVariable.listCategory = await FileManager().readCategoryFile();
        StaticVariable.allListVocabulary =
            await FileManager().readVocabularyFile();
        StaticVariable.listCateg =
            Category.getName(StaticVariable.listCategory).values.toList();
        StaticVariable.categMapData =
            Category.getName(StaticVariable.listCategory);
        setState(() {});
      } catch (e) {
        debugPrint("Couldn't read file");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // fetchData();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lang Edu',
        ),
      ),
      body: Semantics(
        container: true,
        child: Center(
          child: (menuIndex == 1)
              ? const VocabularyPage()
              : (menuIndex == 2)
                  ? const CategoryPage()
                  : const ReviewPage(),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            drawerHeader,
            ListTile(
              title: const Text(
                'Review',
              ),
              leading: const Icon(Icons.rate_review),
              onTap: () {
                setState(() {
                  menuIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                'Vocabulary',
              ),
              leading: const Icon(Icons.wordpress),
              onTap: () {
                setState(() {
                  menuIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                'Category',
              ),
              leading: const Icon(Icons.category),
              onTap: () {
                setState(() {
                  menuIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
