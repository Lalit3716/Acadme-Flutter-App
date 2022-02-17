import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import "../constant.dart";
import '../providers/auth.dart';
import '../models/resources.dart';
import '../widgets/resource_list.dart';
import './library.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final routes = <Widget>[
    const Main(),
    const Library(),
  ];

  final PageController _pageController = PageController(initialPage: 0);

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (ctx, auth, _) => Scaffold(
        drawer: Drawer(
          child: ListView(children: <Widget>[
            DrawerHeader(
              child: Container(
                alignment: Alignment.topLeft,
                child: auth.isAuth
                    ? Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: CircleAvatar(
                              backgroundImage:
                                  Image.network(auth.user!.avatar).image,
                              radius: 30,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              auth.user!.username,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
                auth.logout();
              },
            ),
          ]),
        ),
        appBar: AppBar(
          title: const Text("Acadme"),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for resources',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.tune_rounded),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: routes,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage,
          onTap: (int index) {
            setState(() {
              _currentPage = index;
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: "Library",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
        floatingActionButton: _currentPage != 1
            ? FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  Future<List<Resource>> getResources() async {
    final uri = Uri.parse("${Constants.serverUrl}/resources");

    final response = await http.get(uri);

    final List<dynamic> jsonResponse = jsonDecode(response.body);

    final resources =
        jsonResponse.map((json) => Resource.fromJSON(json)).toList();

    return resources;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Resource>>(
      future: getResources(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ResourceList(resources: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
