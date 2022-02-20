import 'package:flutter/material.dart';

class UnitsButtonsWidget extends StatelessWidget {
  final List<String> units;
  final ValueChanged<String> onSelectedUnit;

  const UnitsButtonsWidget({
    Key? key,
    required this.units,
    required this.onSelectedUnit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).unselectedWidgetColor;
    final allUnits = ['150L', '200L', '250L'];

    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: background,
        ),
        child: ToggleButtons(
          isSelected: allUnits.map((unit) => units.contains(unit)).toList(),
          selectedColor: Colors.white,
          color: Colors.white,
          fillColor: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
          renderBorder: false,
          children: allUnits.map(buildUnit).toList(),
          onPressed: (index) => onSelectedUnit(allUnits[index]),
        ),
      ),
    );
  }

  Widget buildUnit(String text) => Container(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: Text(text),
  );
}