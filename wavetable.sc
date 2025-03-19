(
var wtPaths, waveTable, waveFile, envirVarName, numSamples;

wtPaths = [
	"/System/Volumes/Data/Dropbox-spatial/Dropbox/spatial/music/AudioSources/SingleCycleWTs/Basic_Mini.wav",
	"/System/Volumes/Data/Dropbox-spatial/Dropbox/spatial/music/AudioSources/SingleCycleWTs/wubsquare8.wav",
	"/System/Volumes/Data/Dropbox-spatial/Dropbox/spatial/music/AudioSources/SingleCycleWTs/Echo\ Sound\ Works\ Core\ Tables/Vocal/ESW\ Vocal\ -\ 80s\ 01.wav",
	"/System/Volumes/Data/Dropbox-spatial/Dropbox/spatial/music/AudioSources/SingleCycleWTs/Echo\ Sound\ Works\ Core\ Tables/Metallic/ESW\ Metallic\ -\ Vocal\ Bell.wav"
];

"Wavetable Buffers loaded:".postln;

wtPaths.do { |file|
	"loaded file:".postln;
	file.postln;

	waveFile = SoundFile.openRead(file);
	"opened waveFile:".postln;
	waveFile.numFrames.postln;

	// Pick a power of two for wavetable size
	numSamples = 2048.min(waveFile.numFrames); // don't try to read more than available
	waveTable = FloatArray.newClear(numSamples);

	"about to read in WaveTable".postln;
	waveFile.readData(waveTable, numSamples); // read only numSamples frames
	"about to create WaveTable".postln;
	waveTable = waveTable.as(Signal).asWavetable;
	"about to plot WaveTable".postln;
	{waveTable.plot}.defer;

	envirVarName = ("wt_" ++ PathName(file.standardizePath).fileNameWithoutExtension.replace(" ","_").replace("-","_")).asSymbol;
	("~" ++ envirVarName).postln;
	envirVarName.envirPut(Buffer.loadCollection(s, waveTable));
	waveFile.close;
};



)

~wt_Basic_Mini.bufnum; // should post some number
~wt_wubsquare8.bufnum;

~wt_ESW_Vocal___80s_01.bufnum;
~wt_ESW_Metallic___Vocal_Bell.bufnum;

(
SynthDef(\autobot, {
	arg wtBufA, wtBufB,
	out = 0, gate = 1, amp = 0.3, freq = 440,
	attack = 0.1 , decay = 0.2, sustain = 0.8, release = 0.5, timeScale = 1;

	var sig, osca, oscb, sub, env, mix;

	env = Env.adsr(attack, decay, sustain, release);
	env = EnvGen.ar(env, gate, timeScale: timeScale, doneAction: 2);

	osca = Osc.ar(wtBufA, freq);
	oscb = Osc.ar(wtBufB, freq);
	sub = Pulse.ar(freq/2);

	sig = osca + oscb + sub;
	// sig = osca + oscb;
	sig = sig * env * amp;

	sig = LPF.ar(sig, LinLin.ar(env, 0, 1, 70, 2000));
	sig = Limiter.ar(sig, 0.8);

	// OffsetOut.ar(out, Pan2.ar(sig));
	OffsetOut.ar(out, sig);
}).add;
)

(1..16) * 50 + 100

(
Pbind(
	\instrument, \autobot,
	// \dur, Pseq([1, 1, 2, 1]/5, inf),
	\dur, Prand(
		[0.1, 0.3, 0.7, 1, 1.5, 2, 3, 5, 10, Rest(3)] /
		// [1, Rest(3)] /
		// 2,
		5,
		// Pseq([2, 5, 10, 2], inf),
		inf),
	// \attack, Pseq([0.1, 0.9, 0.2, 0.3], inf),
	// \attack, Pseq([0.3, 0.1, 0.8], inf),
	// \release, Pseq([1, 0.3, 0.7], inf),
	// \release, Pseq([1, 5, 3], inf),
	\timeScale, Prand([0.3, 1, 2, 5, 10, 20], inf),
	#[wtBufA, wtBufB, freq, attack, sustain, release], Ptuple([
		// Buffer A
		Prand([
			~wt_ESW_Metallic___Vocal_Bell.bufnum,
			~wt_Basic_Mini.bufnum,
			~wt_wubsquare8.bufnum
		], inf),
		// Buffer B
		Prand([
			~wt_ESW_Metallic___Vocal_Bell.bufnum,
			~wt_Basic_Mini.bufnum,
			~wt_wubsquare8.bufnum
		], inf),
		// Frequency
		// Pseq((1..6) * 50 + 50, inf),
		Pseq(
			(1..6) *
			[Pexprand(0.18, 25).collect { |val| val.round(0.25) }]
			+ [Pexprand(10, 500).collect { |val| val.round(0.25) }],
		    // + 10,
			inf
		),
		// Attack
		Prand([0.3, 0.1, 0.8], inf),
		// Sustain
		Pseq([1/10, 1, 1/7, 2/30], inf).collect { |val| val.round(0.01) },
		// Release
		Prand([1, 5, 3], inf),

	]).trace,
	// \wtBufA, ~wt_Basic_Mini.bufnum,
	// \wtBufA, ~wt_ESW_Metallic___Vocal_Bell.bufnum,
	// \wtBufA, Prand([~wt_ESW_Metallic___Vocal_Bell.bufnum, ~wt_Basic_Mini.bufnum, ~wt_wubsquare8.bufnum], inf).trace,
	// \wtBufB, ~wt_wubsquare8.bufnum
	// \wtBufB, ~wt_ESW_Vocal___80s_01.bufnum,
	\out, Pseq([0, 1], inf),
).play;
)
