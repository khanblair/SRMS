import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/supabase_config.dart';
import 'package:srms/models/document_model.dart';

class DocumentService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Document>> getDocumentsForRequisition(String requisitionId) async {
    final data = await _client.from('documents')
      .select('*, type:document_types(*)')
      .eq('requisition_id', requisitionId);
      
    return data.map((json) => Document.fromJson(json)).toList();
  }

  Future<Document> uploadDocument({
    required String filePath,
    required String fileName,
    required String requisitionId,
    required String typeId,
  }) async {
    final fileExt = fileName.split('.').last;
    final storagePath = 'documents/$requisitionId/${DateTime.now().millisecondsSinceEpoch}.$fileExt';

    await _client.storage.from('documents').upload(storagePath, filePath);
    final fileUrl = _client.storage.from('documents').getPublicUrl(storagePath);

    final response = await _client.from('documents').insert({
      'type_id': typeId,
      'requisition_id': requisitionId,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_size': await filePath.length(),
      'file_type': fileExt,
    }).select();

    return Document.fromJson(response.first);
  }

  Future<void> deleteDocument(String documentId) async {
    await _client.from('documents').delete().eq('id', documentId);
  }
}