import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ChatPage extends StatefulWidget {
  final String coachName;
  final String coachImageUrl;

  const ChatPage({
    super.key,
    required this.coachName,
    required this.coachImageUrl,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  void _sendMessage(String text) {
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, isMine: true));
    });
    _controller.clear();
  }

  void _sendMedia(String filePath, bool isImage) {
    setState(() {
      _messages.add(ChatMessage(text: filePath, isMine: true, isImage: isImage));
    });
  }

  void _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      _sendMedia(result.files.single.path!, false);
    }
  }

  void _pickImageOrVideo() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null && pickedFile.path != null) {
      _sendMedia(pickedFile.path, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: widget.coachImageUrl.isNotEmpty
                    ? AssetImage(widget.coachImageUrl)
                    : const AssetImage('assets/default_avatar.jpg'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.coachName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text('Available', style: TextStyle(fontSize: 12)),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {
                // Handle call icon tap
              },
            ),
            IconButton(
              icon: const Icon(Icons.video_call),
              onPressed: () {
                // Handle video call icon tap
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          const Divider(height: 1.0),
          Expanded(
            child: ChatScreen(messages: _messages),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (String value) {
                if (value == 'Document') {
                  _pickDocument();
                } else if (value == 'Media') {
                  _pickImageOrVideo();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Document',
                  child: ListTile(
                    leading: Icon(Icons.attach_file),
                    title: Text('Upload Document'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Media',
                  child: ListTile(
                    leading: Icon(Icons.image),
                    title: Text('Upload Image/Video'),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type here ...',
                    border: const OutlineInputBorder(),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            _sendMessage(_controller.text);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.mic),
                          onPressed: () {
                            // Handle microphone icon tap
                            // Implement voice recording logic here
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final List<ChatMessage> messages;

  const ChatScreen({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ChatMessageWidget(
          message: messages[index],
          onDelete: () {
            // Implement delete message logic
          },
        );
      },
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMine;
  final bool isImage;

  ChatMessage({required this.text, required this.isMine, this.isImage = false});
}

class ChatMessageWidget extends StatefulWidget {
  final ChatMessage message;
  final VoidCallback onDelete;

  const ChatMessageWidget({super.key, required this.message, required this.onDelete});

  @override
  _ChatMessageWidgetState createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  bool isLiked = false;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() {
        isHovered = true;
      }),
      onExit: (event) => setState(() {
        isHovered = false;
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: widget.message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: widget.message.isMine ? const Color.fromARGB(255, 94, 204, 255) : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: widget.message.isImage
                      ? Image.file(
                          File(widget.message.text),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.message.text,
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            const SizedBox(height: 6.0),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                    color: isLiked ? Colors.red : null,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isLiked = !isLiked;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
                if (isHovered)
                  Positioned(
                    top: -5,
                    right: -5,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: widget.onDelete,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
