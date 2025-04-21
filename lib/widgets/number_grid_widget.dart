import 'package:flutter/material.dart';

class NumberGrid extends StatelessWidget {
  final List<int> numbersList;
  final Set<int> highlightedIndices;

  const NumberGrid({required this.numbersList, required this.highlightedIndices, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: numbersList.length,
        itemBuilder: (context, index) {
          final number = numbersList[index];
          final isHighlighted = highlightedIndices.contains(index);
          final color = isHighlighted ? Colors.red : Colors.orange;
          final boxHeight = isHighlighted ? 100.0 : 50.0;

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 400 + index * 30),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  height: boxHeight,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    number.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
    });
  }
}
