// import 'dart:typed_data';
//
// import 'package:crop_your_image/crop_your_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image/image.dart' as img;
// import 'package:video_ai/widgets/custom_button.dart';
// import 'package:video_ai/widgets/loading_widget.dart';
//
// import '../common/ui_colors.dart';
//
// class ImageCropPage extends StatelessWidget {
//   ImageCropPage(
//       {super.key, required this.originalImage, this.withCircleUi = false});
//
//   final Uint8List originalImage;
//   final bool withCircleUi;
//   final _controller = CropController();
//
//   @override
//   Widget build(BuildContext context) {
//     // 解码原始图像以获取宽高比
//     return Container(
//       color: Colors.black,
//       child: Stack(
//         children: [
//         Crop(
//         image: originalImage,
//         controller: _controller,
//         onCropped: (image) {
//           // do something with image data
//         },
//         aspectRatio: 4 / 3,
//         // initialSize: 0.5,
//         // initialArea: Rect.fromLTWH(240, 212, 800, 600),
//         // initialRectBuilder: (rect, _) => Rect.fromLTRB(
//         //     rect.left + 24, rect.top + 32, rect.right - 24, rect.bottom - 32
//         // ),
//         // withCircleUi: true,
//         baseColor: Colors.blue.shade900,
//         maskColor: Colors.white.withAlpha(100),
//         progressIndicator: const CircularProgressIndicator(),
//         radius: 20,
//         onMoved: (newRect) {
//           // do something with current crop rect.
//         },
//         onStatusChanged: (status) {
//           // do something with current CropStatus
//         },
//         willUpdateScale: (newScale) {
//           // if returning false, scaling will be canceled
//           return newScale < 5;
//         },
//         cornerDotBuilder: (size, edgeAlignment) => const DotControl(color: Colors.blue),
//         clipBehavior: Clip.none,
//         interactive: true,
//         // fixCropRect: true,
//         // formatDetector: (image) {},
//         // imageCropper: myCustomImageCropper,
//         // imageParser: (image, {format}) {},
//       ),
//           // Crop(
//           //   controller: _controller,
//           //   image: originalImage,
//           //   onCropped: (data) async {
//           //     // 解码裁剪后的图像
//           //     final croppedImage = img.decodeImage(data);
//           //     if (croppedImage == null) {
//           //       ScaffoldMessenger.of(context).showSnackBar(
//           //         const SnackBar(content: Text("Failed to crop image.")),
//           //       );
//           //       Navigator.pop(context);
//           //       return;
//           //     }
//           //
//           //     // 设定最大宽高
//           //     const maxWidth = 3920;
//           //     const maxHeight = 3920;
//           //     final aspectRatio = croppedImage.width / croppedImage.height;
//           //
//           //     int newWidth = croppedImage.width;
//           //     int newHeight = croppedImage.height;
//           //
//           //     // 限制宽高
//           //     if (newWidth > maxWidth) {
//           //       newWidth = maxWidth;
//           //       newHeight = (newWidth / aspectRatio).toInt();
//           //     }
//           //     if (newHeight > maxHeight) {
//           //       newHeight = maxHeight;
//           //       newWidth = (newHeight * aspectRatio).toInt();
//           //     }
//           //
//           //     // 调整图像大小
//           //     final resizedImage = img.copyResize(croppedImage,
//           //         width: newWidth, height: newHeight);
//           //
//           //     // 转换为 JPEG 格式并保存
//           //     List<int> jpegBytes = img.encodeJpg(resizedImage, quality: 60);
//           //     final croppedData = Uint8List.fromList(jpegBytes);
//           //
//           //     // 保存或返回裁剪图像
//           //     Navigator.pop(context, croppedData);
//           //   },
//           //   withCircleUi: withCircleUi,
//           //   aspectRatio: 4 / 3,
//           //   // 设置裁剪区域比例
//           //   maskColor: Colors.black.withOpacity(0.5),
//           //   baseColor: Colors.black,
//           //   progressIndicator: const CircularProgressIndicator(),
//           // ),
//           Positioned(
//             left: 0,
//             top: Get.context?.mediaQueryViewPadding.top,
//             right: 0,
//             height: 56,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () => Get.back(),
//                     child: Image.asset(
//                       'assets/images/ic_close.png',
//                       width: 32,
//                     ),
//                   ),
//                   CustomButton(
//                     text: 'done'.tr,
//                     bgColor: UiColors.cDBFFFFFF,
//                     bgColors: const [UiColors.cBC8EF5, UiColors.cA754FC],
//                     contentPadding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     onTap: () {
//                       Get.dialog(const LoadingWidget());
//                       _controller.crop();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
