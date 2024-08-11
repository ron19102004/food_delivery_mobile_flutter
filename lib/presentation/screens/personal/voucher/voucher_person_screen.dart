import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/assets/images/index.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/datasource/repositories/voucher_repository.dart';

import '../../../../configs/dependency_injection.dart';

class VoucherPersonScreen extends StatefulWidget {
  const VoucherPersonScreen({super.key});

  @override
  State<VoucherPersonScreen> createState() => _VoucherPersonScreenState();
}

class _VoucherPersonScreenState extends State<VoucherPersonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Vouchers Hot",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: di<VoucherRepository>().getVoucher("", true),
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
              final voucher = list[index];
              return ListTile(
                minLeadingWidth: 100,
                tileColor: index % 2 == 0 ? Colors.orange.shade50 : Colors.white,
                title: Text(voucher.name),
                trailing: IconButton(
                    onPressed: () {
                      // Copy the text to the clipboard
                      Clipboard.setData(ClipboardData(text: voucher.code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Code copied to clipboard!')),
                      );
                    },
                    icon: const Icon(Icons.copy)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Sold: ${voucher.quantity - voucher.quantityCurrent}/${voucher.quantity}"),
                    Text("Code: ${voucher.code}"),
                  ],
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(
                        voucher.categoryModel.image ?? "",
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          ImagePath.logo.path,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5))),
                            child: Text(
                              "${voucher.percent}%",
                              style: const TextStyle(color: Colors.white),
                            )))
                  ]),
                ),
              );
            },
          );
        },
      )),
    );
  }
}
