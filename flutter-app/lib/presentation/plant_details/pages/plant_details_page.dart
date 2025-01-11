import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_plant_pot/injection.dart';
import 'package:smart_plant_pot/models/models.dart';
import 'package:smart_plant_pot/presentation/plant_details/plant_details.dart';

class PlantDetailsPage extends StatelessWidget {
  const PlantDetailsPage({super.key, required this.ctx, required this.plant});

  final BuildContext ctx;
  final PlantData plant;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<PlantDetailsCubit>()..getPlantSlotDetails(plant.id),
        ),
        BlocProvider(create: (context) => getIt<PlantDetailsDataCubit>()..init(plant.id)),
      ],
      child: Builder(builder: (context) {
        return BlocBuilder<PlantDetailsCubit, PlantDetailsState>(
          builder: (context, state) {
            if (state is PlantDetailsError) {
              return Scaffold(
                appBar: AppBar(title: Text('${plant.name} details')),
                body: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(state.error),
                    ),
                  ),
                ),
              );
            } else if (state is PlantDetailsSuccess) {
              final plantDetails = state.plant;

              return Scaffold(
                appBar: AppBar(title: Text('${plant.name} details')),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          if (plant.image != null)
                            Container(
                              height: MediaQuery.of(context).size.height * .3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              child: Center(child: Image.network(plant.image!)),
                            ),
                          const SizedBox(height: 20),
                          Text(
                            plant.name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (plant.image != null)
                                CircleAvatar(backgroundImage: NetworkImage(plant.image!)),
                              const SizedBox(width: 20),
                              Column(
                                children: [
                                  Text(plantDetails.plantName),
                                  Text(
                                    [
                                      ...(plantDetails.otherNames ?? []),
                                      ...plantDetails.scientificNames,
                                    ].join(', '),
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  )
                                ],
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: <Widget>[
                                      const Icon(Icons.sunny, size: 12, color: Colors.orange),
                                      const SizedBox(width: 4),
                                      Text(
                                        plantDetails.sunlightRequirements?.join(', ') ?? '-',
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
                                      const SizedBox(width: 4),
                                      Text(
                                        plantDetails.wateringRequirements ?? '-',
                                        style: const TextStyle(fontSize: 8),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          BlocBuilder<PlantDetailsDataCubit, PlantDetailsDataState>(
                            builder: (context, dataState) {
                              final isLoading = dataState.isLoading;

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      const CircleAvatar(
                                        radius: 32,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.device_thermostat, color: Colors.green),
                                      ),
                                      const SizedBox(height: 10),
                                      isLoading
                                          ? SizedBox(
                                              height: 32,
                                              width: MediaQuery.of(context).size.width * .2,
                                              child: const LinearProgressIndicator(),
                                            )
                                          : Column(
                                              children: [
                                                const Text(
                                                  'Temperature',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black26,
                                                  ),
                                                ),
                                                Text(
                                                  dataState.temperature != null
                                                      ? '${dataState.temperature!.toStringAsFixed(1)}°C'
                                                      : '-',
                                                  style:
                                                      const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const CircleAvatar(
                                        radius: 32,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.sunny, color: Colors.orange),
                                      ),
                                      const SizedBox(height: 10),
                                      isLoading
                                          ? SizedBox(
                                              height: 32,
                                              width: MediaQuery.of(context).size.width * .2,
                                              child: const LinearProgressIndicator(),
                                            )
                                          : Column(
                                              children: [
                                                const Text(
                                                  'UV | Lux',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black26,
                                                  ),
                                                ),
                                                Text(
                                                  '${(dataState.uv != null ? dataState.uv!.toString() : '-')} | ${(dataState.lux != null ? dataState.lux!.toString() : '-')}',
                                                  style:
                                                      const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const CircleAvatar(
                                        radius: 32,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.water_drop_rounded, color: Colors.blue),
                                      ),
                                      const SizedBox(height: 10),
                                      isLoading
                                          ? SizedBox(
                                              height: 32,
                                              width: MediaQuery.of(context).size.width * .2,
                                              child: const LinearProgressIndicator(),
                                            )
                                          : Column(
                                              children: [
                                                const Text(
                                                  'Moisture',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black26,
                                                  ),
                                                ),
                                                Text(
                                                  dataState.moisture != null
                                                      ? '${dataState.moisture}%'
                                                      : '-',
                                                  style:
                                                      const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return Scaffold(
              appBar: AppBar(title: Text('${plant.name} details')),
              body: const SafeArea(child: Center(child: CircularProgressIndicator())),
            );
          },
        );
      }),
    );
  }
}
