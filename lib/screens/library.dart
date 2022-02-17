import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../constant.dart';
import '../providers/auth.dart';
import '../models/resources.dart';
import '../widgets/resource_list.dart';

class Library extends StatelessWidget {
  const Library({Key? key}) : super(key: key);

  Future<List<Resource>> getResources(String token) async {
    final uri = Uri.parse("${Constants.serverUrl}/resources/library");

    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    final List<dynamic> jsonResponse = jsonDecode(response.body);

    final resources =
        jsonResponse.map((json) => Resource.fromJSON(json)).toList();

    return resources;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (ctx, auth, _) => FutureBuilder<List<Resource>>(
        future: getResources(auth.token!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ResourceList(resources: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
