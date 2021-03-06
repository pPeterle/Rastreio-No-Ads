import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architeture/modules/home/presenter/home/widgets/add_delivery/add_delivery_bloc.dart';
import 'package:flutter_clean_architeture/modules/home/presenter/home/widgets/add_delivery/events/add_delivery_events.dart';
import 'package:flutter_clean_architeture/modules/home/presenter/home/widgets/add_delivery/states/add_delivery_states.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AddDeliveryBottomSheetWidget extends StatefulWidget {
  const AddDeliveryBottomSheetWidget({Key? key}) : super(key: key);

  @override
  State<AddDeliveryBottomSheetWidget> createState() =>
      _AddDeliveryBottomSheetWidgetState();
}

class _AddDeliveryBottomSheetWidgetState
    extends State<AddDeliveryBottomSheetWidget> {
  final AddDeliveryBloc bloc = Modular.get();
  final TextEditingController _codeTextEditingController =
      TextEditingController();
  final TextEditingController _titleTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    bloc.stream.listen((event) {
      if (event is AddDeliveryForm) {
        final code = event.code;
        _codeTextEditingController.text =
            code ?? _codeTextEditingController.text;

        final title = event.title;
        _titleTextEditingController.text =
            title ?? _titleTextEditingController.text;
      }
    });
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<AddDeliveryStates>(
            stream: bloc.stream,
            builder: (context, snapshot) {
              String? error;
              if (snapshot.data is AddDeliveryError) {
                error = (snapshot.data as AddDeliveryError).codeError;
              }
              print(error);
              return TextField(
                decoration:
                    InputDecoration(hintText: 'C??digo', errorText: error),
                controller: _codeTextEditingController,
                autofocus: true,
              );
            },
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration.collapsed(hintText: 'Nome da'),
            autofocus: true,
            controller: _titleTextEditingController,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Tooltip(
                message: 'Adicionar t??tulo',
                child: Material(
                  child: InkWell(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.short_text,
                        size: 30,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
              Tooltip(
                message: 'Colar c??digo',
                child: Material(
                  child: InkWell(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.paste_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    onTap: () async {
                      final clipbaord =
                          await Clipboard.getData(Clipboard.kTextPlain);
                      bloc.add(PasteCodeClipboard(clipbaord?.text));
                    },
                  ),
                ),
              ),
              const Spacer(),
              TextButton(onPressed: _saveDelivery, child: const Text('Salvar'))
            ],
          )
        ],
      ),
    );
  }

  void _saveDelivery() {
    bloc.add(
      SaveDelivery(
        code: _codeTextEditingController.text,
        title: _titleTextEditingController.text,
      ),
    );
  }
}
