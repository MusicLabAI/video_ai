import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/ui_colors.dart';

class CreditsRulesWidget extends StatelessWidget {
  const CreditsRulesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 32),
      decoration: const ShapeDecoration(
        color: UiColors.c23242A,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(children: [
            Center(
              child: Text(
                "textImage".tr,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16),
              ),
            ),
            Positioned(
                right: 0,
                child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      'assets/images/ic_close.png',
                      width: 24,
                    )))
          ]),
          const SizedBox(
            height: 16,
          ),
          Text(
            "textImageDesc".tr,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          // 表格标题
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                "creditsCalculationRules".tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          // 表格内容
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: UiColors.black,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dividerThickness: 0,
                    horizontalMargin: 0,
                    showCheckboxColumn: false,
                    columnSpacing: 0,
                    headingRowHeight: 40,
                    dataRowMinHeight: 40,
                    dataRowMaxHeight: 40,
                    border: const TableBorder.symmetric(
                        inside: BorderSide(color: UiColors.c333333),
                        outside: BorderSide(color: UiColors.c333333)),
                    columns: [
                      _buildDataColumn(''), // 空标题
                      _buildDataColumn('5s'),
                      _buildDataColumn('10s'),
                      _buildDataColumn('15s'),
                      _buildDataColumn('20s'),
                    ],
                    rows: [
                      _buildRow('480p\nsquare', [10, 20, 30, 40]),
                      _buildRow('480p  ', [15, 30, 45, 60]),
                      _buildRow('720p\nsquare', [20, 40, 60, 80]),
                      _buildRow('720p  ', [30, 60, 90, 120]),
                      _buildRow('1080p\nsquare', [50, 100, 150, 200]),
                      _buildRow('1080p', [100, 200, 300, 400]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 方法：创建 DataColumn
  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: _buildItem(label),
    );
  }

  // 方法：创建 DataRow
  DataRow _buildRow(String resolution, List<int> values) {
    return DataRow(
      cells: [
        DataCell(_buildItem(resolution)),
        ...values.map((value) {
          return DataCell(_buildItem(value.toString(), hasIcon: true));
        }),
      ],
    );
  }

  Widget _buildItem(String text, {bool hasIcon = false}) {
    return SizedBox(
      width: 70,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasIcon)
            Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Image.asset("assets/images/ic_point.png", width: 18)),
          Text(
            text,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: UiColors.cDBFFFFFF,
                fontSize: 10,
                fontWeight: FontWeightExt.semiBold),
          ),
        ],
      ),
    );
  }
}
