import 'package:flutter/material.dart';
import 'package:lojavirtualapp/common/custom_drawer/custom_drawer.dart';
//import 'package:lojavirtualapp/common/order_tile.dart';
import 'package:lojavirtualapp/common/empty_card.dart';
import 'package:lojavirtualapp/common/login_card.dart';
import 'package:lojavirtualapp/models/orders_manager.dart';
import 'package:lojavirtualapp/screens/orders/components/order_tile.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<OrdersManager>(
        builder: (_, ordersManager, __){
          if(ordersManager.user == null){
            return LoginCard();
          }
          if(ordersManager.orders.isEmpty){
            return EmptyCard(
              title: 'Nenhuma compra encontrada!',
              iconData: Icons.border_clear,
            );
          }
          return ListView.builder(
              itemCount: ordersManager.orders.length,
              itemBuilder: (_, index){
                return OrderTile(
                    ordersManager.orders.reversed.toList()[index]
                );
              }
          );
        },
      ),
    );
  }
}