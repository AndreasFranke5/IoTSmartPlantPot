import 'package:flutter/material.dart';
import 'package:smart_plant_pot/presentation/home/home.dart';
import 'package:smart_plant_pot/presentation/widgets/chip_rounded.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: const Color.fromRGBO(230, 228, 215, 1),
        title: const Text('Smart Plant Pot'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Wrap(
            spacing: -6,
            children: [
              ChipRounded(
                label: 'Both',
                isSelected: true,
              ),
              ChipRounded(
                label: 'Indoor',
                isSelected: false,
              ),
              ChipRounded(
                label: 'Outdoor',
                isSelected: false,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Plants',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(onPressed: () {}, child: const Text('View all'))
                  ],
                ),
              ),
              const HomeMyPlants(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Related Plants',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(onPressed: () {}, child: const Text('View all'))
                  ],
                ),
              ),
              const HomeRelatedPlants(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Add plant
        },
      ),
    );
  }
}
