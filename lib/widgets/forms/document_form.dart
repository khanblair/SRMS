import 'package:flutter/material.dart';
import 'package:srms/config/supabase_config.dart';
import 'package:srms/models/document_type_model.dart';

class DocumentForm extends StatefulWidget {
  final String? selectedTypeId;
  final ValueChanged<String?> onTypeChanged;
  final PlatformFile? selectedFile;
  final VoidCallback onFilePicked;

  const DocumentForm({
    super.key,
    required this.selectedTypeId,
    required this.onTypeChanged,
    required this.selectedFile,
    required this.onFilePicked,
  });

  @override
  State<DocumentForm> createState() => _DocumentFormState();
}

class _DocumentFormState extends State<DocumentForm> {
  List<DocumentType> _documentTypes = [];
  bool _isLoadingTypes = true;

  @override
  void initState() {
    super.initState();
    _fetchDocumentTypes();
  }

  Future<void> _fetchDocumentTypes() async {
    try {
      final response = await SupabaseConfig.client
          .from('document_types')
          .select('*')
          .order('name');

      setState(() {
        _documentTypes = response
            .map((json) => DocumentType.fromJson(json))
            .toList();
        _isLoadingTypes = false;
      });
    } catch (e) {
      setState(() => _isLoadingTypes = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading document types: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Document Type Dropdown
        const Text(
          'Document Type',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _isLoadingTypes
            ? const CircularProgressIndicator()
            : DropdownButtonFormField<String>(
                value: widget.selectedTypeId,
                items: _documentTypes
                    .map((type) => DropdownMenuItem(
                          value: type.id,
                          child: Text(type.name),
                        ))
                    .toList(),
                onChanged: widget.onTypeChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                validator: (value) =>
                    value == null ? 'Please select a document type' : null,
              ),
        const SizedBox(height: 24),

        // File Picker
        const Text(
          'Document File',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: widget.onFilePicked,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                const Icon(Icons.cloud_upload, size: 48),
                const SizedBox(height: 8),
                Text(
                  widget.selectedFile?.name ?? 'Select a file to upload',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (widget.selectedFile != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${(widget.selectedFile!.size / 1024).toStringAsFixed(1)} KB',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}