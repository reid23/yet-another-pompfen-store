include <BOSL2/std.scad>

$fn = 100;

PRESSFIT = 0.1;
CLEARANCE = 0.2;

//* OVERALL LENGTHS
LONG = 1400;
STAFF = 1800;
SHORTSTAFF = 1700;
QTIP = 2000;
SHORT = 850;
STAFF_REACH = 1100;

//* BLADE LENGTHS
LONG_BLADE = 900;
SHORT_BLADE = 650;
QTIP_BLADE = 600;
GUARD_LEN = 500;
SHORT_GUARD_LEN = 400;

//* COTS PART DIMENSIONS
NOODLE_OD = 2.7*INCH;
GUARD_OD = 3*INCH;
SMALL_GUARD_OD = 2.25*INCH;
EPP_THICKNESS = 0.5*INCH;
COREDIMS = [12, 14];
SHEEP_DIAMETER = (7/16)*INCH;

//* CRITICAL LENGTH PARAMETERS
TIP_THICKNESS = 50;
BUFFER_THICKNESS = 50;
POMMEL_THICKNESS = 10;
STAFF_GRIP_HEIGHT = 60;
STAFF_GRIP_OD = 2.5*INCH;
NARROW_STAFF_GRIP_OD = 2.0*INCH;

ABOVE_CORE_HEIGHT = 2;
CORE_TO_EPP_DIST = 1;

POMMEL_OD = 2.05*INCH;
BLADE_EPP_ID = 24;
GUARD_EPP_ID = 26;
TIP_EPP_AXIAL_ID = 0;
TIP_EPP_RADIAL_ID = 19.5;

// magic global vars
// high key i dont like these but
// i think its the best way

$kerf = 2.25;

$guard_pitch = 2.5;
$guard_major_d = 20;
$guard_thread_stop_d = 24;

$grip_step_size = 2;
$guard_major_d = 20;

// for tip_interface
$pitch=1.5;
$starts=2;
$major_d=COREDIMS[0]-0.4*4-0.3;
$thread_len=4;