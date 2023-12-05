(
SynthDef(\larango, {
	| out = 0, pitch = 40, vol = 0.2 |
	var snd, env;

	// snd = PulseDPW.ar(XLine.kr(10,100,6),0.1, 0.2);
	snd = PulseDPW.ar(pitch, 0.1, vol);

	Out.ar(out, snd ! 2);
}).add;

)

(
r = Synth(\larango, [\pitch: 0.2, \vol: 0.4]);
// r.set(\vol, 0.8);

g = Synth(\larango, [\pitch: 0.3, \vol: 0.6]);

b = Synth(\larango, [\pitch: 0.8, \vol: 0.8]);
)

r.set(\pitch, 0.2);

g.set(\pitch, 0.3);

b.set(\pitch, 0.4);

r.free;
g.free;
b.free;



(
NetAddr.localAddr;

)

(

var max_vol = 0.32;

OSCdef.new(
	\vdmx_osc_r,
	{
		arg msg, time, addr, port;
		// [msg[9],msg[10]].postln;
		msg.postln;
		msg[1].postln;
        "--".postln;
        "--".postln;

		// r.set(\pitch, msg[1].range(2,30));
	}
	, '/FromVDMX/r'
);

OSCdef.new(
	\vdmx_osc_ra,
	{
		arg msg, time, addr, port;
		// [msg[9],msg[10]].postln;
		msg.postln;
		msg[1].postln;
        "--".postln;
        "--".postln;

		r.set(\vol, msg[1].range(0.0, max_vol));
	}
	, '/FromVDMX/ra'
);

OSCdef.new(
	\vdmx_osc_g,
	{
		arg msg, time, addr, port;
		// [msg[9],msg[10]].postln;
		msg.postln;
		msg[1].postln;
        "--".postln;
        "--".postln;

		// g.set(\pitch, msg[1].range(2,35));
	}
	, '/FromVDMX/g'
);

OSCdef.new(
	\vdmx_osc_ga,
	{
		arg msg, time, addr, port;
		// [msg[9],msg[10]].postln;
		msg.postln;
		msg[1].postln;
        "--".postln;
        "--".postln;

		// g.set(\vol, msg[1].range(0.0, max_vol));
	}
	, '/FromVDMX/ga'
);

OSCdef.new(
	\vdmx_osc_b,
	{
		arg msg, time, addr, port;
		// [msg[9],msg[10]].postln;
		msg.postln;
		msg[1].postln;
        "--".postln;
        "--".postln;

		// b.set(\pitch, msg[1].range(2,40));
	}
	, '/FromVDMX/b'
);

OSCdef.new(
	\vdmx_osc_ba,
	{
		arg msg, time, addr, port;
		// [msg[9],msg[10]].postln;
		msg.postln;
		msg[1].postln;
        "--".postln;
        "--".postln;

		// b.set(\vol, msg[1].range(0.0, max_vol));
	}
	, '/FromVDMX/ba'
);

OSCdef.new(
	\vdmx_osc_lfo_cos,
	{
		arg msg, time, addr, port;
		// [msg[9],msg[10]].postln;
		msg.postln;
		msg[1].postln;
        "--".postln;
        "--".postln;

		r.set(\pitch, msg[1].range(0.2, 0.9));
		r.set(\vol, msg[1].range(0.35, 0.2));
		// g.set(\pitch, msg[1].range(0.3, 0.4));
		// b.set(\pitch, msg[1].range(0.4, 0.5));
	}
	, '/FromVDMX/lfo/cosine'
);


)


(
OSCdef.freeAll
)



10.range(1, 100)

OSCFunc.trace(true); // Turn posting on
OSCFunc.trace(false); 