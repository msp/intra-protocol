~dirt.audioRoutingBusses // here are the busses
 ~dirt.audioRoutingBusses.size // 16, so you can use numbers from 0-15
 ~dirt.audioRoutingBusses.at(0).scope;


////////////////////////////////////////////////////////////////////////////////
// MUTABLE
////////////////////////////////////////////////////////////////////////////////
(
(1..SuperDirt.maxSampleNumChannels).do { |numChannels|
  SynthDef("global_mi_verb" ++ numChannels, { |dryBus, effectBus, verbwet=0, verbtime=0, verbdamp=0, verbhp=0, verbfreeze=0, verbdiff=0|
    var signal = In.ar(dryBus, ~dirt.numChannels);
    signal = MiVerb.ar(signal, verbwet, verbtime, verbdamp, verbhp, verbfreeze, verbdiff);
    Out.ar(effectBus, signal)
  }, [\ir, \ir]).add;
};
)

(
~dirt.orbits.do { |x|
    x.globalEffects = ~dirt.orbits[0].globalEffects.addFirst(
      GlobalDirtEffect(\global_mi_verb, [\verbwet, \verbtime, \verbdamp, \verbhp, \verbfreeze, \verbdiff])
  	)
  };

  ~dirt.orbits[0].initNodeTree;
)

(
SynthDef("global_mi_clouds" ++ ~dirt.numChannels, { |dryBus, effectBus, cloudspitch=0, cloudspos=0, cloudssize=0, cloudsdens=0, cloudstex=0, cloudswet=0, cloudsgain=0, cloudsspread=0, cloudsrvb=0, cloudsfb=0, cloudsfreeze=0, cloudsmode=0, cloudslofi=0|
    var signal = In.ar(dryBus, ~dirt.numChannels);
    Out.ar(effectBus, MiClouds.ar(
      inputArray: signal,
      pit: cloudspitch,
      pos: cloudspos,
      size: cloudssize,
      dens: cloudsdens,
      tex: cloudstex,
      drywet: cloudswet,
      in_gain: cloudsgain,
      spread: cloudsspread,
      rvb: cloudsrvb,
      fb: cloudsfb,
      freeze: cloudsfreeze,
      mode: cloudsmode,
      lofi: cloudslofi
    ));
  }, [\ir, \ir]).add;
)

(
SynthDef(\plaits, {|out, sustain=1, pan, accelerate, freq, harm=0.5, timbre=0.5, morph=0.5, engine=0|
	// var env = EnvGen.ar(Env.linen(0.01, 0.98, 0.01, 1,-3), timeScale:sustain, doneAction:2);
	var sound = MiPlaits.ar(pitch: freq.cpsmidi, engine: engine, harm: harm, timbre: timbre, morph: morph);
	// Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
	Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan));
}).add
);


(
~dirt.addModule('rings', { |dirtEvent|
	dirtEvent.sendSynth('rings' ++ ~dirt.numChannels,
		[
			rtrig: ~rtrig,
			rfreq: ~rfreq,
			rstruct: ~rstruct,
			rbright: ~rbright,
			rdamp: ~rdamp,
			rpos: ~rpos,
			rmodel: ~rmodel,
			rpoly: ~rpoly,
			rintern_exciter: ~rintern_exciter,
			reasteregg: ~reasteregg,
			rbypass: ~rbypass,
			out: ~out
		]
	)
}, {~rbright.notNil});
)

(
SynthDef("rings" ++ ~dirt.numChannels, { |out, rtrig=0, rfreq=60.0, rstruct=0.75, rbright=0.75, rdamp=0.4, rpos=0.9, rmodel=0, rpoly=1,rintern_exciter=0, reasteregg=0, rbypass=0|
	var signal = In.ar(out, ~dirt.numChannels);
	signal = MiRings.ar(signal, rtrig, rfreq, rstruct, rbright, rdamp, rpos, rmodel, rpoly,rintern_exciter, reasteregg, rbypass);
  ReplaceOut.ar(out, signal)
}).add;

);


Quarks.gui


(
// { Pulse.ar(200, SinOsc.kr(0.8).range(0.01, 0.99), 0.2) }.play;
{ Pulse.ar(XLine.kr(40, 4000, 6), 0.1, 0.2) }.play;

)



(
{
    var ctls, mods, chans;
	// ctls = [
	// 	// freq, phase, amp
	// 	[LFNoise1.kr(0.5).range(300, 310), 0, 1],
	// 	[LFNoise1.kr(0.5).exprange(3, 310), 0, 1],
	// 	[LFNoise1.kr(0.5).exprange(3, 100), 0, 1],
	// 	[LFNoise1.kr(0.5).exprange(3, 100), 0, 1],
	// 	[LFNoise1.kr(0.5).exprange(3, 100), 0, 1],
	// 	[LFNoise1.kr(0.5).exprange(3, 100), 0, 1]
	// ];
	ctls = [
		[ 30, 0,    1   ],
		[ 400, pi/2, 1   ],
		[ 1730, 0,    0.5 ],
		[ 0,   0,    0   ],
		[ 0,   0,    0   ],
		[ 0,   0,    0   ]
	];
	mods = [
        [Line.kr(0, 0.001, 2), Line.kr(0.1, 0, 4), 0, MouseY.kr(0, 6), 0, 0],
        [MouseX.kr(0, 6), 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0]
    ];
    chans = [0, 1];
    FM7.ar(ctls, mods).slice(chans) * -12.dbamp; // using "slice" to select specific channels
}.play;
)

(
{
var delay1, delay2, source;

//k from -1 to 1

//in samples
delay1= 100;
delay2= 40;

source= WhiteNoise.ar(0.5)*EnvGen.ar(Env([1,1,0],[(delay1+delay2)/SampleRate.ir,0.0]), Impulse.kr(MouseY.kr(1,4)));

TwoTube.ar(source,MouseX.kr(-1,1),0.99,delay1,delay2);
}.play

)




(
SynthDef(\twotube,{arg delay1=100, delay2=50, k=0.0, loss=0.999, dur=0.5, pan=0.0;
var source;

//k from -1 to 1

source= WhiteNoise.ar(0.5)*EnvGen.ar(Env([1,1,0,0],[(delay1+delay2)/SampleRate.ir,0.0,1.0]));

Out.ar(0,Pan2.ar(TwoTube.ar(source,k,loss,delay1,delay2)*EnvGen.ar(Env([0,1,1,0],[0.001]++((dur-0.001)*[0.4,0.6])),doneAction:2),pan));
}).send(s);
)



(
t.stop;
t={

inf.do{

Synth(\twotube,[\delay1, rrand(1000,1200),\delay2, rrand(1,300),\loss, rrand(0.9,0.999),\dur, rrand(3.1,5.0), \pan, rrand(-1,1.0), \k, rrand(-1,1.0)]);

0.5.wait;
};

}.fork;
)


////////////////////////////////// BUFFER



(
{
	var scale, cycle;
	//scale = Array.fill(12,{ arg i; 60 + i }).midicps; // we fill an array with a scale
	scale = [60, 61, 63, 64, 65, 67, 68, 69, 70].midicps; // we fill an array with a scale
	cycle = scale.size / 2;

	SinOsc.ar(
			Select.kr(
				LFSaw.kr(0.4, 1, cycle, cycle),
				scale
			)
	);
}.play;
)

(
{
var source, filter;
var freq;

freq= IEnvGen.kr(InterplEnv([60,62,63,67,70,67,70,72,48].scramble,0.125.dup(8)),Phasor.ar(LFNoise0.kr(1)>0,0.5*(1.0/SampleRate.ir),0.0,1.0).round(1/8)).midicps;

source= Mix.fill(5,{|i| Saw.ar(freq*(0.25*(2**(i))+SinOsc.ar(LFNoise1.kr([0.125,0.25,0.5].choose,7,8),pi.rand,0.01)),0.2)});

filter= BLowPass.ar(0.5*source,1000+(2000*EnvGen.ar(Env([0,1,0],[0.01,0.25]),Impulse.kr(2))),0.2);

Limiter.ar(GVerb.ar(filter*0.25) + Pan2.ar(filter))
 }.play
)

(
{
    var trig, seq, freq;
    trig = Impulse.kr(24);
    seq = Drand([Dseq((1..5).mirror1, 1), Drand((4..10), 8)], 2000);
    freq = Demand.kr(trig, 0, seq * 100);
    SinOsc.ar(freq + [0,0.7]).cubed.cubed.scaleneg(MouseX.kr(-1,1)) * 0.1;
}.play;
)

// audio rate
(
{
    var a, freq, trig;
    a = Dseq({ 10.rand } ! 32, inf);
    trig = Impulse.ar(MouseX.kr(1, 10000, 1));
    freq = Demand.ar(trig, 0, a) * 30 + 340;
    SinOsc.ar(freq) * 0.1

}.play;

)


// synthdef.art ////////////////////////////////////////////////////////////////

// Wall of Sound
(
    ~noiser = play {
        l = LocalIn.ar(8);
	// o = {|i| Pulse.ar(l[i]*16 + 95, 0.9.rand) } ! 8;
	o = {|i| Pulse.ar(l[i]*16 + rrand(64,66), 0.9.rand) } ! 8;
        LocalOut.ar(o.reverse.tanh);
        w = BLowShelf.ar(_, 447, 1, _);
        p = BPeakEQ.ar(_, 285, 1, _);
        h = BHiShelf.ar(_, 1200, 1, _);
        o = Splay.ar(o);
        o = h.(w.(p.(o, 48), -48), -48);
	    o = GVerb.ar(tanh(o)).flop.mean;


	    s = LeakDC.ar(Limiter.ar(h.(w.(p.(o, -48), 48), 48)));
	// OffsetOut.ar(~out1, DirtPan.ar(s, ~dirt.numChannels, 0, 0.18));
	// OffsetOut.ar(0, DirtPan.ar(s, ~dirt.numChannels, 0, 0.18));

	Out.ar(0, Pan2.ar(s, 0, 0.14));

    }
)

~noiser.free;


// the chordy one!

(
    ~chorder = play {
        c = LFDNoise1.ar(_,0.5,0.5);
        o = Saw.ar(_);
        e = SelectX;
    x = [1,2,3,4.5].collect {|i|
		// r = i * 195;
		r = i * 50;
            e.ar(c.(1/7), [
                e.ar(c.(1/3), o.(r*[3,2])),
                e.ar(c.(1/5), o.(r*[9/8,4/3])),
            ]) * LFPulse.ar([0.5,0.51]).range(0, 1).lag(0.05);
        };
        x = Splay.ar(x.sum);
	x = x * 0.5 + RLPF.ar(GVerb.ar(x.sum*0.1,60,10),7e3);

	s = tanh(x);
	// s = x;

	    //OffsetOut.ar(~out1, DirtPan.ar(s, ~dirt.numChannels, 0, 0.1));
	    Out.ar(0, Pan2.ar(s, 0, 0.006));
    }
)

~chorder.free;

// THIS ONE!
(
~bleeper = play {
    o = SinOsc;
    d = Decay;
    x = (0..2).collect {|i|
        TDuty.ar(1/8, 0, Dseq(scramble([1, 1] ++ (0!(9+i))), inf))
    };

    k = d.ar(x[0], 2);
    m = d.ar(x[1]);

    s = Limiter.ar(
        9 * [
            o.ar(80*k).tanh * k,
            o.ar(2*80*m).sin * m,
            GVerb.ar(o.ar(999) * d.ar(Impulse.ar(1/8)),99,10),
            (BPF.ar(WhiteNoise.ar(2))).sin * d.ar(x[2],0.5)
        ].sum.sin
    );

	// OffsetOut.ar(~out1, DirtPan.ar(s, ~dirt.numChannels, 0, 0.2));
	Out.ar(0, Pan2.ar(s, 0, 0.01));
}
)

~bleeper.free;

(
~distBeat = play {
    t = Impulse.ar(8/[5,4]);
    o = BPF.ar(LFNoise1.ar(1e4), 1e3, 1.2);
    p = WhiteNoise.ar(0.4) * Env([1,0,1,0,1,0.5], [1]/100).ar(0, t);
    o = (o + p) * Env.asr(1e-5, 1, 0.5, -10).ar(0, t);
    y = Decay.ar(TDelay.ar(t, 1), 2);
    o = o + GVerb.ar(o*0.5,99,9).sum + (2*SinOsc.ar(80*y,y*0.5pi,2*y).tanh) * 4;


    s = HPF.ar(o.softclip, 30);
	// OffsetOut.ar(~out1, DirtPan.ar(s, ~dirt.numChannels, 0, 0.2));
	Out.ar(0, Pan2.ar(s, 0, 0.01));

}
)

~distBeat.free;


Env.perc().test.plot;

// AND THIS ONE!
(
// var pairs = { { 1.0.rand } ! 2 } ! 3;
// orig pairs
var pairs = [
	[0.0001, 1],
	[0.1, 0]
];
var envShape = Env.pairs(pairs, \exp);
var mod = SinOsc.kr(Rand(0.1, 0.9), 0, Rand(5, 20));

// Window.closeAll;

pairs.postln;
envShape.duration = 1;
// envShape.plot;
// Env.circle(envShape.levels, envShape.times).plot;


~around = play {
    n = 12;
	//orig
	// e = Env.perc(0.001, 0.1).ar(0, Impulse.ar(1));
	// msp hackery
	e = Env.perc(0.001, 0.1).ar(0, Impulse.ar(0.3));
	// e = Env.pairs(pairs).ar(0, Impulse.ar(1));

    x = n.collect {|i|
		// o = e * Pulse.ar(222*4*e, e*(i+1/n/2));
		o = e * Pulse.ar(55*4*e, e*(i+1/n/2));
		DelayC.ar(o, 1, round(i/n ** SinOsc.ar(1/30, 0.5pi).range(0.25,1), 0.125));
    };
	x = x + Klank.ar(`[111*(1..n)*[1,1,9/8], 1/n!n, 0.3!n], x*0.2 + WhiteNoise.ar(0.02!n));
    s = Limiter.ar(2*Splay.ar(x.sin));
	// OffsetOut.ar(~out1, DirtPan.ar(s, ~dirt.numChannels, 0, 0.4));
	Out.ar(0, Pan2.ar(s, 0, 0.09));
}
)

~around.free;

// this is/was the orig of the above from Github
(
play {
    n = 6;
    e = Env.perc(0.001, 0.1).ar(0, Impulse.ar(2));
    x = n.collect {|i|
		o = e * Pulse.ar(222*4*e, e*(i+1/n/2));
		// DelayC.ar(o, 1, round(i/n ** SinOsc.ar(1/30, 0.5pi).range(0.25,1), 0.125));
		DelayC.ar(o, 1, round(i/n ** SinOsc.ar(1/100).range(0.25,1), 0.125));
		// DelayC.ar(o, 1, 0.1);
    };

	x.poll(5);
	// x = x + Klank.ar(`[111*(1..n)*[1,1,9/8], 1/n!n, 0.3!n], x*0.2 + WhiteNoise.ar(0.02!n));

	// s = Limiter.ar(2*Splay.ar(x));
	s = Limiter.ar(x);
	// s = e * Pulse.ar(222, 0.9);
	// OffsetOut.ar(0, DirtPan.ar(s, 2, 0, 0.4));
	// Out.ar(0, Pan2.ar(s, 0, 1));
	Out.ar(0, s);
}
)

round(0/4 ** SinOsc.ar(1/30, 0.5pi)).poll

// isnt this just a fancy way of getting a bunch of fixed delay times?
// try plugging in the iteration numbers for i && n and see what comes out
// 0/4 = [0]
// 1/4 = [0.25, 0.375, 0.625, 0.5, 0.75]
// 2/4 = [0.625, 0.5, 0.75, 0.875, 0.625]
// 3/4 = [0.625, 0.5, 0.75, 0.875, 0.625]
(
play {
	s = round(3/4 ** SinOsc.ar(1/30).range(0.25,1), 0.12).poll(5);
	Out.ar(0, Pan2.ar(s, 0, 1));
}
)

round(0/4 ** SinOsc.ar(1/30).range(0.25,1), 0.125).poll;

0.5pi

4.collect({|i| i.postln; });

// end synthdef.art ////////////////////////////////////////////////////////////
(
SynthDef("tom", {
    arg startPitch = 6000, endPitch=60, clickLevel=0.7, pitchRel = 0.11, noiseLevel=1, noiseRel= 0.3;
    var pitchEnv = EnvGen.ar(Env.perc(0.01, pitchRel));

    var clickOsc = SinOsc.ar(pitchEnv*(startPitch-endPitch)+endPitch);
    var clickEnv = EnvGen.ar(Env.perc(0.001, pitchRel))*clickLevel;
    var noiseOsc = PinkNoise.ar();
    var noiseEnv = EnvGen.ar(Env.perc(0.01, noiseRel))*noiseLevel;
    var snd =  noiseOsc * noiseEnv +clickOsc *clickEnv;
    Out.ar(0,Pan2.ar(snd, 0, 1));
}).add;
)

(
{
    inf.do{
x = Synth.new("tom",["startPitch", rrand(50,60),"endPitch", rrand(500,50), "clickLevel",rrand(1,0.5), "pitchRel",rrand(0.05,0.9), "noiseLevel",rrand(0.1,0.01),"noiseRel",rrand(0.1,0.06)]);
        0.2.wait;
    }
}.fork
)

Synth.new("tom", ["startPitch", rrand(200,60)])

Synth.new("tom")

Synth.new("tom",["startPitch", rrand(600,60),"
endPitch", rrand(600,50),"clickLevel",rrand(1,0.9), "pitchRel",rrand(0.9,0.1), "noiseLevel",rrand(1.5,0.1),"noiseRel",rrand(0.01,0.06)]);
//

(
SynthDef.new("xxbd", {
    arg  out, pan, nn=0.8, nl = 0.02, start=110, end=1, l1=0.1, l2=0.3, nexp=1.7;
    var boom;
    e = pow(Line.ar(0.9,0,l2),nexp);

    boom = BBandPass.ar(WhiteNoise.ar(), freq: Line.ar(100,10,nl))*Line.ar(1,0,nl)*nn+SinOsc.ar(Line.ar(start, end, l1))*e;
	Out.ar(0,[boom,boom])

	// OffsetOut.ar(out, DirtPan.ar([boom, boom], ~dirt.numChannels, pan, e))

}).add;
)

Synth.new("xxbd", ["out", 0])

(
SynthDef.new("ding", {
    arg out, freq = #[1600,200,177,384,730,1255,60], release=0.1, noiseRel=0.01, noiseLevel=0.7, sustain=1, pan;

    var osc = Mix.arFill(7, { arg i;
		SinOsc.ar(freq[i])*0.3;
		// SinOsc.ar(XLine.kr(freq[i]-30,freq[i],1))*0.3;

		// var senv = Env([0.0, 0.5, 0.0, 1.0, 0.9, 0.0], [0.05, 0.1, 0.01, 1.0, 1.5], -4);
		// var senvgen = EnvGen.ar(senv, doneAction: Done.freeSelf);

		// SinOsc.ar(senvgen * freq[i])*0.3;
    });
    var e = EnvGen.ar(Env.perc(0.01, release), timeScale: sustain, doneAction: 2);

    var noiseOsc = PinkNoise.ar();
    var noiseEnv = EnvGen.ar(Env.perc(0.01, noiseRel))*noiseLevel;

	// var snd =  noiseOsc * noiseEnv + osc;
	var snd =  noiseOsc * noiseEnv + osc*e;
	snd = snd * 0.7;
	Out.ar(0,Pan2.ar(snd))
	// OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, e))
}).add;
)

// MSP do more here
(
{
    inf.do{
		x = Synth.new("ding", ["freq", [rrand(1500,1600),200,177,384,rrand(710,730),1255,60], "release", rrand(5,0.05), "sustain", rrand(0.2,0.5), "noiseRel",rrand(0.1,0.5), "noiseLevel", rrand(0.1,2)]);
        // x = Synth.new("ding", ["freq",Array.fill(7,{rrand(2000,60)}), "rel", rrand(1,0.05), "noiseRel",rrand(0.1,0), "noiseLevel", rrand(0,0.4)]);

		y = Synth(\ding2, [f1: 100, f2: 101, f3: 102, f4: 103, f5: 104, F6: 105, f7: rrand(3006,2006)]);
		z = Synth(\tama, [\note: 55, \tension: 0.01, \loss: 5, \dur:  rrand(0.1,0.5)]);
		rrand(0.15, 0.35).wait
		// abs(2.sum3rand).wait
    }
}.fork
)

100.sum3rand;

a.fet

(
var foo = 400;

Synth(\ding,  [

	// freq: Array.fill(7,{rrand(1500,600)}),
	// freq: [foo, 388, rrand(300,250), 200, 220],
	// release: rrand(3, 1.6)
	sustain: 3
    , noiseRel: 0.1
    , noiseLevel: 2
    , out: 0
]
)
)

// TODO MSP
// - Perlin for more natural cadence
// - Leanr Ndef !


// (
// var a;
// a = Pgauss(0.0, 1.0,inf).asStream;
// {
// 	loop {
// 		Synth(\help_sinegrain, [\freq, 600]);
// 		a.next.postln;
// 		0.2.wait;
// 	}
// }.fork;
// )
//
// Simplex.periodic(3);
//
// gaussian
//
// (0,0.01..3).collect{ arg x; x.postln; }
//
// (0,0.01..3).collect{ arg x; Simplex.periodic(x) }

Synth(\ding, [freq: [1000]])

Synth(\ding2, [f1: 100, f2: 101, f3: 102, f4: 103, f5: 104, F6: 105, f7: rrand(3006,2006)])


(
SynthDef.new("ding2", {
    arg out, f1=1600, f2=200, f3=177, f4=384, f5=730, f6=1255, f7=60, release=0.1, noiseRel=0.01, noiseLevel=0.7, sustain=1, pan;

    var freq = [f1, f2, f3, f4, f5, f6, f7];

    var osc = Mix.arFill(7, { arg i;
        SinOsc.ar(freq[i]*15)*0.3;
        // SinOsc.ar(freq[i])*0.3;
    });
    var e = EnvGen.ar(Env.perc(0.01, release), timeScale: sustain, doneAction: 2);

    var noiseOsc = PinkNoise.ar();
    var noiseEnv = EnvGen.ar(Env.perc(0.01, noiseRel))*noiseLevel;

    // var resonance = 0;
    var atk = 0.1, rel = 0.3, hold = 1.0, cutoff = 2500, resonance = 0.1;

    var resonanceEnv = EnvGen.ar(Env.new([resonance, resonance, resonance, 0.9], [atk, hold, rel], curve: \sine)) ;


    // var sig = DFM1.ar(BrownNoise.ar(1)*Decay.ar(Impulse.ar(0.01),0.1),cutoff,resonanceEnv);



    var snd =  noiseOsc * noiseEnv + osc;
    // var snd =  noiseOsc * noiseEnv + osc*e;

	snd = DFM1.ar(snd * 0.5, freq: cutoff );

	Out.ar(0,Pan2.ar(snd))
	// OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, e))
}).add;
)

// Interesting!
(
{
    var bd, tama;

    inf.do {

        bd = Synth.new("xxbd", ["nn":rrand(0.8,0),"nl",rrand(0.03,0), "start",rrand(100.0,50.0),"end",rrand(100,10), "l1", rrand(0.1,0), "l2", rrand(0.8,0.1),"nexp", rrand(1,4), "out", 0]);

		tama = Synth(\tama, [\note: rrand(125,120), \tension: 0.01, \loss: 5, \dur:  rrand(0.1,0.5)]);

		Synth(\dxkKalimba1, [freq: rrand(800, 1000), amp: 2.5 ]);

		// 0.2.wait;
		rrand(0.05, 0.3).wait;

        // bd.free;
        // tama.free;
    }
}.fork()
)

(
SynthDef(\tama,
         {|note = 52, amp = 1, out_bus = 0, pan=0.0, gate=1, tension=0.05, loss=0.9, vel=1, dur=1 |
		var signal, freq;
		var lossexp=LinLin.ar(loss,0.0,1.0,0.9,1.0);
		var env = Env([0, 1, 0.5, 1, 0], [0.01, 0.5, 0.02, 0.5]);
		var excitation = EnvGen.kr(Env.perc, gate, timeScale: 1, doneAction: 0) * PinkNoise.ar(0.4);
		freq=note.midicps;
		signal = amp*MembraneCircle.ar(excitation, tension*(freq/60.midicps), lossexp);
		DetectSilence.ar(signal,doneAction:2);
		signal = signal * EnvGen.ar(Env.perc, gate, vel*0.5, 0, dur, 2);
		signal=Pan2.ar(signal, pan);
        Out.ar(out_bus,signal);
	}
).add;
)

Synth(\tama);

Synth(\tama, [\note: rrand(125,65), \tension: 0.01, \loss: 5, \dur:  rrand(0.1,2)]);

Synth(\tama, [\note: 65, \tension: 0.01, \loss: 5, \dur:  rrand(0.1,2)]);

(
SynthDef(\neurosnare, {
    var snd;
    // a percussive click to give it some attack
    snd = LPF.ar(HPF.ar(WhiteNoise.ar, 300), 8000) * Env.linen(0.001, 0.01, 0.001).ar;
    // sine sweep body. very important!
    snd = snd + (SinOsc.ar(Env([400, 196, 160], [0.04, 0.2], \exp).ar) * Env.perc(0.04, 0.2).ar * 6.dbamp).tanh;
    // sound of snare coils rattling
    snd = snd + (HPF.ar(BPeakEQ.ar(WhiteNoise.ar, 4000, 0.5, 3), 300) * Env.perc(0.05, 0.2).delay(0.01).ar(2) * -3.dbamp);
    // another sound sweep to improve the attack, optional
    snd = snd + (SinOsc.ar(XLine.kr(3000, 1500, 0.01)) * Env.perc(0.001, 0.02).ar);
    // distortion helps glue everything together and acts as a compressor
    snd = (snd * 1.4).tanh;
    snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1));
    Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\neurosnare, [amp: 0.2]);


SynthDef(\dxkKalimba1, {
    |out = 0, freq = 440, amp = 0.1, mix = 0.1, pan = 0|
    var snd, click;
    // Basic tone is a SinOsc
    snd = SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.03, Rand(3.0, 4.0), 1, -7), doneAction: 2);
	snd = HPF.ar( LPF.ar(snd, 380), 120);
    // The "clicking" sounds are modeled with a bank of resonators excited by enveloped white noise
	click = DynKlank.ar(`[
        // the resonant frequencies are randomized a little to add variation
        // there are two high resonant freqs and one quiet "bass" freq to give it some depth
        [240*ExpRand(0.97, 1.02), 2020*ExpRand(0.97, 1.02), 3151*ExpRand(0.97, 1.02)],
        [-9, 0, -5].dbamp,
        [0.8, 0.07, 0.08]
	], BPF.ar(PinkNoise.ar, 6500, 0.1) * EnvGen.ar(Env.perc(0.001, 0.01))) * 0.1;
    snd = (snd*mix) + (click*(1-mix));
	snd = Pan2.ar(snd*amp, pan);
    Out.ar(out, snd);
}).add;

Synth(\dxkKalimba1, [freq: rrand(40, 500), amp: 2.5 ]);


(
SynthDef(\fmSynth, { |carrierFreq=100, carrierLvl=0.5, modulatorRatio=5, modulatorIndex=1.5, outputAmp=0.8, sig, out=0|

	// the simple FM core
	sig = LFSaw.ar(carrierFreq, 1, 0.5, 0.5) * carrierLvl;
	sig = sig + SinOsc.ar(carrierFreq * modulatorRatio) * modulatorIndex;
	sig = cos( sig * 2pi) * outputAmp * 0.06;
	Out.ar(out, sig);
},1!5).add;
)

// At first start the synth:
g = Synth(\fmSynth);

// Play with the parameters:
g.set(\carrierFreq, 800);
g.set(\carrierFreq, 50);
g.set(\carrierFreq, 100, \modulatorRatio, 5, \modulatorIndex, 0.5);
g.set(\carrierFreq, 40, \modulatorRatio, 7, \modulatorIndex, 1.5);
g.set(\carrierFreq, 955, \carrierLvl, 0.4, \modulatorRatio, 3, \modulatorIndex, 4);
// ... etc.

// To stop:
g.free;



(
SynthDef(\kick, {
    |out = 0, pan = 0, amp = 0.3|
    var body, bodyFreq, bodyAmp;
    var pop, popFreq, popAmp;
    var click, clickAmp;
    var snd;

    // body starts midrange, quickly drops down to low freqs, and trails off
    bodyFreq = EnvGen.ar(Env([261, 120, 51], [0.035, 0.08], curve: \exp));
    bodyAmp = EnvGen.ar(Env.linen(0.005, 0.1, 0.3), doneAction: 2);
    body = SinOsc.ar(bodyFreq) * bodyAmp;
    // pop sweeps over the midrange
    popFreq = XLine.kr(750, 261, 0.02);
    popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
    pop = SinOsc.ar(popFreq) * popAmp;
    // click is spectrally rich, covering the high-freq range
    // you can use Formant, FM, noise, whatever
    clickAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.15;
    click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

    snd = body + pop + click;
    snd = snd.tanh;

    Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;

SynthDef(\snare, {
    |out = 0, pan = 0, amp = 0.3|
    var pop, popAmp, popFreq;
    var noise, noiseAmp;
    var snd;

    // pop makes a click coming from very high frequencies
    // slowing down a little and stopping in mid-to-low
    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq) * popAmp;
    // bandpass-filtered white noise
    noiseAmp = EnvGen.ar(Env.perc(0.001, 0.15), doneAction: 2);
    noise = BPF.ar(WhiteNoise.ar, 810, 1.6) * noiseAmp;

    snd = (pop + noise) * 1.3;

    Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;

SynthDef(\hihat, {
    |out = 0, pan = 0, amp = 0.3|
    var click, clickAmp;
    var noise, noiseAmp;
    var snd;

    // noise -> resonance -> expodec envelope
    noiseAmp = EnvGen.ar(Env.perc(0.001, 0.3, curve: -8), doneAction: 2);
    noise = Mix(BPF.ar(ClipNoise.ar, [4010, 4151], [0.15, 0.56], [1.0, 0.6])) * 0.7 * noiseAmp;

    snd = noise;

    Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;

// adapted from a post by Neil Cosgrove (other three are original)
SynthDef(\clap, {
    |out = 0, amp = 0.5, pan = 0, dur = 1|
    var env1, env2, snd, noise1, noise2;

    // noise 1 - 4 short repeats
    env1 = EnvGen.ar(
        Env.new(
            [0, 1, 0, 0.9, 0, 0.7, 0, 0.5, 0],
            [0.001, 0.009, 0, 0.008, 0, 0.01, 0, 0.03],
            [0, -3, 0, -3, 0, -3, 0, -4]
        )
    );

    noise1 = WhiteNoise.ar(env1);
    noise1 = HPF.ar(noise1, 600);
    noise1 = LPF.ar(noise1, XLine.kr(7200, 4000, 0.03));
    noise1 = BPF.ar(noise1, 1620, 3);

    // noise 2 - 1 longer single
    env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.18], [0, -4]), doneAction:2);

    noise2 = WhiteNoise.ar(env2);
    noise2 = HPF.ar(noise2, 1000);
    noise2 = LPF.ar(noise2, 7600);
    noise2 = BPF.ar(noise2, 1230, 0.7, 0.7);

    snd = noise1 + noise2;
    snd = snd * 2;
    snd = snd.softclip;

    Out.ar(out, Pan2.ar(snd,pan,amp));
}).add;
)

(
var base;

base = Pbind(\amp, 0.6);

Ppar([
    Pbindf(
        base,
        \instrument, Pseq([\kick, \kick, \snare], inf),
        \dur, Pseq([1, 3, 4, 2, 4], inf)
    )
]).play(TempoClock(2.3 * 4));
)

(
var base;

base = Pbind(\amp, 0.6);

Ppar([
    Pbindf(
        base,
        \instrument, Pseq([\mspFM], inf),
        \dur, Pseq([1, 3, 4, 2, 4], inf)
    )
]).play(TempoClock(2.3 * 4));
)

(
TempoClock.default.tempo = 222/60;
k = Pbind(\instrument, \kik, \delta, 4, \preamp, 4.5, \amp, 0.32).play(quant: 1);
k = Pbind(\instrument, \mspFM).play(quant: 1);
)



~ampEnvDuration.set(2.0.rand)