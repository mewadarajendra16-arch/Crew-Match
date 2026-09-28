const setupQueueSocket = (io) => {
  const queueNsp = io.of('/queue');

  queueNsp.on('connection', (socket) => {
    console.log(`[Socket.IO /queue] Client connected: ${socket.id}`);

    socket.on('join_queue_room', (tokenId) => {
      socket.join(`token_${tokenId}`);
      console.log(`[Socket.IO /queue] ${socket.id} joined token_${tokenId}`);
    });

    socket.on('disconnect', () => {
      console.log(`[Socket.IO /queue] Client disconnected: ${socket.id}`);
    });
  });
};

module.exports = setupQueueSocket;
