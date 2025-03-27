import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:srms/models/document_model.dart';
import 'package:srms/widgets/common/document_card.dart';
import 'package:srms/widgets/ui/empty_state.dart';

class DocumentListScreen extends StatelessWidget {
  final List<Document> documents;
  final bool showRequisitionInfo;

  const DocumentListScreen({
    super.key,
    required this.documents,
    this.showRequisitionInfo = false,
  });

  Future<void> _openDocument(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return const EmptyState(
        icon: Icons.folder_open,
        message: 'No documents found',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DocumentCard(
            document: doc,
            showRequisitionInfo: showRequisitionInfo,
            onTap: () => _openDocument(doc.fileUrl),
          ),
        );
      },
    );
  }
}