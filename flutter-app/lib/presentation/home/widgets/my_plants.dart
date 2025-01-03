import 'package:flutter/material.dart';
import 'package:smart_plant_pot/presentation/widgets/widgets.dart';

const plants = ['assets/plant1.png', 'assets/plant2.png', 'assets/plant3.png'];

class HomeMyPlants extends StatelessWidget {
  const HomeMyPlants({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return PlantCard(
            image: plants[index],
          );
        },
        itemCount: plants.length,
      ),
    );
  }
}
