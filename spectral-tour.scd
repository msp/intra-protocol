// boot ////////////////////////////////////////////////////////////////////////
(
f = {
	"running CMD period hooks...".postln;
	~oscClient.sendMsg("/lfo/play", 0);
	~oscClient.sendMsg("/master/layer", 0);
};

CmdPeriod.add(f);
)

// patterns ////////////////////////////////////////////////////////////////////
(

load(~enginePath.fullPath+/+"04-osc.scd");

Routine({
	var play, fx, playChord, playLead, playTonal;
	var total = 0;
	var duration;
	var waveLength = 100;
	var rate;
	var vdmxLFOCycle = 6;

	// var chords = [
	// 	[0, 3, 7, 14],
	// 	[0, 7, 8, 15],
	// 	[0, 2, 7, 11],
	// 	[0, 5, 8, 15],
	// ];
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
			synths = freqs.collect { |freq|
				Synth(synthDef, [freq: freq, duration: duration, sustain: duration]);
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

	playTonal = {
		[
			{
				Routine({
					playLead.(rrand(1.0, 3.0));
				}).play;
				// playChord.(\pad, rrand(1.0, 2.0), root * chords.choose.midiratio);
				// playChord.(\pad, rrand(0.5, 3.7), root * chords.choose.midiratio);
				playChord.(\mspDynKlank, rrand(0.5, 3.7), root * chords.choose.midiratio);
				// play.(\pad, rrand(0.5, 3.7), [freq: root * chords.choose.midiratio]);
			},
			{
				play.(\bass, rrand(0.5, 1.2), [freq: root * (2 ** -3) * chords.choose.choose.midiratio]);
			},
			{
				var chord;
				chord = chords.choose;
				3.do {
					play.(\acid, exprand(0.05, 0.3), [freq: root * (2 ** rrand(-2, 0)) * chord.choose.midiratio]);
				};
			},
		].choose.value;
	};


	s.bind { fx = Synth.tail(nil, \fx); };

	// init FX
	~oscClient.sendMsg("/lfo/time", 0);
	~oscClient.sendMsg("/shader/invert", 0);
	~oscClient.sendMsg("/fx/pitchShift", 0);
	~oscClient.sendMsg("/fx/reverb", 0);
	~oscClient.sendMsg("/fx/comb1", 0);
	~oscClient.sendMsg("/fx/comb2", 0);
	~oscClient.sendMsg("/fx/latch", 0);

	// calc the LFO cycle duration
	(waveLength + 1).do { |i|
		duration = cos(i * 2pi / waveLength).linlin(-1, 1, 0.05, 0.2);
		total = total + duration;
	};

	rate = 1 / (total / vdmxLFOCycle);
	'total ----------------->'.postln;
	total.postln;
	'rate ----------------->'.postln;
	rate.postln;
	~oscClient.sendMsg("/lfo/rate", rate);
	~oscClient.sendMsg("/lfo/play", 1);

    inf.do { |i|
		duration = cos(i * 2pi / waveLength).linlin(-1, 1, 0.05, 0.2);
		// duration = [0.1].choose;
		// duration = [0.02, 0.1, 0.3, 5].choose;
		// orig for lines
		~oscClient.sendMsg("/pulse", [0,1].wrapAt(i));
		// squares with Sal
		~oscClient.sendMsg("/pulse", 1);
		{ (duration / 2).wait; ~oscClient.sendMsg("/pulse", 0); }.fork;

		s.bind { Synth(\kick, [duration: duration]) };
		// s.bind { Synth(\mspFM, [sustain: duration]) };
		// s.bind { Synth(\mspAdder, [sustain: duration]) };

		if(0.05.coin) {
			~oscClient.sendMsg("/part/tonal", 1);
			playTonal.();
		} {
			~oscClient.sendMsg("/part/tonal", 0);

			if(i % 3 == 0) {
				play.(\weirdBass, duration);
			}
		};

		// if(0.01.coin) {
		if(0.3.coin) {
			s.bind { fx.set(\trigger, 1); };
			~oscClient.sendMsg("/fx/trigger", 1);
			~oscClient.sendMsg("/shader/invert", 1);
		} {
			s.bind { fx.set(\trigger, 1); };
			~oscClient.sendMsg("/fx/trigger", 0);
			~oscClient.sendMsg("/shader/invert", 0);
		};
		// s.bind { Synth(\kick, [drive: duration.explin(0.1, 1.0, 0, 1)]) };
        duration.wait;
    };

	~oscClient.sendMsg("/lfo/play", 0);
}).play;
)

// other patterns /////////////////////////////////////////////////////////
(
Routine({
    20.do {
        s.bind { Synth(\kick) };
        rrand(0.03, 0.6).wait;
    };
}).play;
)


(
Routine({
    3.do {
        (0.75 ** (0..10)).do { |duration|
            s.bind { Synth(\kick) };
            duration.wait;
        };
    };
}).play;
)

(
Routine({
    ((0.8 ** (0..8)).normalizeSum * 15.0).do { |phraseDuration|
        ((0.75 ** (0..10)).normalizeSum * phraseDuration).do { |duration|
            s.bind { Synth(\kick) };
            duration.wait;
        };
    };
}).play;
)



(
Routine({
    ((0.8 ** (0..8)).normalizeSum * 15.0).do { |phraseDuration|
        ((0.75 ** (0..10)).normalizeSum * phraseDuration).do { |duration|
            s.bind { Synth(\kick, [duration: duration]) };
            duration.wait;
        };
        if(0.5.coin) {
            s.bind { Synth(\snare) };
            0.28.wait;
        };
    };
}).play;
)

(
Routine({
    ((0.8 ** (0..8)).normalizeSum * 50.0).do { |sectionDuration|
        ((0.8 ** (0..8)).normalizeSum * sectionDuration).do { |phraseDuration|
            ((0.75 ** (0..10)).normalizeSum * phraseDuration).do { |duration|
                s.bind { Synth(\kick, [duration: duration]) };
                duration.wait;
            };
            if(0.5.coin) {
                s.bind { Synth(\snare) };
                0.28.wait;
            };
        };
    };
}).play;
)

(
Routine({
    ((0.8 ** (0..8)).normalizeSum * 50.0).do { |sectionDuration|
        ((0.8 ** (0..8)).normalizeSum.reverse * sectionDuration).do { |phraseDuration|
            ((0.75 ** (0..10)).normalizeSum * phraseDuration).do { |duration|
				s.bind { Synth(\kick, [duration: duration]) };
				// s.bind { Synth(\mspFM, [sustain: duration]) };
                duration.wait;
            };
        };
    };
}).play;
)

(
Routine({
    (({ exprand(0.01, 0.5) } ! 20).sort.normalizeSum * 3.5).do { |duration|
        s.bind { Synth(\kick, [duration: duration]) };
        duration.wait;
    };
}).play;
)

(
Routine({
    var row;
    row = [0.2, 1, 1.4, 0.8, 1].normalizeSum;
    (row * 20.0).do { |sectionDuration|
        (row * sectionDuration).do { |phraseDuration|
            (row * phraseDuration).do { |duration|
                s.bind { Synth(\kick, [duration: duration]) };
                duration.wait;
            };
        };
    };
}).play;
)

(
Routine({
    30.do { |i|
        var duration;
        duration = [0.02, 0.1, 0.432].choose;
        s.bind { Synth(\kick, [duration: duration]) };
        duration.wait;
    };
}).play;
)