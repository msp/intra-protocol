
// If these change, re-run the SynthDefs!
(
~numPartials = 280;
~maxScopeChannels = 80;
~envSteps = 8;
~numPartials.dump;
~synths = [];
~seq;
~vizBus.free();
~audioBus = 0;
// ~audioBus.free();
~vizBus = Bus.audio(s, ~maxScopeChannels);
// ~audioBus = Bus.audio(s, ~numPartials);
// ~vizBus.dump;
// ~audioBus.dump;
~scope;

~factor = { arg numPartials;
	var factor = (numPartials / ~maxScopeChannels).ceil.max(1).asInteger;
	("-MSP FACTOR ("+factor+")-------------------------------- ").postln;
	factor;
};

// ~vizBus.dump;
// ~audioBus.dump;


// SCOPE ///////////////////////////////////////////////////////////

~scope = ~vizBus.scope;
~scope.index = ~vizBus.index;
~scope.numChannels = 30;
~scope.zoom =  1.4;
~scope.yZoom = 1.0;
~scope.zoom = 0.5;
~scope.style = 0;



// SYNTHDEF ////////////////////////////////////////////////////////
SynthDef(\mspAdder, {
	| out = 0, vizOut = 5, envTimeScale = 1, mixerWhite = 0.01, mixerSub = 3, envDuration = 1, scopeStyle = 0 |
	var snd, freqMult, n, env, env2, envShape, vizSig;
	var numPartials = ~numPartials;
	var envSteps = ~envSteps;
	var factor = 2;
	var defaultPairs = { { rrand(0.01, 1) } ! 2 } ! envSteps;

	var freqs = NamedControl.kr(\freqs, {55}!numPartials);
	var levels = NamedControl.kr(\levels, {0.1}!numPartials);
	var pairs = NamedControl.kr(\pairs, defaultPairs);
	var pairs2 = NamedControl.kr(\pairs2, defaultPairs);

	n = (1..freqs.size);
	// Window.closeAll;

	"-MSP freqs ------------------------------------ ".postln;
	freqs.size.postln;
	// freqs.postln;
	// freqs.collect{|x,i| "freq:".post; i.post; "-".post; x.poll; };

	envShape = Env.pairs(pairs, \exp);
	// envShape = Env.perc(0.05, 3, 1, -4);
	env =  EnvGen.ar(envShape, timeScale: envTimeScale, levelScale: 1.0,doneAction: Done.freeSelf);

	envShape = Env.pairs(pairs2, \exp);
	// envShape = Env.perc(0.05, 3, 1, -4);
	env2 = EnvGen.kr(envShape, timeScale: envTimeScale, levelScale: 0.5, doneAction: Done.freeSelf);

	//
	// SHAPING /////////////////////////////////////////////////////
	// freqs.collectInPlace{|x,i| x * env2  };
	// levels = levels * (1 - log2(n * Line.kr(\comb1.kr(1), \comb2.kr(4), envTimeScale)).sin.abs);
	// levels = levels * (1 - log2(n * MouseX.kr(1,16) + MouseY.kr(1,100)).sin.abs);
	levels = levels * (1 - log2(n * env2).sin.abs);
	// levels = levels * env2;

	snd = SinOsc.ar(freqs, 0.0, levels);

	snd = snd.addFirst(
		Resonz.ar(
			WhiteNoise.ar(1.5),
			env2 * 20000,
			0.8,
		mixerWhite)
	);
	// snd = snd.addFirst(
	// 	SinOsc.ar(50, 0, mixerSub) * env;
	// );

	// SCOPE TESTS
	// SinOsc.ar(freqs[0] + freqs[1], 0.0, levels[0] + levels[1]).scope;

	// Grab a subset of partials for the viz bus
	// (we only want to send a max of 80ch to the scope, seems to bork with more)
	factor = ~factor.value(freqs.size);

	// I think we want diff partials depending on the viz type we use
	// although actually, maybe it doesn't actually matter!
	vizSig = Select.ar(
		scopeStyle,
		[
			snd[1, factor..],
			[snd[2], snd[3]]
		]
	);

	Out.ar(vizOut, vizSig);

	// stop pops at the end of the sound
	snd = snd * EnvGen.ar(
		// Env.cutoff(1, 0.95),
		// Env.asr(0.3, 0.9, 1.0),
		// Env.sine(envDuration),
		Env.linen(0.001, (envDuration - 1.0), 1.0, 0.95),
		// Env.linen(0.001, 0.2, 0.1, 0.95, \lin),
		// timeScale: envDuration,
		doneAction: Done.freeSelf
	);

	// stereo out version
	// either..
	// snd = snd.sum ! 2;
	// snd = snd ! 2;
    // or
	// stereo spread
	// snd = snd[0,2..].sum + ([-1,1] * snd[1,3..].sum);

	snd = snd * -30.dbamp;
	// These cause pops it seems :/
	// snd = FreeVerb.ar(snd, 0.33, 0.7, 0.4, 1);
	// snd = Limiter.ar(snd);
	// snd = LeakDC.ar(snd);
	Out.ar(out, snd.sum ! 2);
}).add;
)



