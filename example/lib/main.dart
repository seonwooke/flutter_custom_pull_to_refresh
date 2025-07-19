import 'package:example/constants/dummy_data.dart';
import 'package:example/models/person_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_pull_to_refresh/flutter_custom_pull_to_refresh.dart';

void main() => runApp(FlutterCustomPullToRefreshDemo());

class FlutterCustomPullToRefreshDemo extends StatefulWidget {
  @override
  State<FlutterCustomPullToRefreshDemo> createState() =>
      _FlutterCustomPullToRefreshDemoState();
}

class _FlutterCustomPullToRefreshDemoState
    extends State<FlutterCustomPullToRefreshDemo> {
  List<PersonModel> dummyData = DummyData.dummyData;
  bool isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'flutter_custom_pull_to_refresh',
          ),
        ),
        body: CustomPullToRefresh(
          onRefresh: _onRefreshExample,
          isRefreshing: isRefreshing,
          child: _buildChildExample(),
        ),
      ),
    );
  }

  Widget _buildChildExample() {
    return ListView.builder(
      itemCount: dummyData.length,
      itemBuilder: (context, index) {
        final person = dummyData[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Color(person.backgroundColor),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.grey),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${person.name}'),
                Text('Age: ${person.age}'),
                Text('Email: ${person.email}'),
                Text('Address: ${person.address}'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onRefreshExample() {
    setState(() {
      isRefreshing = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        dummyData.insert(
          0,
          PersonModel(
            name: 'New Person',
            age: 20,
            email: 'new.person@example.com',
            address: '123 Main St, Anytown, USA',
            backgroundColor: 0XFFE4E1,
          ),
        );
        isRefreshing = false;
      });
    });
  }
}
