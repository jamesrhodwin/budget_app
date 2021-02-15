import 'package:budget_app/screens/home.dart';
import 'package:budget_app/screens/itemlist.dart';
import 'package:budget_app/service/category.dart';
import 'package:budget_app/service/categoryService.dart';
import 'package:budget_app/service/item.dart';
import 'package:budget_app/service/itemService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ItemScreen extends StatefulWidget {
  final int item_id;
  String item_name;
  int category_max_budget;
  int category_rem_budget;
  ItemScreen(this.item_id, this.item_name, this.category_max_budget,
      this.category_rem_budget);

  @override
  ItemScreenState createState() => ItemScreenState();
}

class ItemScreenState extends State<ItemScreen> {
  var item;
  var category;
  var totalSum = 0;
  List<Item> _itemList = List<Item>();
  @override
  void initState() {
    super.initState();
    getAllItems();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  getAllItems() async {
    _itemList = List<Item>();
    var items = await _itemService.readItem(widget.item_id);
    items.forEach((item) {
      setState(() {
        var itemModel = Item();
        itemModel.item_name = item['item_name'];
        itemModel.item_id = item['item_id'];
        itemModel.item_amount = item['item_amount'];
        itemModel.item_date = item['item_date'];
        itemModel.category_id = item['category_id'];
        _itemList.add(itemModel);
      });
    });
    totalSum = 0;
    for (var i = 0; i < _itemList.length; i++) {
      setState(() {
        totalSum += _itemList[i].item_amount;
      });
    }

    updateBudget();
  }

  var _category = Category();
  updateBudget() async {
    _category.category_id = widget.item_id;
    _category.category_name = widget.item_name;
    _category.category_max_budget = widget.category_max_budget;
    _category.category_rem_budget = widget.category_max_budget - totalSum;
    var result = await _categoryService.updateCategory(_category);
    print(_category.category_max_budget);
    print(_category.category_rem_budget);
  }

  var _itemService = ItemService();
  var _item = Item();
  var itemNameController = TextEditingController();
  var itemAmountController = TextEditingController();
  var editItemNameController = TextEditingController();
  var editItemAmountController = TextEditingController();
  DateTime chosenDate;
  var _categoryService = CategoryService();

  _deleteItem(BuildContext context, itemId) async {
    _deleteFormDialog(context, itemId);
  }

  _editItem(BuildContext context, itemId) async {
    item = await _itemService.readItemById(itemId);
    setState(() {
      editItemNameController.text = item[0]['item_name'] ?? 'No Name';
      editItemAmountController.text =
          item[0]['item_amount'].toString() ?? 'No Budget';
      chosenDate =
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(item[0]['item_date']);
    });
    _editFormDialog(context);
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Item Form'),
              content: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  TextField(
                    style: TextStyle(),
                    decoration: InputDecoration(
                      labelText: 'New Item Name',
                    ),
                    controller: editItemNameController,
                  ),
                  TextField(
                    //temporary ra ning textfeild kay wa pako kabaw
                    decoration: InputDecoration(
                      labelText: 'New Budget',
                    ),
                    controller: editItemAmountController,
                    keyboardType: TextInputType.number,
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            chosenDate == null
                                ? 'No Date Chosen'
                                : DateFormat.yMd().format(chosenDate),
                          ),
                        ),
                        FlatButton(
                          child: Text(
                            'Choose Date',
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                          onPressed: () async {
                            var pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1999),
                                lastDate: DateTime.now());
                            if (pickedDate != null) {
                              chosenDate = pickedDate;
                              setState(() {
                                chosenDate = pickedDate;
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  RaisedButton(
                      color: Colors.blueGrey,
                      child: Text('Update'),
                      textColor: Colors.white,
                      onPressed: () async {
                        if (editItemNameController.text.isEmpty ||
                            editItemAmountController.text.isEmpty ||
                            chosenDate == null) {
                          return;
                        } else if (widget.category_rem_budget <= 0 ||
                            int.parse(editItemAmountController.text) >
                                widget.category_rem_budget) {
                          return;
                        } else {
                          _item.item_id = item[0]['item_id'];
                          _item.item_name = editItemNameController.text;
                          _item.item_amount =
                              int.parse(editItemAmountController.text);
                          _item.item_date = chosenDate.toString();
                          _item.category_id = item[0]['category_id'];
                          print(_item.item_id);
                          print(_item.item_name);
                          print(_item.item_amount);
                          var result = await _itemService.updateItem(_item);
                          Navigator.of(context).pop();
                          getAllItems();
                        }
                      })
                ],
              )),
            );
          });
        });
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Item Form'),
              content: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  TextField(
                    style: TextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Item Name',
                    ),
                    controller: itemNameController,
                  ),
                  TextField(
                    //temporary ra ning textfeild kay wa pako kabaw
                    decoration: InputDecoration(
                      labelText: 'Enter Amount',
                    ),
                    controller: itemAmountController,
                    keyboardType: TextInputType.number,
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            chosenDate == null
                                ? 'No Date Chosen'
                                : DateFormat.yMd().format(chosenDate),
                          ),
                        ),
                        FlatButton(
                          child: Text(
                            'Choose Date',
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                          onPressed: () async {
                            var pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1999),
                                lastDate: DateTime.now());
                            if (pickedDate != null) {
                              chosenDate = pickedDate;
                              setState(() {
                                chosenDate = pickedDate;
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  RaisedButton(
                      color: Colors.blueGrey,
                      child: Text('Add Item'),
                      textColor: Colors.white,
                      onPressed: () async {
                        if (itemNameController.text.isEmpty ||
                            itemAmountController.text.isEmpty ||
                            chosenDate == null) {
                          return;
                        } else if (widget.category_rem_budget <= 0 ||
                            int.parse(itemAmountController.text) >
                                widget.category_rem_budget) {
                          return;
                        } else {
                          _item.item_name = itemNameController.text;
                          _item.item_amount =
                              int.parse(itemAmountController.text);
                          _item.item_date = chosenDate.toString();
                          _item.category_id = widget.item_id;
                          var result = await _itemService.saveItem(_item);
                          Navigator.of(context).pop();
                          getAllItems();
                          itemNameController.text = '';
                          itemAmountController.text = '';
                          chosenDate = null;
                        }
                      })
                ],
              )),
            );
          });
        });
  }

  _deleteFormDialog(BuildContext context, itemId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              RaisedButton(
                  color: Colors.red[200],
                  child: Text('Delete'),
                  textColor: Colors.white,
                  onPressed: () async {
                    var result = await _itemService.deleteItem(itemId);
                    Navigator.pop(context);
                    getAllItems();
                  }),
              RaisedButton(
                  color: Colors.blueGrey,
                  child: Text('Cancel'),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
            title: Text('Are you sure?'),
          );
        });
  }

  // List<Item> get getExpenses {
  //   return _itemList.where((expense) {}).toList();
  // // }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blueGrey[200],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[600],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Home())),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _showFormDialog(context);
                })
          ],
          title: Text(
            widget.item_name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SizedBox.expand(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    width: 250,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircularPercentIndicator(
                      lineWidth: 20.0,
                      radius: 230.0,
                      animation: true,
                      animateFromLastPercent: true,
                      animationDuration: 1200,
                      percent: (widget.category_max_budget - totalSum) /
                          widget.category_max_budget,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Remaining Budget',
                              style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontSize: 15,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (widget.category_max_budget - totalSum)
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.blueGrey[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              Text("/",
                                  style: TextStyle(
                                    color: Colors.blueGrey[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  )),
                              Text(widget.category_max_budget.toString(),
                                  style: TextStyle(
                                    color: Colors.blueGrey[800],
                                    fontSize: 25,
                                  ))
                            ],
                          ),
                        ],
                      ),
                      progressColor: Colors.orange,
                      circularStrokeCap: CircularStrokeCap.round,
                    )),
              ),
              ItemList(_itemList, _deleteItem, _editItem),
            ],
          ),
        ));
  }
}
