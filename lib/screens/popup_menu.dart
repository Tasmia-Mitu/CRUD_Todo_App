import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'add_page.dart';

class HorizontalPopupMenu extends StatefulWidget {
  final String id;
  final Map item;
  final Function onItemDeleted;
  final Function fetchTodo;

  HorizontalPopupMenu({
    required this.id, 
    required this.onItemDeleted, 
    required this.item,
    required this.fetchTodo,
  });

  @override
  _HorizontalPopupMenuState createState() => _HorizontalPopupMenuState();
}

class _HorizontalPopupMenuState extends State<HorizontalPopupMenu> {
    bool isLoading = false; 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            position.dx, // X position of the icon
            position.dy, // Y position of the icon
            0,            // Right margin (we don't need to set this)
            0,            // Bottom margin (we don't need to set this)
          ),
          items: [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ).then((value) {
          if (value != null) {
            handleMenuSelection(value, widget.id, widget.item, widget.fetchTodo);
          }
        });
      },
      child: const Icon(Icons.more_horiz), // Horizontal dots icon
    );
  }

  void handleMenuSelection(String value, String id, Map item, Function fetchTodo) {
    if (value == 'edit') {
      // Edit action here
      navigateToEditPage(item, fetchTodo);
    } else if (value == 'delete') {
      // Delete action here
      deleteById(id);
    }
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    print("Deleting from URL: $url");
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      // Successfully deleted the item, call the callback to update the parent list
      widget.onItemDeleted(id);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully deleted the item')),
      );
    } else {
      // Handle error, show a failure message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete item')),
      );
    }
  }



  void navigateToEditPage(Map item, Function fetchTodo) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }
}

