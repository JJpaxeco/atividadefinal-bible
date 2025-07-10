import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:myapp/pages/webview_page.dart';
import '../models/study_model.dart';
import '../services/firestore_service.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  LibraryPageState createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biblioteca de Estudos')),
      body: _uid == null
          ? const Center(child: Text('Usuário não autenticado.'))
          : StreamBuilder<List<StudyModel>>(
              stream: _firestoreService.getStudies(_uid!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum estudo salvo.'));
                }

                final studies = snapshot.data!;

                return ListView.builder(
                  itemCount: studies.length,
                  itemBuilder: (context, index) {
                    final study = studies[index];
                    return ListTile(
                      title: Text(study.verse),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(study.createdAt.toDate()),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StudyDetailPage(study: study),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}

class StudyDetailPage extends StatelessWidget {
  final StudyModel study;

  const StudyDetailPage({super.key, required this.study});

  @override
  Widget build(BuildContext context) {
    final urlRegex = RegExp(r'https?:\/\/[^\s\)]+');
    final urls =
        urlRegex.allMatches(study.studyText).map((m) => m.group(0)!).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Estudo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              study.verse,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(study.studyText),
            if (urls.isNotEmpty) ...[
              const SizedBox(height: 20),
              ...urls.map((url) => ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WebViewPage(url: url),
                        ),
                      );
                    },
                    child: Text('Abrir: ${url.split('/').last}'),
                  ))
            ]
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza de que deseja excluir este estudo?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _deleteStudy(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteStudy(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && study.id != null) {
      try {
        await FirestoreService().deleteStudy(uid, study.id!);
        Navigator.of(context).pop(); // Fecha o diálogo
        Navigator.of(context).pop(); // Volta para a lista de estudos
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estudo excluído com sucesso!')),
        );
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir o estudo: $e')),
        );
      }
    }
  }
}
