import 'package:flutter/material.dart';
import 'package:srms/models/document_model.dart';
import 'package:srms/config/constants.dart';

class DocumentCard extends StatelessWidget {
  final Document document;
  final bool showRequisitionInfo;
  final VoidCallback? onTap;

  const DocumentCard({
    super.key,
    required this.document,
    this.showRequisitionInfo = false,
    this.onTap,
  });

  IconData _getFileIcon(String type) {
    if (type.contains('pdf')) return Icons.picture_as_pdf;
    if (type.contains('doc')) return Icons.description;
    if (type.contains('image')) return Icons.image;
    return Icons.insert_drive_file;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getFileIcon(document.fileType),
                    size: 40,
                    color: Color(AppConstants.primaryColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.fileName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${document.fileType.toUpperCase()} • ${_formatFileSize(document.fileSize)}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  if (document.isVerified)
                    const Icon(Icons.verified, color: Colors.green),
                ],
              ),
              if (document.typeName != null) ...[
                const SizedBox(height: 8),
                Chip(
                  label: Text(document.typeName!),
                  backgroundColor: Colors.grey[200],
                ),
              ],
              if (showRequisitionInfo && document.requisitionId != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Requisition: ${document.requisitionId!.substring(0, 8)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                'Uploaded: ${document.createdAt.toLocal().toString().split(' ')[0]}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}