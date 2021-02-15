import 'package:budget_app/screens/itemscreen.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/service/category.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CategoryList extends StatelessWidget {
  final List<Category> _categoryList;
  final Function _editCategory;
  final Function _deleteCategory;

  CategoryList(this._categoryList, this._editCategory, this._deleteCategory);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.6,
      child: _categoryList.isEmpty
          ? Column(
              children: <Widget>[],
            )
          : ListView.builder(
              itemCount: _categoryList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ItemScreen(
                              _categoryList[index].category_id,
                              _categoryList[index].category_name,
                              _categoryList[index].category_max_budget,
                              _categoryList[index].category_rem_budget))),
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 13),
                        elevation: 5,
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            padding: EdgeInsets.all(7.0),
                            color: Colors.white,
                            child: ListTile(
                              title: Row(children: <Widget>[
                                Text(
                                  _categoryList[index].category_name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ]),
                              subtitle: LinearPercentIndicator(
                                lineHeight: 14.0,
                                percent: _categoryList[index]
                                        .category_rem_budget /
                                    _categoryList[index].category_max_budget,
                                center: Text(
                                  _categoryList[index]
                                          .category_rem_budget
                                          .toString() +
                                      "/" +
                                      _categoryList[index]
                                          .category_max_budget
                                          .toString(),
                                  style: new TextStyle(fontSize: 12.0),
                                ),
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor: Colors.deepOrangeAccent,
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            IconSlideAction(
                              caption: 'Edit',
                              color: Colors.blue,
                              icon: Icons.edit,
                              onTap: () {
                                _editCategory(
                                    context, _categoryList[index].category_id);
                              },
                            ),
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red[400],
                              icon: Icons.delete,
                              onTap: () {
                                _deleteCategory(
                                    context, _categoryList[index].category_id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
    );
  }
}
