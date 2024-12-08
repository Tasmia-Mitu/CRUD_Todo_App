import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../theme/theme_provider.dart';
import 'add_page.dart';
import 'popup_menu.dart';
import 'show_description.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListState();
}

class _TodoListState extends State<TodoListPage> {
  List items = [];
  bool isDarkTheme = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    fetchTodo();
  }

  void removeItem(String id) {
    setState(() {
      items.removeWhere((item) => item['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Todo List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
            ),
            child: IconButton(
              icon: Icon(
                Provider.of<ThemeProvider>(context).isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode,
                color: Provider.of<ThemeProvider>(context).isDarkMode
                    ? Colors.amber
                    : Colors.blue,
              ),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        onRefresh: fetchTodo,
        child: Visibility(
          visible: items.isEmpty,
          replacement: const Center(
            child: Text(
              "No Todo Item!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),

          child: ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'] as String;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800 // Dark theme background color
                        : Theme.of(context)
                            .colorScheme
                            .primary, // Light theme background color
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                                .withOpacity(0.2) // Dark theme shadow color
                            : Theme.of(context)
                                .shadowColor
                                .withOpacity(0.1), // Light theme shadow color
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text(
                        item['title'],
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge, // Updated for title
                      ),
                      subtitle: Text(
                        item['description'],
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1, // Limit description to 1 line
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        // Function to show full description
                        showFullDescription(
                          context,
                          item['title'],
                          item['description'],
                        );
                      },
                      trailing: HorizontalPopupMenu(
                        id: id,
                        onItemDeleted: removeItem,
                        item: item,
                        fetchTodo: fetchTodo,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return FloatingActionButton.extended(
            onPressed: navigateToAddPage,
            label: const Text(
              "Add Todo",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: themeProvider.isDarkMode
                ? const Color.fromARGB(255, 143, 108, 6)
                : const Color.fromARGB(255, 33, 81, 121),
          );
        },
      ),
    );
  }

  // void navigateToEditPage() {
  //   final route = MaterialPageRoute(
  //     builder: (context) => const AddTodoPage(),
  //   );
  //   Navigator.push(context, route);
  // }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;

      setState(() {
        items = result;
      });
    }
  }
}
