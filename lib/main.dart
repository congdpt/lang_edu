import 'package:flutter/material.dart';
import 'package:lang_edu/controller/file_controller.dart';
import 'package:lang_edu/models/category.dart';
import 'package:lang_edu/models/vocabulary.dart';
import 'views/page_category.dart';
import 'views/page_revew.dart';
import 'views/page_vocabulary.dart';

const List<Tab> menuItemIcon = <Tab>[
  Tab(text: 'Review'),
  Tab(text: 'Vocabulary'),
  Tab(text: 'Category')
];

void main() => runApp(MaterialApp(
      title: "Lang Edu",
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.light(useMaterial3: true),
      theme: ThemeData(primarySwatch: Colors.lightBlue),
    ));

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;
  int menuIndex = 0;
  List<Category> listCategory = [];
  List<String> listCateg = [];
  List<Vocabulary> allListVocabulary = [];

  fetchData() async {
    if (listCategory.isEmpty) {
      try {
        listCategory = await FileManager().readCategoryFile();
        allListVocabulary = await FileManager().readVocabularyFile();
        listCateg = Category.getName(listCategory).values.toList();
        setState(() {});
      } catch (e) {
        debugPrint("Couldn't read file");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    // _tabController.addListener(() {
    //   setState(() {});
    // });
    fetchData();
  }

  @override
  void dispose() {
    debugPrint('Tao tab dispose ne!');
    // _tabController.removeListener(() {
    //   setState(() {});
    // });
    // _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return DefaultTabController(
    //     length: menuItemIcon.length,
    //     child: Builder(builder: (BuildContext context) {
    //       final TabController tabController = DefaultTabController.of(context);
    //       tabController.addListener(() {
    //         if (!tabController.indexIsChanging) {
    //           // Your code goes here.
    //           // To get index of current tab use tabController.index
    //         }
    //       });
    //       return SafeArea(
    //         maintainBottomViewPadding: false,
    //         top: false,
    //         bottom: false,
    //         child: Scaffold(
    //           appBar: PreferredSize(
    //             preferredSize: const Size.fromHeight(48.0),
    //             child: AppBar(
    //               title: const Text("Lang Edu"),
    //               backgroundColor: Colors.cyan,
    //               bottom: TabBar(
    //                 tabs: menuItemIcon,
    //                 controller: _tabController,
    //               ),
    //             ),
    //           ),
    //           body: FutureBuilder(
    //               future: fetchData(),
    //               builder: (context, snapshot) {
    //                 return TabBarView(
    //                   controller: _tabController,
    //                   children: [
    //                     ReviewPage(
    //                         allListVocabulary: allListVocabulary,
    //                         listCategory: listCategory,
    //                         listCategStr: listCateg),
    //                     VocabularyPage(
    //                         allListVocabulary: allListVocabulary,
    //                         listCategory: listCategory,
    //                         listCategStr: listCateg),
    //                     CategoryPage(listCategory: listCategory),
    //                   ],
    //                 );
    //               }),
    //           drawer: const Drawer(),
    //         ),
    //       );
    //     }));

    const drawerHeader = UserAccountsDrawerHeader(
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
              ? VocabularyPage(
                  allListVocabulary: allListVocabulary,
                  listCategory: listCategory,
                  listCategStr: listCateg)
              : (menuIndex == 2)
                  ? CategoryPage(listCategory: listCategory)
                  : ReviewPage(
                      allListVocabulary: allListVocabulary,
                      listCategory: listCategory,
                      listCategStr: listCateg),
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
                menuIndex = 0;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                'Vocabulary',
              ),
              leading: const Icon(Icons.wordpress),
              onTap: () {
                menuIndex = 1;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                'Category',
              ),
              leading: const Icon(Icons.category),
              onTap: () {
                menuIndex = 2;
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
