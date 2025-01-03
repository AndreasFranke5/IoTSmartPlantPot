import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  const PlantCard({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return Container(
        margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
        width: MediaQuery.of(context).size.width * .4,
        decoration: BoxDecoration(
          border: Border.all(width: 4, color: Colors.white),
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.tertiary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                child: Center(child: Image.asset(image)),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.device_thermostat, size: 16, color: Colors.green),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '20 °C',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),

                Column(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.sunny, size: 16, color: Colors.orange),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sunny',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.water_drop_rounded, size: 16, color: Colors.blue),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '90',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ),
      );
    });
  }
}
