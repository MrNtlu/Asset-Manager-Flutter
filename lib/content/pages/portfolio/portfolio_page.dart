import 'dart:io';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/widgets/portfolio/add_investment_button.dart';
import 'package:asset_flutter/content/widgets/portfolio/investment_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/portfolio_stats_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PortfolioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light),
      child: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait || Platform.isMacOS || Platform.isWindows ? 
          NestedScrollView(
            floatHeaderSlivers: false,
            headerSliverBuilder: ((context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height > 600 ? 420 : 400,
                  floating: true,
                  snap: false,
                  backgroundColor: Colors.white,
                  elevation: 5,
                  flexibleSpace: const FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Center(
                      child: PortfolioStatsHeader(),
                    ),
                  ),
                ),
              ]
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  PortfolioInvestment(),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: const AddInvestmentButton(edgeInsets: EdgeInsets.only(left: 8, right: 8, bottom: 8))
                  ),
                ],
              )
            )
          )
          : 
          CustomScrollView(
            physics: const ScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        const PortfolioStatsHeader(),
                        PortfolioInvestment(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
    );
  }
}