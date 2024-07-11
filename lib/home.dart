import 'package:flutter/material.dart';
import 'data_controller.dart';
import 'data_model.dart';
import 'package:provider/provider.dart';



class DataView extends StatefulWidget {
  @override
  _DataViewState createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataController>(context, listen: false).fetchData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      Provider.of<DataController>(context, listen: false).loadMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MVC with Pagination Example'),
      ),
      body: Consumer<DataController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.dataModel.userList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.statusMessage.isNotEmpty) {
            return Center(child: Text(controller.statusMessage));
          } else {
            return ListView.builder(
              controller: _scrollController,
              itemCount: controller.dataModel.userList.length,
              itemBuilder: (context, index) {
                User user = controller.dataModel.userList[index];
                return ListTile(
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email),
                );
              },
            );
          }
        },
      ),
    );
  }
}
