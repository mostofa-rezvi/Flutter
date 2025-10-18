class DashboardData {
  final String shopBalance;
  final int totalOrders;
  final int pendingOrders;
  final int deliveredOrders;
  final int completedOrders;
  final int cancelledOrders;

  DashboardData({
    required this.shopBalance,
    required this.totalOrders,
    required this.pendingOrders,
    required this.deliveredOrders,
    required this.completedOrders,
    required this.cancelledOrders,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      shopBalance: json['shop_balance'] ?? '0.0 BDT',
      totalOrders: json['total_orders'] ?? 0,
      pendingOrders: json['pending_orders'] ?? 0,
      deliveredOrders: json['delivered_orders'] ?? 0,
      completedOrders: json['completed_orders'] ?? 0,
      cancelledOrders: json['cancelled_orders'] ?? 0,
    );
  }
}