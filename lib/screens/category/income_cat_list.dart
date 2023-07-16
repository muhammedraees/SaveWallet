import 'package:flutter/material.dart';

import 'package:mm_helper/db/category/category_db.dart';
import 'package:mm_helper/model/category/category_model.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDb().incomeCategoryListListener,
      builder: (BuildContext ctx, List<CategoryModel> newlist, Widget? _) {
        if (newlist.isEmpty) {
          return const Center(
            child: Text(
              'Income Category is Empty',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          itemBuilder: (ctx, index) {
            final category = newlist[index];
            return Card(
              child: ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text(
                              'Are you sure you want to delete this category?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                CategoryDb.instance.deleteCategory(category.id);
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Category deleted'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemCount: newlist.length,
        );
      },
    );
  }
}
