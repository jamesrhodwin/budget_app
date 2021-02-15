class Category {
  int category_id;
  String category_name;
  int category_max_budget;
  int category_rem_budget;

  Category({
    this.category_id,
    this.category_name,
    this.category_max_budget,
    this.category_rem_budget,
  });

  categoryMap() {
    var mapping = Map<String, dynamic>();
    mapping['category_id'] = category_id;
    mapping['category_name'] = category_name;
    mapping['category_max_budget'] = category_max_budget;
    mapping['category_rem_budget'] = category_rem_budget;

    return mapping;
  }
}
