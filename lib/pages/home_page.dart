import 'package:flutter/material.dart';
import 'package:myapp/app_state.dart';
import 'package:myapp/models/bible_model.dart';
import 'package:myapp/models/book_model.dart';
import 'package:myapp/models/language_model.dart';
import 'package:myapp/pages/account_page.dart';
import 'package:myapp/pages/library_page.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:myapp/pages/study_page.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../services/bible_api_service.dart';
import '../models/verse_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final BibleApiService _bibleApiService = BibleApiService();
  final AuthService _authService = AuthService();
  List<Language> _languages = [];
  List<Bible> _bibles = [];
  String? _selectedBibleRef;
  List<Book> _books = [];
  String? _selectedBookRef;
  int? _selectedChapter;
  List<Verse> _verses = [];
  bool _isLoadingLanguages = false;
  bool _isLoadingBibles = false;
  bool _isLoadingBooks = false;
  bool _isLoadingVerses = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadLanguages();
  }

  void _loadLanguages() async {
    setState(() {
      _isLoadingLanguages = true;
    });
    try {
      final languages = await _bibleApiService.getLanguages();
      if (!mounted) return;
      setState(() {
        _languages = languages;
        _isLoadingLanguages = false;
        _loadBibles();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao carregar idiomas: $e')),
      );
      setState(() {
        _isLoadingLanguages = false;
      });
    }
  }

  void _loadBibles() async {
    final langCode = Provider.of<AppState>(context, listen: false).currentLang;
    setState(() {
      _isLoadingBibles = true;
      _bibles = [];
      _selectedBibleRef = null;
    });
    try {
      final bibles = await _bibleApiService.getBibles(langCode);
      if (!mounted) return;
      setState(() {
        _bibles = bibles;
        _isLoadingBibles = false;
        if (bibles.isNotEmpty) {
          _selectedBibleRef = bibles.first.ref;
          _loadBooks();
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao carregar Bíblias: $e')),
      );
      setState(() {
        _isLoadingBibles = false;
      });
    }
  }

  void _loadBooks() async {
    if (_selectedBibleRef == null) return;
    setState(() {
      _isLoadingBooks = true;
      _books = [];
      _selectedBookRef = null;
    });
    try {
      final books = await _bibleApiService.getBooks(_selectedBibleRef!);
      if (!mounted) return;
      setState(() {
        _books = books;
        _isLoadingBooks = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao carregar livros: $e')),
      );
      setState(() {
        _isLoadingBooks = false;
      });
    }
  }

  void _loadVerses() async {
    if (_selectedBibleRef == null ||
        _selectedBookRef == null ||
        _selectedChapter == null) return;
    setState(() {
      _isLoadingVerses = true;
    });
    try {
      final verses = await _bibleApiService.getVerses(
        _selectedBibleRef!,
        _selectedBookRef!,
        _selectedChapter!,
      );
      if (!mounted) return;
      setState(() {
        _verses = verses;
        _isLoadingVerses = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao carregar versículos: $e')),
      );
      setState(() {
        _isLoadingVerses = false;
      });
    }
  }

  void _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<String>(
          value: appState.currentLang,
          underline: const SizedBox.shrink(),
          items: _languages.map((Language lang) {
            return DropdownMenuItem<String>(
              value: lang.code,
              child: Text(
                lang.name,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              appState.setLang(newValue);
              _loadBibles();
            }
          },
          dropdownColor: Colors.blue,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LibraryPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoadingLanguages || _isLoadingBibles
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        value: _selectedBibleRef,
                        hint: const Text('Selecione uma tradução'),
                        isExpanded: true,
                        items: _bibles.map((Bible bible) {
                          return DropdownMenuItem<String>(
                            value: bible.ref,
                            child: Text(bible.name),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedBibleRef = newValue;
                            _loadBooks();
                          });
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              value: _selectedBookRef,
                              hint: const Text('Selecione um livro'),
                              isExpanded: true,
                              items: _books.map((Book book) {
                                return DropdownMenuItem<String>(
                                  value: book.ref,
                                  child: Text(book.name),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedBookRef = newValue;
                                  _selectedChapter = null;
                                  _verses = [];
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (_selectedBookRef != null)
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Capítulo',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedChapter = int.tryParse(value);
                                  });
                                },
                                onSubmitted: (_) => _loadVerses(),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoadingBooks || _isLoadingVerses
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: _verses.length,
                          itemBuilder: (context, index) {
                            final verse = _verses[index];
                            return ListTile(
                              title: Text('${verse.verse}. ${verse.text}'),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StudyPage(verse: verse.text),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
