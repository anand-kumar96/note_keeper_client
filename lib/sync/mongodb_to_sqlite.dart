import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:note_keeper/model/notes_model.dart';
import 'package:note_keeper/repository/database_repository.dart';

Future<void> fetchAndUpdateNotesFromApi() async {
    try {
      String apiUrl = 'https://note-keeper-api-6yg7.onrender.com/getAllNote';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> notesData = json.decode(response.body)['data'];
        
        final List<NotesModel> notes = [];
        for (var noteData in notesData) {
          final note = NotesModel.fromMapObject(noteData);
          notes.add(note);
        }
        await DatabaseRepository().insertOrUpdateNotes(notes);
        if (kDebugMode) {
          print('Notes fetched from API and updated in SQLite');
        }
      } else {
        throw Exception('Failed to fetch notes');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching and updating notes: $error');
      }
    }
  }