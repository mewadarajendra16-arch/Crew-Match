const setupRosterSocket = (io) => {
  const rosterNsp = io.of('/roster');

  rosterNsp.on('connection', (socket) => {
    console.log(`[Socket.IO /roster] Client connected: ${socket.id}`);

    socket.on('join_shift', (shiftId) => {
      socket.join(`shift_${shiftId}`);
      console.log(`[Socket.IO /roster] ${socket.id} joined shift_${shiftId}`);
    });

    socket.on('disconnect', () => {
      console.log(`[Socket.IO /roster] Client disconnected: ${socket.id}`);
    });
  });
};

module.exports = setupRosterSocket;
