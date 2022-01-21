import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/widgets/portfolio_main_section.dart';
import 'package:asset_flutter/content/widgets/portfolio_section_title.dart';
import 'package:asset_flutter/content/widgets/portfolio_stats.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PortfolioPage extends StatelessWidget {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Center(
            child: Column(
              children: [
                Container(
                  color: TabsPage.darkBlueColor,
                  padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 8)),
                PortfolioMainSection(),
                const PortfolioStats(),
                InkWell(
                  onTap: () {
                    print("Investments Pressed");
                  },
                  child: Column(
                    children: [
                      const PortfolioSectionTitle("Investments", "Details>"),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: SizedBox(
                          height: 125,
                          child: ListView.builder(itemBuilder: ((context, index) {
                              return Card(
                                color: TabsPage.darkBlueColor,
                                margin: const EdgeInsets.only(left: 8, bottom: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 12, right: 16, left: 16),
                                      child: Column(
                                        children: [
                                          const Expanded(
                                            flex: 1,
                                            child: Text(
                                              "BTC/USD",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: const[
                                                  Padding(
                                                      padding: EdgeInsets.only(right: 6),
                                                      child: Icon(
                                                        Icons.account_balance_wallet_rounded,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      '45038212.82', 
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold
                                                      )
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: const[
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 6),
                                                      child: Icon(
                                                        Icons.tag,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      '0.0472', 
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold
                                                      )
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  true ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                                                  color: true ? TabsPage.greenColor : Colors.red.shade700,
                                                  size: 15,
                                                ),
                                                Text(
                                                  "430.23",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: true ? TabsPage.greenColor : Colors.red.shade700,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]
                                ) 
                              );
                            }),
                            itemCount: 20,
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<PieChartSectionData> getSections() => PieData.data
    .asMap()
    .map<int, PieChartSectionData>((index, data) {
      final value = PieChartSectionData(
        color: data.color,
        value: data.percent,
        showTitle: false,
        radius: 45,
        titleStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
            fontSize: 12),
      );
      return MapEntry(index, value);
    })
    .values
    .toList();

class PieData {
  static List<Data> data = [
    Data(name: 'Crypto', percent: 40, color: TabsPage.primaryColor),
    Data(name: 'Exchange', percent: 0, color: TabsPage.orangeColor),
    Data(name: 'Stock', percent: 60, color: TabsPage.blueColor),
  ];
}

class Data {
  final String name;

  final double percent;

  final Color color;

  Data({required this.name, required this.percent, required this.color});
}
