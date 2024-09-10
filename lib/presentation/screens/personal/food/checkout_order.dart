import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/configs/color_config.dart';
import 'package:mobile/configs/dependency_injection.dart';
import 'package:mobile/configs/navigation_screen.dart';
import 'package:mobile/datasource/models/food_model.dart';
import 'package:mobile/datasource/repositories/order_repository.dart';
import 'package:mobile/datasource/services/location_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:toastification/toastification.dart';

import '../../../../datasource/services/auth_service.dart';
import '../../../widgets/map_widget.dart';

class CheckoutOrder extends StatefulWidget {
  final FoodModel food;

  const CheckoutOrder({super.key, required this.food});

  @override
  State<CheckoutOrder> createState() => _CheckoutOrderState();
}

class _CheckoutOrderState extends State<CheckoutOrder> {
  final TextEditingController voucherInput = TextEditingController();
  final TextEditingController noteInput = TextEditingController();
  final TextEditingController addressInput = TextEditingController();
  int quantity = 1;
  late LatLng initialCenter;
  late LatLng latLngShop;

  @override
  void dispose() {
    super.dispose();
    voucherInput.dispose();
    noteInput.dispose();
    addressInput.dispose();
  }

  @override
  void initState() {
    super.initState();
    initialCenter = LatLng(LocationService.locationCurrent.latitude,
        LocationService.locationCurrent.longitude);
    latLngShop = LatLng(widget.food.sellerModel?.latitude ?? 0,
        widget.food.sellerModel?.longitude ?? 0);
  }

  Future<void> _pasteFromClipboard() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    setState(() {
      voucherInput.text = data?.text ?? '';
    });
  }

  void orderHandle() async {
    final res = await di<OrderRepository>().orderFood(
        widget.food.id,
        initialCenter.latitude,
        initialCenter.longitude,
        quantity,
        noteInput.text,
        addressInput.text,
        voucherInput.text);
    if (res.status) {
      context.pop();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
        res.message,
        style: const TextStyle(color: Colors.white),
      )),
    );
  }

  @override
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
            "Order & Checkout",
            style: TextStyle(
                fontSize: 20,
                color: Colors.red.shade600,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _contentWidget()),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: orderHandle,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                          color: ColorConfig.primary,
                          border: Border.all(color: ColorConfig.primary),
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text(
                        "Order",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  )),
            )
          ],
        ));
  }

  SingleChildScrollView _contentWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Product",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () {
              context.pop();
            },
            leading: Image.network(
              widget.food.poster,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            title: Text(
              widget.food.name,
              style: const TextStyle(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            subtitle: Row(
              children: [
                const Text(" Price: ", style: TextStyle(fontSize: 15)),
                Text(
                  "\$${widget.food.price}",
                  style: TextStyle(
                      fontSize: 15,
                      decoration: widget.food.saleOff > 0.0
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                const SizedBox(
                  width: 5,
                ),
                widget.food.saleOff > 0.0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 1),
                        child: Text(
                          " ${widget.food.salePrice}\$",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ColorConfig.primary),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
          Divider(
            color: Colors.grey.shade200,
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Quantity",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              InputQty.int(
                decoration: const QtyDecorationProps(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12))),
                initVal: 1,
                minVal: 1,
                maxVal: 50,
                onQtyChanged: (val) {
                  quantity = int.parse(val.toString());
                },
              )
            ],
          ),
          Divider(
            color: Colors.grey.shade200,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Apply Voucher",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: voucherInput,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: _pasteFromClipboard,
                      icon: const Icon(Icons.paste)),
                  hintText: "Enter any voucher",
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12)),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12))),
            ),
          ),
          Divider(
            color: Colors.grey.shade200,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Notes",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: noteInput,
              decoration: const InputDecoration(
                  hintText: "Enter notes",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12))),
            ),
          ),
          Divider(
            color: Colors.grey.shade200,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Address",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: addressInput,
              decoration: const InputDecoration(
                  hintText: "Enter your address",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12))),
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Map",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              IconButton(
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Scaffold(
                            appBar: AppBar(
                              title: Text(
                                "Map",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade500),
                              ),
                              centerTitle: true,
                              backgroundColor: Colors.grey.shade50,
                              leading: IconButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  icon: const Icon(CupertinoIcons.back)),
                            ),
                            body: MapOrderWidget(
                              initialCenter: initialCenter,
                              latLngUser: initialCenter,
                              latLngShop: latLngShop,
                            ),
                          );
                        });
                  },
                  icon: const Icon(CupertinoIcons.map)),
            ],
          ),
        ],
      ),
    );
  }
}
