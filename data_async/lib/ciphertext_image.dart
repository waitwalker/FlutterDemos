import 'package:data_async/encrypt_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

/// 加密的图片
class CiphertextImage extends StatefulWidget {
  const CiphertextImage({
    Key? key,
    required this.url,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.filterQuality = FilterQuality.low,
    BoxConstraints? constraints,
    this.isAntiAlias = false,
    this.cacheWidth,
    this.cacheHeight,
    this.cache = true,
  }) : super(key: key);

  const CiphertextImage.network({
    Key? key,
    required this.url,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.filterQuality = FilterQuality.low,
    this.isAntiAlias = false,
    this.cacheWidth,
    this.cacheHeight,
    this.cache = true,
  }) : super(key: key);

  final String url;
  final double? width;
  final double? height;
  final Color? color;
  final Animation<double>? opacity;
  final FilterQuality filterQuality;
  final BlendMode? colorBlendMode;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final bool isAntiAlias;
  final int? cacheWidth;
  final int? cacheHeight;
  final bool cache;

  @override
  State<StatefulWidget> createState() => _CiphertextImageState();
}

class _CiphertextImageState extends State<CiphertextImage> {
  String imageUrl = '';
  Uint8List? imageData;
  bool hasError = false;
  String errorHint = "";

  late Uint8List realData;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.url;
    loadImageFromCache();
  }

  Future<void> loadImageFromCache() async {
    try {
      final cacheManager = DefaultCacheManager();
      final fileInfo = await cacheManager.getFileFromCache(imageUrl);
      if (fileInfo != null && fileInfo.validTill.isAfter(DateTime.now())) {
        imageData = await fileInfo.file.readAsBytes();
      } else {
        imageData = await downloadAndCacheImage();
      }
      if (imageData != null) {
        imageData = EncryptUtil.aesDecrypt(imageData!);
      }
      hasError = false;
      errorHint = "";
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print('Error while loading image: $e');
      }
      hasError = true;
      errorHint = "Error while downloading image";
      setState(() {});
    }
  }

  Future<Uint8List?> downloadAndCacheImage() async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final Uint8List downloadedData = response.bodyBytes;
        if (widget.cache && !kIsWeb) {
          final cacheManager = DefaultCacheManager();
          await cacheManager.putFile(imageUrl, downloadedData);
        }
        return downloadedData;
      } else {
        if (kDebugMode) {
          print('Failed to download image. Status code: ${response.statusCode}');
        }
        hasError = true;
        errorHint = "Error while downloading image";
        setState(() {});
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while downloading image: $e');
      }
      hasError = true;
      errorHint = "Error while downloading image";
      setState(() {});
      return null;
    }
  }

  void retryLoad() {
    setState(() {
      hasError = false;
    });
    if (imageUrl.isEmpty) {
      setState(() {
        errorHint = "image url is Empty";
        hasError = true;
      });
      return;
    }
    loadImageFromCache();
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return InkWell(
        onTap: retryLoad,
        child: Center(
          child: Text(
            errorHint,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    return Center(
      child: imageData != null
          ? Image.memory(
              imageData!,
              semanticLabel: widget.semanticLabel,
              excludeFromSemantics: widget.excludeFromSemantics,
              width: widget.width,
              height: widget.height,
              color: widget.color,
              opacity: widget.opacity,
              colorBlendMode: widget.colorBlendMode,
              fit: widget.fit,
              alignment: widget.alignment,
              repeat: widget.repeat,
              centerSlice: widget.centerSlice,
              matchTextDirection: widget.matchTextDirection,
              gaplessPlayback: widget.gaplessPlayback,
              isAntiAlias: widget.isAntiAlias,
              filterQuality: widget.filterQuality,
              cacheWidth: widget.cacheWidth,
              cacheHeight: widget.cacheHeight,
            ) // Display the image from Uint8List data
          : const CircularProgressIndicator(), // Show loading indicator while fetching and caching the image
    );
  }
}
