
(
var durationSeconds = 15;
// var durationSeconds = 30;
var minFreq = 120;
var baseFreq = 450;
var freq;
var minDuration = 0.09;

~oscClient.sendMsg("/master/layer", 1);

Routine({
	((0.8 ** (0..10)).normalizeSum * durationSeconds).do { |phraseDuration|
		'phrase: '.post;
		phraseDuration.postln;
		~oscClient.sendMsg("/fill/phrase/pulse", 0);
		((0.75 ** (0..10)).normalizeSum * phraseDuration).do { |duration|
			freq = max(minFreq, baseFreq * duration);
			duration = max(minDuration, duration);

			'duration: '.post;
			(duration).postln;

			'freq: '.post;
			(freq).postln;

			s.bind {
				// Synth(\mspLaser, [amp: 0.1, sustain: phraseDuration, freq: 200])
				// Synth(\pluck, [amp: 0.1, freq: ~root])

				// Synth(\mspsupergong, [amp: 0.5, att: 0.01, decay: (duration.linlin(0, 2, 0.5, 1)), accelerate: 0.01, sustain: duration * 1.5, freq:freq ])
				// Synth(\mspsupergong, [amp: 0.5, att: 0.01, decay: 1, accelerate: 0.01, sustain: duration, freq:freq ])

				Synth(\mspSuperhex, [sustain: phraseDuration/5, amp: 0.008, freq: freq])

			};
			s.bind {
				// Synth(\kick, [duration: duration])
			};
			~oscClient.sendMsg("/fill/width", duration.linlin(0, phraseDuration * durationSeconds/2, 0, 1));
			~oscClient.sendMsg("/fill/height", 1 * duration);
			~oscClient.sendMsg("/fill/pulse", 1);
			~oscClient.sendMsg("/fill/x", duration);
			{ (duration / 2).wait; ~oscClient.sendMsg("/fill/pulse", 0); }.fork;

			duration.wait;
		};

	~oscClient.sendMsg("/fill/phrase/pulse", 1);
	};
}).play;

)

(

var durationSeconds = 15;
// var durationSeconds = 30;
var minFreq = 130;
var baseFreq = 450;
var freq;
var minDuration = 0.09;

~oscClient.sendMsg("/master/layer", 1);

Routine({
	((0.8 ** (0..10)).normalizeSum * durationSeconds).do { |phraseDuration|
		'phrase: '.post;
		~oscClient.sendMsg("/fill/phrase/pulse", 0);

		phraseDuration.postln;
		((0.75 ** (0..10)).normalizeSum * phraseDuration).do { |duration|
			freq = max(minFreq, baseFreq * duration);
			duration = max(minDuration, duration);

			'duration: '.post;
			(duration).postln;

			'freq: '.post;
			(freq).postln;
			s.bind {

				// Synth(\mspLaser, [amp: 0.1, sustain: phraseDuration, freq: 150])
				// Synth(\pluck, [amp: 0.1, freq: ~root * 2])

				Synth(\mspSuperhex, [sustain: phraseDuration/5, amp: 0.008, freq: freq])
			};
			~oscClient.sendMsg("/fill/width", duration.linlin(0, phraseDuration * durationSeconds/2, 0, 1));
			~oscClient.sendMsg("/fill/height", 1 * duration);
			~oscClient.sendMsg("/fill/pulse", 1);
			~oscClient.sendMsg("/fill/x", 1 - duration);
			{ (duration / 2).wait; ~oscClient.sendMsg("/fill/pulse", 0); }.fork;

			duration.wait;
		};
	~oscClient.sendMsg("/fill/phrase/pulse", 1);
	};
}).play;

)

//// Tester /////////////////////////////////////////////////////////////

(
var freq;

Routine({
	inf.do { |i|
		var duration;
		duration = [0.02, 0.1, 0.432, 0.8].choose;

		'duration: '.post;
		(duration).postln;

		freq = 250 * duration;
		// 'freq: '.post;
		// (freq).postln;

		s.bind {
			Synth(\mspSuperhex, [sustain: 2, amp: 0.08, freq: freq])
			// Synth(\mspLaser, [amp: 0.3, sustain: duration * 3, freq: freq])

			// too CPH heavy
			// Synth(\mspsupergong, [amp: 0.5, att: duration/5, decay: (duration.linlin(0, 2, 0.5, 1)), accelerate: 0.01, sustain: duration * 1.5, freq: freq])
			// Synth(\pluck, [amp: 0.1, freq: ~root * 2])
		};
		~oscClient.sendMsg("/fill/width", 0.2);
		~oscClient.sendMsg("/fill/height", 1 * duration);
		~oscClient.sendMsg("/fill/pulse", 1);
		~oscClient.sendMsg("/fill/x", 1 - duration);
		{ (duration / 2).wait; ~oscClient.sendMsg("/fill/pulse", 0); }.fork;

		duration.wait;
	};
}).play;
)
