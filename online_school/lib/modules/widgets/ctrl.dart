import 'dart:async';
import 'package:online_school/common/tools/time_utils.dart';
import 'package:chewie/chewie.dart';
import 'package:chewie/src/material_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';

class MaterialControls extends StatefulWidget {
  String title;

  MaterialControls({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MaterialControlsState();
  }
}

class _MaterialControlsState extends State<MaterialControls> {
  VideoPlayerValue _latestValue;
  double _latestVolume;
  bool _hideStuff = false;
  Timer _hideTimer;
  Timer _showTimer;
  Timer _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _locked = false;
  bool _hideLock = true;

  final barHeight = 40.0;
  final marginSize = 5.0;

  VideoPlayerController controller;
  ChewieController chewieController;
  Duration durationCanDrag;

  bool _inDragH = false;
  bool _inDragL = false;
  bool _inDragR = false;

  Offset downPosition;
  Offset updatePosition;
  Offset upPosition;

  double volume;

  double brightness;

  Size _size() => (context.findRenderObject() as RenderBox).size;

  @override
  void initState() {
    Screen.keepOn(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_latestValue.hasError) {
      return chewieController.errorBuilder != null
          ? chewieController.errorBuilder(
              context,
              chewieController.videoPlayerController.value.errorDescription,
            )
          : Center(
              child: Icon(
                Icons.error,
                color: Colors.white,
                size: 42,
              ),
            );
    }

    Widget _controlChild() {
      return AbsorbPointer(
        absorbing: _locked || _hideStuff,
        child: Column(
          children: <Widget>[
            if (!_locked) _buildTopBar(context),
            if (!_locked)
              _latestValue != null &&
                          !_latestValue.isPlaying &&
                          _latestValue.duration == null ||
                      _latestValue.isBuffering
                  ? const Expanded(
                      child: const Center(
                        child: const Text('加载中...'),
                      ),
                    )
                  : _buildHitArea(),
            if (!_locked) _buildBottomBar(context),
          ],
        ),
      );
    }

    var controlWidgetLocked = GestureDetector(
      onTap: () => _cancelAndRestartTimer(),
      child: _controlChild(),
    );
    var controlWidget = GestureDetector(
      onTap: () => _cancelAndRestartTimer(),
      onDoubleTap: () {
        _playPause();
      },
      onHorizontalDragDown: (details) {
        print('onHorizontalDragDown');
        _inDragH = true;
        downPosition = details.globalPosition;
      },
      onHorizontalDragUpdate: (details) {
        // print('$downPosition - ${details.globalPosition}');
        // seekToRelativePosition(details.delta);

        // print(details.globalPosition);
        print('=============');
        setState(() {
          _hideStuff = false;
          updatePosition = details.globalPosition;
        });
        _cancelAndRestartTimer();
      },
      onHorizontalDragEnd: (details) {
        print('onHorizontalDragEnd');
        seekToRelativePosition(_calculatePosition());
        setState(() {
          downPosition = updatePosition = null;
          // hack, avoid play icon animation
          _inDragL = _inDragR = _inDragH = false;
        });
      },
      onHorizontalDragCancel: () {
        print('onHorizontalDragCancel');
        setState(() {
          // downPosition = updatePosition = null;
          _inDragH = false;
        });
      },
      onVerticalDragDown: (details) {
        print('onVerticalDragDown $details');
        downPosition = details.globalPosition;
        var isRight = downPosition.dx > _size().width / 2;
        isRight ? _inDragR = true : _inDragL = true;
      },
      onVerticalDragUpdate: (details) async {
        // print(details.globalPosition);
        // print('1111111111111');
        _hideStuff = false;
        if (updatePosition == null) {
          updatePosition = details.globalPosition;
          return;
        }
        var lastPosition = updatePosition;
        updatePosition = details.globalPosition;
        var deltaOffset = lastPosition - updatePosition;
        final box = context.findRenderObject() as RenderBox;
        var rate = deltaOffset.dy * 3 / box.size.height;
        if (_inDragR) {
          print('_inDragR');
          volume = (controller.value.volume + rate).clamp(0.0, 1.0);
          print('$volume = $rate + ${controller.value.volume}');
        } else {
          print('_inDragL');
          brightness = (await Screen.brightness + rate).clamp(0.0, 1.0);
          print('brightness: -> $brightness = $rate');
        }
        setState(() {});
        _cancelAndRestartTimer();
      },
      onVerticalDragEnd: (details) {
        print('onVerticalDragEnd');
        _inDragL = _inDragR = false;
        downPosition = updatePosition = null;
      },
      onVerticalDragCancel: () {
        print('onVerticalDragCancel');
        _inDragL = _inDragR = false;
        // downPosition = updatePosition = null;
      },
      child: _controlChild(),
    );

    var withLock = AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: _locked ? controlWidgetLocked : controlWidget,
            ),
            AnimatedAlign(
              duration: Duration(milliseconds: 300),
              alignment: Alignment(_hideStuff ? -1.4 : -0.9, 0),
              child: GestureDetector(
                onTap: _toggleLock,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(_locked ? Icons.lock : Icons.lock_open,
                        size: 24.0, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ));
    return withLock;
  }

  @override
  void dispose() {
    Screen.keepOn(false);
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _showTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = chewieController;
    chewieController = ChewieController.of(context);
    controller = chewieController.videoPlayerController;

    if (_oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  AnimatedOpacity _buildBottomBar(
    BuildContext context,
  ) {
    final iconColor = Theme.of(context).textTheme.button.color;

    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 0.8,
      duration: Duration(milliseconds: 300),
      child: Container(
        height: barHeight,
        color: Colors.black.withOpacity(0.6),
        child: Row(
          children: <Widget>[
            _buildPlayPause(controller),
            chewieController.isLive
                ? Expanded(child: const Text('LIVE'))
                : _buildPosition(iconColor),
            chewieController.isLive ? const SizedBox() : _buildProgressBar(),
            chewieController.isLive
                ? Expanded(child: const Text('LIVE'))
                : _buildDuration(iconColor),
            chewieController.allowMuting
                ? _buildMuteButton(controller)
                : Container(),
            controller.allowSpeed ? _buildSpeedButton(controller) : Container(),
            chewieController.allowFullScreen
                ? _buildExpandButton()
                : Container(),
          ],
        ),
      ),
    );
  }

  AnimatedOpacity _buildTopBar(
    BuildContext context,
  ) {
    final iconColor = Theme.of(context).textTheme.button.color;

    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 0.8,
      duration: Duration(milliseconds: 300),
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            (chewieController.isFullScreen)
                ? _buildBack(controller)
                : Container(width: 20),
            _buildTitle(),
            Expanded(child: Container()),
            _buildMenu(),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildExpandButton() {
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          height: barHeight,
          margin: EdgeInsets.only(right: 12.0),
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Center(
            child: Icon(
              chewieController.isFullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildHitArea() {
    // print('$_inDragH - $_inDragL - $_inDragR');
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _hideStuff = !_hideStuff;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: Colors.transparent,
          child: Center(
            child: _inDragR
                ? _buildVolume()
                : _inDragL
                    ? _buildBrightness()
                    : _inDragH
                        ? _buildSeek()
                        : _latestValue != null &&
                                !_latestValue.isPlaying &&
                                !_dragging
                            ? GestureDetector(
                                onTap: () {
                                  _playPause();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(48.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Icon(Icons.play_arrow,
                                        size: 32.0, color: Colors.white),
                                  ),
                                ),
                              )
                            : Container(),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildMuteButton(
    VideoPlayerController controller,
  ) {
    return GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();

        if (_latestValue.volume == 0) {
          controller.setVolume(_latestVolume ?? 0.5);
        } else {
          _latestVolume = controller.value.volume;
          controller.setVolume(0.0);
        }
      },
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            child: Container(
              height: barHeight,
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: Icon(
                (_latestValue != null && _latestValue.volume > 0)
                    ? Icons.volume_up
                    : Icons.volume_off,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildSpeedButton(
    VideoPlayerController controller,
  ) {
    return GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();
        var oldSpeed = controller.value.speed;
        double newSpeed;
        if (oldSpeed < 2) {
          newSpeed = oldSpeed + 0.5;
        } else if (oldSpeed < 3) {
          newSpeed = 3;
        } else {
          newSpeed = 0.5;
        }
        controller.setSpeed(newSpeed);
      },
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            child: Container(
                alignment: Alignment.center,
                height: barHeight,
                padding: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                ),
                child: Text(
                  '${controller.value.speed}X',
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                )),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildPlayPause(VideoPlayerController controller) {
    return GestureDetector(
      onTap: _playPause,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        margin: EdgeInsets.only(left: 8.0, right: 4.0),
        padding: EdgeInsets.only(
          left: 12.0,
          right: 12.0,
        ),
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }

  GestureDetector _buildBack(VideoPlayerController controller) {
    return GestureDetector(
      onTap: _back,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        margin: EdgeInsets.only(left: 8.0, right: 4.0),
        padding: EdgeInsets.only(
          left: 12.0,
          right: 12.0,
        ),
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    );
  }

  GestureDetector _buildMenu() {
    return GestureDetector(
      onTap: null,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        margin: EdgeInsets.only(left: 8.0, right: 4.0),
        padding: EdgeInsets.only(
          left: 12.0,
          right: 12.0,
        ),
        child: Icon(
          Icons.more_horiz,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPosition(Color iconColor) {
    final position = _latestValue != null && _latestValue.position != null
        ? _latestValue.position
        : Duration.zero;

    return Padding(
      padding: EdgeInsets.only(right: 24.0),
      child: Text(
        '${toHMS(position.inMicroseconds)}',
        style: TextStyle(fontSize: 14.0, color: Colors.white),
      ),
    );
  }

  Widget _buildDuration(Color iconColor) {
    final duration = _latestValue != null && _latestValue.duration != null
        ? _latestValue.duration
        : Duration.zero;

    return Padding(
      padding: EdgeInsets.only(right: 24.0),
      child: Text(
        '${toHMS(duration.inMicroseconds)}',
        style: TextStyle(fontSize: 14.0, color: Colors.white),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
    });
  }

  Future<Null> _initialize() async {
    controller.addListener(_updateState);

    _updateState();

    if ((controller.value != null && controller.value.isPlaying) ||
        chewieController.autoPlay) {
      _startHideTimer();
    }

    _showTimer = Timer(Duration(milliseconds: 200), () {
      setState(() {
        _hideStuff = false;
      });
    });
  }

  void _onExpandCollapse() {
    setState(() {
      _hideStuff = true;

      chewieController.toggleFullScreen();
      _showAfterExpandCollapseTimer = Timer(Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  void _playPause() {
    setState(() {
      if (controller.value.isPlaying) {
        _hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller.value.initialized) {
          controller.initialize().then((_) {
            controller.play();
          });
        } else {
          controller.play();
        }
      }
    });
  }

  void _back() {
    Navigator.of(context).pop();
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _updateState() {
    setState(() {
      _latestValue = controller.value;
      durationCanDrag =
          Duration(seconds: (controller.value.duration?.inSeconds ?? 60) ~/ 3);
    });
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: MaterialVideoProgressBar(
          controller,
          onDragStart: () {
            setState(() {
              _dragging = true;
            });

            _hideTimer?.cancel();
          },
          onDragEnd: () {
            setState(() {
              _dragging = false;
            });

            _startHideTimer();
          },
          colors: chewieController.materialProgressColors ??
              ChewieProgressColors(
                  playedColor: Colors.white,
                  handleColor: Colors.white,
                  bufferedColor: Theme.of(context).primaryColor,
                  backgroundColor: Color(0xff6a6a6a)),
        ),
      ),
    );
  }

  _buildTitle() {
    return Text(widget.title ?? '',
        style: TextStyle(color: Colors.white, fontSize: 17));
  }

  void _toggleLock() {
    setState(() {
      _locked = !_locked;
    });
  }

  _showLock() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideLock = false;
    });
  }

  void seekToRelativePosition(Duration position) {
    controller.seekTo(position);
  }

  _buildVolume() {
    if (updatePosition == null ||
        downPosition == null ||
        !_inDragR ||
        volume == null) {
      return Container();
    }
    // var volume =
    //     (_calculateVertical() + controller.value.volume).clamp(0.0, 1.0);
    // print('volume:   --->   $volume');
    controller.setVolume(volume);
    return AnimatedOpacity(
      opacity: _inDragR ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Center(
        widthFactor: 0.2,
        heightFactor: 0.2,
        child: Container(
          padding: EdgeInsets.all(_size().height / 20.0),
          alignment: Alignment.center,
          width: _size().width / 3.0,
          height: _size().height / 3.0,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Text(volume.toStringAsFixed(1),
              //     style: TextStyle(color: Colors.white, fontSize: 23)),
              Icon(
                  volume > 0.8
                      ? Icons.volume_up
                      : volume > 0.5
                          ? Icons.volume_down
                          : volume > 0.0 ? Icons.volume_mute : Icons.volume_off,
                  size: _size().height / 10.0,
                  color: Colors.white),
              SizedBox(height: _size().height / 20.0),
              LinearProgressIndicator(
                value: volume,
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildBrightness() {
    if (updatePosition == null ||
        downPosition == null ||
        !_inDragL ||
        brightness == null) {
      return Container();
    }
    // var volume =
    //     (_calculateVertical() + controller.value.volume).clamp(0.0, 1.0);
    // print('volume:   --->   $volume');
    Screen.setBrightness(brightness);
    return AnimatedOpacity(
      opacity: _inDragL ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Center(
        widthFactor: 0.2,
        heightFactor: 0.2,
        child: Container(
          padding: EdgeInsets.all(_size().height / 20.0),
          alignment: Alignment.center,
          width: _size().width / 3.0,
          height: _size().height / 3.0,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Text(brightness.toStringAsFixed(1),
              //     style: TextStyle(color: Colors.white, fontSize: 23)),
              Icon(
                  brightness > 0.8
                      ? Icons.brightness_7
                      : brightness > 0.6
                          ? Icons.brightness_6
                          : brightness > 0.5
                              ? Icons.brightness_5
                              : brightness > 0.4
                                  ? Icons.brightness_4
                                  : brightness > 0.3
                                      ? Icons.brightness_3
                                      : brightness > 0.2
                                          ? Icons.brightness_2
                                          : Icons.brightness_1,
                  size: _size().height / 10.0,
                  color: Colors.white),
              SizedBox(height: _size().height / 20.0),
              LinearProgressIndicator(
                value: brightness,
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildSeek() {
    if (updatePosition == null || downPosition == null) {
      return Container();
    }
    Duration position = _calculatePosition();
    return AnimatedOpacity(
      opacity: _inDragH ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Center(
        widthFactor: 0.2,
        heightFactor: 0.2,
        child: Container(
          alignment: Alignment.center,
          width: _size().width / 4.0,
          height: _size().height / 4.0,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(toHMS(position.inMicroseconds),
              style: TextStyle(color: Colors.white, fontSize: 23)),
        ),
      ),
    );
  }

  Duration _calculatePosition() {
    var offset = updatePosition - downPosition;
    // print('$updatePosition -> $downPosition = $offset');
    final box = context.findRenderObject() as RenderBox;
    final double relative = offset.dx / box.size.width;
    final Duration position =
        controller.value.position + durationCanDrag * relative;
    return position > controller.value.duration
        ? controller.value.duration
        : position;
  }
}
