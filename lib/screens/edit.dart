import 'package:flutter/material.dart';

import '../models/note.dart';

class EditScreen extends StatefulWidget {
  // Заметка которое будет получать значения узла, который был нажат
  final Note? note;
  const EditScreen({super.key, this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  // Получить ввод из текстового поля
  // 1 для заголовка
  TextEditingController _titleEditingController = TextEditingController();
  // 2 порядок для содержимого заметки
  TextEditingController _contentController = TextEditingController();

  // Метод сосотояние инициализаций
  @override
  void initState() {
    // TODO: implement initState
    if (widget.note != null) {
      _titleEditingController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 80, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade800.withOpacity(.8),
                      borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      )),
                )
              ],
            ),
            Expanded(
                child: ListView(
              children: [
                TextField(
                  controller: _titleEditingController,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Заголовок",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 30)),
                ),
                TextField(
                  controller: _contentController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  maxLines: null, // заголовок узла под содержимым
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Введите что-нибудь",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      )),
                ),
              ],
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        onPressed: () {
          // сохранить заметку
          Navigator.pop(
              context, [_titleEditingController.text, _contentController.text]);
        },
        child: const Icon(
          Icons.save,
          size: 30,
        ),
      ),
    );
  }
}
