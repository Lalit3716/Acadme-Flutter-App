import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/resources.dart';
import '../widgets/resource_list.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Future<List<Resource>> getResources() async {
    final uri = Uri.parse("http://192.168.29.148:3000/api/resources");

    final response = await http.get(uri);

    final List<dynamic> jsonResponse = jsonDecode(response.body);

    final resources =
        jsonResponse.map((json) => Resource.fromJSON(json)).toList();

    return resources;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(children: <Widget>[
          DrawerHeader(
            child: Container(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundImage:
                          Image.asset("assets/images/avatar.jpg").image,
                      radius: 30,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "John Doe",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
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
      body: FutureBuilder<List<Resource>>(
        future: getResources(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ResourceList(resources: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
