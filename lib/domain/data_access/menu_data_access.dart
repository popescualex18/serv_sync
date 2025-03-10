
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';

class MenuDataAccess {
  final CollectionReference menusCollection =
      FirebaseFirestore.instance.collection('menus');

  Future<List<MenuItem>> fetchMenus() async {
    var menus = <MenuItem>[];
    var data = await menusCollection.get();

    for (var doc in data.docs) {
      menus.add(MenuItem.fromJson(doc.data() as Map<String, dynamic>));
    }
    return menus;
  }

  Future<void> delete(String id) async{
    var dbMenu = await menusCollection.where(MenuItem.idFieldKey, isEqualTo: id)
        .limit(1)
        .get();
    await dbMenu.docs.first.reference.delete();

  }

  Future<void> addOrUpdateMenu({MenuItem? menu}) async {
    var dbMenu = await menusCollection.where(MenuItem.idFieldKey, isEqualTo: menu!.id!)
        .limit(1)
        .get();

    if (dbMenu.docs.isNotEmpty) {
      await dbMenu.docs.first.reference.set(menu.toJson(), SetOptions(merge: true));

    } else {
      await FirebaseFirestore.instance
          .collection('menus')
          .add(menu.toJson());
    }
  }


  Future<MenuItem> fetchMenuById(String id) async {
    var data = await menusCollection.where(MenuItem.idFieldKey, isEqualTo: id).get();
    //var result = await _dioClient.get("/canteen/Menu/$id");
    return MenuItem.fromJson(data.docs.first.data() as Map<String, dynamic>);
  }
}
