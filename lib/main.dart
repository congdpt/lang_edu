import 'package:flutter/material.dart';
import 'views/page_category.dart';
import 'views/page_revew.dart';
import 'views/page_vocabulary.dart';

List<StatefulWidget> menuItemPage = <StatefulWidget>[
  const VocabularyPage(),
  const ReviewPage(),
  const CategoryPage(),
];

const List<Tab> menuItemIcon = <Tab>[
  Tab(text: 'Vocabulary'),
  Tab(text: 'Review'),
  Tab(text: 'Category')
];

void main() {
  runApp(
    const MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.light(useMaterial3: true),
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      home: DefaultTabController(
          length: menuItemIcon.length,
          child: Builder(builder: (BuildContext context) {
            final TabController tabController =
                DefaultTabController.of(context);
            tabController.addListener(() {
              if (!tabController.indexIsChanging) {
                // Your code goes here.
                // To get index of current tab use tabController.index
              }
            });
            return SafeArea(
              maintainBottomViewPadding: false,
              top: false,
              bottom: false,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(48.0),
                  child: AppBar(
                    bottom: TabBar(
                      tabs: menuItemIcon,
                      controller: _tabController,
                    ),
                  ),
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: menuItemPage.map((page) {
                    return page;
                  }).toList(),
                ),
              ),
            );
          })),
    );
  }
}
