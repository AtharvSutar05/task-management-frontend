import 'package:flutter/material.dart';
import 'package:frontend/core/utils.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onTap;
  const DateSelector({super.key, required this.selectedDate, required this.onTap});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {

  int weekOffset = 0;

  @override
  Widget build(BuildContext context) {
    final weekDates = generateWeekDates(weekOffset);
    String monthName = DateFormat('MMMM').format(weekDates.first);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: (){
                setState(() {
                  weekOffset--;
                });
              },
              icon: const Icon(
                Icons.navigate_before,
                size: 32,
                weight: 5,
              ),
            ),
            Text(
              monthName,
              style:const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            IconButton(
              onPressed: (){
                setState(() {
                  weekOffset++;
                });
              },
              icon: const Icon(
                Icons.navigate_next,
                size: 32,
                weight: 5,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 70,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: weekDates.length,
            itemBuilder: (context, index) {
              final date = weekDates[index];
              bool isSelected = DateFormat('d').format(widget.selectedDate) == DateFormat('d').format(date)
                  && widget.selectedDate.month == date.month
                  && widget.selectedDate.year == date.year;
              return GestureDetector(
                onTap: () => widget.onTap(date),
                child: Container(
                  width: 60,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black87 : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('d').format(date),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),
                      ),
                      Text(
                        DateFormat('E').format(date),
                        style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
