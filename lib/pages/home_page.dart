import 'package:flutter/material.dart';
import 'package:gini_apps_assignment/widgets/number_grid_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/list_data_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> numbersList = [];

  Set<int> highlightedIndices = {};

  Future<ListData> fetchNumbersList() async {
    final url = Uri.parse('https://pastebin.com/raw/cKT8eYt5');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> rawList = data['numbers'];
      final parsedNumbers = rawList.map<int>((e) => e['number'] as int).toList();
      final highlights = findZeroSumIndices(parsedNumbers);

      return ListData(parsedNumbers, highlights);
    } else {
      throw Exception('Failed to load numbers');
    }
  }

  Set<int> findZeroSumIndices(List<int> nums) {
    Set<int> result = {};
    Map<int, int> valueToIndex = {};

    for (int i = 0; i < nums.length; i++) {
      int currentNum = nums[i];
      if (valueToIndex.containsKey(-currentNum)) {
        result.add(valueToIndex[-currentNum]!);
        result.add(i);
      }
      valueToIndex[currentNum] = i;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder<ListData>(
        future: fetchNumbersList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: NumberGrid(
                numbersList: data.numbers,
                highlightedIndices: data.highlightedIndices,
              ),
            );
          } else {
            return const Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }
}
