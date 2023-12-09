
(59 + 3 + [-3, 0, 2, 4, 7, 11]).midicps.collect { |freq| Synth(\pad, [freq: freq]) }

Synth(\pad, [freq: 329.62])
Synth(\pad, [freq: 369.99])


Synth(\pad, [freq: 440])

// boot ////////////////////////////////////////////////////////////////////////
(
load(~enginePath.fullPath+/+"04-osc.scd");

f = {
	"running CMD period hooks...".postln;
	~oscClient.sendMsg("/lfo/play", 0);
	~oscClient.sendMsg("/master/layer", 0);
};

CmdPeriod.add(f);

)

// ctrl ////////////////////////////////////////////////////////////////////////
(



// ~speed = 1;
~speed = 0.95;
~pacer = 1;
// ~pacer = 0.01;
~durations = [3, 4, 5, 6] / 50;
// ~durations = [0.2];
// ~durations = [0.02];
~durMult = 6;
~bassSustain = 2.5;
// ~bassSustain = 1.5;
// ~oscClient.sendMsg("/lfo/play", 0);
~oscClient.sendMsg("/lfo/play", 1);


)

// pttn ////////////////////////////////////////////////////////////////////////
(
var root = 59;
var j = 0;
var duration;

var minPacer = 0.01;


Routine({
	~oscClient.sendMsg("/master/layer", 1);

	inf.do { |i|
		duration = ~durations.choose;

		// note on
		~synths = (
			[Synth(\msp808, [sustain: ~bassSustain, voice: -0.4, speed: 2, att: 0.01])]
			++ (root + j + [-3, 0, 2, 4, 7, 11]).midicps.collect { |freq| Synth(\pad, [freq: freq]) }
			// ++ [Synth(\kick, [duration: duration])]
			// ++ [Synth(\mspFM, [sustain: duration])]
			// ++ [Synth(\bass3, [freq: ((root + j) - 24).midicps])]
		);

		~oscClient.sendMsg("/pulse", 1);

		if(0.1.coin) {
			duration = duration * ~durMult;
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

		if(0.2.coin) {
			~synths.do { |synth|
				if(synth.defName == 'pad') {
					synth.set(\duck, 1);
				}
			};
		};

		duration.wait;

		//note off
		~synths.do { |synth|
			if(synth.defName == 'pad') {
				synth.set(\gate, 0);
			}
		};

		{ ((duration) / 2).wait; ~oscClient.sendMsg("/pulse", 0); }.fork;

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
