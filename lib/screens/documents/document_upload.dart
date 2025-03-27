import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/supabase_config.dart';
import 'package:srms/models/document_model.dart';
import 'package:srms/widgets/forms/document_form.dart';

class DocumentUploadScreen extends StatefulWidget {
  final String requisitionId;

  const DocumentUploadScreen({super.key, required this.requisitionId});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedTypeId;
  PlatformFile? _selectedFile;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() => _selectedFile = result.files.first);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _uploadDocument() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFile == null || _selectedTypeId == null) return;

    setState(() => _isUploading = true);

    try {
      // Get document type name
      final typeResponse = await SupabaseConfig.client
          .from('document_types')
          .select('name')
          .eq('id', _selectedTypeId!)
          .single();

      // Upload file to storage
      final fileExt = _selectedFile!.name.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'documents/${widget.requisitionId}/$fileName';

      await SupabaseConfig.client.storage
          .from('documents')
          .upload(filePath, File(_selectedFile!.path!));

      // Get public URL
      final fileUrl = SupabaseConfig.client.storage
          .from('documents')
          .getPublicUrl(filePath);

      // Create document record
      await SupabaseConfig.client.from('documents').insert({
        'type_id': _selectedTypeId,
        'requisition_id': widget.requisitionId,
        'file_url': fileUrl,
        'file_name': _selectedFile!.name,
        'file_size': _selectedFile!.size,
        'file_type': _selectedFile!.extension,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document uploaded successfully')),
      );
      Navigator.pop(context);
    } on StorageException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage error: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading document: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Document')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DocumentForm(
                selectedTypeId: _selectedTypeId,
                onTypeChanged: (value) => setState(() => _selectedTypeId = value),
                selectedFile: _selectedFile,
                onFilePicked: _pickFile,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: _isUploading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.upload),
                  label: Text(_isUploading ? 'Uploading...' : 'Upload Document'),
                  onPressed: _isUploading ? null : _uploadDocument,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}