import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_openai/dart_openai.dart';
import '../models/study_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class OpenaiService {
  OpenaiService() {
    OpenAI.apiKey = dotenv.env['OPENAI_API_KEY']!;
  }

  Future<StudyModel> generateStudy(String verseText) async {
    try {
      const systemPrompt =
          'Você é um assistente teológico especializado em exegese bíblica. Sua tarefa é fornecer estudos concisos e claros sobre versículos bíblicos.';
      final userPrompt = '''
Analise o seguinte versículo bíblico e forneça um estudo (com no máximo 500 tokens) sobre ele, estruturado EXATAMENTE da seguinte forma:

**Contexto Histórico:**
[Seu texto aqui]

**Aplicação Prática:**
[Seu texto aqui]

**Referências Cruzadas:**
[Suas referências aqui]

Versículo: "$verseText"
''';

      final chatCompletion = await OpenAI.instance.chat.create(
        model: 'gpt-3.5-turbo',
        maxTokens: 500,
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(systemPrompt),
            ],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(userPrompt),
            ],
          ),
        ],
      );

      final studyText = chatCompletion.choices.first.message.content?.first.text ??
          'Não foi possível gerar o estudo.';

      return StudyModel(
        verse: verseText,
        studyText: studyText,
        createdAt: Timestamp.now(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao chamar a API da OpenAI: $e');
      }
      rethrow;
    }
  }
}
