import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serv_sync/core/network/client/dio_client.dart';
import 'package:serv_sync/domain/entities/menu/daily_menu_components.dart';
import 'package:serv_sync/domain/entities/menu/daily_menu_item.dart';

class DailyMenuDataAccess {
  final CollectionReference dailyMenuCollection =
      FirebaseFirestore.instance.collection('dailyMenu');
  Future<List<DailyMenuComponents>> fetchDailyMenus() async {
    var result = <DailyMenuComponents>[];
    var querySnapshot =
    await dailyMenuCollection // Expecting only one document per menuType
        .get();
    for (var doc in querySnapshot.docs) {
      result.add(DailyMenuComponents.fromJson(doc.data() as Map<String, dynamic>));
    }
    return result;
  }

  Future<void> addDailyMenu(DailyMenuComponents dailyMenu) async {
    var querySnapshot =
        await dailyMenuCollection // Replace with your collection name
            .where('menuType', isEqualTo: dailyMenu.menuType)
            .limit(1) // Expecting only one document per menuType
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Step 2: Document found, update the menuIds field
      await querySnapshot.docs.first.reference
          .update({'menuIds': dailyMenu.menuIds});
      print("menuIds Updated Successfully");
    } else {
      // Step 3: Document not found, create a new one
      await dailyMenuCollection.add(dailyMenu.toJson());
      print("New Document Created Successfully");
    }
  }
}
