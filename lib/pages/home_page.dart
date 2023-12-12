import 'package:catatanku_note_app/data/models/colors.dart';
import 'package:flutter/material.dart';

import '../data/datasources/local_datasource.dart';
import '../data/models/note.dart';
import 'add_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];
  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> getNotes() async {
    setState(() {
      isLoading = true;
    });
    notes = await LocalDatasource().getNotes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Call getNotes in initState so that the data is fetched when the widget is created
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Noted App CWB',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 2,
        backgroundColor: ColorName.appBarColor,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await getNotes();
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : notes.isEmpty
                ? const Center(child: Text('No Notes'))
                : GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.8),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return DetailPage(
                              note: notes[index],
                            );
                          }));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 243, 242, 242),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 6, 133, 2),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notes[index].title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: Colors.black,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      notes[index].content,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15),
                                      maxLines: 8,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: notes.length,
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorName.appBarColor,
        onPressed: () async {
          // Call _refreshIndicatorKey.currentState?.show() before navigating to AddPage
          _refreshIndicatorKey.currentState?.show();
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddPage();
          }));
          // Refresh data after returning from AddPage
          await getNotes();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
