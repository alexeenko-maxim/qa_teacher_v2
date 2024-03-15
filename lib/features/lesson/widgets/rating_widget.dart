import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  final int maxRating;
  final ValueChanged<int> onChanged;

  const RatingWidget({Key? key, required this.maxRating, required this.onChanged}) : super(key: key);

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late int currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = 0; // Изначально все звезды неактивны
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.maxRating, (index) {
        return IconButton(
          icon: Icon(
            index < currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              currentRating = index + 1; // Устанавливаем текущую оценку
              widget.onChanged(currentRating); // Вызываем обратный вызов при изменении оценки
            });
          },
        );
      }),
    );
  }
}