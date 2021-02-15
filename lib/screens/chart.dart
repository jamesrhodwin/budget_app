import 'package:budget_app/service/item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Item> _itemList;
  var date = DateTime.now();
  Chart(this._itemList);
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = date.subtract(Duration(days: index));

      var totalSum = 0.0;
      for (var i = 0; i < _itemList.length; i++) {
        if (weekDay.day ==
                DateFormat("yyyy-MM-dd hh:mm:ss")
                    .parse(_itemList[i].item_date)
                    .day &&
            weekDay.month ==
                DateFormat("yyyy-MM-dd hh:mm:ss")
                    .parse(_itemList[i].item_date)
                    .month &&
            weekDay.year ==
                DateFormat("yyyy-MM-dd hh:mm:ss")
                    .parse(_itemList[i].item_date)
                    .year) {
          totalSum += _itemList[i].item_amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'item_amount': totalSum
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['item_amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              width: 300.0,
              child: Text(
                'Weekly Spending',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      date = date.subtract(new Duration(days: 7));
                    });
                  },
                ),
                Text(
                  " ${DateFormat.yMMMMd('en_US').format(date.subtract(Duration(days: 7))).toString()} " +
                      " - "
                          " ${DateFormat.yMMMMd('en_US').format(date).toString()}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      date = date.add(new Duration(days: 7));
                    });
                  },
                ),
              ],
            ),
            Card(
              elevation: 6,
              margin: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: groupedTransactionValues.map((expense) {
                    return Container(
                        padding: EdgeInsets.all(10),
                        child: ChartBar(
                            day: expense['day'],
                            category_max_budget: expense['item_amount'],
                            percentage: maxSpending != 0
                                ? (expense['item_amount'] as double) /
                                    maxSpending
                                : 0.0));
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class ChartBar extends StatelessWidget {
  final String day;
  final double category_max_budget;
  final double percentage;

  ChartBar({this.category_max_budget, this.day, this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      FittedBox(child: Text('₱' + category_max_budget.toStringAsFixed(0))),
      SizedBox(
        height: 10,
      ),
      RotatedBox(
        quarterTurns: 2,
        child: Container(
          width: 10,
          height: 100,
          color: Color.fromRGBO(220, 220, 220, 1),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FractionallySizedBox(
                  heightFactor: percentage,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Text(this.day)
    ]);
  }
}
