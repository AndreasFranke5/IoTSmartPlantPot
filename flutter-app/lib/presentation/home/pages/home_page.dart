import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_plant_pot/injection.dart';
import 'package:smart_plant_pot/presentation/auth/auth.dart';
import 'package:smart_plant_pot/presentation/common/auth/bloc/auth_cubit.dart';
import 'package:smart_plant_pot/presentation/common/widgets/widgets.dart';
import 'package:smart_plant_pot/presentation/home/home.dart';
import 'package:smart_plant_pot/presentation/widgets/chip_rounded.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ExpandableFabState> childKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()
        ..getDevices()
        ..getPlants()
        ..getPlantsStats(),
      child: Builder(builder: (context) {
        return BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthInitial) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AuthPage()),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              // backgroundColor: const Color.fromRGBO(230, 228, 215, 1),
              title: const Text('Smart Plant Pot'),
              actions: [
                IconButton(
                  onPressed: context.read<AuthCubit>().logout,
                  icon: const Icon(Icons.logout_outlined),
                ),
              ],
              // bottom: const PreferredSize(
              //   preferredSize: Size.fromHeight(50),
              //   child: Wrap(
              //     spacing: -6,
              //     children: [
              //       ChipRounded(
              //         label: 'Both',
              //         isSelected: true,
              //       ),
              //       ChipRounded(
              //         label: 'Indoor',
              //         isSelected: false,
              //       ),
              //       ChipRounded(
              //         label: 'Outdoor',
              //         isSelected: false,
              //       ),
              //     ],
              //   ),
              // ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: const Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Plants',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // ElevatedButton(onPressed: () {}, child: const Text('View all'))
                        ],
                      ),
                    ),
                    HomeMyPlants(),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Devices',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // ElevatedButton(onPressed: () {}, child: const Text('View all'))
                        ],
                      ),
                    ),
                    HomeMyDevices(),
                  ],
                ),
              ),
            ),
            floatingActionButton: ExpandableFab(
              key: childKey,
              distance: 80,
              children: [
                ActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddDevicePage(ctx: context)),
                    );
                    if (childKey.currentState != null) childKey.currentState!.toggle();
                  },
                  icon: const Text(
                    'Add Device',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return ActionButton(
                      onPressed: state.devices != null && state.devices!.isNotEmpty
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => AddPlantPage(ctx: context)),
                              );
                              if (childKey.currentState != null) childKey.currentState!.toggle();
                            }
                          : null,
                      icon: Text(
                        'Add Plant',
                        style: TextStyle(
                          color: state.devices != null && state.devices!.isNotEmpty
                              ? Colors.white
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
