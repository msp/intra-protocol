
//// OPO2 ///////////////////////////////////////////////////////////////

(
// var loopLength = [150, 300, 500].choose;
var loopLength = 150;
// var minWaitTime = 0.00008;
// var minWaitTime = 0.008;
var minWaitTime = 0.008;
// var maxWaitTime = 1.5.rand;
var maxWaitTime = 0.2;
// var maxWaitTime = 0.3;
// var maxWaitTime = 5;
var duration;
var up = Array.exprand(loopLength, minWaitTime, maxWaitTime).sort;
// var up = Array.fill(loopLength,
// 	{ arg i; (i).sin + 1 * 0.07 }
// );
var i = 0;
var j = 0;
var upN = up.normalize;
var upNR = up.reverse;
var leftScreen, rightScreen;
// up.plot;

// if (1.0.coin) {
// 	up = up.reverse;
// };

//// Left Screen ///////////////////////////////////////////
~oscClient.sendMsg("/opo1/clear", 0);
~oscClient.sendMsg("/opo1/layer", 1);
~oscClient.sendMsg("/master/layer", 1);

leftScreen = Routine({
	up.size.do {
		duration = up[i];
		(type:\dirt, orbit: ~out1, s: \bouncer, n: 0, begin: 0, end: duration, speed: [1,2].choose - duration, pan: [0.0].choose, hcutoff: 50 + (duration * 5), gain: 0.8).play;

		~oscClient.sendMsg("/opo1/pulse", 1);
		~oscClient.sendMsg("/opo1/ypos", upN[i]);
		// ~oscClient.sendMsg("/opo1/height", upN[i]/10);
		{ (duration / 2).wait; ~oscClient.sendMsg("/opo1/pulse", 0); }.fork;

		duration.wait;
		i = i + 1;
	};
}).play;


//// Right Screen ////////////////////////////////////////
~oscClient.sendMsg("/opo2/clear", 0);
~oscClient.sendMsg("/opo2/layer", 0);

rightScreen =Routine({
	up.size.do {
		duration = up[j];
		// s.bind { Synth(\mspSuperhex, [sustain: 3, amp: 0.008, freq: 80 + (duration * 100)]) };
		(type:\dirt, orbit: ~out1, s: \bd, n: [0,1,2,3,4].choose, begin: 0, speed: 0.8, crush: [5,6,7,9].choose, shape: 0.8, pan: 1.0, gain: 0.8).play;

		~oscClient.sendMsg("/opo2/pulse", 1);

		if (upN[j] != nil) {
			~oscClient.sendMsg("/opo2/ypos", 1 - upN[j]);
		};

		{ (duration / 2).wait; ~oscClient.sendMsg("/opo2/pulse", 0); }.fork;

		duration.wait;
		j = j + 1;
	};
}).play;

)

//// Tinker /////////////////////////////////////////////////////////////

1 > 0

z = Array.exprand(100, 0.1, 3).sort.reverse;
z.size

(
var randomNumbers, histogram, distribution, randomTable, randTableSize=20;
var minValue = -250, maxValue = 250, numVals = 10000, numBins = 500;

// create some random distribution with values between 0 and 1
distribution = Array.fill(randTableSize,
	{ arg i; (i).sin + 1 * 0.1 }
);

distribution.postln;

distribution.plot("this was the histogram we wanted");
)
