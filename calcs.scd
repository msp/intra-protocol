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
