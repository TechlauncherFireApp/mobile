import 'package:fireapp/base/widget.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/presentation/volunteer_list/volunteer_list_viewmodel.dart';
import 'package:fireapp/widgets/request_state_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class VolunteerList extends StatefulWidget {
  const VolunteerList({super.key});

  @override
  State createState() => _VolunteerListState();
}

class _VolunteerListState extends FireAppState<VolunteerList>
  implements ViewModelHolder<VolunteerListViewModel> {

  @override
  VolunteerListViewModel viewModel = GetIt.instance.get();

  @override
  void initState() {
    super.initState();
    viewModel.getVolunteerList();
  }

  @override
  Widget build(BuildContext context) {
    return RequestStateWidget.stream<List<VolunteerListing>>(
        state: viewModel.volunteers,
        retry: viewModel.getVolunteerList,
        child: (_,volunteers) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: volunteers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(volunteers[index].name),
                          subtitle: Text(volunteers[index].volunteerId),
                    );
                  },
                ),
              ),
            ],
          );
        }
    );
  }


}


