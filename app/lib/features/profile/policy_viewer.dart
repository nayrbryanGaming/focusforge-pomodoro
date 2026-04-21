import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PolicyViewer extends StatelessWidget {
  final String title;
  final String contentData;

  const PolicyViewer({
    super.key,
    required this.title,
    required this.contentData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Markdown(
        data: contentData,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          p: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
