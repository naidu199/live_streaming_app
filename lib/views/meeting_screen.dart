import 'package:flutter/material.dart';

import 'package:videosdk/videosdk.dart';

import 'speaker.dart';
import 'viewer.dart';

class MeetingScreen extends StatefulWidget {
  final String meetingId;
  final String token;
  final Mode mode;

  const MeetingScreen(
      {super.key,
      required this.meetingId,
      required this.token,
      required this.mode});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  late Room _room;
  bool isJoined = false;

  @override
  void initState() {
    // create room when widget loads
    _room = VideoSDK.createRoom(
      roomId: widget.meetingId,
      token: widget.token,
      displayName: "Naidu",
      micEnabled: false,
      camEnabled: false,
      defaultCameraIndex: 1,
      mode: widget.mode,
    );
    // setting the event listener for join and leave events
    setMeetingEventListener();
    // Joining room
    _room.join();
    super.initState();
  }

  // listening to room events
  void setMeetingEventListener() {
    //Setting the joining flag to true when meeting is joined
    _room.on(Events.roomJoined, () {
      if (widget.mode == Mode.CONFERENCE) {
        _room.localParticipant.pin();
      }
      isJoined = true;
      setState(() {});
    });

    //Handling navigation when meeting is left
    _room.on(Events.roomLeft, () {
      Navigator.pop(context);
    });
  }

  // onbackButton pressed leave the room
  Future<bool> _onWillPop() async {
    _room.leave();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          _onWillPop();
        }
      },
      child: Scaffold(
        body: isJoined
            ? widget.mode == Mode.CONFERENCE
                ? SpeakerView(room: _room)
                : widget.mode == Mode.VIEWER
                    ? ViewerView(room: _room)
                    : const Text("Something went wrong")
            : const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
