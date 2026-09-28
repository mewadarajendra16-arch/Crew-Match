import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? _rosterSocket;
  static IO.Socket? _queueSocket;

  static String socketUrl = 'http://localhost:5000';

  static void initRosterSocket(Function(dynamic) onUpdate) {
    _rosterSocket?.disconnect();
    _rosterSocket = IO.io('$socketUrl/roster', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _rosterSocket!.onConnect((_) {
      print('[SocketService] Connected to /roster namespace');
    });

    _rosterSocket!.on('roster_updated', (data) {
      print('[SocketService] roster_updated received: $data');
      onUpdate(data);
    });
  }

  static void initQueueSocket({
    Function(dynamic)? onCounterCalled,
    Function(dynamic)? onCounterUpdated,
    Function(dynamic)? onTokenCreated,
  }) {
    _queueSocket?.disconnect();
    _queueSocket = IO.io('$socketUrl/queue', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _queueSocket!.onConnect((_) {
      print('[SocketService] Connected to /queue namespace');
    });

    if (onCounterCalled != null) {
      _queueSocket!.on('counter_called_next', (data) => onCounterCalled(data));
    }
    if (onCounterUpdated != null) {
      _queueSocket!.on('counter_updated', (data) => onCounterUpdated(data));
    }
    if (onTokenCreated != null) {
      _queueSocket!.on('token_created', (data) => onTokenCreated(data));
    }
  }

  static void dispose() {
    _rosterSocket?.disconnect();
    _queueSocket?.disconnect();
  }
}
