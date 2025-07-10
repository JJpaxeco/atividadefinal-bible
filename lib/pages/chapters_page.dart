import 'package:flutter/material.dart';
import 'package:myapp/app_state.dart';
import 'package:myapp/models/book_model.dart';
import 'package:myapp/pages/verses_page.dart';
import 'package:myapp/theme.dart';
import 'package:provider/provider.dart';

class ChaptersPage extends StatelessWidget {
  final Book book;
  final String bibleRef;

  const ChaptersPage({
    super.key,
    required this.book,
    required this.bibleRef,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(book.name),
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.primaryColor),
        actions: [
          IconButton(
            icon: Icon(appState.themeMode == ThemeMode.light
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () {
              appState.toggleTheme();
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: book.chaptersCount,
        itemBuilder: (context, index) {
          final chapter = index + 1;
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VersesPage(
                    bibleRef: bibleRef,
                    bookRef: book.ref,
                    chapter: chapter,
                  ),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  '$chapter',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
