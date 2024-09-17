import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:live_streaming_app/meeting_screen.dart';
import 'package:videosdk/videosdk.dart';

import 'meeting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? meetingId;
  TextEditingController roomIdController = TextEditingController();
  //Auth token we will use to generate a meeting and connect to it
  //Get this token from https://www.videosdk.live/
  String token = 'Get the Token';
  Future createMeetingRoom() async {
    try {
      // API call to create meeting
      final http.Response httpResponse = await http.post(
        Uri.parse("https://api.videosdk.live/v2/rooms"),
        headers: {'Authorization': token},
      );

      // Destructuring the roomId from the response
      if (httpResponse.statusCode == 200) {
        meetingId = jsonDecode(httpResponse.body)['roomId'];
        // print(meetingId);
        roomIdController.text = meetingId!;
      }
      // print(httpResponse.body);
      //{"apiKey":"11c3f41c-286a-46bc-895a-07e3a718e590",
      //"webhook":{"events":[]},"disabled":false,
      //"autoCloseConfig":{"type":"session-end"},
      //"createdAt":"2024-09-17T03:41:43.283Z",
      //"updatedAt":"2024-09-17T03:41:43.283Z",
      //"roomId":"wy8e-5j8e-k9dh",
      //"links":{"get_room":"https://api.videosdk.live/v2/rooms/wy8e-5j8e-k9dh",
      //"get_session":"https://api.videosdk.live/v2/sessions/"},
      //"id":"66e8fa7765fb35448461975a"}
      setState(() {});
    } catch (e) {
      // Error handling
      print("Error creating meeting room: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFEBEDCE),
                Colors.purpleAccent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              const Text(
                "Live Streaming ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 100),
              const Text(
                textAlign: TextAlign.center,
                "Create a New Room",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                textAlign: TextAlign.center,
                "Or",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                textAlign: TextAlign.center,
                "Join an Existing Room.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      createMeetingRoom();
                    },
                    child: Container(
                      height: 50,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Create Room",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Join Room'),
                            content: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Enter Room ID',
                              ),
                              controller: roomIdController,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MeetingScreen(
                                        meetingId: roomIdController.text,
                                        token: token,
                                        mode: Mode.VIEWER,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Join as Viewer'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MeetingScreen(
                                        meetingId: roomIdController.text,
                                        token: token,
                                        mode: Mode.CONFERENCE,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Join as Host'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Join Room",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (meetingId !=
                  null) // Show the copy container only if a meeting ID is generated
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Meeting Id :",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Container(
                      height: 50,
                      width: 300,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              meetingId!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: Colors.black),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: roomIdController.text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Meeting ID copied to clipboard!"),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
