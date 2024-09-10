import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/datasource/models/order_model.dart';
import 'package:mobile/datasource/repositories/order_repository.dart';

import '../../../../configs/color_config.dart';
import '../../../../configs/dependency_injection.dart';

class MyOrderPersonScreen extends StatefulWidget {
  const MyOrderPersonScreen({super.key});

  @override
  State<MyOrderPersonScreen> createState() => _MyOrderPersonScreenState();
}

class _MyOrderPersonScreenState extends State<MyOrderPersonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        surfaceTintColor: Colors.grey.shade100,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(CupertinoIcons.back)),
        backgroundColor: Colors.grey.shade50,
        shadowColor: Colors.grey.shade50,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "My Orders",
          style: TextStyle(
              fontSize: 20,
              color: Colors.red.shade600,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
          future: di<OrderRepository>().myOrder(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorConfig.primary,
                ),
              );
            }
            final list = snapshot.data!;
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  return _orderItem(item);
                });
          }),
    );
  }

  ListTile _orderItem(OrderModel order) {
    return ListTile(
      leading: Image.network(
        order.food.poster,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
      title: Text(
        order.food.name,
        style: const TextStyle(),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total price: \$${order.total}"),
          Text(
              "Deliver name: ${order.deliver == null ? "Unknown" : order.deliver!.name}"),
          Text(
              "Deliver phone: ${order.deliver == null ? "Unknown" : order.deliver!.phoneNumber}")
        ],
      ),
    );
  }
}
