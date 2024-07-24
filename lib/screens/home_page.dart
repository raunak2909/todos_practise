import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todos_practise/app_widgets/my_outlined_custom_btn.dart';
import 'package:todos_practise/firebase_repo/firebase_repository.dart';
import 'package:todos_practise/utils/util_helper.dart';

import '../models/todo_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoModel> listTodo = [];
  String selectedPriority = "High";

  List<String> listPriority = [
    "High",
    "Medium",
    "Low",
  ];

  var titleController = TextEditingController();

  var descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
            text: TextSpan(text: "ToDo", style: mTextStyle16(), children: [
              TextSpan(
                  text: " Manager",
                  style: mTextStyle16(
                      mFontWeight: FontWeight.bold, mColor: Colors.blue))
            ])),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseRepository.fetchAllTodo(),
          builder: (_, snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            listTodo.clear();
            for(QueryDocumentSnapshot<Map<String, dynamic>> eachDoc in snapshot.data!.docs){
              listTodo.add(TodoModel.fromDoc(eachDoc.data()));
            }


            return listTodo.isNotEmpty
                ? ListView.builder(
                itemCount: listTodo.length,
                itemBuilder: (_, index) {

                  var myFormat = DateFormat.yMMMMEEEEd();

                  var assignTime = myFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(listTodo[index].assignedAt!)));
                  var completedTime = listTodo[index].completedAt != "" ? myFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(listTodo[index].assignedAt!))) : "";

                  return Card(
                    color: getBackgroundColor(listTodo[index].priority!),
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          side: BorderSide(
                              color: Colors.white,
                              width: 2
                          ),
                          checkColor: Colors.white,
                          value: listTodo[index].isCompleted,
                          onChanged: (value) {
                            FirebaseRepository.markTodoStatus(listTodo[index].todoId!, value!);
                          },
                          title: Text(
                            listTodo[index].title!,
                            style: mTextStyle16(mColor: Colors.white).copyWith(
                              decorationColor: Colors.white,
                                decoration: listTodo[index].isCompleted!
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                          subtitle: Text(
                            listTodo[index].desc!,
                            style: mTextStyle12(mColor: Colors.white).copyWith(
                                decorationColor: Colors.white,
                                decoration: listTodo[index].isCompleted!
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 11.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(text:
                              TextSpan(text: "Assigned at: ", style: mTextStyle12(mColor: Colors.white, mFontWeight: FontWeight.bold), children: [
                                TextSpan(text: assignTime, style: mTextStyle12(mColor: Colors.white)),
                              ]),
                              )
                            ],
                          ),
                        ),
                        completedTime != "" ?Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 11.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(text:
                              TextSpan(text: "Completed at: ", style: mTextStyle12(mColor: Colors.white, mFontWeight: FontWeight.bold), children: [
                                TextSpan(text: completedTime, style: mTextStyle12(mColor: Colors.white)),
                              ]),
                              )
                            ],
                          ),
                        ) : Container()
                      ],
                    ),
                  );
                })
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Todo's yet",
                    style: mTextStyle16(mColor: Colors.grey.shade400),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  MyOutlinedCustomBtn(
                      title: "Add now +",
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) {
                              return bottomSheetContent(context);
                            });
                      })
                ],
              ),
            );
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) {
                return bottomSheetContent(context);
              });
        },
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        splashColor: Colors.blue,
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.add),
      ),
    );
  }

  Color getBackgroundColor(int priority) {
    if (priority == 3) {
      return Colors.blue;
    } else if (priority == 2) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget bottomSheetContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 11,
          left: 11,
          right: 11,
          bottom: 11 + MediaQuery
              .of(context)
              .viewInsets
              .bottom),
      width: double.infinity,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.5 +
          MediaQuery
              .of(context)
              .viewInsets
              .bottom,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.blue,
                  size: 16,
                ),
              ),
              SizedBox(
                width: 11,
              ),
              Text(
                'Add ToDo',
                style: mTextStyle16(
                    mColor: Colors.blue, mFontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 21,
          ),
          TextField(
            controller: titleController,
            style: mTextStyle16(),
            decoration: InputDecoration(
                hintText: "Enter title here",
                label: Text(
                  'Title',
                  style: mTextStyle16(mColor: Colors.blue),
                ),
                hintStyle: mTextStyle16(mColor: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ))),
          ),
          SizedBox(
            height: 11,
          ),
          TextField(
            controller: descController,
            style: mTextStyle16(),
            decoration: InputDecoration(
                hintText: "Enter desc here",
                label: Text(
                  'Desc',
                  style: mTextStyle16(mColor: Colors.blue),
                ),
                hintStyle: mTextStyle16(mColor: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ))),
          ),
          SizedBox(
            height: 11,
          ),
          DropdownMenu(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 22,
              textStyle: mTextStyle16(),
              onSelected: (value){
                selectedPriority = value!;
              },
              selectedTrailingIcon: Icon(Icons.low_priority_outlined),
              trailingIcon: Icon(
                Icons.arrow_drop_down_circle_rounded,
                color: Colors.blue,
              ),
              label: Text(
                "Priority",
                style: mTextStyle16(mColor: Colors.blue),
              ),
              dropdownMenuEntries: listPriority
                  .map((priority) =>
                  DropdownMenuEntry(
                      label: priority,
                      value: priority,
                      style: ButtonStyle(
                          textStyle: MaterialStateTextStyle.resolveWith(
                                  (states) => mTextStyle12()))))
                  .toList()),
          SizedBox(
            height: 11,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MyOutlinedCustomBtn(title: "Add", onPressed: () {
                //adding the todo

                var todoModel = TodoModel(
                    title: titleController.text.toString(),
                    desc: descController.text.toString(),
                    priority: selectedPriority=="High" ? 1 : (selectedPriority=="Medium" ? 2 : 3),
                    assignedAt: DateTime.now().millisecondsSinceEpoch.toString()
                );

                FirebaseRepository.addTodo(todoModel);

                Navigator.pop(context);
              }),
              MyOutlinedCustomBtn(
                  title: "Cancel",
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          )
        ],
      ),
    );


  }
}


enum Directions{
  North, South, East, West
}

///weekdays
///months