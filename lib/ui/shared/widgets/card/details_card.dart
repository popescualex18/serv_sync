import 'package:flutter/material.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/main.dart';
import 'package:serv_sync/ui/navigation/app_router.dart';
import 'package:serv_sync/ui/state_management/cubits/menu/menu_cubit.dart';

class DetailsCard extends StatelessWidget {
  final MenuItem item;
  final Widget actionButton;
  final void Function() onEditClosed;
  const DetailsCard({
    super.key,
    required this.item,
    required this.actionButton,
    required this.onEditClosed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12)), // Slightly reduced border radius
      elevation: 1.5, // Lower shadow for a compact look
      shadowColor: Colors.grey.withOpacity(0.15),
      margin: EdgeInsets.symmetric(vertical: 4), // Reduced vertical spacing
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async{
          await AppRouter.router.push("/menu/manage/${item.id}");
          onEditClosed();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 8), // Reduced padding
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Smaller Icon
              Container(
                padding: EdgeInsets.all(6), // Reduced padding
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.fastfood_rounded,
                    size: 20, color: Colors.orangeAccent), // Smaller icon
              ),
              SizedBox(width: 10), // Reduced spacing

              // 🔹 Menu Details (Smaller)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Allows shrinking
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14, // Smaller font size
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis, // Prevents overflow
                      maxLines: 2, // Limits height
                    ),
                    SizedBox(height: 2), // Smaller spacing
                    Text(
                      "Pret: ${item.price} RON",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700]), // Smaller text
                    ),
                    SizedBox(height: 2), // Smaller spacing
                    Row(
                      children: [
                        _buildTag(item.hasBread, "Pâine"),
                        SizedBox(width: 4), // Reduced spacing
                        _buildTag(item.hasPolenta, "Mămăligă"),
                      ],
                    ),
                  ],
                ),
              ),

             actionButton,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(bool condition, String label) {
    return condition
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: TextStyle(color: Colors.blueAccent, fontSize: 14),
            ),
          )
        : SizedBox.shrink();
  }
}
