// srvr ////////////////////////////////////////////////////////////////////////

(
s = Server.local
)

// boot ////////////////////////////////////////////////////////////////////////
(
load(~enginePath.fullPath+/+"04-osc.scd");

f = {
	"running CMD period hooks...".postln;
	~oscClient.sendMsg("/lfo/play", 0);
	~oscClient.sendMsg("/master/layer", 0);
	~oscClient.sendMsg("/opo1/clear", 1);
	~oscClient.sendMsg("/opo2/clear", 1);
};

~oscClient.sendMsg("/lfo/play", 1);

CmdPeriod.add(f);

)

// guii ////////////////////////////////////////////////////////////////////////
(
PdefAllGui(Pdef.all.size);
)

// ctrl ////////////////////////////////////////////////////////////////////////
(
~root = 59;
// ~root = 60;
// ~speed = 1;
~speed = 0.95;
~pacer = 1;
// ~pacer = 0.05;
~durations = [3, 4, 5] / 100;
// ~durations = [0.4, 0.2, 0.1];
// ~durations = [0.2, 0.1];

// ~durations = [0.1, 0.3, 0.5, 0.8];
// ~durations = [0.1, 0.04];
// ~durations = [0.08, 0.02];
///////////////////////////////////////////
// Edit the Pad synth for the last passage!
///////////////////////////////////////////
// ~durations = [0.04];
~durMult = [0.5, 1, 3, 6];
// ~durMult = [3, 6, 9];
~bassSustain = 0.7;
// ~bassSustain = 0.5;
~playLFO = true;

)


// pttn ////////////////////////////////////////////////////////////////////////
(

var j = 0.1;
var duration;
var minPacer = 0.01;
var freqs;
var acids;
var fx;
var bassMult;
var chord = [-3, 0, 2, 4, 7, 11];

// s.bind { fx = Synth.tail(nil, \fx); };

Routine({
	~oscClient.sendMsg("/master/layer", 1);

	inf.do { |i|
		duration = ~durations.choose;

		if (~playLFO == true) {
			~oscClient.sendMsg("/lfo/play", 1);
		}{
			~oscClient.sendMsg("/lfo/play", 0);
		};

		freqs = (~root + j.rand + chord).midicps;
		// freqs.postln;

		bassMult = [0.9, 1, 1.1].wchoose([0.2, 0.8, 0.1].normalizeSum);
		// bassMult = 1;

		// note on
		~synths = (
			[Synth(\msp808, [sustain: ~bassSustain, voice: -0.4, speed: 2, att: 0.01])]
			// ++ freqs.collect { |freq| Synth(\pad, [freq: freq * bassMult]) }
			// ++ [Synth(\kick, [duration: duration])]

			// ++ [Synth(\bass3, [freq: ((~root * bassMult + j) - 24).midicps])]
			// ++ [Synth(\mspplucklead, [sustain: duration, amp: 0.2, freq: ((~root/3) * bassMult + j).midicps])]

			// ++ [Synth(\mspLaser, [amp: 0.1, sustain: rrand(0.5, 2.0), freq: [140, 160, 180, 200].choose])]
			// ++ [Synth(\mspSuperhex, [sustain: duration * 2, amp: 0.01, freq: ((~root * 1.1 + j)).midicps])]

			// ++ [Synth(\mspSuperzow, [amp: 0.02, sustain: duration * 2, freq: ((~root * bassMult * 1.0 + j)).midicps])]

			// ++ [Synth(\acid, [freq: (~root) * (3 ** rrand(-2, 0))])]
			// ++ [Synth(\acid, [freq: ~root * 1 * bassMult])]
			++ [Synth(\pluck, [amp: 0.1, freq: ~root])]
		);

		// Synth(\mspSuperhex, [sustain: duration * 2, amp: 0.01, freq: ((~root * 1.1 + j)).midicps]);
		Synth(\mspSuperhex, [sustain: duration * rrand(0.2, 0.8), amp: 0.008, freq: ((~root * rrand(1.099, 1.1) + j)).midicps]);

		Routine({
			if(0.5.coin) {
				// (~pacer * 2).wait;
				s.bind { fx.set(\trigger, 1); };
				Synth(\pluck, [amp: 0.1, transpose: [-3, -2, -1, 0, 1,2,3].choose])
			};
			(~pacer * 2).wait;
		}).play;


		~oscClient.sendMsg("/pulse", 1);

		s.bind { fx.set(\trigger, 1); };

		if(0.1.coin) {
			duration = duration * ~durMult.choose;
			// s.bind { fx.set(\trigger, 1); };
			~oscClient.sendMsg("/fx/trigger", 1);
			~oscClient.sendMsg("/part/tonal", 1);
			~oscClient.sendMsg("/shader/invert", 1);
		} {
			// s.bind { fx.set(\trigger, 1); };
			~oscClient.sendMsg("/fx/trigger", 0);
			~oscClient.sendMsg("/part/tonal", 0);
			~oscClient.sendMsg("/shader/invert", 0);
		};

		Routine({
			if(0.4.coin) {
				s.bind { Synth(\mspSuperHat, [accelerate: 0.4, sustain: duration, amp: 0.08]); };
			};
			if(0.2.coin) {
				(~pacer * 2).wait;
				s.bind { Synth(\mspSuperHat, [accelerate: 0.4, sustain: duration, amp: 0.08]); };
			};
			~pacer.wait;

			if(0.3.coin) {
				s.bind { Synth(\mspSuperHat, [accelerate: rrand(-1.0, 1.0), sustain: duration * [0.1, 1, 2].choose, amp: 0.09]); };
			};

			(~pacer * 2).wait;
		}).play;



		if(0.04.coin) {
			[1, 3].choose.do {
				s.bind { Synth(\ghostKick, [amp: 0.8]); };
				(~pacer * (1 / [3, 6].choose)).wait;

				~oscClient.sendMsg("/fill/phrase/pulse", 0);

				~oscClient.sendMsg("/fill/width", 1);
				~oscClient.sendMsg("/fill/height", 1 * duration);
				~oscClient.sendMsg("/fill/pulse", 1);
				~oscClient.sendMsg("/fill/x", 1 - duration);
				{
					(duration / 2).wait; ~oscClient.sendMsg("/fill/pulse", 0);
					~oscClient.sendMsg("/fill/phrase/pulse", 1);

				}.fork;



			};
		};

		if(0.2.coin) {
			~synths.do { |synth|
				if(synth.defName == 'pad') {
					synth.set(\duck, 1);
				};

				if(synth.defName == 'bass3') {
					synth.set(\duck, 1);
				};

			};
		};

		duration.wait;

		//note off
		~synths.do { |synth|
			if(synth.defName == 'pad') {
				synth.set(\gate, 0);
			};

			if(synth.defName == 'bass3') {
				synth.set(\gate, 0);
			};

			if(synth.defName == 'acid') {
				synth.set(\gate, 0);
			};
		};

		// { ((duration) / 2).wait; ~oscClient.sendMsg("/pulse", 0); }.fork;
		{ ((duration) / 3).wait; ~oscClient.sendMsg("/pulse", 0); }.fork;

		// (duration / 3).wait / 10;
		(duration).wait;

		if(0.3.coin) {
			~pacer = max(minPacer, ~pacer * ~speed);
			~pacer.postln;

			"Iteration: %, Pacer: %\n".postf(i, ~pacer);
			~pacer.wait;
		}
	};
}).play;
)


(
var duration = 1.0;  // starting duration
var minDuration = 0.1;  // the minimum duration to prevent the duration from becoming too short
var factor = 0.95;  // the factor by which the duration is multiplied each time
var maxIterations = 100;  // maximum number of iterations

Task({
    maxIterations.do({ |i|
        duration = max(minDuration, duration * factor);  // update the duration logarithmically
        "Iteration: %, Duration: %\n".postf(i, duration);
		Synth(\msp808, [sustain: 2.5, voice: -0.4, speed: 2, att: 0.01]);
        duration.wait;  // wait for the current duration
    });
}).play;
)

~synths.do { |synth| synth.set(\duck, 1); }

~synths.do { |synth| synth.set(\gate, 0); }

(
Routine({
	var total = 0;

    101.do { |i|
        var duration;
        var wave;
        var slider;

        wave = cos(i * 2pi / 100);
        duration = wave.linlin(-1, 1, 0.05, 0.2);
        slider = wave.linlin(-1, 1, 0, 1);
		"[".post;
		i.post;
		"] ".post;
		wave.postln;
		duration.postln;

		total = total + duration;

		"------------------ ------- (".post;
		total.post;
		") ".postln;


		// 0.01.wait;
    };
}).play;
)


// ////////////
[ 370.0, 415.31095787428, 554.37361844348, 659.26505142233 ].choose

(

SynthDef(\pad, {
	arg freq;
	var snd;
	// snd = LFTri.ar(\freq.kr(440) * ({ LFNoise2.kr(3) * 0.2 } ! 5).midiratio);
	// snd = LFTri.ar(\freq.kr(440) * ({ LFNoise2.kr(3) * 0.2 } ! 5).midiratio);

	snd = LFTri.ar(LFTri.kr(0.05, iphase: (0..3)) *  freq, 0, 0.1).sum;
	// snd = LFTri.ar(LFTri.kr(0.05, iphase: (0..3)) *  (\freq.kr(440) / 2) + 400, 0, 0.1).sum;


	snd = Splay.ar(snd);
	// snd = (snd * -20.dbamp) + BPF.ar([snd], { ExpRand(800, 8120) } ! 3, 0.1).sum;
	// snd = (snd * 16).round / 16;
	// snd = snd * Env.asr(0.2, 1, 0.03, curve: 4).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * Env.asr(0.2, 1, 0.7, curve: 4).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -18.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

)

Synth(\pad)

Synth(\hauntedSine)

Synth(\mspDynKlank)

410 * [0, 2, 7, 10].midiratio;

(
	var play, fx, playChord, playLead, playTonal;

	var chords = [
		[0, 2, 7, 10],
		[0, 2, 7, 10] + 2,
	[0, 3, 6, 9],
	[0, 7, 8, 15],
	[0, 2, 7, 11],
	[0, 5, 8, 15],
	];

	var root = 370;

	play = { |synthDef, duration, args = #[]|
		var synth;
		s.bind { synth = Synth(synthDef, [duration: duration] ++ args); };
		duration.wait;
		s.bind { synth.set(\gate, 0); };
	};

	playChord = { |synthDef, duration, freqs|
		var synths;
		s.bind {
			'playing chord with freqs:'.postln;
			freqs.postln;

			synths = freqs.collect { |freq|
				Synth(synthDef, [freq: freq, duration: duration]);
			};
		};
		duration.wait;
		// 1.wait;
		s.bind {
			synths.do { |synth|
				synth.set(\gate, 0);
			}
		};
	};

(
Routine({
    inf.do { |i|
        var duration, chord;
		chord = chords.wrapAt(i);
		'chord -----------> ';
		chord.postln;

        duration = cos(i * 2pi / 20).linlin(-1, 1, 0.05, 0.2);
		// s.bind { Synth(\kick, [duration: duration]) };

		playChord.(\mspDynKlank, rrand(0.5, 0.7), root * chord.midiratio);

        duration.wait;
    };
}).play;
)


)

(

[1,0].cycl


)
