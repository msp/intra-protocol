(
var wtPaths, waveTable, waveFile, envirVarName;

wtPaths = [
	"/System/Volumes/Data/Dropbox-spatial/Dropbox/spatial/music/AudioSources/SingleCycleWTs/Basic_Mini.wav",
	"/System/Volumes/Data/Dropbox-spatial/Dropbox/spatial/music/AudioSources/SingleCycleWTs/wubsquare8.wav"

];

"Wavetable Buffers loaded:".postln;

wtPaths.do { |file|
	file.postln;
	waveFile = SoundFile.openRead(file);

	waveFile.postln;
	waveTable = FloatArray.newClear(waveFile.numFrames);
	waveFile.readData(waveTable);
	waveTable = waveTable.as(Signal).asWavetable;
	{waveTable.plot}.defer; // uncomment if you want to plot each wavetable

	envirVarName = ("wt_" ++ PathName(file.standardizePath).fileNameWithoutExtension.replace(" ","_")).asSymbol;
    ("~" ++ envirVarName).postln;
	envirVarName.envirPut(Buffer.loadCollection(s, waveTable));
    waveFile.close;
};
)

~wt_Basic_Mini.bufnum; // should post some number
~wt_wubsquare8.bufnum; // should post some number

(
SynthDef(\autobot, {
	arg wtBufA, wtBufB,
	out = 0, gate = 1, amp = 0.3, freq = 440,
	attack = 0.1 , decay = 0.2, sustain = 0.3, release = 0.5;

	var sig, osca, oscb, sub, env, mix;

	env = Env.adsr(attack, decay, sustain, release);
	env = EnvGen.ar(env, gate, timeScale: 0.6, doneAction: 2);

	osca = Osc.ar(wtBufA, freq);
	oscb = Osc.ar(wtBufB, freq);
	sub = Pulse.ar(freq/2);

	sig = osca + oscb + sub;
	sig = sig * env * amp;

	sig = LPF.ar(sig, LinLin.ar(env, 0, 1, 70, 2000));
	sig = Limiter.ar(sig, 0.8);

	OffsetOut.ar(out, Pan2.ar(sig));
}).add;
)

(1..16) * 50 + 100

(
Pbind(
	\instrument, \autobot,
	\dur, Pseq([1, 1, 2, 1]/5, inf),
	// \attack, Pseq([0.1, 0.9, 0.2, 0.3], inf),
	\attack, Pseq([0.3, 0.1], inf),
	\release, Pseq([1, 0.3, 0.7], inf),
	#[freq, sustain], Ptuple([
		Pseq((1..6) * 50 + 50, inf),
		// Pseq([500], 4),
		Pseq([1/10, 1, 1/7, 2/30], inf)
	]).trace,
	\wtBufA, ~wt_Basic_Mini.bufnum,
	\wtBufB, ~wt_wubsquare8.bufnum
).play;
)
