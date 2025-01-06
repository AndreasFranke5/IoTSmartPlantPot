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
        BlocProvider(create: (context) => getIt<PlantDetailsDataCubit>()..detailsListener()),
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
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * .3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          child: Center(
                            child: plant.image != null
                                ? Image.network(plant.image!)
                                : Image.asset('assets/plant1.png'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          plant.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: plant.image != null
                                ? NetworkImage(plant.image!)
                                : const AssetImage('assets/images/placeholder.png')
                                    as ImageProvider,
                          ),
                          title: Text(plantDetails.plantName),
                          subtitle: Text(
                            [
                              ...(plantDetails.otherNames ?? []),
                              ...plantDetails.scientificNames,
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
                                    Text(
                                      plantDetails.wateringRequirements ?? '-',
                                      style: const TextStyle(fontSize: 8),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                                      radius: 16,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.device_thermostat,
                                          size: 16, color: Colors.green),
                                    ),
                                    const SizedBox(height: 4),
                                    isLoading
                                        ? const LinearProgressIndicator()
                                        : Text(
                                            dataState.temperature != null
                                                ? '${dataState.temperature!.toStringAsFixed(1)}°C'
                                                : '-',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 8),
                                          ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.sunny, size: 16, color: Colors.orange),
                                    ),
                                    const SizedBox(height: 4),
                                    isLoading
                                        ? const LinearProgressIndicator()
                                        : Text(
                                            dataState.sunlight ?? '-',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 8),
                                          ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.water_drop_rounded,
                                          size: 16, color: Colors.blue),
                                    ),
                                    const SizedBox(height: 4),
                                    isLoading
                                        ? const LinearProgressIndicator()
                                        : Text(
                                            dataState.moisture != null
                                                ? '${dataState.moisture!.toStringAsFixed(2)}%'
                                                : '-',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 8),
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
