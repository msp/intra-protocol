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
var envTimeScale = 0.12;
var n = (1..numPartials);
var freq = 110;
// var freqChoices = [55, 110, 165, 220, 275, 660];
// var freqChoices = [110];
var freqChoices = [110, 110 * 2];
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
var randWait = 1;
var cps = 1/2;
var tmpEnv;

~seq = Routine {
    inf.do({ arg count;
		mixerWhite = rrand(0.4, 0.99);
		// mixerWhite = rrand(0.01, 0.08);
		// mixerSub = rrand(0.5,5);
		mixerSub = rrand(5, 12);
		// mixerSub = 10;
		cps = [0.5, 1, 2, 4].choose([0.05, 0.5, 0.3, 0.15]);
		// cps = 6;

		// Sometimes go very lowercase with <= 30 partials
		if(0.4.coin) {
			n = (1..(numPartials.min(rrand(30, 60))));
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


/*		if(0.8.coin) {
			envTimeScale = rrand(3,8);
		} {
			envTimeScale = rrand(15, 27);
		};*/

		envTimeScale = rrand(0.20, 0.40);
		// envTimeScale = rrand(0.20, 1.0);
		// envTimeScale = 1.0;
		// envTimeScale = 4.0;
		// envTimeScale = rrand(0.33, 0.68);
		// envTimeScale = 2.9;
		// envTimeScale = rrand(0.80, 0.98);
		// envTimeScale = rrand(0.5, 1.0);

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
		// pairsRand = { { rrand(0.01, 1.0) } ! 2 } ! envSteps;

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

		// pairsRand = [
		// 	[ 0.01, 0.325 ],
		// 	[ 0.30, 0.7194878757 ],
		// 	[ 0.86, 0.5 ],
		// 	[ 0.91, 0.001 ]
		// ];


		// the length of the ENV will be the max time value in the [time,level] pairs
		a = 0.001;
		tmpEnv = Env.perc(rrand(0.01, a), rrand(0.01, a), 1.0, rrand(-4, 4));

		pairsRand = tmpEnv.times.collect{|x,i| [x, tmpEnv.levels[i+1]] };


		// times the scale
		dur = pairsRand.collect{|x,i| x[0]; }.sort.reverse[0] * envTimeScale;

		("-MSP DUR ("+dur+")------------------------- ").postln;
		("-MSP ENV ---------------------------------- ").postln;

		// pairs = pairsRand.collect{|x,i| [x[1], x[0]] };
		// pairs2 = pairsRand.collect{|x,i| [x[1], x[0]] };
		pairs = pairsRand;
		pairs2 = pairsRand;

		// {
		// 	Env.pairs(pairs, \exp).plot;
		// }.defer;

		pairs.postln;

		("-MSP FIRING! ("+count+")***************************** ").postln;
		("***************************************************** ").postln;
		"".postln;
		"".postln;
		"".postln;

		if(1.0.coin) {
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

			if(0.8.coin) {
				Routine {
					// (1/cps/[0.3, 0.6, 2, 4].wchoose([0.1, 0.1, 0.4, 0.4])).wait;
					(1/cps/[0.5, 2, 4].wchoose([0.1, 0.5, 0.4])).wait;

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

				}.play

			}

		};

		if(0.0.coin) {
			~d1.((
				// sound: 'sd:8',
				sound: '808bd:4',
				// sound: 'bd:6',
				// sound: 'bd:11',
				begin: 0,
				// end: 1,
				speed: 1.0,
				accelerate: [-1.5, -1, 0, 0.1 ].choose,
				// cutoff: rrand(250, 1040),
				hcutoff: 80,
				hresonance: 0.6.rand,
				shape: [0.6, 0.8, 0.9].choose,
				// crush: [2, 4, 8, 12, 16].wchoose([0.05, 0.1, 0.3, 0.25, 0.3]),
				krush: [0, 0.3, 0.6, 0.9].wchoose([0.35, 0.35, 0.2, 0.1]),
				kcutoff: rrand(100, 15000),  //cutoff of the krush filter
				// gain: [0.65, 0.85].choose,
				gain: [0.7, 0.85, 0.9].choose,
				delaytime: [0.25, 0.75].choose,
				delay: 0.1,
				delayfeedback: [0, 0.15, 0.25, 0.35].wchoose([0.3, 0.15, 0.45, 0.1]),
				room: 0.25,
				size: 0.2

			)
		);
		};


		if(0.0.coin) {
			~d1.((
				sound: 'sd:8',
/*				begin: 0.5.rand,
				end: 1,*/
					begin:1.0.rand,
					end: 2.0.rand,
				speed: rrand(0.7, 0.9),
				accelerate: rrand(0.1, 0.3),
				cutoff: rrand(50, 15040),
				shape: rrand(0.25, 0.65),
				crush: [4, 8, 12, 16].wchoose([0.1, 0.3, 0.3, 0.3]),
				gain: 0.9 ,
				delaytime: [0.15, 0.25, 0.50, 0.75].wchoose([0.1, 0.3, 0.3, 0.3]),
				delay: [0, 0.2, 0.4, 0.6].wchoose([0.1, 0.3, 0.3, 0.1]),
				delayfeedback: [0, 0.15, 0.25, 0.35].wchoose([0.3, 0.15, 0.45, 0.1]),
				room: 0.2,
				size: 0.2,
				pan: [0.01, 0.99].choose
			)
			);
		};


		if(0.2.coin) {
			~d1.(
				(
					sound: '808cy:11',
					speed: rrand(0.1, 2.0),
					begin:1.0.rand,
					end: 2.0.rand,
					// accelerate:1.0.rand,
					hcutoff: rrand(2000, 4000),
					hresonance: 0.2.rand,
					delay: 1.0.rand,
					delaytime: 1/4,
    				delayfeedback: [0, 0.15, 0.25, 0.35].wchoose([0.3, 0.15, 0.45, 0.1]),
					gain: [0.8, 0.9, 0.7].choose,
					room: 0.2,
					size: 0.2,
					pan: [0.3, 0.7].choose

			));

			// rhythm tester
			// ~d1.(
			// 	(
			// 		sound: '808cy:11',
			// 		hcutoff: rrand(2000, 4000),
			// 		hresonance: 0.2.rand,
			// 		gain: 0.9
			//
			// ));
		};


		// randWait = rrand((dur * 0.6), (dur + 3.rand ));
		// ("-MSP DUR / WAIT ("+ dur + "/"+ randWait +")***************************** ").postln;

		// randWait.wait;

		// cps = cps + [0.001, 0.1, 0.3, 3].wchoose([0.55, 0.3, 0.2, 0.05]);
		// cps = cps + [0.001, 0.1, 0.3, 3].wchoose([0.35, 0.2, 0.2, 0.25]);
		// cps = cps + 3.9 + 0.006.rand;
		// cps = 1;
		(1/cps).wait;

    });
    // Wait half second before saying we're done
    0.5.wait;
    "done!".postln;
}.play;

)
