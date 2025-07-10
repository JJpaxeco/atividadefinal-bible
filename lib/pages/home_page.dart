import 'package:flutter/material.dart';
import 'package:myapp/app_state.dart';
import 'package:myapp/models/book_model.dart';
import 'package:myapp/models/language_model.dart';
import 'package:myapp/pages/account_page.dart';
import 'package:myapp/pages/chapters_page.dart';
import 'package:myapp/pages/library_page.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/widgets/segmentation_tabs.dart';
import 'package:provider/provider.dart';
import '../services/bible_api_service.dart';
import '../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final BibleApiService _bibleApiService = BibleApiService();
  final AuthService _authService = AuthService();
  List<Language> _languages = [];
  String? _selectedBibleRef;
  List<Book> _books = [];
  bool _isLoadingBooks = false;
  int _testamentIndex = 0; // Old Testament is the default

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.currentLang.isNotEmpty) {
      _loadLanguages();
    }
  }

  void _loadLanguages() async {
    setState(() {
      _isLoadingBooks = true; // Use um único indicador de carregamento
    });
    try {
      final languages = await _bibleApiService.getLanguages();
      if (!mounted) return;
      setState(() {
        _languages = languages;
      });
      _loadBibles();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao carregar idiomas: $e')),
      );
      setState(() {
        _isLoadingBooks = false;
      });
    }
  }

  void _loadBibles() async {
    final langCode = Provider.of<AppState>(context, listen: false).currentLang;
    setState(() {
      _isLoadingBooks = true;
      _selectedBibleRef = null;
    });
    try {
      final bibles = await _bibleApiService.getBibles(langCode);
      if (!mounted) return;
      setState(() {
        if (bibles.isNotEmpty) {
          _selectedBibleRef = bibles.first.ref;
          _loadBooks();
        } else {
          _isLoadingBooks = false;
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao carregar Bíblias: $e')),
      );
      setState(() {
        _isLoadingBooks = false;
      });
    }
  }

  void _loadBooks() async {
    if (_selectedBibleRef == null) return;
    setState(() {
      _isLoadingBooks = true;
      _books = [];
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

  void _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final lang = _languages[index];
              return ListTile(
                title: Text(lang.name),
                onTap: () {
                  Provider.of<AppState>(context, listen: false)
                      .setLang(lang.code);
                  _loadBibles();
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    final filteredBooks = _books.where((book) {
      return _testamentIndex == 0 ? book.order < 39 : book.order >= 39;
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
              ),
              const SizedBox(width: 12),
              const Text('Bible',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              if (_languages.isNotEmpty)
                GestureDetector(
                  onTap: _showLanguagePicker,
                  child: Chip(
                    label: Text(
                      appState.currentLang.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: AppTheme.lightGreyChipColor,
                  ),
                )
            ],
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SegmentationTabs(
                selectedIndex: _testamentIndex,
                onTabSelected: (index) {
                  setState(() {
                    _testamentIndex = index;
                  });
                },
                tabs: const ['Antigo Testamento', 'Novo Testamento'],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoadingBooks
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = filteredBooks[index];
                          return SizedBox(
                            height: 60,
                            child: Card(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Center(
                                child: ListTile(
                                  title: Text(book.name,
                                      style: const TextStyle(fontSize: 16)),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ChaptersPage(
                                          book: book,
                                          bibleRef: _selectedBibleRef!,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
