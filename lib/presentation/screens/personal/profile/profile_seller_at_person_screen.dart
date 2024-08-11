import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';

class ProfileSellerAtPersonScreen extends StatefulWidget {
  final int id;

  const ProfileSellerAtPersonScreen({super.key, required this.id});

  @override
  State<ProfileSellerAtPersonScreen> createState() =>
      _ProfileSellerAtPersonScreenState();
}

class _ProfileSellerAtPersonScreenState
    extends State<ProfileSellerAtPersonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ContainedTabBarView(
          tabs: const [
            Text('Information'),
            Text('Products'),
            Text('Vouchers'),
          ],
          views: [_infoSeller(), _foodsSeller(), _voucher()],
          onChange: (index){},
          initialIndex: 0,
        ),
      ),
    );
  }

  Widget _infoSeller() {
    return Text("info");
  }

  Widget _foodsSeller() {
    return Text("f");
  }

  Widget _voucher() {
    return Text("d");
  }
}
