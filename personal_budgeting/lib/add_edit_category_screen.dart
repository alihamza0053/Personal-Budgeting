// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class AddEditCategoryScreen extends StatefulWidget {
  final QueryDocumentSnapshot? category;
  const AddEditCategoryScreen({super.key, this.category});

  @override
  State<AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  TextEditingController nameContoller = TextEditingController();
  TextEditingController budgetAmountContoller = TextEditingController();
  TextEditingController spentAmountController = TextEditingController();

  var spentVisibility = false;
  var saveUpdate = "Save";
  var appBarTitle = "Add Category";

  @override
  void initState() {
    nameContoller.text =
        widget.category != null ? widget.category!['category_name'] : '';
    budgetAmountContoller.text =
        widget.category != null ? widget.category!['budget_amount'] : '';
    spentAmountController.text =
        widget.category != null ? widget.category!['spent_amount'] : '';
    saveUpdate = widget.category != null ? "Update" : "Save";
    spentVisibility = widget.category != null ? true : false;
    appBarTitle = widget.category != null ? "Edit Category" : "Add Category";

    super.initState();
  }

  @override
  void dispose() {
    nameContoller.dispose();
    budgetAmountContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nameContoller,
                  decoration: const InputDecoration(labelText: "Category Name",),
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: budgetAmountContoller,
                  decoration: const InputDecoration(labelText: "Budget Amount"),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            Visibility(
              visible: spentVisibility,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: spentAmountController,
                    decoration: const InputDecoration(labelText: "Spent Amount"),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueAccent),
                            foregroundColor: MaterialStateProperty.all(Colors.white)),
                    onPressed: () async {
                      if (nameContoller.text.isNotEmpty &&
                          budgetAmountContoller.text.isNotEmpty) {
                        if (widget.category != null) {
                          if (int.parse(spentAmountController.text) <
                              int.parse(budgetAmountContoller.text)) {
                            try {
                              await FirebaseFirestore.instance
                                  .collection("categories")
                                  .doc(widget.category!.id)
                                  .update({
                                'category_name': nameContoller.value.text,
                                'budget_amount':
                                    budgetAmountContoller.value.text,
                                'spent_amount': spentAmountController.value.text
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Data Update Successfully")),
                              );
                              Navigator.pop(context);
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("$error")));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: const Text(
                                    "If you do not have much budget don't try to spend more.")));
                          }
                        } else {
                          try {
                            await FirebaseFirestore.instance
                                .collection("categories")
                                .add({
                              'category_name': nameContoller.value.text,
                              'budget_amount': budgetAmountContoller.value.text,
                              'spent_amount': '0'
                            });
                            nameContoller.clear();
                            budgetAmountContoller.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Data Added Successfully")),
                            );
                            Navigator.pop(context);
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $error")),
                            );
                          }
                        }
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fill data first!")));
                      }
                    },
                    child: Text(saveUpdate),
                  ),
                  const Spacer(),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                              foregroundColor: MaterialStateProperty.all(Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  const Spacer(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
