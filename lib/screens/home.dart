import 'package:budget_app/service/categoryService.dart';
import 'package:budget_app/service/item.dart';
import 'package:budget_app/service/itemService.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/service/category.dart';
import 'package:budget_app/screens/chart.dart';
import 'package:budget_app/screens/categorylist.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var category;
  var totalSum = 0;
  List<Category> _categoryList = List<Category>();
  List<Item> _itemList = List<Item>();
  List<Item> _itemList2 = List<Item>();
  @override
  void initState() {
    super.initState();
    getAllCategories();
    getAllItems();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.category_name = category['category_name'];
        categoryModel.category_id = category['category_id'];
        categoryModel.category_max_budget = category['category_max_budget'];
        categoryModel.category_rem_budget = category['category_rem_budget'];
        _categoryList.add(categoryModel);
      });
    });
  }

  var _itemService = ItemService();
  getAllItems() async {
    _itemList = List<Item>();
    var items = await _itemService.readAllItem();
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
  }

  var _categoryService = CategoryService();
  var _category = Category();
  var categoryNameController = TextEditingController();
  var categoryBudgetController = TextEditingController();
  var editCategoryNameController = TextEditingController();
  var editCategoryBudgetController = TextEditingController();

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      editCategoryNameController.text =
          category[0]['category_name'] ?? 'No Name';
      editCategoryBudgetController.text =
          category[0]['category_max_budget'].toString() ?? 'No Budget';
    });
    _editFormDialog(context);
  }

  _deleteCategory(BuildContext context, categoryId) async {
    _deleteFormDialog(context, categoryId);
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Add Category Form'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  style: TextStyle(),
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                  ),
                  controller: categoryNameController,
                ),
                TextField(
                  //temporary ra ning textfeild kay wa pako kabaw
                  decoration: InputDecoration(
                    labelText: 'Enter Budget',
                  ),
                  controller: categoryBudgetController,
                  keyboardType: TextInputType.number,
                ),
                RaisedButton(
                    color: Colors.blueGrey,
                    child: Text('Add Category'),
                    textColor: Colors.white,
                    onPressed: () async {
                      if (categoryNameController.text.isEmpty ||
                          categoryBudgetController.text.isEmpty) {
                        return;
                      } else {
                        _category.category_name = categoryNameController.text;
                        _category.category_max_budget =
                            int.parse(categoryBudgetController.text);
                        _category.category_rem_budget =
                            int.parse(categoryBudgetController.text);
                        var result =
                            await _categoryService.saveCategory(_category);
                        print(result);
                        Navigator.of(context).pop();
                        getAllCategories();
                        categoryNameController.text = '';
                        categoryBudgetController.text = '';
                      }
                    })
              ],
            )),
          );
        });
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Edit Category Form'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  style: TextStyle(),
                  decoration: InputDecoration(
                    labelText: 'New Category Name',
                  ),
                  controller: editCategoryNameController,
                ),
                TextField(
                  //temporary ra ning textfeild kay wa pako kabaw
                  decoration: InputDecoration(
                    labelText: 'New Budget',
                  ),
                  controller: editCategoryBudgetController,
                  keyboardType: TextInputType.number,
                ),
                RaisedButton(
                    color: Colors.blueGrey,
                    child: Text('Update'),
                    textColor: Colors.white,
                    onPressed: () async {
                      if (editCategoryNameController.text.isEmpty ||
                          editCategoryBudgetController.text.isEmpty) {
                        return;
                      } else {
                        _category.category_id = category[0]['category_id'];
                        _category.category_name =
                            editCategoryNameController.text;
                        _category.category_max_budget =
                            int.parse(editCategoryBudgetController.text);
                        var result =
                            await _categoryService.updateCategory(_category);
                        print(result);
                        Navigator.of(context).pop();
                        getAllCategories();
                        _showSuccessSnackBar(Text("Updated Successfully"));
                      }
                    })
              ],
            )),
          );
        });
  }

  _deleteFormDialog(BuildContext context, categoryId) {
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
                    var result =
                        await _categoryService.deleteCategory(categoryId);
                    Navigator.pop(context);
                    getAllCategories();
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

  // List<Category> get getExpenses {
  //   return _categoryList.where((expense) {}).toList();
  // }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blueGrey[200],
        key: _globalKey,
        appBar: AppBar(
          leading: Image.network('https://i.imgur.com/FWkzRfj.png'),
          backgroundColor: Colors.blueGrey[600],
          title: Text(
            "Budget App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _showFormDialog(context);
                })
          ],
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3.5,
              child: Card(
                child: Chart(_itemList),
              ),
            ),
            SingleChildScrollView(
              child: CategoryList(
                _categoryList,
                _editCategory,
                _deleteCategory,
              ),
            ),
          ],
        ));
  }
}
