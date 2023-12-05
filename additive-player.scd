// CONTROL /////////////////////////////////////////////////////////
(
~seq;
// ~seq.play;
~seq.stop;
~seq.beats;
~seq.seconds;
~seq.clock;
~synths;
~synths.collect{|x,i| x.free; };
~synths = [];
)

// EXECUTE! ////////////////////////////////////////////////////////
(
// NB: must match value in SynthDef!
var numPartials = ~numPartials;
var envSteps = ~envSteps;
var envTimeScale = 4;
var n = (1..numPartials);
var freq = 55;
var freqChoices = [55, 110, 165, 220, 275, 660];
// var freqChoices = [55];
// var freqChoices = [55, 110, 165];
var freqs = [];
var levels = [];
var tilt = -3;
var pairs = [];
var pairs2 = [];
var pairsRand = [];
var mixerWhite = 0.04;
var mixerSub = 3;
var r;
var dur;
var tmpViz = [];
var factor = 2;
var scopeStyle = 0;
var randWait = 2;

~seq = Routine {
    inf.do({ arg count;
		mixerWhite = rrand(0.01, 0.08);
		// mixerSub = rrand(0.5,5);
		mixerSub = 0;

		// Sometimes go very lowercase with <= 30 partials
		if(0.55.coin) {
			n = (1..(numPartials.min(rrand(2, 30))));
		} {
			n = (1..numPartials);
		};

		factor = ~factor.value(n.size);

		tmpViz = n[0, factor..];
		("-MSP SCOPE ("+tmpViz.size+")-------------------------------- ").postln;

		// http://doc.sccode.org/Guides/GUI-Introduction.html#Caution:%20GUI%20and%20timing
		{
			scopeStyle = [0, 2].wchoose([0.7, 0.3]);

			// ~scope.dump;
			~scope.index = ~vizBus.index;
			~scope.numChannels = tmpViz.size;

			// 0 == tracks
			// 2 == X/Y
			if(scopeStyle == 0) {
				if(n.size > 25) {
					~scope.zoom  = [12, 14, 16].wchoose([0.33, 0.33, 0.34]);
					~scope.yZoom = rrand(2, 16);
				} {
					~scope.zoom =  rrand(0.4, 1.5);
					~scope.yZoom = 16;
				};
			} {
				// ~scope.zoom =  [0, 1, 2].wchoose([0.65, 0.25, 0.10]);
				~scope.zoom =  1.2.rand;
				~scope.yZoom = rrand(0.5, 6.0);
			};
			~scope.style = scopeStyle;
		}.defer;

		("-MSP PARTIALS ("+n.size+")----------------------------- ").postln;

		if(0.1.coin) {
			freq = freqChoices.rand;
		} {
			freq = freqChoices.choose;
		};

		("-MSP FREQ ("+freq+")--------------------------------- ").postln;
		freqs = freq * n;


		if(0.8.coin) {
			envTimeScale = rrand(3,8);
		} {
			envTimeScale = rrand(15, 27);
		};

		//tilt EQ to roll off harsh highs
		levels = 1 * (log2(n) * tilt).dbamp;


		("-MSP TIMESCALE ("+envTimeScale+")------------------------ ").postln;
		// FREQS /////////////////////////////////////////////////////////
		//frequency dispersion
		freqs = freqs  * (1 + (n * n * 0.000521)).abs.sqrt;

		// ** TODO MSP Play with these values for timbre **

		// Hmm, sometimes these get out of sync
		if(freqs.size == levels.size) {
			if(0.2.coin) {
				freqs.collectInPlace{|x,i| if((i%2) == 0) {levels.put(i,0.0); x;} {x;}};
			} {};
		} {
			"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".postln;
			"freqs.size: ".post;
			freqs.size.postln;
			"levels.size: ".post;
			levels.size.postln;
		};

		if(0.8.coin) {
			("-MSP INHARMONIC SHIFT ------------------------------ ").postln;
			// inharmonic frequency shift of every 4th partial by 20 hz
			freqs.collectInPlace{|x,i| if((i%4) == 0) {x = x + 20;} {x;}};
		} {};


		if(0.4.coin) {
			("-MSP 3RD PARTIAL ----------------------------------- ").postln;
			// harmonic ratio multiplication of every 3rd partial
			freqs.collectInPlace{|x,i| if((i%3) == 0) {x = x * 1.5;} {x;}};
		} {};


		if(0.5.coin) {
			("-MSP 5TH PARTIAL ----------------------------------- ").postln;
			freqs.collectInPlace{|x,i| if((i%5) == 0) {x = x * 5;} {x;}};
			// freqs.collectInPlace{|x,i| if((i%5) == 0) {x = x + rrand(450, 550);} {x;}};
			levels.collectInPlace{|x,i| if((i%5) == 0) {x = x * 0.5;} {x;}};
		} {};

		("-MSP FREQS --------------------------------------------- ").postln;
		freqs.postln;

		// LEVELS ////////////////////////////////////////////////////////
		//uncomment this to silence every 2nd harmonic, creating a square-like timbre
		// levels.collectInPlace{|x,i| if(i.even) {x = x*0.0;} {x;}};

		//periodic filter approximation?
		//x axis controls phase, y axis number of peaks/troughs. exponent controls steepness
		// levels.collectInPlace{|x,i| {x * (((i/MouseY.kr(0.5,48) + MouseX.kr(0,8)).sin.abs) ** 4);}};

		//different approach from nathan ho's video
		// levels = levels * (1 - log2(n * MouseX.kr(1,16) + MouseY.kr(1,100)).sin.abs);
		// levels.plot;

		// "-MSP freqs 2 ---------------------------------- ".postln;
		// freqs.collectInPlace{|x,i| XLine.kr(x, freqs.scramble[i], 0.3) };

		//mute all sines above 20k to prevent aliasing
		freqs.collectInPlace{|x,i| if(x>20000) {levels.put(i,0.0); x;} {x;}};

		// ENV ///////////////////////////////////////////////////////////
		pairsRand = { { rrand(0.01, 1.0) } ! 2 } ! envSteps;

		// Don't start at zero else it pops!
		// pairsRand = [
		// 	[0.001, 0.001],
		// 	[0.05, 0.9],
		// 	[0.5, 0.5],
		// 	[0.6, 0.4],
		// 	[0.7, 0.3],
		// 	[0.8, 0.2],
		// 	[0.9, 0.1],
		// 	[1.0, 0.001]
		// ];

		// the length of the ENV will be the max time value in the [time,level] pairs
		// times the scale
		dur = pairsRand.collect{|x,i| x[0]; }.sort.reverse[0] * envTimeScale;

		("-MSP DUR ("+dur+")------------------------- ").postln;
		("-MSP ENV ---------------------------------- ").postln;

		pairs = pairsRand.collect{|x,i| [x[1], x[0]] };
		pairs2 = pairsRand.collect{|x,i| [x[1], x[0]] };

/*		{
			Env.pairs(pairs, \exp).plot;
		}.defer;*/

		pairs.postln;

		("-MSP FIRING! ("+count+")***************************** ").postln;
		("***************************************************** ").postln;
		"".postln;
		"".postln;
		"".postln;

		~synths.add(
			Synth(\mspAdder,
			[
				\out: ~audioBus,
				\vizOut: ~vizBus,
				\freqs: freqs,
				\levels: levels,
				\pairs: pairs,
				\pairs2: pairs2,
					\mixerWhite: mixerWhite,
					// \mixerWhite: 0,
					\mixerSub: mixerSub,
					// \mixerSub: 0,
				\envTimeScale: envTimeScale,
					envDuration: dur,
					scopeStyle: scopeStyle
			])
		);

		randWait = rrand((dur * 0.6), (dur + 3.rand ));
		("-MSP DUR / WAIT ("+ dur + "/"+ randWait +")***************************** ").postln;

		randWait.wait;
    });
    // Wait half second before saying we're done
    0.5.wait;
    "done!".postln;
}.play;

)
