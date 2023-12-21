
//// OPO2 ///////////////////////////////////////////////////////////////

(
// var sinusoidalProb = 1.0;
var sinusoidalProb = 0.3;
// var reversingProb = 1.0;
var reversingProb = 0.4;
var loopLength = [150, 300, 500].choose;
// var loopLength = 150;
var minWaitTime = 0.00008;
// var minWaitTime = 0.008;
var maxWaitTime = 1.5.rand;
// var maxWaitTime = 0.2;
var calcs;
var i = 0;
var j = 0;
var durationsN;
var leftScreen, rightScreen;
// up.plot;

var durations;

'====================================================='.postln;
loopLength.postln;
minWaitTime.postln;
maxWaitTime.postln;

if (sinusoidalProb.coin) {
	'........ Sinusoidal!'.postln;
	calcs = Array.fill(loopLength,
		{ arg i; (i).sin + 1 * 0.4.rand }
	);
} {
	'........ Exponential!'.postln;
	calcs = Array.exprand(loopLength, minWaitTime, maxWaitTime).sort;
};

if (reversingProb.coin) {
	'<<<<<<<< Reversing!'.postln;
	durations = calcs.reverse;
} {
	durations = calcs;
};

durationsN = durations.normalize;

//// Left Screen ///////////////////////////////////////////
~oscClient.sendMsg("/opo1/clear", 0);
~oscClient.sendMsg("/opo1/layer", 1);
~oscClient.sendMsg("/master/layer", 1);

leftScreen = Routine({
	var duration;

	durations.size.do {
		duration = durations[i];
		(type:\dirt, orbit: ~out1, s: \bouncer, n: 0, begin: 0, end: duration, speed: [1,2].choose - duration, pan: [0.0].choose, hcutoff: 50 + (duration * 5), gain: 0.8).play;

		~oscClient.sendMsg("/opo1/pulse", 1);
		~oscClient.sendMsg("/opo1/ypos", durationsN[i]);
		// ~oscClient.sendMsg("/opo1/height", durationsN[i]/10);
		{ (duration / 2).wait; ~oscClient.sendMsg("/opo1/pulse", 0); }.fork;

		duration.wait;
		i = i + 1;
	};
}).play;


//// Right Screen ////////////////////////////////////////
~oscClient.sendMsg("/opo2/clear", 0);
~oscClient.sendMsg("/opo2/layer", 0);

rightScreen = Routine({
	var duration;
	var ypos;
	var reverseProb = 0.5.coin;

	durations.size.do {
		duration = durations[j];
		// (type:\dirt, orbit: ~out1, s: \bd, n: [0,1,2,3,4].choose, begin: 0, speed: 0.8, crush: [5,6,7,9].choose, shape: 0.8, pan: 1.0, gain: 0.8).play;
		(type:\dirt, orbit: ~out1, s: \bd, n: [0,1,2,3,4].choose, begin: 0, speed: 2 - duration, shape: 0.5, pan: 1.0, gain: 0.95).play;

		~oscClient.sendMsg("/opo2/pulse", 1);

		if (reverseProb) {
			ypos = 1 - durationsN[j];
		} {
			ypos = durationsN[j];
		};

		~oscClient.sendMsg("/opo2/ypos", ypos);

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
