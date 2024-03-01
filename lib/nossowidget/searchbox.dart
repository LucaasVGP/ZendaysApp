import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  SearchBox({
    this.initialValue = '',
    required this.onChanged,
  });

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: 'Pesquisar...',
        prefixIcon: Icon(Icons.search),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _textEditingController.clear();
              widget.onChanged('');
            });
          },
        ),
      ),
    );
  }
}
