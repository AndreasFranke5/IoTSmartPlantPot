import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_plant_pot/dtos/dtos.dart';
import 'package:smart_plant_pot/injection.dart';
import 'package:smart_plant_pot/logger.dart';
import 'package:smart_plant_pot/presentation/common/widgets/widgets.dart';
import 'package:smart_plant_pot/presentation/home/home.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({super.key, required this.ctx});

  final BuildContext ctx;

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> with WidgetsBindingObserver {
  final _overlay = LoadingOverlay();
  late final TextEditingController _nameTec;
  late final FocusNode _nameFocusNode;
  String _deviceId = 'Scan the QR code to get the device ID';
  bool isValid = false;

  @override
  void initState() {
    super.initState();

    _nameTec = TextEditingController()
      ..addListener(
        () => setState(() => isValid = _nameTec.text.isNotEmpty && _deviceId.isNotEmpty),
      );
    _nameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameTec.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.ctx.read<HomeCubit>()..getPredefinedPlants()),
        BlocProvider(create: (context) => getIt<AddDeviceCubit>()),
      ],
      child: Builder(builder: (context) {
        return BlocConsumer<AddDeviceCubit, AddDeviceState>(listener: (context, state) {
          if (state is AddDeviceLoading) {
            _overlay.show(context);
          } else {
            _overlay.hide();
          }

          if (state is AddDeviceSuccess) {
            context.read<HomeCubit>().getDevices();
            Navigator.of(context).pop();
          } else if (state is AddDeviceError) {
            logger.e(state.error);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
        }, builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Device'),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: state is AddPlantLoading
                            ? null
                            : () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const QrScanPage()),
                                );
                                if (result != null) {
                                  setState(() => _deviceId = result.toString());
                                  _nameFocusNode.requestFocus();
                                }
                              },
                        child: const Text('Scan QR Code'),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(_deviceId),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        focusNode: _nameFocusNode,
                        controller: _nameTec,
                        decoration: const InputDecoration(
                          labelText: 'Device Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: state is AddPlantLoading || !isValid
                            ? null
                            : () {
                                final device = AddDeviceDto(
                                  deviceId: _deviceId,
                                  name: _nameTec.text,
                                );
                                context.read<AddDeviceCubit>().addDevice(device);
                              },
                        child: const Text('Add'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      }),
    );
  }
}
