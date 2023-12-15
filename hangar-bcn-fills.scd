
(
var durationSeconds = 15;
// var durationSeconds = 30;

Routine({
	((0.8 ** (0..10)).normalizeSum * durationSeconds).do { |phraseDuration|
		'phrase: '.post;
		phraseDuration.postln;
		~oscClient.sendMsg("/fill/phrase/pulse", 0);
		((0.75 ** (0..10)).normalizeSum * phraseDuration).do { |duration|
			'duration: '.post;
			(duration).postln;

			s.bind {
				// Synth(\mspLaser, [amp: 0.1, sustain: phraseDuration, freq: 200])
				Synth(\pluck, [amp: 0.1, freq: ~root])
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

Routine({
	((0.8 ** (0..10)).normalizeSum * durationSeconds).do { |phraseDuration|
		'phrase: '.post;
		~oscClient.sendMsg("/fill/phrase/pulse", 0);

		phraseDuration.postln;
		((0.75 ** (0..10)).normalizeSum * phraseDuration).do { |duration|
			'duration: '.post;
			(duration).postln;

			s.bind {
				// Synth(\mspSuperhex, [sustain: duration * rrand(0.2, 0.8), amp: 0.008, freq: ((~root * rrand(1.099, 1.1))).midicps])
				// Synth(\mspLaser, [amp: 0.1, sustain: phraseDuration, freq: 150])
				Synth(\pluck, [amp: 0.1, freq: ~root * 2])
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
