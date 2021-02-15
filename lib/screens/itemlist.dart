import 'package:budget_app/service/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ItemList extends StatelessWidget {
  final List<Item> _itemList;
  final Function _deleteItem;
  final Function _editItem;

  ItemList(this._itemList, this._deleteItem, this._editItem);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: _itemList.isEmpty
            ? Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'No Expenses Yet',
                    style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: _itemList.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 7, vertical: 13),
                    elevation: 10,
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: Container(
                        padding: EdgeInsets.all(7.0),
                        color: Colors.white,
                        child: ListTile(
                          title: Row(children: <Widget>[
                            Text(
                              _itemList[index].item_name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ]),
                          subtitle: Text(
                            DateFormat.yMd().format(
                                DateFormat("yyyy-MM-dd hh:mm:ss")
                                    .parse(_itemList[index].item_date)),
                          ),
                          trailing: Text(
                            "\₱" + _itemList[index].item_amount.toString(),
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        IconSlideAction(
                          caption: 'Edit',
                          color: Colors.blue,
                          icon: Icons.edit,
                          onTap: () {
                            _editItem(context, _itemList[index].item_id);
                          },
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red[400],
                          icon: Icons.delete,
                          onTap: () {
                            _deleteItem(context, _itemList[index].item_id);
                          },
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
