import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_plant_pot/presentation/home/bloc/bloc.dart';

class HomeMyDevices extends StatelessWidget {
  const HomeMyDevices({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.devices == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.devices!.isEmpty) {
          return const Center(child: Text('No devices'));
        }
        return SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width * .4,
                decoration: BoxDecoration(
                  border: Border.all(width: 4, color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color.fromRGBO(205, 207, 204, 1),
                      ),
                      // height: constrains.maxHeight * .6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset('assets/logo.png', height: 80),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        state.devices![index].name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              );
            },
            itemCount: state.devices!.length,
          ),
        );
      },
    );
  }
}
