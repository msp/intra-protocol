(

var lfo;
// ~rbus = Bus.audio(s,2);
// ~reverbGroup = Group.new;

// Scale.directory
~scale = Scale.ritusen;

//// tester ////////////////////////////////////////////////////////////////////
SynthDef(\simpleSine,
    {|freq = 80, out| Out.ar(out, SinOsc.ar(freq, 0, 0.2)) }
).add;


//// intra protocaol ///////////////////////////////////////////////////////////

lfo = { |rate = 1|
	Select.ar(ToggleFF.ar(Dust.ar(rate)), [
		LFNoise2.ar(rate),
		TRand.ar(-1, 1, Dust.ar(rate * 3)),
	]);
};

SynthDef(\kick, {
    var snd, duration, velocity;
    duration = \duration.kr(1.0);
    velocity = duration.linlin(1, 0, 1, 0);
    snd = SinOsc.ar(
        60
        * (1 + (8 * Env.perc(0, 0.001).ar * velocity))
        * (1 + (8 * Env.perc(0, 0.03).ar * velocity))
        * (1 + (0.5 * Env.perc(0, 0.3).ar * velocity))
        * ([1, -1] * 0.1).midiratio
    );
    snd = snd * (1 + (Env.perc(0, 0.03).ar * velocity));
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 8321, 0.3) * Env.perc(0.001, 0.003).ar * 1.dbamp * velocity);
    snd = snd.tanh;
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3321, 0.3) * Env.perc(0.03, 0.05).ar * -10.dbamp * velocity);
    snd = snd * velocity.sqrt;
    snd = snd + GVerb.ar(snd.sum * -30.dbamp, 30, 1);
    snd = snd * Env.perc(0.001, duration.min(0.6)).ar(Done.freeSelf);
    snd = snd * -16.dbamp;
    Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\snare, {
    var snd;
    snd = SinOsc.ar(
        260
        * (1 + (3 * Env.perc(0.001, 0.04, curve: -6).ar))
        * [1, 4.3, 8.4]
    );
    snd = snd * [0, -8, -12].dbamp;
    snd = snd * Env.perc(0.001, [0.3, 0.1, 0.03]).ar;
    snd = snd.sum;
    snd = snd + (BPF.ar(WhiteNoise.ar, 2310, 0.25) * Env.perc(0.03, 0.3).ar * 12.dbamp);
    snd = snd + (BPF.ar(WhiteNoise.ar, 7310, 0.3) * Env.perc(0.003, 0.04).ar * 8.dbamp);
    snd = snd.tanh;
    snd = snd + PitchShift.ar(snd, 0.06, 2.4);
    snd = snd + PitchShift.ar(snd * -5.dbamp, 0.08, 1.3);
    snd = snd * Env.linen(0.001, 0.23, 0.01).ar(Done.freeSelf);
    snd = snd * -7.dbamp;
    snd = snd ! 2;
    Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\weirdBass, {
	var snd, rate, duration;
	duration = \duration.kr(1);
	rate = 1;
	snd = SinOsc.ar(90 * (2 ** lfo.(rate)));
	snd = (snd * lfo.(rate).linlin(-1, 1, 0, 20).lag(0.05).dbamp).fold2;
	snd = RLPF.ar(snd, lfo.(rate).lag(0.01).linexp(-1, 1, 1000, 2000), 0.3);
	snd = PitchShift.ar(snd, ExpRand(0.01, 0.04), XLine.kr(ExpRand(0.5, 1), ExpRand(0.5, 1), duration)) * 20.dbamp;
	snd = BLowShelf.ar(snd, 500, 0.3, 5);
	snd = Limiter.ar(snd);
	snd = (snd * 10.dbamp).fold2;
	snd = snd + (GVerb.ar(snd, ExpRand(1, 10), ExpRand(1, 3), maxroomsize: 10) * -20.dbamp);
	snd = snd + (PitchShift.ar(snd, ExpRand(0.001, 0.04), XLine.kr(ExpRand(0.5, 2), ExpRand(0.5, 2), duration)) * 6.dbamp);
	snd = snd * Env.asr(0.3, 1, 0.01, curve: 4).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -15.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = Saw.ar(freq);
	5.do {
		snd = snd + DelayC.ar(snd, 0.2, LFNoise2.kr(3 ! 2).linlin(-1, 1, 0, 1) * 2e-3);
	};
	snd = (SinOsc.ar(freq) * 3).tanh + (HPF.ar(snd, 400) * -10.dbamp);
	snd = snd * -10.dbamp;
	snd = snd * Env.asr(0.01, 1, 0.03, curve: 4).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\acid, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(440);
	snd = Saw.ar(freq);
	snd = Latch.ar(snd, Impulse.ar(ExpRand(3e3, 16e3)));
	snd = MoogFF.ar(snd, (ExpRand(100, 2000) * (Env.perc(0.001, Rand(0.1, 0.3)).ar * Rand(10, 30)).midiratio * [1, 1.5]).min(16e3), 3).sum;
	snd = (snd * 3).fold2;
	snd = snd * Env.asr(0.001, 1, 0.03).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -20.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\pad, {
	var snd, env, pitchEnv;
	env = Env.perc(0.03, 0.5).ar(Done.none, \duck.tr);
	snd = Saw.ar(\freq.kr(440) * (LFNoise2.kr(3 ! 8) * 0.1).midiratio);
	snd = Splay.ar(snd);
	snd = MoogFF.ar(snd, LFNoise2.kr(3).linexp(-1, 1, 500, 1000) * (env.neg * 8).midiratio, 1.5) * 10.dbamp;
	// snd = Latch.ar(snd, Impulse.ar(LFNoise2.kr(3).linexp(-1, 1, 4e3, 16e3)));
	snd = snd * (1 - env);
	snd = snd * Env.asr(0.1, 1, 0.1).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(1);
	snd = snd * -38.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass3, {
	var snd, env, freq;
	env = Env.perc(0.03, 0.6).ar(Done.none, \duck.tr);
	freq = \freq.kr(440);
	snd = Pulse.ar(freq * [-0.1, 0.1].midiratio, 0.5);
	snd = MoogFF.ar(snd, 1000 * (LFNoise2.kr(1) * 10).midiratio, 1) * 10.dbamp;
	snd = SinOsc.ar(freq) + HPF.ar(snd.tanh, 300);
	snd = snd * (1 - env);
	snd = snd * Env.asr(0.1, 1, 0.1).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(1);
	snd = snd * -25.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd, trigger, probability;
	var trigPitchShift, pitchShiftProbability;
	var trigFilter, filterProbability;
	var trigReverb, reverbProbability;
	var trigComb1, comb1Probability;
	var trigComb2, comb2Probability;
	var trigLatch, latchProbability;
	snd = In.ar(\out.kr(0), 2);
	snd = snd * 20.dbamp;
	trigger = K2A.ar(\trigger.tr);
	// trigs
	trigPitchShift = TRand.ar(0, 1, trigger);
	trigFilter = TRand.ar(0, 1, trigger);
	trigReverb = TRand.ar(0, 1, trigger);
	trigComb1 = TRand.ar(0, 1, trigger);
	trigComb2 = TRand.ar(0, 1, trigger);
	trigLatch = TRand.ar(0, 1, trigger);
	// probs
	probability = 0.03;
	// probability = 0.4;
	pitchShiftProbability = 0.3;
	// pitchShiftProbability = 0;
	filterProbability = 0.2;
	// filterProbability = 0;
	reverbProbability = probability;
	comb1Probability = probability;
	comb2Probability = probability;
	latchProbability = probability;

	3.do {

		snd = Select.ar((trigReverb < reverbProbability).lag(0.01), [snd, GVerb.ar(snd.sum, Rand(1, 3), Rand(1, 3)) * -5.dbamp]);
		snd = LeakDC.ar(snd);
		snd = Select.ar((trigComb1 < comb1Probability).lag(0.01), [snd, CombC.ar(snd, 0.2, 1 / lfo.(3).lag(0.01).linexp(-1, 1, 10, 300), 0.1)]);
		snd = Select.ar((trigComb2 < comb2Probability).lag(0.01), [snd, CombC.ar(snd, 0.2, 1 / lfo.(3).lag(0.01).linexp(-1, 1, 10, 3000), 0.2)]);
		snd = Select.ar((trigLatch < latchProbability).lag(0.01), [snd, Latch.ar(snd, Impulse.ar(lfo.(1).linexp(-1, 1, 100, 16e3)))]);
	};

	SendReply.kr(\trigger.tr, '/fxTrigPitchShift', trigPitchShift < pitchShiftProbability);
	SendReply.kr(\trigger.tr, '/fxTrigFilter', trigFilter < filterProbability);
	SendReply.kr(\trigger.tr, '/fxTrigReverb', trigReverb < reverbProbability);
	SendReply.kr(\trigger.tr, '/fxTrigComb1', trigComb1 < comb1Probability);
	SendReply.kr(\trigger.tr, '/fxTrigComb2', trigComb2 < comb1Probability);
	SendReply.kr(\trigger.tr, '/fxTrigLatch', trigLatch < latchProbability);

	snd = Select.ar(
		(trigPitchShift < pitchShiftProbability).lag(0.01),
		[
			snd,
			snd + PitchShift.ar(snd, 0.03, lfo.(2).linexp(-1, 1, 1, 4))
		]
	);
	snd = Select.ar(
		(trigFilter < filterProbability).lag(0.01),
		[
			snd,
			RLPF.ar([snd], [150, 200, 300] * (Amplitude.ar(snd.sum, 0.01, 0.1).linlin(0, 60, 0, 20).lag(0.01) * [1, -0.6, 0.5]).midiratio, 0.3).sum
//			RLPF.ar([snd], [1200, 3200, 5200] * (Amplitude.ar(snd.sum, 0.01, 0.1).linlin(0, 60, 0, 20).lag(0.01) * [1, -0.6, 0.5]).midiratio, 0.3).sum
		]
	);
	snd = BHiShelf.ar(snd, 3000, 0.3, -3);
	snd = BLowShelf.ar(snd, 300, 0.3, 5);
	snd = Limiter.ar(snd);
	snd = snd * -5.dbamp;
	ReplaceOut.ar(\out.kr(0), snd);
}).add;

//// gamaBell //////////////////////////////////////////////////////////////////
SynthDef(\gamaBell,
    {|out = 0, freqs = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        rings = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], atk = 5, sus = 8, rel = 5, pan = 0, amp = 0.5|
        var e = EnvGen.kr(Env.linen(atk, sus, rel, 1, 4), doneAction: Done.freeSelf);
        var i = Decay.ar(Impulse.ar(Rand(0.8, 2.2)), 0.03, ClipNoise.ar(0.01));
        var z = Klank.ar(
            `[freqs, nil, rings],     // specs
            i                    // input
        );
        var sound = z*e * amp;
        // Out.ar(out, Pan2.ar(z*e, pan));
        OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan))
}).add;


SynthDef(\hauntedSine, {
    arg freq=440, atk=0.005, rel=0.3, sustain=1, amp=1, pan=0, out=0;
    var sig, env;
    sig = SinOsc.ar(freq);
    env = EnvGen.kr(Env.new([0,1,0], [atk, rel], [1 -1]), timeScale:sustain, doneAction:2);
    sig = Pan2.ar(sig, pan, amp);
    sig = sig * env;
    // Out.ar(out, sig);
    OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan))
}).add;

SynthDef(\mspDynKlank, { arg out=0, freq = 440, pan = 0.5, sustain = 1;
    var klank, harm, amp, ring;

    // harmonics
    harm = Control.names(\harm).kr(Array.series(4, 1, 0.5));
    // amplitudes
    amp = Control.names(\amp).kr(Array.rand(4, 0.04, 0.08));
    // ring times
	// ring = Control.names(\ring).kr(Array.fill(4, 3));
    ring = Control.names(\ring).kr(Array.rand(4, 1, 3));
    klank = DynKlank.ar(`[harm, amp, ring], {ClipNoise.ar(0.003)}.dup, freq);

	klank = klank * EnvGen.ar(Env.sine, timeScale: sustain, doneAction: Done.freeSelf);

	klank = GVerb.ar(klank, roomsize: 80, revtime: 4.25, damping: 0.11, inputbw: 0.69, drylevel: -8, earlyreflevel: -9, taillevel: -11) * -35.dbamp;


    OffsetOut.ar(out, DirtPan.ar(klank, ~dirt.numChannels, pan))
}).add;

////////////////////////////////////////////////////////////////////////////////
//
// AMBIENT
//
//
// Based up Eli Fieldsteel's excellent wavetable synthesis lessons:
// https://www.youtube.com/watch?v=8EK9sq_9gFI
//
////////////////////////////////////////////////////////////////////////////////

//10 wavetables with increasing complexity
~wt_sig = 10.collect({
    arg i;

    //random number of envelope segments
    var numSegs = i.linexp(0,9,4,40).round;

    Env(
        //env always begins and ends with zero
        //inner points are random from -1.0 to 1.0
        [0]++({1.0.rand}.dup(numSegs-1) * [1,-1]).scramble++[0],

        //greater segment duration variety in higher-index wavetables
        {exprand(1,i.linexp(0,9,1,50))}.dup(numSegs),

        //low-index wavetables tend to be sinusoidal
        //high index wavetables tend to have sharp angles and corners
        {[\sine,0,exprand(1,20) * [1,-1].choose].wchoose([9-i,3,i].normalizeSum)}.dup(numSegs)
    ).asSignal(1024);
});

//load into 10 buffers in wavetable format
~wt_buf = Buffer.allocConsecutive(10, s, 2048, 1, {
    arg buf, index;
    buf.setnMsg(0, ~wt_sig[index].asWavetable);
});

SynthDef(\mspWaves, {
    arg buf=0, freq=200, detune=0.2,
    amp=0.2, pan=0, out=0, rout=0, rsend=(-20),
    atk=0.01, sustain=1, rel=0.01, c0=1, c1=(-1),
	// mAttackTime = 0.01,
	// mDecayTime = 0.2,
	// mDecayLevel = 0.5,
	// mHoldTime = 0.95,
	// mHoldLevel = 0.5,
	// mReleaseTime = 1;
	foo = 1;

    var sig, envShape, env, detuneCtrl;

    env = EnvGen.ar(
        Env([0,1,1,0],[atk,sustain,rel],[c0,0,c1]),
        // timeScale:sus, //MSP
        doneAction:2
    );

    // These must be our universal shape defaults for use with Processing
	// envShape = Env.pairs([
	// 	[0,0],
	// 	[mAttackTime,1],
	// 	[mDecayTime, mDecayLevel],
	// 	[mHoldTime,mHoldLevel],
	// [mReleaseTime,0]], -1);
	//
	// env = EnvGen.kr(envShape, timeScale:sustain, doneAction:2);


    //array of eight Oscs with uniquely detune frequencies
    //and unique initial phase offsets
    detuneCtrl = LFNoise1.kr(0.1!8).bipolar(detune).midiratio;
	sig = Osc.ar(buf, freq * detuneCtrl, {Rand(0,2pi)}!8);
	// sig = Osc.ar(~wt_buf[5], freq * detuneCtrl, {Rand(0,2pi)}!8); // MSP

    sig = Splay.ar(sig); //spread 8 signals over stereo field
    sig = LeakDC.ar(sig); //remove DC bias
	sig = Balance2.ar(sig[0], sig[1], pan, amp); //L/R balance (pan)
	sig = Pan2.ar(sig, pan);
    sig = sig * env;

	Out.ar(out, sig!2 * -15.dbamp);
	// Out.ar(rout, sig * rsend.dbamp); //"post-fader" send to reverb
	// OffsetOut.ar(out, DirtPan.ar(sig!2, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\reverb, {
    arg in=0, out=0, dec=4, lpf=1500;
    var sig;
    sig = In.ar(in, 2).sum;
    sig = DelayN.ar(sig, 0.03, 0.03);
    sig = CombN.ar(sig, 0.1, {Rand(0.01,0.099)}!32, dec);
    sig = SplayAz.ar(2, sig);
    sig = LPF.ar(sig, lpf);
    5.do{sig = AllpassN.ar(sig, 0.1, {Rand(0.01,0.099)}!2, 3)};
    sig = LPF.ar(sig, lpf);
    sig = LeakDC.ar(sig);
    Out.ar(out, sig);
}).add;

SynthDef(\mspVibSawPlucker, {
    arg out, sustain = 1, freq = 440, speed = 1, begin=0, end=1, pan, accelerate, offset,
    mAttackTime = 0.01,
    mDecayTime = 0.2,
    mDecayLevel = 0.5,
    mHoldTime = 0.95,
    mHoldLevel = 0.5,
    mReleaseTime = 1;

    var envShape = Env.pairs([
        [0,0],
        [mAttackTime,1],
        [mDecayTime, mDecayLevel],
        [mHoldTime,mHoldLevel],
        [mReleaseTime,0]], -1);


    var line = Line.ar(begin, end, sustain, doneAction:2);
    // var env = Env([0, 1, 0.333, 0],[900, 70, 1000]);
    // var envGen = IEnvGen.ar(env, line*env.times.sum*abs(speed));
    var envGen = IEnvGen.ar(envShape, line*envShape.times.sum*abs(speed));
    var sound = Saw.ar(freq*abs(speed)+(SinOsc.ar(10)*(freq*0.06)*line*line));
    sound = RLPF.ar(sound, Clip.ar(envGen*freq*48, 0, 20000), 0.5);
    Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, envGen));
}).add;


// A vaguely 808-ish kick drum
// "n" controls the chirp frequency, "sustain" the overall timescale, "rate" the filter sweep speed,
// and "voice" the sinewave feedback

SynthDef(\super808, {|out, rate=1, sustain=1, pan, voice=0, n |
    var env, sound, freq;
    n = ((n>0)*n) + ((n<1)*3);
    freq = (n*10).midicps;
    env = EnvGen.ar(Env.linen(0.01, 0, 1, 1, -3), timeScale:sustain, doneAction:2);
    sound = LPF.ar(SinOscFB.ar(XLine.ar(freq.expexp(10, 2000, 1000, 8000), freq, 0.025/rate), voice), 9000);
    OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;


/*(
// test-er the-er laser synth-er
var sustain = 1;
var accelerate = 0;
var decay = 0.4;
var voice = 1;
var freq = 440;
var att=0.01;

var freqlist =[1.000,  2.081,  3.414,  3.893,  4.995,  5.954,  6.819,  8.280,  8.722,  8.882, 10.868, 11.180, 11.754,
13.710, 13.715, 15.057, 15.484, 16.469, 16.817, 18.628]**1.0;

var tscale = 100.0 / freq / (freqlist**(2-clip(decay,0,2)));
var ascale =freqlist**clip(voice,0,4);

// "--------------------------------------".postln;
// tscale.postln;
// ascale.postln;


)*/

//
// based on supergong!
//

SynthDef(\mspLaser,{
    arg out, sustain=1, pan, accelerate, freq, voice=0,
    mAttackTime = 0.01,
    mDecayTime = 1,
    mDecayLevel = 0.5,
    // mHoldTime = 0.95,
    // mHoldLevel = 0.5,
    mReleaseTime = 1;

    // lowest modes for clamped circular plate

    var freqlist =[1.000,  2.081,  3.414,  3.893,  4.995,  5.954,  6.819,  8.280,  8.722,  8.882, 10.868, 11.180, 11.754,
        13.710, 13.715, 15.057, 15.484, 16.469, 16.817, 18.628]**1.0;

    var tscale = 100.0 / freq / (freqlist**(2-clip(mDecayTime,0,2)));

    var ascale =freqlist**clip(voice,0,4);

    var partials = freqlist.size;
    // var partials =8;
    // var partials = numPartials;

    var sound = Mix.arFill(partials, {
        arg i;

        // var envShape = Env.pairs([
        //     [0,0],
        //     [mAttackTime*tscale[i],1],
        //     [mDecayTime, mDecayLevel],
        //     [mHoldTime,mHoldLevel*ascale[i]],
        // [mReleaseTime*tscale[i],0]], -1);

        var envShape = Env.perc(mAttackTime*tscale[i], (mReleaseTime/2)*tscale[i], 0.2*ascale[i] );

        // EnvGen.ar(Env.perc(att*tscale[i], 0.5*tscale[i], 0.2*ascale[i] ), timeScale:sustain*5)
        // * SinOsc.ar(freq * freqlist[i] * Line.kr(1, 1+accelerate, sustain))

        EnvGen.ar(envShape, timeScale:sustain*5)
        * SinOsc.ar(freq * freqlist[i] * Line.kr(1, 1+accelerate, sustain))
    });

    OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan))
}).add;

// orig!
SynthDef(\mspsupergong,{|out, sustain=1, pan, accelerate, freq=440, voice=0, decay=1, att=0.01 |
    // lowest modes for clamped circular plate
    var freqlist =[1.000,  2.081,  3.414,  3.893,  4.995,  5.954,  6.819,  8.280,  8.722,  8.882, 10.868, 11.180, 11.754,
        13.710, 13.715, 15.057, 15.484, 16.469, 16.817, 18.628]**1.0;
    var tscale = 100.0 / freq / (freqlist**(2-clip(decay,0,2)));
    var ascale =freqlist**clip(voice,0,4);


    var sound = Mix.arFill(15, {arg i; EnvGen.ar(Env.perc(att*tscale[i], 0.5*tscale[i], 0.2*ascale[i] ), timeScale:sustain*5)
        * SinOsc.ar(freq * freqlist[i] * Line.kr(1, 1+accelerate, sustain))});


    OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan))
}).add;



SynthDef(\mspplucklead, {
    |out, sustain = 1, freq = 440, speed = 1, begin=0, end=1, pan, offset|

    var line = Line.ar(begin, end, sustain, doneAction:2);
    var env = Env([0, 1, 0.333, 0],[5, 70, 1000]);

    var envGen = IEnvGen.ar(env, line*env.times.sum*abs(speed));
    // var envGen = EnvGen.ar(Env.adsr);
    var speedFreq = freq*abs(speed);

    var pulseLfo = SinOsc.ar(Rand(-1,1));

    var sound = Pulse.ar([speedFreq*Rand(0.99,1.01)*2,speedFreq*Rand(0.99,1.01)*2]);
    // sound = RLPF.ar(sound, (20000*(envGen**2.8))+DC.ar(10), 0.5);
    // sound = RLPF.ar(sound, (2500*(envGen**4.8))+DC.ar(10), 0.2);


    // var filterEnv = (2500*(envGen**4.8))+DC.ar(10);
    var filterEnv = XLine.kr(2500, 10, 0.3, 1);
    sound = RLPF.ar(sound, filterEnv, 0.5);
    // sound = Resonz.ar(sound, filterEnv, 2, 3);

    Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, envGen));
}).add;


SynthDef(\msp808, {|out, speed=1, sustain=1, pan, voice=0, att = 0.01, n |
    var env, sound, kick, synth, freq, freqCurve;
    n = ((n>0)*n) + ((n<1)*3);
    freq = (n*10).midicps;

    env = EnvGen.ar(Env.linen(att, 0, 1, 1, -3), timeScale:sustain, doneAction:2);

    // sound = LPF.ar(SinOscFB.ar(XLine.ar(freq.expexp(10, 2000, 1000, 8000), freq, 0.025/speed), voice), 9000);


    freqCurve = XLine.ar(freq.expexp(10, 2000, 1000, 8000), freq, 0.025/speed);

    kick = LPF.ar(SinOscFB.ar(freqCurve, voice), 9000);

    // synth = DynKlank.ar(`[[800, 1071, 1353, 3723], nil, [0.1, 0.1, 0.1, 1]], PinkNoise.ar([0.007, 0.007])) * 0.6;

    // sound = Mix.new([ kick, synth ]);
    sound = kick;
	sound = sound * -16.dbamp;

    OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;

// Hi-hat using Rumble-San's implementation as a starting point
// http://blog.rumblesan.com/post/53271713518/drum-sounds-in-supercollider-part-1
// using "n" in a weird way to provide some variation on the frequency
// "sustain" affects the overall envelope rate, "accelerate" sweeps the filter
(
SynthDef(\mspSuperHat, {|out, sustain=1, pan, accelerate, n |
    var env, sound, accel, freq;
    env = EnvGen.ar(Env.linen(0.01, 0, 0.3, 1, -3), timeScale:sustain, doneAction:2);
    accel = Line.kr(1, 1+accelerate, 0.2*sustain);
    freq = 2000*accel*(n/5 + 1).wrap(0.5,2);
    sound = HPF.ar(LPF.ar(WhiteNoise.ar(1), 3*freq), freq);
    OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add
);

SynthDef(\mspSuperzow, {
    arg out,
    pan,
    accelerate,
    freq = 261,
    sustain = 2,
    // mAttackTime = 0.01,
    mAttackTime = 0.3,
    // mDecayTime = 0.2,
    mDecayTime = 0.1,
    mDecayLevel = 0.5,
    // mHoldTime = 0.95,
    mHoldTime = 0.2,
    mHoldLevel = 0.5,
    mReleaseTime = 1,
    slide=1,
    detune=1;


    // These must be our universal shape defaults for use with Processing
    var envShape = Env.pairs([
        [0,0],
        [mAttackTime,1],
        [mDecayTime, mDecayLevel],
        [mHoldTime,mHoldLevel],
        [mReleaseTime,0]], -1);

    var env = EnvGen.kr(envShape, timeScale:sustain, doneAction:2);
    // var env = EnvGen.ar(Env.pairs([[0,0],[0.07,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -1), timeScale:sustain, doneAction:2);

    // var env = EnvGen.kr(Env.adsr(mAttackTime, mDecayTime, mSustainLevel, mReleaseTime), timeScale:sustain, doneAction:2);

    // var env = EnvGen.ar(Env.perc, timeScale:sustain, doneAction:2);

    var basefreq = freq * Line.kr(1, 1+accelerate, sustain);

    var sound = VarSaw.ar(basefreq, 0, Line.ar(0,0.5,sustain*20/slide));
    var sound2 = VarSaw.ar(basefreq*(detune/100+1), 0, Line.ar(0,0.5,sustain*20/slide));
    var sound3 = VarSaw.ar(basefreq*(-1*detune/100+1), 0, Line.ar(0,0.5,sustain*20/slide));
    sound = sound - DelayN.ar(sound2,0.2, Line.ar(0,1,5*sustain/slide)/basefreq)
    + DelayN.ar(sound3,0.2, Line.ar(0,1,20*sustain/slide)/basefreq);



    OffsetOut.ar(out, DirtPan.ar(sound/2, ~dirt.numChannels, pan, env));
    // sound = sound * env; // MSP
    // Out.ar(out, sound);
}).add;

// waveguide mesh, hexagonal drum-like membrane

SynthDef(\mspSuperhex,{|out, rate=1, sustain=1, pan, freq, accelerate |
    var env = EnvGen.ar(Env.linen(0.02, 0.96, 0.02, 1,-3), timeScale:sustain, doneAction:2);
    var tension = 0.05*freq/400 * Line.kr(1,accelerate+1, sustain);
    var loss = 1.0 - (0.01 * rate / freq);
    var sound = MembraneHexagon.ar(Decay.ar(Impulse.ar(0,0,1), 0.01), tension, loss);
    OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;



)

// Synth(\mspSuperzow);
// Synth(\mspplucklead, []);
// Synth(\mspLaser, [freq: 440, sustain: 7]);
// Synth(\mspsupergong, [decay: 0.8]);
// Synth(\mspVibSawPlucker);