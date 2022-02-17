import 'package:flutter/material.dart';

import '../widgets/resource_item.dart';
import '../models/resources.dart';

class ResourceList extends StatelessWidget {
  final List<Resource> resources;

  const ResourceList({Key? key, required this.resources}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return resources.isNotEmpty
        ? ListView.builder(
            itemCount: resources.length,
            itemBuilder: (context, index) {
              final resource = resources[index];

              return ResourceItem(resource: resource);
            },
          )
        : const Center(
            child: Text('No resources found.'),
          );
  }
}
