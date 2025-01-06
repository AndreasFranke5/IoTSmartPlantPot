import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:smart_plant_pot/dtos/dtos.dart';
import 'package:smart_plant_pot/injection.dart';
import 'package:smart_plant_pot/logger.dart';
import 'package:smart_plant_pot/models/models.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:smart_plant_pot/presentation/common/widgets/widgets.dart';

import 'package:smart_plant_pot/presentation/home/home.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key, required this.ctx, this.device, this.plant});

  final BuildContext ctx;

  final Device? device;
  final PlantEmpty? plant;

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> with WidgetsBindingObserver {
  final _overlay = LoadingOverlay();
  late final TextEditingController _nameTec;
  late final FocusNode _nameFocusNode;
  Device? _selectedDevice;
  PlantEmpty? _selectedPlant;
  PredefinedPlant? _selectedPrePlant;
  bool isValid = false;

  @override
  void initState() {
    super.initState();

    _nameTec = TextEditingController()
      ..addListener(
        () => setState(
          () {
            isValid = _nameTec.text.isNotEmpty && _selectedDevice != null && _selectedPlant != null;
          },
        ),
      );
    _nameFocusNode = FocusNode();
    _selectedDevice = widget.device;
    _selectedPlant = widget.plant;
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
        BlocProvider(create: (context) => getIt<AddPlantCubit>()),
      ],
      child: Builder(builder: (context) {
        return BlocConsumer<AddPlantCubit, AddPlantState>(
          listener: (context, state) {
            if (state is AddPlantLoading) {
              _overlay.show(context);
            } else {
              _overlay.hide();
            }

            if (state is AddPlantSuccess) {
              context.read<HomeCubit>().getPlants();
              Navigator.of(context).pop();
            } else if (state is AddPlantError) {
              logger.e(state.error);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Add Plant'),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            return DropdownMenu<Device>(
                              width: double.infinity,
                              initialSelection: _selectedDevice,
                              label: Text(_selectedDevice != null ? 'Device' : 'Select a device'),
                              onSelected: (value) {
                                if (value != null) setState(() => _selectedDevice = value);
                              },
                              dropdownMenuEntries: (state.devices ?? []).map((value) {
                                return DropdownMenuEntry<Device>(
                                  value: value,
                                  label: value.name,
                                );
                              }).toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            return DropdownMenu<Plant>(
                              width: double.infinity,
                              initialSelection: _selectedPlant,
                              label: Text(_selectedPlant != null ? 'Slot' : 'Select a slot'),
                              onSelected: (value) {
                                if (value != null && value is PlantEmpty) {
                                  setState(() => _selectedPlant = value);
                                }
                              },
                              dropdownMenuEntries: (state.plants ?? [])
                                  .where((element) => element.deviceId == _selectedDevice?.deviceId)
                                  .mapWithIndex((value, i) {
                                return DropdownMenuEntry<Plant>(
                                  enabled: value is PlantEmpty,
                                  value: value,
                                  label: value is PlantData
                                      ? '${value.name} (Slot ${++i})'
                                      : 'Slot ${++i}',
                                );
                              }).toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        BlocSelector<HomeCubit, HomeState, bool>(
                          selector: (state) => state.isLoadingPredefinedPlants,
                          builder: (context, isLoading) {
                            return DropdownSearch<PredefinedPlant>(
                              items: (search, cs) =>
                                  context.read<HomeCubit>().getPredefinedPlants(search: search),
                              itemAsString: (item) => item.name,
                              compareFn: (item1, item2) => item1.id == item2.id,
                              selectedItem: _selectedPrePlant,
                              onChanged: (value) {
                                if (value != null) setState(() => _selectedPrePlant = value);
                              },
                              decoratorProps: DropDownDecoratorProps(
                                decoration: const InputDecoration()
                                    .applyDefaults(Theme.of(context).inputDecorationTheme)
                                    .copyWith(
                                      label: const Text('Plant'),
                                      hintText: 'Select a plant',
                                    ),
                              ),
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                loadingBuilder: isLoading
                                    ? (_, __) => const Center(child: CircularProgressIndicator())
                                    : null,
                                itemBuilder: (context, item, isDisabled, isSelected) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: item.image != null
                                        ? NetworkImage(item.image!)
                                        : const AssetImage('assets/images/placeholder.png')
                                            as ImageProvider,
                                  ),
                                  title: Text(item.name),
                                  subtitle: Text(
                                    [
                                      ...(item.otherNames ?? []),
                                      ...item.scientificNames,
                                    ].join(', '),
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                  trailing: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            const Icon(Icons.sunny, size: 12, color: Colors.orange),
                                            Text(
                                              item.sunlightRequirements?.join(', ') ?? '-',
                                              style: const TextStyle(fontSize: 8),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.water_drop,
                                              size: 12,
                                              color: Colors.blue[200],
                                            ),
                                            Text(
                                              item.wateringRequirements ?? '-',
                                              style: const TextStyle(fontSize: 8),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                fit: FlexFit.loose,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        if (_selectedPrePlant != null)
                          Row(
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.network(
                                  _selectedPrePlant!.image ?? '',
                                  width: double.infinity,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedPrePlant!.name,
                                    style:
                                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    [
                                      ...(_selectedPrePlant!.otherNames ?? []),
                                      ..._selectedPrePlant!.scientificNames,
                                    ].join(', '),
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      const Icon(Icons.sunny, size: 12, color: Colors.orange),
                                      Text(
                                        _selectedPrePlant!.sunlightRequirements?.join(', ') ?? '-',
                                        style: const TextStyle(fontSize: 8),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.water_drop,
                                        size: 12,
                                        color: Colors.blue[200],
                                      ),
                                      Text(
                                        _selectedPrePlant!.wateringRequirements ?? '-',
                                        style: const TextStyle(fontSize: 8),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        TextField(
                          focusNode: _nameFocusNode,
                          controller: _nameTec,
                          decoration: const InputDecoration(
                            labelText: 'Plant Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: state is AddPlantLoading || !isValid
                              ? null
                              : () {
                                  final plant = AddPlantDto(
                                    deviceId: _selectedPlant!.deviceId,
                                    slotId: _selectedPlant!.id,
                                    plantId: _selectedPrePlant!.id,
                                    name: _nameTec.text,
                                  );
                                  context.read<AddPlantCubit>().addPlant(plant);
                                },
                          child: const Text('Add'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
