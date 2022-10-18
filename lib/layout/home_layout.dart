import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit , AppStates>(
         listener:(BuildContext context,AppStates state) {
           if (state is AppInsertToDatabaseState){
             Navigator.pop(context);
           }
         },
        builder: (BuildContext context,AppStates state)
        {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataFromDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),

            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                    );
                    //   title: titleController.text,
                    //   time: timeController.text,
                    //   date: dateController.text,
                    // ).then((value) {
                    //   getDataFromDatabase(database).then((value)
                    //   {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   isBottomSheetShown = false;
                    //     //   fabIcon = Icons.edit;
                    //     //   tasks = value;
                    //     //   print(tasks);
                    //     // });
                    //   });
                    // });
                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(
                        20.0,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              onFieldSubmitted: (value) {
                                print(value);
                              },
                              onChanged: (value) {
                                print(value);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Title must not be empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Task title',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.title,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              controller: timeController,
                              keyboardType: TextInputType.datetime,
                              onFieldSubmitted: (value) {
                                print(value);
                              },
                              onTap: () {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                    .then((value) {
                                  timeController.text =
                                      value!.format(context).toString();
                                  print(value?.format(context));
                                });
                              },
                              onChanged: (value) {
                                print(value);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Time must not be empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Task time',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.watch_later_outlined,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              onFieldSubmitted: (value) {
                                print(value);
                              },
                              onChanged: (value) {
                                print(value);
                              },
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-11-11'),
                                ).then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Date must not be empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Task date',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  ).closed.then((value)
                  {
                    cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit
                    );
                  });
                  cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add
                  );
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }




}



