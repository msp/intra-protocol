(

"OSC =========================================".postln;
OSCdef.freeAll;



OSCdef(\receiveFxTrigPitchShift, {
	| msg, time, addr, recvPort |

	if (msg[3] > 0.0) {
		'fxTrigPitchShift >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'.postln;
		// msg[3].postln;
		~oscClient.sendMsg("/fx/pitchShift", 1);
	}{
		~oscClient.sendMsg("/fx/pitchShift", 0);
	}
}, '/fxTrigPitchShift');

OSCdef(\receiveFxFilter, {
	| msg, time, addr, recvPort |

	if (msg[3] > 0.0) {
		'fxTrigFilter >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'.postln;
		// msg[3].postln;
		~oscClient.sendMsg("/fx/filter", 1);
	}{
		~oscClient.sendMsg("/fx/filter", 0);
	}
}, '/fxTrigFilter');

OSCdef(\receiveFxReverb, {
	| msg, time, addr, recvPort |

	if (msg[3] > 0.0) {
		'fxTrigReverb >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'.postln;
		// msg[3].postln;
		~oscClient.sendMsg("/fx/reverb", 1);
	}{
		~oscClient.sendMsg("/fx/reverb", 0);
	}
}, '/fxTrigReverb');

OSCdef(\receiveFxComb1, {
	| msg, time, addr, recvPort |

	if (msg[3] > 0.0) {
		'fxTrigComb1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'.postln;
		// msg[3].postln;
		~oscClient.sendMsg("/fx/comb1", 1);
	}{
		~oscClient.sendMsg("/fx/comb1", 0);
	}
}, '/fxTrigComb1');

OSCdef(\receiveFxComb2, {
	| msg, time, addr, recvPort |

	if (msg[3] > 0.0) {
		'fxTrigComb2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'.postln;
		// msg[3].postln;
		~oscClient.sendMsg("/fx/comb2", 1);
	}{
		~oscClient.sendMsg("/fx/comb2", 0);
	}
}, '/fxTrigComb2');

OSCdef(\receiveFxLatch, {
	| msg, time, addr, recvPort |

	if (msg[3] > 0.0) {
		'fxTrigLatch >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'.postln;
		// msg[3].postln;
		~oscClient.sendMsg("/fx/latch", 1);
	}{
		~oscClient.sendMsg("/fx/latch", 0);
	}
}, '/fxTrigLatch');


)