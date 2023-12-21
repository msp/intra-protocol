(

var i = 0;
var freq = 1; // Frequency of the sine wave (adjust as needed)
var rangeMin = 0.1; // Minimum duration (in seconds)
var rangeMax = 10.0; // Maximum duration (in seconds)

// Function to generate sinusoidal durations
var generateSinusoidalDur = {
	var sinValue = {  // Create a function for reusability
		var sinWave = SinOsc.ar(freq);
		rangeMin + ((sinWave + 1) * (rangeMax - rangeMin));
	}.value;

	sinValue;
};

Pbind(
	\type, \dirt,
	\s, \cr,
	\n, Pseq([1, 0, 1, 5], inf),
	\freq, Pseq([440, 660], inf),
	\dur, Pfunc { generateSinusoidalDur.value },
	\postEvent, Pfuncn({ |event|
		i.postln;
		event.postln;
		// event.put(\dur, 1).postln;

		// if(i >= 5) {
		// 	event.put(\freq, 100).postln;
		// };
		//
		// if(i >= 10) {
		// 	event.put(\freq, 800).postln;
		// };

		i = i + 1;
	}, inf)
).play;
)


//////////////

(
var minWaitTime = 0.1; // Minimum wait time (in seconds)
var maxWaitTime = 1.0; // Maximum wait time (in seconds)
var reverseDistribution = false; // Initial distribution direction

Routine {
	inf.do {
		// Generate a random wait time based on the distribution
		var waitTime;

		if (reverseDistribution) {
			// Reverse the distribution when needed
			waitTime = maxWaitTime - exprand(0, maxWaitTime - minWaitTime);
		} {
			waitTime = exprand(minWaitTime, maxWaitTime);
		};

		// Perform your actions here (replace with your actual code)
		// For example, you can print the waitTime
		"Waiting for: ".post; waitTime.postln;

		// Check if the wait time reached maxWaitTime and reverse the distribution
		if (waitTime >= maxWaitTime) {
			'reversing!!!!'.postln;
			reverseDistribution = reverseDistribution.not; // Toggle the distribution
		};

		Synth(\mspSuperhex, [sustain: 0.1, amp: 0.008, freq: 200]);
		waitTime.wait;
	};
}.play;
)

//// OPO1 ///////////////////////////////////////////////////////////////

(
var loopLength = [150, 300, 500].choose;
// var minWaitTime = 0.00008;
// var minWaitTime = 0.008;
var minWaitTime = 0.008;
// var maxWaitTime = 1.5.rand;
var maxWaitTime = 0.3;
// var maxWaitTime = 5;
var duration;
var up = Array.exprand(loopLength, minWaitTime, maxWaitTime).sort;
// var up = Array.fill(loopLength,
// 	{ arg i; (i).sin + 1 * 0.3 }
// );
var i = 0;

var upN = up.normalize;


// up.plot;

// if (1.0.coin) {
// 	up = up.reverse;
// };

Routine {
	Routine({
		inf.do {
			// (type:\dirt, orbit: ~out1, s: \bd, n: 4, begin: 0, speed: 0.81, shape: 0.1, gain: 0.8).play;
			1.wait;
			// (type:\dirt, orbit: ~out1, s: \cr, n: 0, begin: 0, end: duration, speed: 0.8, hcutoff: 8400, gain: 0.4).play;
		}
	}).play;

	up.size.do {
		duration = up[i];
		// Perform your actions here (replace with your actual code)
		// For example, you can print the duration
		"Waiting: [".post; i.post; "] ".post; duration.postln;

		// s.bind { Synth(\mspSuperhex, [sustain: 3, amp: 0.008, freq: 80 + (duration * 100)]) };
		(type:\dirt, orbit: ~out1, s: \bouncer, n: 0, begin: 0, end: duration, speed: [1,2].choose - duration, pan: [0.25,0.75].choose, hcutoff: 50 + (duration * 5), gain: 0.9).play;

		(type:\dirt, orbit: ~out1, s: \bd, n: [0,1,2,3,4].choose, begin: 0, speed: 0.8, crush: [5,6,7,9].choose, shape: 0.8, gain: 1.0).play;


		~oscClient.sendMsg("/opo1/pulse", 1);
		~oscClient.sendMsg("/opo1/ypos", upN[i]);
		{ (duration / 2).wait; ~oscClient.sendMsg("/opo1/pulse", 0); }.fork;

		duration.wait;
		i = i + 1;
	};
}.play;

'done!!!!!!'.postln;
)


//// OPO2 ///////////////////////////////////////////////////////////////

(
var loopLength = [150, 300, 500].choose;
// var minWaitTime = 0.00008;
// var minWaitTime = 0.008;
var minWaitTime = 0.008;
var maxWaitTime = 1.5.rand;
// var maxWaitTime = 0.3;
// var maxWaitTime = 5;
var duration;
var up = Array.exprand(loopLength, minWaitTime, maxWaitTime).sort;
// var up = Array.fill(loopLength,
// 	{ arg i; (i).sin + 1 * 0.3 }
// );
var i = 0;
var j = 0;

var upN = up.normalize;
var upNR = up.reverse;


// up.plot;

// if (1.0.coin) {
// 	up = up.reverse;
// };

Routine({
	//// Left Screen ///////////////////////////////////////////
	~oscClient.sendMsg("/opo1/clear", 0);
	~oscClient.sendMsg("/master/layer", 1);

	Routine({
		up.size.do {
			duration = up[i];
			"Waiting: [".post; i.post; "] ".post; duration.postln;

			// s.bind { Synth(\mspSuperhex, [sustain: 3, amp: 0.008, freq: 80 + (duration * 100)]) };
			(type:\dirt, orbit: ~out1, s: \bouncer, n: 0, begin: 0, end: duration, speed: [1,2].choose - duration, pan: [0.0].choose, hcutoff: 50 + (duration * 5), gain: 0.8).play;

			// (type:\dirt, orbit: ~out1, s: \bd, n: [0,1,2,3,4].choose, begin: 0, speed: 0.8, crush: [5,6,7,9].choose, shape: 0.8, gain: 1.0).play;

			~oscClient.sendMsg("/opo1/pulse", 1);
			~oscClient.sendMsg("/opo1/ypos", upN[i]);
			~oscClient.sendMsg("/opo1/height", upN[i]/10);
			{ (duration / 2).wait; ~oscClient.sendMsg("/opo1/pulse", 0); }.fork;

			duration.wait;
			i = i + 1;
		};
	}).play;


	//// Right Screen ////////////////////////////////////////
	~oscClient.sendMsg("/opo2/clear", 0);

	Routine({
		up.reverse.size.do {
			duration = up[i];
			"Waiting: [".post; i.post; "] ".post; duration.postln;

			// s.bind { Synth(\mspSuperhex, [sustain: 3, amp: 0.008, freq: 80 + (duration * 100)]) };
			// (type:\dirt, orbit: ~out1, s: \bouncer, n: 0, begin: 0, end: duration, speed: [1,2].choose - duration, pan: [0.25,0.75].choose, hcutoff: 50 + (duration * 5), gain: 0.9).play;

			(type:\dirt, orbit: ~out1, s: \bd, n: [0,1,2,3,4].choose, begin: 0, speed: 0.8, crush: [5,6,7,9].choose, shape: 0.8, pan: 1.0, gain: 0.8).play;

			~oscClient.sendMsg("/opo2/pulse", 1);
			~oscClient.sendMsg("/opo2/ypos", 1 - upN[i]);
			{ (duration / 2).wait; ~oscClient.sendMsg("/opo2/pulse", 0); }.fork;

			duration.wait;
			i = i + 1;
		};
	}).play;

}).play;

'OPO 2 done!!!!!!'.postln;
)

//// Tinker /////////////////////////////////////////////////////////////

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
