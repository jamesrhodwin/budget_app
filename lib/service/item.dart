class Item {
  int item_id;
  String item_name;
  int item_amount;
  String item_date;
  int category_id;

  Item({
    this.item_id,
    this.item_name,
    this.item_amount,
    this.item_date,
    this.category_id,
  });

  itemMap() {
    var mapping = Map<String, dynamic>();
    mapping['item_id'] = item_id;
    mapping['item_name'] = item_name;
    mapping['item_amount'] = item_amount;
    mapping['item_date'] = item_date;
    mapping['category_id'] = category_id;

    return mapping;
  }
}
