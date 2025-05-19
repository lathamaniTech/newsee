import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/blocs/masters/master_bloc.dart';
import '../blocs/masters/masters_event.dart';
import '../blocs/masters/masters_state.dart';
import '../widgets/master_tile.dart';

class MastersPage extends StatelessWidget {
  const MastersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MastersBloc(),
      child: BlocListener<MastersBloc, MastersState>(
        listenWhen:
            (previous, current) =>
                previous.done != current.done && current.allSynced,
        listener: (context, state) {
          context.goNamed('home');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All master data synced successfully'),
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(title: const Text("Master Data Sync")),
          body: BlocBuilder<MastersBloc, MastersState>(
            builder: (context, state) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...AppConstants.lovMastersList.map((type) {
                    return MasterTile(
                      label:
                          '${type[0].toUpperCase()}${type.substring(1)} Master',
                      type: type,
                      loading: state.loading[type]!,
                      done: state.done[type]!,
                      onTap:
                          () => context.read<MastersBloc>().add(
                            UpdateMaster(type),
                          ),
                    );
                  }),
                  const SizedBox(height: 40),
                  const Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.cloud_download,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Updating Master Data",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
