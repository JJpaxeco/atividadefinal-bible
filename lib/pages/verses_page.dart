import 'package:flutter/material.dart';
import 'package:myapp/app_state.dart';
import 'package:myapp/models/verse_model.dart';
import 'package:myapp/pages/study_page.dart';
import 'package:myapp/services/bible_api_service.dart';
import 'package:provider/provider.dart';

class VersesPage extends StatefulWidget {
  final String bibleRef;
  final String bookRef;
  final int chapter;

  const VersesPage({
    super.key,
    required this.bibleRef,
    required this.bookRef,
    required this.chapter,
  });

  @override
  VersesPageState createState() => VersesPageState();
}

class VersesPageState extends State<VersesPage> {
  final BibleApiService _bibleApiService = BibleApiService();
  List<Verse> _verses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVerses();
  }

  void _loadVerses() async {
    try {
      final verses = await _bibleApiService.getVerses(
        widget.bibleRef,
        widget.bookRef,
        widget.chapter,
      );
      if (!mounted) return;
      setState(() {
        _verses = verses;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao carregar versículos: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.bookRef} ${widget.chapter}'),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _verses.length,
              itemBuilder: (context, index) {
                final verse = _verses[index];
                return ListTile(
                  title: Text(verse.text),
                  leading: Text('${verse.verse}'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StudyPage(verse: verse.text),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
