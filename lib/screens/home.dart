import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/resources.dart';

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
      appBar: AppBar(
        title: const Text("Acadme"),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundImage: Image.asset('assets/images/avatar.jpg').image,
              radius: 20,
            ),
          ),
        ],
        bottom: AppBar(
          title: const SizedBox(
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
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final resource = snapshot.data![index];

                return Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height / 3,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    elevation: 10,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: resource.thumbnail != null
                              ? Image.network(
                                  resource.thumbnail!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                )
                              : Image.asset(
                                  'assets/images/note-taking.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          width: double.infinity,
                          child: Text(
                            resource.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 5,
                            bottom: 5,
                          ),
                          width: double.infinity,
                          child: Text(
                            resource.description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            // Upvote and Downvote Icons
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.thumb_up),
                                  onPressed: () {},
                                ),
                                Text(
                                  resource.upvotes.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.thumb_down),
                                  onPressed: () {},
                                ),
                                Text(
                                  resource.downvotes.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
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
