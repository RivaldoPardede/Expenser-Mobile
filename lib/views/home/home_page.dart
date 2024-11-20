import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<FlSpot> getSpots() {
    return [
      FlSpot(0, 500000),
      FlSpot(1, 250000),
      FlSpot(2, 500000),
      FlSpot(3, 200000),
      FlSpot(4, 250000),
      FlSpot(5, 250000),
      FlSpot(6, 500000),
    ];
  }

  String? selectedValue = 'Week1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Menonaktifkan tombol back
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 16.0),
          //   child: Icon(Icons.notifications, color: Colors.grey),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xFF4391DE),
                            child: Icon(Icons.account_balance_wallet, color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text('Total Balance', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('IDR 1.000.000',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  //Box For Add Account
                  SizedBox(width: 18),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xFF4391DE),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text('Add account', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                //Cart Information
                child:Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            'Expend',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          DropdownButton<String>(
                            value: selectedValue,
                            items: [
                              DropdownMenuItem(
                                value: 'Week1',
                                child: Text('Week1'),
                              ),
                              DropdownMenuItem(
                                value: 'Week2',
                                child: Text('Week2'),
                              ),
                              DropdownMenuItem(
                                value: 'Week3',
                                child: Text('Week3'),
                              ),
                              DropdownMenuItem(
                                value: 'Week4',
                                child: Text('Week4'),
                              ),
                            ],
                            onChanged: (String? value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 200,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 100000,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey.withOpacity(0.2),
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: Colors.grey.withOpacity(0.2),
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                interval: 100000,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${(value / 1000).toInt()}k',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const titles = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      titles[value.toInt()],
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: 6,
                          minY: 0,
                          maxY: 600000,
                          lineBarsData: [
                            LineChartBarData(
                              spots: getSpots(),
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 2,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 6,
                                    color: Colors.white,
                                    strokeWidth: 2,
                                    strokeColor: Colors.blue,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.1),
                              ),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.white,
                              tooltipRoundedRadius: 8,
                              tooltipPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                return touchedBarSpots.map((barSpot) {
                                  return LineTooltipItem(
                                    '${barSpot.y.toStringAsFixed(0)}',
                                    TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                            handleBuiltInTouches: true,
                            getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                              return spotIndexes.map((spotIndex) {
                                return TouchedSpotIndicatorData(
                                  FlLine(
                                    color: Colors.blue.withOpacity(0.2),
                                    strokeWidth: 2,
                                    dashArray: [3, 3],
                                  ),
                                  FlDotData(
                                    getDotPainter: (spot, percent, barData, index) {
                                      return FlDotCirclePainter(
                                        radius: 8,
                                        color: Colors.white,
                                        strokeWidth: 3,
                                        strokeColor: Colors.blue,
                                      );
                                    },
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //For Top Expenses
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Top Expenses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    // Menambahkan Divider untuk garis pemisah
                    Divider(
                      color: Colors.black.withOpacity(0.2), // Menentukan warna garis
                      thickness: 0.5,       // Menentukan ketebalan garis
                      indent: 0,          // Jarak dari kiri
                      endIndent: 0,       // Jarak dari kanan
                    ),
                    Text('THIS MONTH', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(height: 16),
                    _buildExpenseItem('Rent', 'IDR 500.000,00', Colors.orange),
                    SizedBox(height: 12),
                    _buildExpenseItem('Groceries', 'IDR 70.000,00', Colors.red),
                    SizedBox(height: 12),
                    _buildExpenseItem('Clothes & Shoes', 'IDR 70.000,00', Colors.blue),
                    SizedBox(height: 12),
                    _buildExpenseItem('Games', 'IDR 90.000,00', Colors.yellow),
                  ],
                ),
              ),

              //Last Records
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last Records', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Divider(
                      color: Colors.black.withOpacity(0.2), // Menentukan warna garis
                      thickness: 0.5,       // Menentukan ketebalan garis
                      indent: 0,          // Jarak dari kiri
                      endIndent: 0,       // Jarak dari kanan
                    ),
                    Text('THIS MONTH', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(height: 16),
                    _buildRecordItem('Rent', '-IDR 500.000,00', '08 November 2024', 'Voucher', Icons.home, Colors.orange),
                    Divider(
                      color: Colors.black.withOpacity(0.2), // Menentukan warna garis
                      thickness: 0.2,       // Menentukan ketebalan garis
                      indent: 0,          // Jarak dari kiri
                      endIndent: 0,       // Jarak dari kanan
                    ),
                    SizedBox(height: 12),
                    _buildRecordItem('Clothes & Shoes', '-IDR 70.000,00', '09 November 2024', 'Debit Card', Icons.shopping_bag, Colors.blue),
                    Divider(
                      color: Colors.black.withOpacity(0.2), // Menentukan warna garis
                      thickness: 0.2,       // Menentukan ketebalan garis
                      indent: 0,          // Jarak dari kiri
                      endIndent: 0,       // Jarak dari kanan
                    ),
                    SizedBox(height: 12),
                    _buildRecordItem('Groceries', '-IDR 70.000,00', '10 November 2024', 'Cash',  Icons.shopping_cart, Colors.red),
                  ],
                ),
              ),
              SizedBox(height: 80), // Extra space for bottom navigation
            ],
          ),
        ),
      ),
      //Button (+) Ditengah
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF5B9EE1),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.add, size: 22, color: Colors.black), // Ikon besar
            Container(
              width: 25, // Ukuran lingkaran kecil
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(  // Tambahkan ini
                  color: Colors.black,
                  width: 2.0,  // Sesuaikan ketebalan border
                ),
              ),
            ),
          ],
        ),
        elevation: 0, // Memastikan tidak ada bayangan
        shape: CircleBorder(), // Mengatur bentuk menjadi bulat
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //Button Yang Lainnya Pada Bagian Bawah
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color(0xFF5B9EE1),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Statistic',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(width: 24), // Placeholder for the FAB
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time_outlined),
              activeIcon: Icon(Icons.access_time),
              label: 'Planning',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  final List<double> allAmounts = [];
  Widget _buildExpenseItem(String title, String amount, Color color) {
    // Convert amount string to number by cleaning the format
    double cleanAmount = double.parse(amount
        .replaceAll('IDR ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim());

    // Add current amount to the list if not already present
    if (!allAmounts.contains(cleanAmount)) {
      allAmounts.add(cleanAmount);
    }

    // Calculate total by summing all amounts
    double total = allAmounts.reduce((a, b) => a + b);

    // Calculate percentage
    double percentage = (cleanAmount / total) * 100;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(amount),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 24,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.2),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: MediaQuery.of(context).size.width * (percentage / 100) * 0.7,
                  height: 24,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordItem(String title, String amount, String tanggal, String pembayaran, IconData icon, Color color) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14)),
              Text(pembayaran, style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        Column(  // Membungkus amount dan tanggal di dalam Column
          crossAxisAlignment: CrossAxisAlignment.end,  // Agar kedua teks ter-align ke kanan
          children: [
            Text(
              amount,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 4),
            Text(
              tanggal,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}