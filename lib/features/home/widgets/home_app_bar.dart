import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey,
      title: const Text(
        'Панель управления',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            TextButton(
              onPressed: () {
                // Действия при нажатии на Кнопка 1
              },
              child: const Text(
                'База знаний',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}