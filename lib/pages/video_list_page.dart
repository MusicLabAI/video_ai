import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/main_controller.dart';

import '../controllers/create_controller.dart';
import '../widgets/video_list_item_widget.dart';

class VideoListPage extends StatefulWidget {
  const VideoListPage({super.key});

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage>
    with AutomaticKeepAliveClientMixin {
  final _createCtr = Get.find<CreateController>();
  BuildContext? _ctx1;
  int _hitIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double leadingOffset = screenHeight / 3;
    return SafeArea(
        bottom: false,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'recent'.tr,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeightExt.semiBold),
            ),
          ),
          Expanded(
              child: ListViewObserver(
            autoTriggerObserveTypes: const [
              ObserverAutoTriggerObserveType.scrollEnd,
            ],
            sliverListContexts: () {
              return [if (_ctx1 != null) _ctx1!];
            },
            leadingOffset: leadingOffset,
            onObserveAll: (resultMap) {
              final model = resultMap[_ctx1];
              if (model == null) return;

              if (_hitIndex != model.firstChild?.index) {
                _hitIndex = model.firstChild?.index ?? 0;
                setState(() {});
              }
            },
            child: Obx(
              () => ListView.builder(
                itemCount: _createCtr.promptItems.length,
                itemBuilder: (context, index) {
                  return _buildListItem(context, index);
                },
              ),
            ),
          ))
        ]));
  }

  Widget _buildListItem(BuildContext context, int index) {
    _ctx1 = context;
    final model = _createCtr.promptItems.value[index];
    return AspectRatio(
      aspectRatio: model.ratio,
      child: Stack(
        children: [
          Positioned.fill(
              child: _hitIndex == index
                  ? VideoListItemWidget(
                      url: model.videoUrl ?? "",
                      previewImageUrl: model.thumbnailUrl ?? "",
                      fromPosition: "video_list_page_$index",
                    )
                  : CachedNetworkImage(
                      imageUrl: model.thumbnailUrl ?? "",
                      fit: BoxFit.fitWidth,
                    )),
          Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  _createCtr.prompt.value = model.description ?? "";
                  Get.find<MainController>().tabController.index = 1;
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xBA000000),
                      borderRadius: BorderRadius.circular(256)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Text(
                    'tryPrompt'.tr,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: Text(
                  model.tag ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
