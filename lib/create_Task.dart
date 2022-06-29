import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'dart:async';

class TaskForm extends StatefulWidget {
  const TaskForm({Key? key}) : super(key: key);


  @override
  State<TaskForm> createState() => _State();
}

class _State extends State<TaskForm> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  late String _title;
  late Category? category;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new task'),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildTitleField(),
            _buildDropDownButton(),
            _buildSubmitButton()
          ],
        )
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Title'),
      validator: (String? value) {
        if (value == null) {
          return 'Value is null';
        }
        if (value.isEmpty) {
          return 'Value is empty';
        }
        _title = value;
        return null;
      },
    );
  }

  Widget _buildDropDownButton() {

    return DropdownButton<Category>(
        items: Category.values.map((Category category) {
          return DropdownMenuItem<Category>(
            value: category,
            child: Text(category.toString()),
          );

        }).toList(),
        onChanged: (Category? newcategory) {
          setState(() {
            category = newcategory;
          });
      });
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if(_formKey.currentState!.validate()) {
          FirebaseFirestore.instance.collection('tasks').add({'title': _title, 'category': category.toString(), 'user': loggedinUser.email});
          Navigator.pushNamed(context, 'home_screen');
        }
      },
      child: const Text('Next'),
    );
  }




}
