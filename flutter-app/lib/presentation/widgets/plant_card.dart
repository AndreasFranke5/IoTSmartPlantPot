import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_plant_pot/models/models.dart';

import 'package:smart_plant_pot/presentation/home/home.dart';

class PlantCard extends StatelessWidget {
  const PlantCard(this.plant, {super.key, required this.isJustRefreshed});

  final Plant plant;
  final bool isJustRefreshed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return InkWell(
        onTap: () {
          if (plant is PlantData) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PlantDetailsPage(ctx: context, plant: plant as PlantData)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddPlantPage(
                  ctx: context,
                  device: context
                      .read<HomeCubit>()
                      .state
                      .devices
                      ?.firstWhere((x) => x.deviceId == plant.deviceId),
                  plant: plant as PlantEmpty,
                ),
              ),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
          width: MediaQuery.of(context).size.width * .4,
          decoration: BoxDecoration(
            border: Border.all(width: 4, color: Colors.white),
            borderRadius: BorderRadius.circular(20),
            color: isJustRefreshed && plant is PlantData
                ? Colors.green.withOpacity(.2)
                : Theme.of(context).colorScheme.tertiary,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (plant is PlantData)
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color.fromRGBO(205, 207, 204, 1),
                      ),
                      height: constrains.maxHeight * .6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: (plant as PlantData).image != null
                            ? Image.network((plant as PlantData).image!, fit: BoxFit.cover)
                            : Image.asset('assets/plant1.png'),
                      ),
                    ),
                    Positioned(
                      right: 6,
                      left: 6,
                      bottom: 6,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            (plant as PlantData).name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            context
                                    .read<HomeCubit>()
                                    .state
                                    .devices
                                    ?.firstWhere((element) =>
                                        element.deviceId == (plant as PlantData).deviceId)
                                    .name ??
                                '-',
                            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color.fromRGBO(205, 207, 204, 1),
                      ),
                      height: constrains.maxHeight * .6,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Icon(
                            Icons.add_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 100,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            context
                                    .read<HomeCubit>()
                                    .state
                                    .devices
                                    ?.firstWhere((element) =>
                                        element.deviceId == (plant as PlantEmpty).deviceId)
                                    .name ??
                                '-',
                            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (plant is PlantData)
                BlocSelector<HomeCubit, HomeState, PlantStat>(
                  selector: (state) {
                    final p = plant as PlantData;
                    return state.plantsStats.firstWhere(
                      (element) => element.deviceId == p.deviceId && element.slotId == p.id,
                      orElse: () => PlantStat(slotId: p.id, deviceId: p.deviceId),
                    );
                  },
                  builder: (context, stat) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.device_thermostat, size: 16, color: Colors.green),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              stat.temperature != null
                                  ? '${stat.temperature!.toStringAsFixed(1)}°C'
                                  : '-',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
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
                            Text(
                              '${stat.uv?.toString() ?? ' - '} | ${stat.lux?.toString() ?? ' - '}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.water_drop_rounded, size: 16, color: Colors.blue),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              stat.moisture != null ? '${stat.moisture}%' : '-',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add a plant',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      );
    });
  }
}
