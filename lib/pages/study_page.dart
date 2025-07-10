import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/study_model.dart';
import '../services/openai_service.dart';
import '../services/firestore_service.dart';

class StudyPage extends StatefulWidget {
  final String verse;

  const StudyPage({super.key, required this.verse});

  @override
  StudyPageState createState() => StudyPageState();
}

class StudyPageState extends State<StudyPage> {
  final OpenaiService _openaiService = OpenaiService();
  final FirestoreService _firestoreService = FirestoreService();
  StudyModel? _study;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _generateStudy();
  }

  void _generateStudy() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final study = await _openaiService.generateStudy(widget.verse);
      if (!mounted) return;
      setState(() {
        _study = study;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao gerar estudo: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _saveStudy() async {
    if (_study == null) return;
    setState(() {
      _isSaving = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestoreService.saveStudy(user.uid, _study!);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estudo salvo com sucesso!')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao salvar estudo: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudo do Versículo')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _study == null
              ? const Center(child: Text('Não foi possível gerar o estudo.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _study!.verse,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(_study!.studyText),
                          const SizedBox(height: 20),
                          _isSaving
                              ? const Center(child: CircularProgressIndicator())
                              : Center(
                                  child: ElevatedButton(
                                    onPressed: _saveStudy,
                                    child: const Text('Salvar Estudo'),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
