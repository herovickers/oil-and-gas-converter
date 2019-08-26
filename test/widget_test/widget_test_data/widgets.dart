import 'package:flutter/material.dart';
import 'package:oil_and_gas_unit_converter/src/ui/home_page.dart';

import 'finders.dart';

DropdownButton conversionCategoryDropdownWidget =
    conversionCategoryDropdownFinder.evaluate().single.widget as DropdownButton;

DropdownButton fromUnitDropdownWidget = fromConversionCategoryUnitDropdownFinder
    .evaluate()
    .single
    .widget as DropdownButton;

DropdownButton toUnitDropdownWidget = toConversionCategoryUnitDropdownFinder
    .evaluate()
    .single
    .widget as DropdownButton;

class HomePageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oil and Gas Converter',
      home: HomePage(),
    );
  }
}