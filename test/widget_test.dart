import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Cinema stub renders headline', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Добро пожаловать в кино'),
          ),
        ),
      ),
    );

    expect(find.text('Добро пожаловать в кино'), findsOneWidget);
  });
}
