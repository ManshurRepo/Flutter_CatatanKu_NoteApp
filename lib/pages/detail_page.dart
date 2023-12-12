import 'package:catatanku_note_app/data/datasources/local_datasource.dart';
import 'package:catatanku_note_app/data/models/colors.dart';
import 'package:catatanku_note_app/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../data/models/note.dart';
import 'edit_page.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    Key? key,
    required this.note,
  }) : super(key: key);
  final Note note;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Catatan',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 2,
        backgroundColor: ColorName.appBarColor,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Hapus catatan'),
                        content: const Text('Apakah anda yakin?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () async {
                                await LocalDatasource()
                                    .deleteNoteById(widget.note.id!);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const HomePage();
                                }));
                              },
                              child: const Text('Hapus')),
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              )),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.note.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          Text(widget.note.content,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 18)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 78, 161, 78),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EditPage(
              note: widget.note,
            );
          }));
        },
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }
}
