import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oil_and_gas_unit_converter/src/data/conversions.dart';
import 'package:oil_and_gas_unit_converter/src/model/converter.dart';
import 'package:oil_and_gas_unit_converter/src/utils/app_constants.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = 'Oil and Gas Converter';
  final double screenPadding = AppConstants.screenPadding;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil()..init(context);

    print(
        'Screen size is ${MediaQuery.of(context).size} on ${Platform.operatingSystem}');

    return ChangeNotifierProvider<Converter>(
      builder: (context) => Converter(),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(18, 22, 28, 1),
        drawer: Drawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(title),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(screenPadding),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ScreenUtil.getInstance().setHeight(50.0),
                    ),
                    child: ConversionTopPanel(),
                  ),
                  ConversionCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ConversionTopPanel extends StatelessWidget {
  const ConversionTopPanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final converter = Provider.of<Converter>(context);
    final currentConversionCategory = converter.currentConversionCategory;
    final conversionCategoriesList = converter.conversionCategoriesList;
    final conversionCategoriesMap = converter.conversionCategoriesMap;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Convert',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil(allowFontScaling: false).setSp(80),
          ),
        ),
        SizedBox(
          width: ScreenUtil.getInstance().setWidth(50.0),
        ),
        Flexible(
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade500, width: 0.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: DropdownButton<Conversions>(
                  style: TextStyle(color: Colors.red),
                  value: currentConversionCategory,
                  key: Key('conversionCategoryDropdown'),
                  isDense: true,
                  iconEnabledColor: Colors.grey.shade800,
                  underline: Container(),
                  onChanged: (value) {
                    converter.currentConversionCategory = value;
                  },
                  items: conversionCategoriesList.map((conversionCategory) {
                    String conversionCategoryText =
                        conversionCategoriesMap[conversionCategory];

                    return DropdownMenuItem(
                      key: Key(conversionCategoryText),
                      value: conversionCategory,
                      child: Text(
                        conversionCategoryText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList()),
            ),
          ),
        ),
      ],
    );
  }
}

class ConversionCard extends StatelessWidget {
  ConversionCard({
    Key key,
  }) : super(key: key);

  final double screenPadding = AppConstants.screenPadding;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0.0),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ScreenUtil.getInstance()
                    .setWidth(ScreenUtil().width - (2 * screenPadding)),
                minWidth: ScreenUtil.getInstance()
                    .setWidth(ScreenUtil().width - (2 * screenPadding)),
                minHeight: ScreenUtil.getInstance().setWidth(
                        ((ScreenUtil().width - (2 * screenPadding)) / 2)) -
                    (ScreenUtil.getInstance().setHeight(120)),
              ),
              child: ConversionBox(
                top: true,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Divider(),
                Align(
                  alignment: Alignment(0.8, 0.0),
                  child: SizedBox(
                      height: ScreenUtil.getInstance().setHeight(120),
                      width: ScreenUtil.getInstance().setHeight(120),
                      child: RoundConverterIcon()),
                )
              ],
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ScreenUtil.getInstance()
                    .setWidth(ScreenUtil().width - (2 * screenPadding)),
                minWidth: ScreenUtil.getInstance()
                    .setWidth(ScreenUtil().width - (2 * screenPadding)),
                minHeight: ScreenUtil.getInstance().setWidth(
                        ((ScreenUtil().width - (2 * screenPadding)) / 2)) -
                    (ScreenUtil.getInstance().setHeight(120)),
              ),
              child: ConversionBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class ConversionBox extends StatelessWidget {
  ConversionBox({
    Key key,
    this.top = false,
  }) : super(key: key);

  final double screenPadding = AppConstants.screenPadding;
  final bool top;

  @override
  Widget build(BuildContext context) {
    final converter = Provider.of<Converter>(context);
    List conversionUnitTypes = converter.conversionUnitTypes;
    Map conversionStringValueMap = converter.conversionStringValueMap;
    dynamic conversionToUnitValue = converter.currentToUnit;
    dynamic conversionFromUnitValue = converter.currentFromUnit;

    return Padding(
      padding: EdgeInsets.only(
          top: top == true ? 1.5 * screenPadding : screenPadding / 4,
          bottom: top == true ? screenPadding / 4 : 1.5 * screenPadding,
          right: 1.5 * screenPadding,
          left: 1.5 * screenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: DropdownButton(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil(allowFontScaling: false).setSp(50),
                    ),
                    value: top == true
                        ? conversionToUnitValue
                        : conversionFromUnitValue,
                    key: Key(
                        '${top == true ? 'from' : 'to'}ConversionCategoryUnitDropDown'),
                    isDense: true,
                    isExpanded: true,
                    iconEnabledColor: Colors.grey.shade800,
                    underline: Container(),
                    onChanged: (value) {
                      top == true
                          ? converter.currentToUnit = value
                          : converter.currentFromUnit = value;
                    },
                    items: conversionUnitTypes.map((conversionUnitType) {
                      String conversionUnitTypeString =
                          conversionStringValueMap[conversionUnitType];
                      return DropdownMenuItem(
                        value: conversionUnitType,
                        key: Key(conversionUnitTypeString),
                        child: Text(
                          conversionUnitTypeString,
                        ),
                      );
                    }).toList()),
              ),
            ],
          ),
          SizedBox(
            height: screenPadding,
          ),
          Text(
            '1 cm per square N - 15, 95940 dynes/cm 2 - 15, 95940 dynes/cm 2',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: ScreenUtil(allowFontScaling: false).setSp(35),
            ),
          ),
          SizedBox(
            height: screenPadding / 2,
          ),
          Text(
            "48484848",
            style: TextStyle(
              fontSize: ScreenUtil(allowFontScaling: false).setSp(85),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundConverterIcon extends StatelessWidget {
  const RoundConverterIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      shape: CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(0, 198, 255, 1),
            Color.fromRGBO(0, 114, 255, 1),
          ],
        )),
        child: RotatedBox(
            quarterTurns: 1,
            child: Icon(
              Icons.compare_arrows,
              size: ScreenUtil.getInstance().setHeight(60.0),
              color: Colors.white,
            )),
      ),
    );
  }
}