const mongoose = require('mongoose');
const env = require('../config/env');
const User = require('../models/User');
const Worker = require('../models/Worker');
const Shift = require('../models/Shift');
const RosterEntry = require('../models/RosterEntry');
const Timesheet = require('../models/Timesheet');
const QueueService = require('../models/QueueService');
const QueueToken = require('../models/QueueToken');
const Counter = require('../models/Counter');
const AnalyticsSnapshot = require('../models/AnalyticsSnapshot');

const seedData = async () => {
  try {
    await mongoose.connect(env.mongoUri);
    console.log('[Seed] Connected to MongoDB');

    // Clear existing collections
    await User.deleteMany({});
    await Worker.deleteMany({});
    await Shift.deleteMany({});
    await RosterEntry.deleteMany({});
    await Timesheet.deleteMany({});
    await QueueService.deleteMany({});
    await QueueToken.deleteMany({});
    await Counter.deleteMany({});
    await AnalyticsSnapshot.deleteMany({});

    console.log('[Seed] Cleared old collections');

    // 1. Create Users
    const organiser = await User.create({
      name: 'Rahul Organiser',
      email: 'organiser@crewmatch.com',
      passwordHash: 'password123',
      role: 'organiser',
      phone: '9876543210',
    });

    const workerUser = await User.create({
      name: 'Pooja Sundaram',
      email: 'pooja@crewmatch.com',
      passwordHash: 'password123',
      role: 'worker',
      phone: '9876543211',
    });

    // 2. Create Workers
    const workers = await Worker.insertMany([
      {
        userId: workerUser._id,
        name: 'Pooja Sundaram',
        role: 'Lead VIP Guest Hostess & Registration',
        category: 'Guest Relations',
        hourlyRate: 850,
        rating: 4.95,
        stat: '(42 events)',
        meta: 'Tomorrow, 8 hrs slot',
        metaKind: 'clock',
        badges: ['Aadhaar Verified', 'Govt Background Cleared'],
        skills: ['Multilingual (Eng, Hin, Mar)', 'Badge Printing', 'VIP Protocol'],
        weekend: true,
        immediate: false,
      },
      {
        name: 'Rahul Verma',
        role: 'Senior Live Sound & AV Technician',
        category: 'AV & Technical',
        hourlyRate: 1200,
        rating: 4.88,
        stat: '(67 gigs completed)',
        meta: 'BKC, Bandra Base',
        metaKind: 'pin',
        badges: ['Certified Sound Guild', 'Police Verified', 'Replies in ~5 mins'],
        skills: ['Yamaha CL5', 'Line Array Tuning', 'DMX Lighting', 'XLR Routing'],
        immediate: true,
        weekend: false,
      },
      {
        name: 'Ananya Mehra',
        role: 'Mixologist & Event Beverage Lead',
        category: 'Hospitality',
        hourlyRate: 950,
        rating: 4.92,
        stat: '(31 events)',
        meta: '100% On-Time Record',
        metaKind: 'check',
        badges: ['FSSAI Certified', 'ID Verified'],
        skills: ['Speed Bartending', 'Inventory Reconcile', 'Craft Cocktails'],
        weekend: true,
        immediate: true,
      },
    ]);

    // 3. Create Shift
    const shift = await Shift.create({
      organiserId: organiser._id,
      eventName: 'Tech Leadership Summit 2025',
      category: 'Corporate Conference / Exhibition',
      venue: 'Jio World Convention Centre, BKC, Mumbai',
      roleNeeded: 'Registration & Guest Escort Specialist',
      staffRequired: 4,
      hourlyWage: 750,
      criteria: {
        'Formal Business Attire (All Black)': true,
        'Fluent English & Hindi': true,
        'Verified Govt ID Mandatory': true,
        'Smart Badge / QR Scanner Experience': true,
      },
      status: 'active',
      escrow: {
        basePay: 24000,
        platformFee: 1200,
        totalLocked: 25200,
        status: 'locked',
      },
    });

    // 4. Create Roster Entries
    await RosterEntry.insertMany([
      {
        shiftId: shift._id,
        workerId: workers[0]._id,
        name: 'Pooja Sundaram',
        role: 'Registration Lead',
        duty: 'on',
        station: 'Hall 3 Registration Desk',
        checkedIn: '08:15 AM via GPS QR',
        loggedHours: '3.7 hrs active',
        msg: 'Message / Call',
        action2: 'Reassign Station',
        action2Icon: 'swap_vert',
      },
      {
        shiftId: shift._id,
        workerId: workers[1]._id,
        name: 'Karan Joshi',
        role: 'VIP Escort',
        duty: 'breakTime',
        station: 'Scheduled Lunch Break',
        checkedIn: '08:30 AM',
        loggedHours: 'Until 12:00 PM (18m elapsed)',
        msg: 'Ping Staff',
        action2: 'Emergency Recall',
        action2Icon: 'warning_amber',
        danger: true,
      },
      {
        shiftId: shift._id,
        workerId: workers[2]._id,
        name: 'Sneha Patel',
        role: 'Speaker Lounge Host',
        duty: 'on',
        station: 'Green Room / VIP Stage',
        checkedIn: '08:22 AM (On Schedule)',
        loggedHours: '3.5 hrs active',
        msg: 'Message / Call',
        action2: 'Swap Shift',
        action2Icon: 'swap_horiz',
      },
      {
        shiftId: shift._id,
        name: 'Amit Roy',
        role: 'Helpdesk & Flow Controller',
        duty: 'on',
        station: 'Main Entrance Turnstiles',
        checkedIn: '08:10 AM (Punctual +10m)',
        loggedHours: '3.8 hrs active',
        msg: 'Message / Call Amit',
      },
    ]);

    // 5. Create Timesheets
    await Timesheet.insertMany([
      {
        shiftId: shift._id,
        name: 'Pooja Sundaram',
        role: 'Registration Desk Lead',
        amount: 6000,
        sub: '8.0 hrs @ ₹750/hr',
        gps: 'GPS Verified: 08:15 AM – 05:30 PM',
        footer: 'Shift Manager Signed Off',
        chip: 'Net: 8h 00m billable',
        chipIcon: 'timer_outlined',
        rating: 5.0,
        status: 'ready',
      },
      {
        shiftId: shift._id,
        name: 'Sneha Patel',
        role: 'Speaker Lounge Host',
        amount: 6000,
        sub: '8.0 hrs @ ₹750/hr',
        gps: 'GPS Verified: 08:22 AM – 05:30 PM',
        footer: 'Client Sign-off Confirmed',
        chip: '45m break deducted',
        chipIcon: 'restaurant',
        status: 'ready',
      },
      {
        shiftId: shift._id,
        name: 'Amit Roy',
        role: 'Technical Helpdesk',
        amount: 6000,
        sub: '8.0 hrs @ ₹750/hr',
        gps: 'GPS Verified: 08:30 AM – 05:30 PM',
        footer: 'Timesheet Matched',
        flawless: true,
        status: 'ready',
      },
      {
        shiftId: shift._id,
        name: 'Karan Joshi',
        role: 'VIP Stage Escort',
        amount: 6750,
        sub: '8.0h + 1.0h OT',
        gps: 'GPS Verified: 08:30 AM – 06:30 PM',
        footer: 'Overtime Claimed',
        status: 'discrepancy',
        overtime: {
          hasDiscrepancy: true,
          reason: 'Stayed until 06:30 PM for VIP Keynote speaker wrap-up requested by stage director.',
          claimedAmount: 6750,
          resolution: 'pending',
        },
      },
    ]);

    // 6. Queue Services
    await QueueService.insertMany([
      { name: 'General Inquiries & Verification', desc: 'ID verification, stamped certificates, general advice', prefix: 'G', waitMin: 6, ahead: 3 },
      { name: 'Document Submission & Biometrics', desc: 'Fingerprint capture, photo desk, deed approvals', prefix: 'D', waitMin: 14, ahead: 8 },
      { name: 'Billing, Payments & Refunds', desc: 'Challan payment, receipt reprint, fee disputes', prefix: 'B', waitMin: 2, ahead: 1 },
      { name: 'Priority Senior & Accessible Desk', desc: 'Age 60+, expectant mothers, assisted mobility', prefix: 'A', waitMin: 0, ahead: 0 },
    ]);

    // 7. Counters
    await Counter.insertMany([
      { no: '01', name: 'General Inquiries', staff: 'Sarah M.', device: 'Station-A', prefix: 'G', serving: 89, waiting: 2, status: 'active', hwLabel: 'Hardware Buzzer', hwValue: 'Pager #04 Paged', secLabel: 'Ping Buzzer', secIcon: 'notifications_active_outlined' },
      { no: '02', name: 'Document Verification', staff: 'David K.', device: 'Optical-1', prefix: 'D', serving: 44, waiting: 5, status: 'active', hwLabel: 'Scanner Link', hwValue: 'Kiosk-A Synced', secLabel: 'Feed Doc', secIcon: 'document_scanner_outlined' },
      { no: '03', name: 'Biometrics IoT Booth', staff: 'Priya R.', device: 'Camera & FP Pod', prefix: 'A', serving: 107, waiting: 2, status: 'active', hwLabel: 'Hardware Status', hwValue: 'Sensor Calibrated', secLabel: 'Calibrate', secIcon: 'fingerprint' },
      { no: '04', name: 'Billing & Express', staff: 'Michael T.', device: 'Terminal POS-3', prefix: 'B', serving: 12, waiting: 0, status: 'session', hwLabel: 'POS Terminal', hwValue: 'Processing Tx' },
      { no: '05', name: 'Accessible & Senior Care', staff: 'Elena V.', device: 'Returns in 4m', prefix: 'S', serving: 0, waiting: 1, status: 'onBreak' },
    ]);

    // 8. Analytics Snapshots
    await AnalyticsSnapshot.insertMany([
      {
        range: 'today',
        footfall: '348',
        delta: '+12% vs yesterday',
        wait: '6.4',
        rate: '94.2%',
        served: '328 served, 20 queued',
        uptime: '99.8%',
        loadArray: [0.18, 0.28, 0.52, 1.0, 1.0, 0.86, 0.44, 0.5, 0.88, 0.22],
        hoursArray: ['08', '09', '10', '11', '12', '13', '14', '15', '16', '17'],
      },
      {
        range: 'week',
        footfall: '2,184',
        delta: '+5% vs last week',
        wait: '7.1',
        rate: '92.6%',
        served: '2,022 served, 162 queued',
        uptime: '99.5%',
        loadArray: [0.3, 0.4, 0.6, 0.8, 0.9, 0.7, 0.5, 0.6, 0.7, 0.4],
        hoursArray: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      },
      {
        range: 'month',
        footfall: '9,420',
        delta: '+8% vs last month',
        wait: '6.8',
        rate: '93.4%',
        served: '8,798 served, 622 queued',
        uptime: '99.7%',
        loadArray: [0.5, 0.6, 0.7, 0.8, 0.9, 0.85, 0.75, 0.65],
        hoursArray: ['W1', 'W2', 'W3', 'W4'],
      },
    ]);

    console.log('[Seed] Database successfully populated!');
    process.exit(0);
  } catch (err) {
    console.error('[Seed] Error seeding data:', err);
    process.exit(1);
  }
};

seedData();
