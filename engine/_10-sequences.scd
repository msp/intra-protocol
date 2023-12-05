////////////////////////////////////////////////////////////////////////////////
// SEQUENCES
////////////////////////////////////////////////////////////////////////////////

(
// place cursor below this line and execute CMD + enter to execute the section)


//// rumble sequence ///////////////////////////////////////////////////////////
Pdef(\rumble,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \rumble,
			\n, Pseq([Prand([0,1,6])], inf),
			\speed, Pseq([0.8, 1, 0.5, 1.2], inf),
			\dur, 8 * Pseq([1, Rest(2), 2, Rest(8), 1/2], inf),
			\shape, 0.3,
			\distort, 0.01,
			\cutoff, 50,
			\orbit, ~out1
		),
		Pbind(
			\type, \dirt,
			\s, 'form-msp5',
			\n, Pseq([0, 1], inf),
			\speed, Pseq([0.2, 0.5], inf),
			\dur, Pseq([16, Rest(1)], inf),
			\gain, 1.2,
			\room, Pseq([0, 0, 0.4], inf),
			\orbit, ~out1
		)
	])
);


//// industrial ////////////////////////////////////////////////////////////////
Pdef(\industrial,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \soundfx,
			\n, Pseq([1], inf),
			\speed, Pseq([Prand([0.2, 0.1, 0.5, 1.2])], inf),
			\dur, Pseq([8, 10, 12, Rest(10)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.7, 0.25, 0.75, 0.6], inf),
			\size, Pseq([0.6, 0.25, 0.75, 0.5], inf),
			\shape, 0.5,
			// \crush, 4,
			\gain, 0.85,
			\orbit, ~out1
		)
	])
);

//// smash ////////////////////////////////////////////////////////////////
Pdef(\smash,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \smash,
			\n, Pseq([Prand((0..13))], inf),
			// \n, 0,
			\speed, Pseq([Prand([0.2, 0.1, 0.5, 1.2])], inf),
			\dur, Pseq([8, 10, 12, Rest(10)], inf),
			// \dur, 3,
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			// \room, Pseq([0.7, 0.25, 0.75, 0.6], inf),
			// \size, Pseq([0.6, 0.25, 0.75, 0.5], inf),
			// \comb, Pseq([Prand([0.2, 0.5, 0.8])], inf),
			// \hbrick, Pseq([Pwrand([0, 0.1, 0.2],[0.7, 0.2, 0.1])], inf),
			\shape, 0.4,
			// \crush, 8,
			\gain, 0.8,
			\orbit, ~out1
		)
	])
);

//// rain/pool //////////////////////////////////////////////////////////////////
Pdef(\rainpool,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \soundfx,
			\n, Pseq([0,3], inf),
			\speed, Pseq([0.2, 0.1, 0.5, 1.2], inf),
			\dur, Pseq([8, Rest(2)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0, 0.25, 0.75, 0.6], inf),
			\size, Pseq([0.6, 0.75, 0.25, 0], inf),
			\gain, 0.85,
			\orbit, ~out1
		)
	])
);

//// pool //////////////////////////////////////////////////////////////////////
Pdef(\pool,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \soundfx,
			\n, Pseq([2], inf),
			\speed, Pseq([Prand([0.2, 0.5, 1])], inf),
			\dur, Pseq([32, Rest(32)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0, 0.25, 0.75, 0.8], inf),
			\size, Pseq([0.6, 0.75, 0.25, 0], inf),
			\hcutoff, 1800,
			\shape, 0.4,
			\crush, 6,
			\gain, 1.05,
			\orbit, ~out1
		)
	])
);

//// charger ///////////////////////////////////////////////////////////////////
Pdef(\charger,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \soundfx,
			\n, Pseq([Rest(7), 4], inf),
			\speed, Pseq([Prand([0.2, 0.5, 1, 2])], inf),
			\dur, Pseq([8, Rest(6)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0, 0.25, 0.75, 0.8], inf),
			\size, Pseq([0.6, 0.75, 0.25, 0], inf),
			\comb, Pseq([Prand([0.2, 0.5, 0.8])], inf),
			\hbrick, Pseq([Pwrand([0, 0.1, 0.2],[0.7, 0.2, 0.1])], inf),
			\gain, 0.7,
			\orbit, ~out1
		)
	])
);

//// tester ////////////////////////////////////////////////////////////////////
Pdef(\seqtest,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \cr,
			\n, Pseq([1, 0, 1, 5], inf),
			\speed, 1,
			\dur, 1,
			\gain, 0.8,
			// \pan, Pseq([0.2, 0.4, 0.6, 0.8, 1], inf),
			// \delaytime, 1/8,
			// \delay, 2,
			// \delayfeedback, 0.9,
			\orbit, ~out1
		)
	])
);

//// cymbals ///////////////////////////////////////////////////////////////////
Pdef(\cymbals,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \cr,
			\n, Pseq([1, 0, 1, 5], inf),
			\speed, Pseq([Prand([0, 0.1, 0.15])], inf),
			\dur, Pseq([Prand([5, Rest(8), 10])], inf),
			// \dur, Pseq([Prand([3])], inf),
			\crush, 6,
			\room, Pseq([0, 0.25, 0.75, 0.6], inf),
			\size, Pseq([1, 0.75, 0.25, 0], inf),
			\comb, 0.5,
			\hbrick, Pseq([Pwrand([0, 0.1, 0.2],[0.7, 0.2, 0.1])], inf),
			\enhance, 0.05,
			\gain, 0.6,
			\orbit, ~out1
		)
	])
);

//// twinkle ///////////////////////////////////////////////////////////////////
Pdef(\twinkle,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \gamaBell,
			// \instrument, \gamaBell,
			\n, Pseq([1, 5, 10, 3, 6, 4], inf),
			\atk, 2,
			\sus, 2,
			\rel, 3,
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\freqs, Pfunc({50.0.rrand(4000)}.dup(12)),
			\rings, Pfunc({0.1.rrand(2)}.dup(12)),
			\speed, 1,
			\dur, 10,
			\gain, 0.85,
			\orbit, ~out1
		)
	])
);

//// haunted ///////////////////////////////////////////////////////////////////
Pdef (
	\haunted,
	Pbind(
		\instrument, \hauntedSine,
		\dur, Pwhite(0.05, 1.8, inf),
		\midinote, Pseq([33], inf),
		\harmonic, Pexprand(1, 80, inf).round,
		// \freq, Pexprand(300, 600, inf),
		\atk, Pwhite(1.0, 3.0, inf),
		\rel, Pwhite(5.0, 15.0, inf),
		\amp, Pkey(\harmonic).reciprocal * 0.06,
		\pan, Pwhite(-0.8, 0.8, inf),
		\orbit, ~out1
		// \out, ~out1
	);
);

//// gravity ///////////////////////////////////////////////////////////////////
Pdef(\gravity,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, 'form-msp5',
			\n, Pseq([Rest(8), 8], inf),
			\speed, Pseq([Prand([5, 0.2, 0.1, 0.5, 1.2, 2, 0.8])], inf),
			\dur, Pseq([8, Rest(4)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0, 0.25, 0.75], inf),
			\size, Pseq([0.75, 0.25, 0], inf),
			\hcutoff, 1300,
			\gain, 0.80,
			\orbit, ~out1
		)
	])
);

//// cellophane ////////////////////////////////////////////////////////////////
Pdef(\cellophane,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \Paper,
			\n, Pseq([0], inf),
			\speed, Pseq([Prand([2, 1, 0.6])], inf),
			\dur, Pseq([16, Rest(8)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0, 0.25, 0.75, 0.6], inf),
			\size, Pseq([0.5, 0.75, 0.25, 0], inf),
			\hcutoff, 8300,
			\gain, 0.85,
			\orbit, ~out1
		)
	])
);

//// paper /////////////////////////////////////////////////////////////////////
Pdef(\paper,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \Paper,
			\n, Pseq([Prand([1,2,3,4,5,6,7])], inf),
			\speed, Pseq([Prand([2, 1, 0.6])], inf),
			\dur, Pseq([16, Rest(8)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.75, 0.25, 0], inf),
			\size, Pseq([0.75, 0.25, 0], inf),
			\gain, 1,
			\orbit, ~out1
		)
	])
);

//// pad ///////////////////////////////////////////////////////////////////////
Pbindef(\pad,
	\instrument, \mspWaves,
	\dur, Pseq([Rest(10.rand), Prand([1,6,12]),2, Rest(5.rand), 1.5, 0.5], inf),
	\atk, Pexprand(3,6),
	\sus, 0,
	\rel, Pexprand(5,10),
	\c0, Pexprand(1,2),
	\c1, Pexprand(1,2).neg,
	\detune, Pfunc({rrand(0.15,0.4)}!3),
	\buf, Prand(~wt_buf[0..3], inf),
	\scale, ~scale,
	\degree, Pfunc({
		(-12,-10..12).scramble[0..rrand(1,3)]
	}),
	\amp, Pexprand(0.05,0.07),
	// \pan, Pwhite(0.2,0.6),
	\pan, 0.5,
	\out, 1,
	\rout, ~rbus,
	\rsend, -10,
);

//// pad2 //////////////////////////////////////////////////////////////////////
Pbindef(\pad2,
	\instrument, \mspWaves,
	\dur, Prand([
		Pseq([Rest(10.rand), Prand([12,16,20]),2   , 1.5, 0.5], 1),
		Pseq([Rest(10.rand), Prand([12,16,20]),1.5, 1   , 1.5], 1),
	],inf),
	// \degree, Pfunc({
	//     (-12,-10..0).scramble[0..rrand(1,3)]
	// }), // Not if using midinotes - see hierachy at pBind detunedFreq help
	\atk, rrand(3,10),
	\sus, 0.3,
	\rel, rrand(2, 5),
	\c0, -2,
	\c1, -2,
	\detune, Pexprand(0.18,0.25),
	\buf, Pwrand([
		Pseq([~wt_buf[0]],4),
		Pseq([~wt_buf[3]],4),
		Pseq([~wt_buf[7]],4),
	],[15,3,1].normalizeSum,inf),
	\scale, ~scale,
	\midinote, Pxrand([
		Pseq([\,67,60,Prand([58,70,\])],1),
		Pseq([\,67,58,Prand([57,63,\])],1),
		Pseq([\,70,72,Prand([65,79,\])],1)
	],inf),
	\amp, Pseq([0,0.18,0.24,0.28],inf),
	\out, 1,
	// \rout, ~rbus,
	// \rsend, -6,
);

//// bells /////////////////////////////////////////////////////////////////////
Pdef(\bell_1,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \prayer_bell,
			\dur, Pseq([8, 20], inf),
			// \dur, Pseq([5, 5], inf),
			\freq, Pseq([800, 500], inf),
			\amp, 0.5,
			\lag, 0,
			\trig, Pseq([0.1], inf) * Pwhite(0.5, 1, inf) * Pwrand([0, 1], [1, 5].normalizeSum, inf),
			\sing_switch, Pseq((0!4) ++ (1!4), inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\delay, 0.8,
			\delayt, 0.1,
			\delayfb, 0.8,
			\room, Pseq([0.75, 0.25, 0], inf),
			\size, Pseq([0.75, 0.25, 0], inf),
			\gain, 0.9,
			\orbit, ~out1
		)
	])
);

Pdef(\bell_2,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \prayer_bell,
			\dur, Pwhite(8, 20, inf),
			\trig, Pwhite(0.05, 0.09),
			\sing_switch, Pwrand([0, 1], [5, 3].normalizeSum, inf),
			\freq, Prand((240, 360 .. 2000), inf),
			\amp, 0.3,
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\gain, 0.9,
			\orbit, ~out1
		)
	])
);

Pdef(\bell_3,
	Ppar([
		Pmono(\prayer_bell,
			\freq, 100,
			\dur, 1,
			\trig, 0,
			\sing_switch, Pwrand([0, 1], [10, 3].normalizeSum, inf),
			\amp, Pwhite(0.1, 0.4),
			\gain, 0.6,
			\orbit, ~out8
		),
		Pmono(\prayer_bell,
			\freq, 200,
			\dur, 3,
			\trig, 0,
			\sing_switch, Pwrand([0, 1], [10, 3].normalizeSum, inf),
			\amp, Pwhite(0.1, 0.3),
			\gain, 0.6,
			\orbit, ~out8
		),
		Pmono(\prayer_bell,
			\freq, 300,
			\dur, 1,
			\trig, 0,
			// \sing_switch, Pwrand([0, 1], [1, 2].normalizeSum, inf),
			\sing_switch, 0.5,
			\amp, Pwhite(0.1, 0.4),
			\gain, 0.6,
			\orbit, ~out1
		)
	])
);

/*Pdef(\bell_3,
Ppar([
Pbind(
\type, \dirt,
\s, \prayer_bell,
\freq, 100,
\dur, 16,
\trig, 1,
\sing_switch, Pwrand([0, 1], [10, 3].normalizeSum, inf),
\amp, Pwhite(0.1, 0.4),
\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
\gain, 0.9,
\orbit, ~out1
),
Pbind(
\type, \dirt,
\s, \prayer_bell,
\freq, 200,
\dur, 16,
\trig, 1,
\sing_switch, Pwrand([0, 1], [10, 3].normalizeSum, inf),
\amp, Pwhite(0.1, 0.4),
\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
\gain, 0.9,
\orbit, ~out1
),
Pbind(
\type, \dirt,
\s, \prayer_bell,
\freq, 300,
\dur, 16,
\trig, 1,
\sing_switch, Pwrand([0, 1], [10, 3].normalizeSum, inf),
\amp, Pwhite(0.1, 0.4),
\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
\gain, 0.9,
\orbit, ~out1
)
])
);*/

//// noise /////////////////////////////////////////////////////////////////////
Pdef(\noise,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \supernoise,
			// \dur, Pseq([8, Rest(1)], inf),
			\dur, Pseq([4, Rest(1)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\distort, 0.3,
			// \cutoff, Pseq([1750, 5000, 10000]),
			\resonance, Pseq([0.9, 0.2, 0.3], inf),
			\phaserrate, 0.4,
			\phaserdepth, 0.6,
			// why no workie?!
			// \delaytime, 0.4,
			// \delayfeedback, 0.5,
			// \delaySend, 1,
			\gain, 0.3,
			\orbit, ~out1
		),
		Pbind(
			\type, \dirt,
			\s, \superstatic,
			\freq, Pseq([Pwrand([100, 500, 1000, 1500, 2000], [5, 3, 2, 3, 6].normalizeSum)], inf),
			\dur, Pseq([8, Rest(3)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\crush, 4,
			\distort, 0.1,
			\gain, 0.75,
			\orbit, ~out1
		)
	])
);


//// chimes ////////////////////////////////////////////////////////////////////
Pdef(\chimes,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \soundfx,
			\n, Pseq([Prand([5,6,7])], inf),
			\speed, Pseq([Prand([0.1, 0.6, 1, 2])], inf),
			\dur, Pseq([16, Rest(8)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\gain, 0.9,
			\orbit, ~out1
		)
	])
);

//// modular ///////////////////////////////////////////////////////////////////
Pdef(\modular,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \modular,
			\n, Pseq([Prand([0,1,2])], inf),
			\speed, Pseq([Prand([0.5, 1, 2])], inf),
			\dur, Pseq([4, Rest(4)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.5, 0.25, 0], inf),
			\size, Pseq([0.5, 0.25, 0], inf),
			\gain, 0.85,
			\orbit, ~out1
		)
	])
);

//// scissors //////////////////////////////////////////////////////////////////
Pdef(\scissors,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \soundfx,
			\n, Pseq([Prand([8,9,10])], inf),
			\speed, Pseq([Prand([0.5, 1, 2])], inf),
			\dur, Pseq([4, Rest(2)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.5, 0.25, 0], inf),
			\size, Pseq([0.5, 0.25, 0], inf),
			\gain, 1,
			\orbit, ~out1
		)
	])
);

//// intro /////////////////////////////////////////////////////////////////////
Pdef(\intro,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \formsally,
			\n, Pseq([Prand([0])], inf),
			\speed, Pseq([Prand([0.5, 1, 1.6])], inf),
			\dur, Pseq([4, Rest(2)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.5, 0.25], inf),
			\size, Pseq([0.5, 0.25], inf),
			\gain, 0.9,
			\orbit, ~out1
		)
	])
);

//// choir /////////////////////////////////////////////////////////////////////
Pdef(\choir,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \vocals,
			\n, Pseq([Pwrand([0], [10].normalizeSum, inf)], inf),
			// \speed, Pseq([Prand([0.8, 1, 1.2, 1.4])], inf),
			\speed, Pseq([Prand([0.2, 0.4, 0.4, 0.8])], inf),
			\dur, Pseq([4, Rest(2), 6], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.5, 0.25], inf),
			\size, Pseq([0.5, 0.25], inf),
			\hcutoff, 1000,
			\gain, 0.8,
			\orbit, ~out1
		)
	])
);

//// sunrise ///////////////////////////////////////////////////////////////////
Pdef(\sunrise,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \formsally,
			\n, Pseq([Pwrand([5], [10].normalizeSum, inf)], inf),
			\speed, Pseq([Prand([0.4, 0.8])], inf),
			\dur, Pseq([16, Rest(4), 8], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.5, 0.25], inf),
			\size, Pseq([0.5, 0.25], inf),
			\gain, 0.8,
			\orbit, ~out1
		),
	])
);

Pdef(
	\sunrisearp,
	Pbind(
		\type, \dirt,
		\s, \hauntedSine,
		\dur, Pseq([1/16, 1/12, 1/16], inf),
		\stretch, 2.875,
		\note, Pxrand([0, 3, 5, 8, 10, 12], inf),
		\atk, Pexprand(0.05, 0.1, inf),
		\sustain, Pwhite(0.5, 2, inf),
		\octave, 6,
		\rel, Pexprand(0.05, 0.1, inf),
		\amp, Pexprand(0.8, 0.9, inf),
		\pan, Pwhite(-0.8, 0.8, inf),
		\delay, 0.2,
		\delayt, 0.1,
		\delayfb, 0.8,
		\room, Pseq([0.5, 0.25], inf),
		\size, Pseq([0.5, 0.25], inf),
		\hcutoff, 2200,
		// \hcutoff, Pwhite(500, 2200, inf),
		// \phaserdepth, 0.8,
		// \phaserrate, 0.8,
		// \psratio, 1,
		\gain, 0.85,
		\orbit, ~out1
	);
);

//// running ///////////////////////////////////////////////////////////////////
Pdef(\running,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \formsally,
			\n, 6,
			\speed, Pseq([Prand([0.4, 0.8])], inf),
			\dur, Pseq([Pwrand([0.1, 0.2, 1], [30, 15, 1].normalizeSum, inf)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.5, 0.25], inf),
			\size, Pseq([0.5, 0.25], inf),
			\gain, 0.8,
			\orbit, ~out1
		),
	])
);

//// chipsoul //////////////////////////////////////////////////////////////////
Pdef(\chipsoul,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \formsally,
			\n, 1,
			\speed, 0.4,
			\end, Pwrand([0.5, 1], [30, 1].normalizeSum, inf),
			// \dur, Pseq([10, 5, 10, 5, 0.5, 1, 5, 10, 5, 1], inf),
			\dur, Pseq([
				Pseq([10], 8),
				Pseq([5], 1),
				Pseq([0.5], 1),
				Pseq([1, Rest(9), 0.5], 2),
				Pseq([5], 1),
			], inf),
			\pan, Pseq([0.45, 0.5, 0.55], inf),
			\room, Pseq([0.45], inf),
			\size, Pseq([0.45], inf),
			// \hcutoff, Pseq([0, 50, 100, 150, 250], inf),
			\hcutoff, Pseq([
				Pseq([50], 8),
				Pseq([50], 1),
				Pseq([150], 1),
				Pseq([100, 100, 200], 2),
				Pseq([200], 1),
			], inf),
			\gain, 0.85,
			\orbit, ~out1
		)
	])
);

Pdef(\chipsoul2,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \formsally,
			\n, 1,
			\speed, Pwrand([0.8, 1.2, 1.4, 2], [4, 0.6, 0.4, 0.2].normalizeSum, inf),
			\end, Pwrand([0.8, 1], [10, 1].normalizeSum, inf),
			\dur, Pseq([Pwrand([0.5, 1, 4, 8], [2, 5, 10, 4].normalizeSum, inf)], inf),
			\pan, Prand([0, 0.25, 0.75, 1], inf),
			\room, Pseq([0.5], inf),
			\size, Pseq([0.5], inf),
			\hcutoff, Pseq([400, 800, 2400], inf),
			\gain, 0.5,
			\orbit, ~out1
		)
	])
);

//// pulser ////////////////////////////////////////////////////////////////////
Pdef(\pulser,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \super808,
			\n, Pseq([
				Pseq([0], 24),
				// Pseq([3], 4),
			], inf),
			\sustain, Pseq([
				Pseq([0.2], 8),
				Pseq([2.4], 8),
				Pseq([0.1, 0.4], 8),
				Pseq([1.8, 4], 4),
			], inf),
			\voice, Pseq([
				Pseq([0.1], 8),
				Pseq([0.4], 8),
				Pseq([0.1], 8),
				Pseq([0.8], 4),
			], inf),
			\speed, 1,
			\cutoff, Pwrand([50, 100, 150, 1500], [20, 10, 8, 1].normalizeSum, inf),
			// \dur, Pwhite(1.15, 1.25, inf) / 8,
			// \amp, Pbjorklund(3, 5, inf),
			// \dur, 1,
			// \dur, Pseq([2, 1, 1/2, 1/4, 1/6, 1/8, 1/2, Rest(8)], inf),
			// \dur, Pseq([2, 1, 1/2, 1/4, Rest(3)], inf),
			\dur, Pseq([1/2, Rest(3)], inf),
			\gain, 0.8,
			\shape, 0.8,
			\crush, Pwrand([50, 4], [20, 1].normalizeSum, inf),
			\pan, 0.5,
			// \pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\orbit, ~out1
		)
	])
);

//// kicker ////////////////////////////////////////////////////////////////////
Pdef(\kicker,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \super808,
			\n, Pseq([
				Pseq([0], 24),
				Pseq([3], 4),
			], inf),
			\sustain, Pseq([
				Pseq([0.2], 8),
				Pseq([2.4], 8),
				Pseq([0.1, 0.4], 8),
				Pseq([1.8, 4], 4),
			], inf),
			\voice, Pseq([
				Pseq([0.1], 8),
				Pseq([0.2], 8),
				Pseq([0.1], 8),
				// Pseq([0.8], 4),
			], inf),
			\speed, 1,
			\cutoff, Pwrand([150, 1100, 5000], [5, 8, 2].normalizeSum, inf),
			// \dur, Pwhite(1.15, 1.25, inf) / 8,
			\amp, Pbjorklund(2, 4, inf),
			\dur, 1/4.67,
			// \dur, Pseq([1/2, Rest(3)], inf),
			\gain, 0.9,
			\shape, 0.2,
			// \crush, Pwrand([50, 6], [20, 1].normalizeSum, inf),
			\pan, 0.5,
			// \pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\orbit, ~out1
		),
		Pbind(
			\type, \dirt,
			\s, \sd,
			\n, Pseq([
				Pseq([0], 24),
				Pseq([3], 4),
			], inf),
			\speed, 3,
			\vowel, "aeiou".choose.asSymbol,
			\resonance, Pwhite(0.1, 0.5, inf),
			// \cutoff, Pwrand([150, 1500, 5000], [5, 10, 5].normalizeSum, inf),
			// \dur, Pwhite(1.15, 1.25, inf) / 8,
			\amp, Pbjorklund(4, 8, inf),
			\dur, 1/4.67,
			// \delaytime, Pwrand([1/3, 1/8, 1/4, 1/2], [20, 15, 10, 15].normalizeSum, inf),
			// \delaytime, 1/3,
			// \delay, 0.3,
			// \delayfeedback, 0.4,
			\phaserrate, 0.4,
			\phaserdepth, 0.6,
			\hcutoff, 800,
			// \shape, 0.8,
			// \crush, Pwrand([50, 4], [20, 1].normalizeSum, inf),
			// \pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\gain, Pwhite(0.35, 0.55, inf),
			\orbit, ~out1
		),
		Pbind(
			\type, \dirt,
			\s, \h,
			\n, Pseq([
				Pseq([0], 24),
				Pseq([3], 4),
			], inf),
			\amp, Pbjorklund(4, 8, inf),
			// \dur, Pseq([Rest(1/4.67), 1/4.67], inf),
			\dur, Pseq([1/4.67, Rest((1/4.67) * 2)], inf),
			\gain, 0.56,
			// \delaytime, 1/3,
			// \delay, 0.3,
			// \delayfeedback, 0.4,
			\phaserrate, 0.4,
			\phaserdepth, 0.6,
			// \shape, 0.8,
			\hcutoff, 1200,
			// \crush, Pwrand([50, 4], [20, 1].normalizeSum, inf),
			// \pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\gain, Pwhite(0.1, 0.4, inf),
			\orbit, ~out1
		),
		Pbind(
			\type, \dirt,
			\s, \hh,
			\n, Pseq([
				Pseq([0], 24),
				Pseq([3], 4),
			], inf),
			\speed, Pwhite(3.0, 1.8, inf),
			\amp, Pbjorklund(4, 8, inf),
			// \dur, Pseq([Rest(1/4.67), 1/4.67], inf),
			\dur, Pseq([(1/4.67) / 4], inf),
			// \delaytime, 1/3,
			// \delay, 0.3,
			// \delayfeedback, 0.4,
			\phaserrate, 0.4,
			\phaserdepth, 0.6,
			\shape, 0.5,
			\hcutoff, 1200,
			\crush, Pwrand([50, 4], [20, 1].normalizeSum, inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\gain, 0.55,
			\orbit, ~out1
		)
	])
);

//// teleharmonic //////////////////////////////////////////////////////////////
Pdef(\teleharmonic,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \teleharmonic,
			// \n, Pseq([Pwrand([1], [10].normalizeSum, inf)], inf),
			\n, Pseq([0,1,2,3,4], inf),
			\speed, Pseq([Prand([0.5, 1, 1.5], inf)], inf),
			\cutoff, 50,
			\resonance, 0.5,
			\shape, 0.5,
			// \distort, 0.01,
			\crush, 4,
			\phaserdepth, 0.8,
			\phaserrate, 0.8,
			\psratio, 1,
			// \room, Pseq([0.5, 0.25], inf),
			// \size, Pseq([0.5, 0.25], inf),
			\gain, 0.8,
			\orbit, ~out1
		),
		Pbind(
			\type, \dirt,
			\s, \teleharmonic,
			\n, Pseq([Pwrand([2, 3, 4], [5, 7, 10].normalizeSum, inf)], inf),
			// \n, Pseq([0,1,2,3,4], inf),
			\dur, Pseq([Pwrand([Rest(8), 4, 8, 1], [5, 10, 5, 1].normalizeSum, inf)], inf),
			// \speed, Pseq([Prand([0.8, 1, 1.5, 2, 3], inf)], inf),
			\speed, Pseq([Pwrand([3, 2, 1.5, 1, 0.8], [10, 5, 4, 3, 2].normalizeSum, inf)], inf),
			\hcutoff, 550,
			\room, Pseq([0.5, 0.65], inf),
			\size, Pseq([0.5, 0.65], inf),
			\delay, 0.5,
			\delayt, 0.3,
			\delayfb, 0.8,
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\gain, 0.95,
			\orbit, ~out1
		)
	])
);

//// oooh //////////////////////////////////////////////////////////////////
Pdef(\oooh,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \vocals,
			\n, Pseq([Pwrand([4], [10].normalizeSum, inf)], inf),
			\speed, Pseq([Prand([0.6, 0.1, 1.2])], inf),
			\dur, Pseq([2, Rest(5)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.5, 0.25, 0], inf),
			\size, Pseq([0.5, 0.25, 0], inf),
			\delaytime, Pwrand([1/3, 1/8, 1/4, 1/2], [20, 15, 10, 15].normalizeSum, inf),
			\delay, 0.8,
			\delayfeedback, 0.6,
			\gain, 0.85,
			\orbit, ~out1
		)
	])
);

//// move //////////////////////////////////////////////////////////////////////
Pdef(\move,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \samples,
			\n, Pseq([Pwrand([1], [10].normalizeSum, inf)], inf),
			\speed, Pseq([Prand([0.8, 0.75, 0.9])], inf),
			\dur, Pseq([3, Rest(6)], inf),
			//        	\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.5, 0.25, 0], inf),
			\size, Pseq([0.5, 0.25, 0], inf),
			\gain, 0.85,
			\orbit, ~out1
		)
	])
);

//// beat //////////////////////////////////////////////////////////////////////
Pdef(\beat,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \beat,
			\n, Pseq([Prand([0,2,5,1,3,4,7,6])], inf),
			\speed, Pseq([Prand([0.8, 1.2, 2])], inf),
			\dur, Pseq([2, Rest(0)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.5, 0.25, 0], inf),
			\size, Pseq([0.5, 0.25, 0], inf),
			\gain, 0.85,
			\orbit, ~out1
		)
	])
);

//// DubGround /////////////////////////////////////////////////////////////////
Pdef(\dubground,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \samples,
			\n, Pseq([Pwrand([0], [10].normalizeSum, inf)], inf),
			\speed, Pseq([Prand([0.8, 1.1, 1])], inf),
			\dur, Pseq([3, Rest(1)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.5, 0.25, 0], inf),
			\size, Pseq([0.5, 0.25, 0], inf),
			\gain, 0.75,
			\orbit, ~out1
		)
	])
);

//// sellotape /////////////////////////////////////////////////////////////////
Pdef(\sellotape,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \sellotape,
			\n, Pseq([Prand([0,1,2])], inf),
			\speed, Pseq([Prand([2, 1, 0.6])], inf),
			\dur, Pseq([8, Rest(3)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.75, 0.25, 0], inf),
			\size, Pseq([0.75, 0.25, 0], inf),
			\gain, 1,
			\orbit, ~out1
		)
	])
);

//// paperrip //////////////////////////////////////////////////////////////////
Pdef(\paperrip,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \Paper,
			\n, Pseq([Prand([8,9])], inf),
			\speed, Pseq([Prand([2, 1, 0.6])], inf),
			\dur, Pseq([6, Rest(0)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.75, 0.25, 0], inf),
			\size, Pseq([0.75, 0.25, 0], inf),
			\gain, 1.2,
			\orbit, ~out1
		)
	])
);

//// bubblewrap ////////////////////////////////////////////////////////////////
Pdef(\bubblewrap,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \bubblewrap,
			\n, Pseq([Prand([0])], inf),
			\speed, Pseq([Prand([1, 0.8])], inf),
			\dur, Pseq([4, Rest(4)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.75, 0.25, 0], inf),
			\size, Pseq([0.75, 0.25, 0], inf),
			\gain, 0.85,
			\orbit, ~out1
		)
	])
);

//// synthpluck ////////////////////////////////////////////////////////////////
Pdef(\synthpluck,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \segments,
			\n, Pseq([Prand([0])], inf),
			\speed, Pseq([Prand([0.8, 0.9])], inf),
			\dur, Pseq([4, Rest(0)], inf),
			\pan, Pseq([Prand([0.25, 0.75, 1])], inf),
			\room, Pseq([0.75, 0.25, 0], inf),
			\size, Pseq([0.75, 0.25, 0], inf),
			\gain, 1,
			\orbit, ~out1
		)
	])
);

//// synthpluck2 ///////////////////////////////////////////////////////////////
Pdef(\synthpluck2,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \segments,
			\n, Pseq([Prand([7])], inf),
			\speed, Pseq([Prand([1.3, 1.1])], inf),
			\dur, Pseq([4, Rest(0)], inf),
			\pan, Pseq([Prand([0.25, 0.75, 1])], inf),
			\room, Pseq([0.75, 0.25, 0], inf),
			\size, Pseq([0.75, 0.25, 0], inf),
			\gain, 1,
			\orbit, ~out1
		)
	])
);

//// chordpluck ////////////////////////////////////////////////////////////////
Pdef(\chordpluck,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \segments,
			\n, Pseq([Prand([1])], inf),
			\speed, Pseq([Prand([1.5, 2, 3])], inf),
			\dur, Pseq([2, Rest(0)], inf),
			\pan, Pseq([Prand([0.25, 0.75, 1])], inf),
			\room, Pseq([0.75, 0.25, 0], inf),
			\size, Pseq([0.75, 0.25, 0], inf),
			\gain, 0.85,
			\orbit, ~out1
		)
	])
);

//// percrump //////////////////////////////////////////////////////////////////
Pdef(\percrump,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \segments,
			\n, Pseq([Prand([2])], inf),
			\speed, Pseq([Prand([1, 0.9])], inf),
			\dur, Pseq([2, Rest(0)], inf),
			\pan, Pseq([Prand([0.25, 0.75, 1])], inf),
			\room, Pseq([0.75, 0.25, 0], inf),
			\size, Pseq([0.75, 0.25, 0], inf),
			\gain, 0.85,
			\orbit, ~out1
		)
	])
);

//// peratmos /////////////////////////////////////////////////////////// ///////
Pdef(\peratmos,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \segments,
			\n, 3,
			\speed, Pseq([Prand([0.4, 0.8])], inf),
			\dur, Pseq([Pwrand([0.1, 0.2, 1], [30, 15, 1].normalizeSum, inf)], inf),
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.3, 0.25], inf),
			\size, Pseq([0.3, 0.25], inf),
			\gain, 0.65,
			\orbit, ~out1
		),
	])
);

//// padwater //////////////////////////////////////////////////////////////////
Pdef(\padwater,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \segments,
			\n, 4,
			\speed, Pseq([Prand([0.3, 0.5, 0.7])], inf),
			\dur, Pseq([Pwrand([0.1, 0.2, 1], [30, 15, 1].normalizeSum, inf)], inf),
			// \resonance, Pseq([0.9, 0.2, 0.3], inf),
			\phaserrate, 0.4,
			\phaserdepth, 0.8,
			\pan, Pseq([Prand([0, 0.25, 0.75, 1])], inf),
			\room, Pseq([0.5, 0.25], inf),
			\size, Pseq([0.5, 0.25], inf),
			\gain, 0.7,
			\orbit, ~out3
		),
	])
);

//// bassy /////////////////////////////////////////////////////////////////////
Pdef(\bassy,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \segments,
			\n, Pseq([Prand([5, 6])], inf),
			\speed, Pseq([Prand([1, 0.9])], inf),
			\dur, Pseq([2, Rest(1)], inf),
			\pan, Pseq([Prand([0.75, 1])], inf),
			\room, Pseq([0.75, 0.25, 0], inf),
			\size, Pseq([0.75, 0.25, 0], inf),
			\gain, 0.9,
			\orbit, ~out1
		)
	])
);


//// sands /////////////////////////////////////////////////////////////////////
Pdef(\sands,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \sands,
			\n, 0,
			\speed, Pseq([Prand([1, 0.4, 0.7, 1.4])], inf),
			\dur, Pseq([5, 4, 3, 2, 1, Rest(16)], inf),
			// \dur, Pseq([5, 4, 3, 2, 1], inf),
			// \dur, 5,
			// \pan, Pseq([Prand([0.75, 1])], inf),
			// \resonance, Pseq([0.9, 0.2, 0.3], inf),
			\phaserrate, 0.4,
			\phaserdepth, 0.2,
			\room, Pseq([0.75, 0.25, 0], inf),
			\size, Pseq([0.75, 0.25, 0], inf),
			\shape, 0.1,
			\hcutoff, Pseq([Prand([750, 900, 1200, 1500])], inf),
			// \crush, Pwrand([50, 4], [20, 1].normalizeSum, inf),
			// \crush, 4,
			\pan, Pseq([Prand([0.1, 0.9])], inf),
			\gain, Pseq([Prand([0.8, 0.8, 1.0, 1.2])], inf),
			\orbit, ~out1
		)
	])
);


//// bouncer //////////////////////////////////////////////////////////////////
Pdef(\bouncer,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \bouncer,
			\n, 0,
			\speed, Pseq([1, 0.8, 1, 1, 8], inf),
			// \dur, Pseq([2, 1, 1/2, 1/4, 1/6, 1/8, 1/2, Rest(8)], inf),
			\dur, Pseq([2, 1/2, Rest(18)], inf),
			// \pan, Pseq([Prand([0.75, 1])], inf),
			// \resonance, Pseq([0.9, 0.2, 0.3], inf),
			\room, Pseq([0.75, 0.25, 0, 0.6], inf),
			\size, Pseq([0.75, 0.25, 0], inf),
			\phaserrate, 0.4,
			\phaserdepth, 0.4,
			\shape, 0.8,
			\hcutoff, 300,
			\cutoff, 4500,
			\crush, Pwrand([50, 6], [20, 1].normalizeSum, inf),
			\gain, Pseq([1.0, 0.7, 1], inf),
			\orbit, ~out1
		)
	])
);

//// spinner //////////////////////////////////////////////////////////////////
Pdef(\spinner,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \spinner,
			\n, 0,
			\speed, Pseq([1, 0.8, 1, 1, 8], inf),
			\dur, Pseq([2, 1, 1/2, 1/4, 1/6, 1/8, 1/2, Rest(8)], inf),
			// \pan, Pseq([Prand([0.75, 1])], inf),
			// \resonance, Pseq([0.9, 0.2, 0.3], inf),
			\room, Pseq([0.75, 0.25, 0, 0.6], inf),
			\size, Pseq([0.75, 0.25, 0], inf),
			// \phaserrate, 0.4,
			// \phaserdepth, 0.4,
			// \shape, 0.4,

			// \cutoff, 4500,
			// \crush, Pwrand([50, 6], [20, 1].normalizeSum, inf),
			\delaytime, Pwrand([1/3, 1/8, 1/4, 1/2], [20, 15, 10, 15].normalizeSum, inf),
			\delay, 0.8,
			\delayfeedback, 0.3,
			\gain, Pseq([0.9, 0.7, 0.8], inf),
			\orbit, ~out1
		)
	])
);

//// space //////////////////////////////////////////////////////////////////
Pdef(\space,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \space,
			\n, 1,
			\speed, Pseq([1], inf),
			\dur, Pseq([1.8, 1.8, Rest(32)], inf),
			\begin, Pseq([0.0, 0.1, 0.2, 0.3, 0.4], inf),
			\end, Pseq([0.2, 0.3, 0.4, 0.5, 0.6], inf),
			// \shape, 0.4,
			\hcutoff, Pexprand(550, 1000, inf),
			// \hcutoff, Pfuncn({ |x| if(x > (1/2), 150, 5000) }, inf) <> Pkey(\dur),
			// \djf, 0.7,
			// \cutoff, 500,
			\room, Pseq([0.55, 0.25, 0], inf),
			\size, Pseq([0.2, 0.55, 0.25, 0], inf),
			\pan, Pseq([Prand([0.4, 0.6])], inf),
			\gain, 1.2,
			\orbit, ~out1
		)
	])
);

//// crackle //////////////////////////////////////////////////////////////////
Pdef(\crackle,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \crackle,
			\n, 0,
			\speed, Pseq([0.7], inf),
			\dur, 6.5,
			// \begin, Pseq([0.0, 0.1, 0.2, 0.3, 0.4], inf),
			// \end, Pseq([0.2, 0.3, 0.4, 0.5, 0.6], inf),
			// \shape, 0.4,
			\hcutoff, Pexprand(150, 1000, inf),
			// \room, Pseq([0.55, 0.25, 0], inf),
			// \size, Pseq([0.2, 0.55, 0.25, 0], inf),
			\pan, Pseq([Prand([0.4, 0.6])], inf),
			\gain, 0.8,
			\orbit, ~out1
		)
	])
);

//// submsp //////////////////////////////////////////////////////////////////
Pdef(\submsp,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, \msp,
			\n, 0,
			\speed, Pseq([0.8, 1, 0.7], inf),
			\dur, Pseq([4, 3, Rest(12)], inf),
			// \dur, 3,
			// \pan, Pseq([Prand([0.75, 1])], inf),
			\phaserrate, 0.4,
			\phaserdepth, 0.6,
			\shape, 0.1,
			\gain, 1.3,
			\orbit, ~out1
		)
	])
);

//// dancestabs /////////////////////////////////////////////////////////////
Pdef(\dancestabs,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, "m-r-play".asSymbol,
			\n, 4,
			\speed, 1,
			\begin, 0,
			// \end, 0.023,
			// \dur, 3.43,
			\dur, 110,
			// \dur, Pseq([4, 3, Rest(5)], inf),
			// \pan, Pseq([Prand([0.75, 1])], inf),
			\phaserrate, 0.4,
			\phaserdepth, 0.6,
			\shape, 0.2,
			\hcutoff, 650,
			\delaytime, Pwrand([1/4, 1/2, 1/3], [10, 15, 5].normalizeSum, inf),
			\delay, 0.5,
			\delayfeedback, 0.8,
			\gain, 1.5,
			\orbit, ~out1
		)
	])
);


//// volcano /////////////////////////////////////////////////////////////
Pdef(\volcano,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, "volcano".asSymbol,
			\n, Pseq([Prand([0,1,2,3,4,5])], inf),
			// \speed, 1,
			\speed, Pseq([1, 0.5, 0.1], inf),
			\begin, 0,
			// \end, 0.023,
			// \dur, 3.43,
			// \dur, 110,
			\dur, Pseq([8, 16, Rest(32)], inf),
			\pan, Pseq([Prand([0.25, 0.75])], inf),
			// \phaserrate, 0.4,
			// \phaserdepth, 0.6,
			// \shape, 0.2,
			\hcutoff, Pseq([30, 150, 300, 450, 750], inf),
			// \delaytime, Pwrand([1/4, 1/2, 1/3], [10, 15, 5].normalizeSum, inf),
			// \delay, 0.5,
			// \delayfeedback, 0.8,
			\gain, 1.5,
			\orbit, ~out1
		)
	])
);

//// VDMX Ocean /////////////////////////////////////////////////////////////
Pdef(\vdmxocean,
	Ppar([
		Pbind(
			\type, \dirt,
			\s, "vdmx-ocean".asSymbol,
			\n,Pseq([Prand([0,1,2,3,4,5])], inf),
			// \speed, 1,
			\speed, Pseq([Prand([0.7, 0.5, 0.3, 0.1])], inf),
			\begin, 0,
			// \end, 0.023,
			// \dur, 3.43,
			// \dur, 110,
			\dur, Pseq([Prand([8, 16, 24, 4])], inf),
			\pan, Pseq([Prand([0.25, 0.75])], inf),
			// \phaserrate, 0.4,
			// \phaserdepth, 0.6,
			// \shape, 0.2,
			\hcutoff, Pseq([30, 150, 300, 450, 750], inf),
			// \delaytime, Pwrand([1/4, 1/2, 1/3], [10, 15, 5].normalizeSum, inf),
			// \delay, 0.5,
			// \delayfeedback, 0.8,
			\gain, 1.2,
			\orbit, ~out1
		)
	])
);





// "".postln;
// "List all sequences........".postln;
// Pdef.all.do(_.postln);
)

// PdefAllGui(Pdef.all.size);



