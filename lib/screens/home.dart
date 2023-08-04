import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/constants/colors.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/screens/edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // функция которая удаляет заметку
  void deleteNote(int index) {
    setState(() {
      // удаление во время поиска заметки
      Note note = filteredNotoes[index];
      sampleNotes.remove(note);
      // используется отфильтрованные заметки для удаления заметки
      filteredNotoes.removeAt(index); // это удалить элемент
    });
  }

  // функция чтобы user с мог найти нужную заметку
  void onSearchText(String searchText) {
    setState(() {
      filteredNotoes = sampleNotes
          .where((note) =>
              note.content.toLowerCase().contains(searchText.toLowerCase()) ||
              note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList(); // метод работы в простом списке заметок
    });
  }

  // список отфильтрованными заметками
  List<Note> filteredNotoes = [];
  bool sorted = false;
  // метод сосотояния инициализаций
  void initState() {
    super.initState();
    filteredNotoes = sampleNotes;
  }

  // функция которая выполняет сортировку
  List<Note> sortNotesByModifiedTime(List<Note> notes) {
    if (sorted) {
      notes.sort(
        (a, b) => a.modifiedTime.compareTo(b.modifiedTime),
      );
    } else {
      notes.sort(
        (b, a) => a.modifiedTime.compareTo(b.modifiedTime),
      );
    }
    sorted = !sorted;
    return notes;
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    Size mySize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 80, 16, 0),
        child: Column(
          children: [
            // AppBar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Дневник",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade800.withOpacity(.8),
                      borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        setState(() {
                          filteredNotoes =
                              sortNotesByModifiedTime(filteredNotoes);
                        });
                      },
                      icon: const Icon(
                        Icons.sort,
                        color: Colors.white,
                      )),
                )
              ],
            ),
            SizedBox(
              height: mySize.height * 0.02,
            ),
            // поиск причечания
            TextField(
              onChanged: onSearchText,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                hintText: "Искать примечания...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                fillColor: Colors.grey.shade800,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            // Карточки отображения
            Expanded(
                child: ListView.builder(
              padding: EdgeInsets.only(top: 30),
              // Два обязательных свойства:
              // 1) колличество элементов
              itemCount: filteredNotoes.length,
              // 2) построитель элементов
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 20),
                  color: getRandomColor(),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      // для редактирования
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => EditScreen(
                              note: filteredNotoes[index],
                            ), // фильтрировать индекс узла
                          ),
                        );
                        // сохранить выбронного заметка
                        if (result != null) {
                          setState(() {
                            int originalIndex =
                                sampleNotes.indexOf(filteredNotoes[index]);
                            sampleNotes[originalIndex] = (Note(
                                id: sampleNotes[originalIndex].id,
                                title: result[0],
                                content: result[1],
                                modifiedTime: DateTime.now()));
                            filteredNotoes[index] = Note(
                                id: filteredNotoes[index].id,
                                title: result[0],
                                content: result[1],
                                modifiedTime: DateTime.now());
                          });
                        }
                      },
                      title: RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text:
                                '${filteredNotoes[index].title} :\n', // реорганизировать карту
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: filteredNotoes[index].content,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ]),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Отредактировано: ${DateFormat('EEE MMM d, yyyy h:mm a').format(filteredNotoes[index].modifiedTime)}', // класс формата даты для форматирования нашей даты и времени, (intl)
                          style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                          onPressed: () async {
                            // выбор user
                            final result = await
                                // подверждение перед удалением
                                confirmDialog(context);
                            // выбор user на удаление
                            if (result != null && result) {
                              deleteNote(index);
                            }
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                  ),
                );
              }, // функция обратного вызова которые дает нам индекс, который мы можем использовать для создание каждого элемента в списке
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade800,
        elevation: 10,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => EditScreen(),
            ),
          );
          // добавление новых заметок
          if (result != null) {
            setState(() {
              sampleNotes.add(Note(
                  id: sampleNotes.length,
                  title: result[0],
                  content: result[1],
                  modifiedTime: DateTime.now()));
              filteredNotoes = sampleNotes;
            });
          }
        },
        child: const Icon(
          Icons.add,
          size: 38,
        ),
      ),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade800,
            icon: const Icon(
              Icons.info,
              color: Colors.grey,
              size: 30,
            ),
            title: const Text(
              "Вы уверены, что хотите удалить ?",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const SizedBox(
                    width: 60,
                    child: Text(
                      "Да",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false); // отмена удаление
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const SizedBox(
                    width: 60,
                    child: Text(
                      "Нет",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
