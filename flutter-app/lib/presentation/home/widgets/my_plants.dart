import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_plant_pot/presentation/home/bloc/home_cubit.dart';
import 'package:smart_plant_pot/presentation/widgets/widgets.dart';

class HomeMyPlants extends StatelessWidget {
  const HomeMyPlants({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.plants == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.plants!.isEmpty) {
          return const Center(child: Text('No plants'));
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height * .3,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return PlantCard(state.plants![index], isJustRefreshed: state.isPlantStatsRefreshed);
            },
            itemCount: state.plants!.length,
          ),
        );
      },
    );
  }
}
