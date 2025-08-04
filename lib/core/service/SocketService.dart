
import 'package:socket_io_client/socket_io_client.dart' as IO;
class SocketService {
  late IO.Socket socket;

  void init() {
    socket = IO.io('https://ap1.winsz.my.id', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void off(String event) {
    socket.off(event);
  }

  void disconnected(){
    socket.disconnect();
  }
}