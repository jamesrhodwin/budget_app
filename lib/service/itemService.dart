import 'package:budget_app/database/repository.dart';
import 'package:budget_app/service/item.dart';

class ItemService {
  Repository _repository;

  ItemService() {
    _repository = Repository();
  }

  //INSERT DATA
  saveItem(Item item) async {
    return await _repository.insertItem('item', item.itemMap());
  }

//READ DATA
  readItem(categoryId) async {
    return await _repository.readItem('item', categoryId);
  }

  //READ DATA
  readAllItem() async {
    return await _repository.readAllItem('item');
  }

  //READY DATA BY ID
  readItemById(itemId) async {
    return await _repository.readItemById('item', itemId);
  }

//UPDATE ITEM
  updateItem(Item item) async {
    return await _repository.updateItem('item', item.itemMap());
  }

  //DELETE CATEGORY
  deleteItem(itemId) async {
    return await _repository.deleteItem('item', itemId);
  }
}
