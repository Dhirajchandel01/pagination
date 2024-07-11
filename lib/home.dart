import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_controller.dart';
import 'data_model.dart';



class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<ViewModel>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: [
          Consumer<ViewModel>(
            builder: (context, viewModel, _) {
              return IconButton(
                icon: Icon(viewModel.viewType == ViewType.list
                    ? Icons.grid_view
                    : Icons.list),
                onPressed: () => viewModel.toggleView(),
              );
            },
          ),
        ],
      ),
      body: Consumer<ViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading && viewModel.userList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.hasError) {
            return const Center(child: Text("Error loading data"));
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!viewModel.isLoading &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                viewModel.loadMoreData();
                return true;
              }
              return false;
            },
            child: viewModel.viewType == ViewType.list
                ? ListView.builder(
              itemCount: viewModel.userList.length,
              itemBuilder: (context, index) {
                User user = viewModel.userList[index];
                return ListTile(
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text('${user.email} ${user.phoneNo}'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text('View Profile'),
                  ),
                );
              },
            )
                : GridView.builder(
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: viewModel.userList.length,
              itemBuilder: (context, index) {
                User user = viewModel.userList[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${user.firstName} ${user.lastName}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text('Email: ${user.email}'),
                        Text('Phone: ${user.phoneNo}'),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('View Profile'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
