////////////////////////////////////////////////////////////////////////////////
//
// SETUP
//
// Sampler and synthesizer
// https://github.com/musikinformatik/SuperDirt
//
// Duartion patches based on work by Nathan Ho
// https://nathan.ho.name
//
// Most things found and hacked from vairous sources online. Respect!
//
// We run the SETUP to define the audio system and load the SEQUENCES.
//
// The CONTROL section allows us to start/stop each sequence.
// Multiple sequences can be played together for layering.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// (1) SETUP - ensure the path to sample folder is correct
////////////////////////////////////////////////////////////////////////////////

(
// place cursor below this line and execute CMD + enter to execute the section
var foo;

s.meter;
s.plotTree;


"SETUP =========================================".postln;

// ~dirt.free;
// Server.freeAll;

// Pdef.removeAll;
// Pbindef.removeAll;

~oscClient = NetAddr.new("127.0.0.1", 1234);
SuperDirt.default = ~dirt;

// The samples need to exist on your computer!
// ~dirt.loadSoundFiles("/Users/Sally/Dropbox/oily-cart-awu-samples/*");
// ~dirt.loadSoundFiles("/Dropbox-shared/oily-cart-awu-samples/*");
~dirt.loadSoundFiles("/data/Dropbox-spatial/Dropbox/spatial/music/AudioSources/oily-cart-awu-samples/*");
~dirt.loadSoundFiles("/data/Dropbox-spatial/Dropbox/spatial/music/AudioSources/iklectik-202209/*");


// Run to test to check we have sound. You should hear a cymbal
(type:\dirt, orbit: ~out1_2, s: \bouncer, n: 0, speed: 1.0, pan: 0.25, gain: 0.8).play;
(type:\dirt, orbit: ~out1_2, s: \cr, n: 0, speed: 0.3, pan: 0.75, gain: 0.6).play;


~enginePath = PathName.new(thisProcess.nowExecutingPath.dirname+/+"engine/");
// ~enginePath.entries.postln;

~enginePath.files.do{|aFile|
	"found ----------------------------------------".postln;
    aFile.fullPath.postln;

	// 95 == '_"
	if(aFile.fileName[0].ascii != 95) {
		"loading >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>".postln;
		load(aFile.fullPath);
	} {
		"......................................(ignoring)".postln;
	};
};

"DONE SETUP ====================================".postln;
)