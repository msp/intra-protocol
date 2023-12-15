// synthdef.art ////////////////////////////////////////////////////////////////

// Wall of Sound
(
    ~noiser = play {
        l = LocalIn.ar(8);
	// o = {|i| Pulse.ar(l[i]*16 + 95, 0.9.rand) } ! 8;
	// o = {|i| Pulse.ar(l[i]*16 + rrand(64,66), 0.9.rand) } ! 8;
	o = {|i| Pulse.ar(l[i]*16 + rrand(44,46), 0.9.rand) } ! 8;
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

	s = s * -18.dbamp;
	Out.ar(0, Pan2.ar(s, 0, 0.14));

    }
)

~noiser.free;

~distBeat.free;

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

