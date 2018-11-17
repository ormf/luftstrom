s=Server(\myServer,NetAddr("localhost",57110));
Server.supernova;
Server.scsynth;
Server.default = s;
s.plotTree;
Stethoscope.new;
s.quit;
/ s.boot;
s.boot;
s.options.memSize = 1048576;


s.options.maxNodes = 65536;
s.options.memSize.postln;

(
SynthDef("lfo-click-2d-out", {
	arg pitch = 0.8, amp=0.8, dur = 0.5, suswidth = 0, suspan = 0,
	decaystart = 0.001 , decayend = 0.0035, lfofreq = 10, xpos = 0.5, ypos = 0.5, ioffs = 0;
	
	var lfo, innerphase, innerenv, lfoenv, sig, outerenv;
	 
	outerenv = EnvGen.ar(Env([0, 1,1,0], [suspan*(1-suswidth),suswidth, (1-suspan)*(1-suswidth) ], curve: 'cub')
		, timeScale:dur, doneAction:2);
	lfo = Impulse.ar(lfofreq);
	innerphase = Phasor.ar(lfo, 1, 0, 2000000);
	innerenv = Env([1, 1,1,0], [0, decaystart, (decayend-decaystart)] , [0,0,-30]);
	lfoenv = EnvGen.ar(innerenv,lfo);
	sig = 	SinOsc.ar(0, ((innerphase**pitch)+(0.5*pi)).mod(2pi));
	Out.ar(0, Pan2.ar(sig*lfoenv*amp*outerenv, xpos));
};).load(s);
)

(
SynthDef("lfo-click-2d-out", {
	arg pitch = 0.8, amp=0.8, dur = 0.5, suswidth = 0, suspan = 0,
	decaystart = 0.001 , decayend = 0.0035, lfofreq = 10, xpos = 0.5, ypos = 0.5, ioffs = 0;
	
	var lfo, innerphase, innerenv, lfoenv, sig, outerenv;
	 
	outerenv = EnvGen.ar(Env([0, 1,1,0], [suspan*(1-suswidth),suswidth, (1-suspan)*(1-suswidth) ], curve: 'cub')
		, timeScale:dur, doneAction:2);
	lfo = Impulse.ar(lfofreq);
	innerphase = Phasor.ar(lfo, 1, 0, 2000000);
	innerenv = Env([1, 1,1,0], [0, decaystart, (decayend-decaystart)] , [0,0,-30]);
	lfoenv = EnvGen.ar(innerenv,lfo);
	sig = 	SinOsc.ar(lfofreq, 0);
	Out.ar(0, Pan2.ar(sig*amp*outerenv, xpos));
};).load(s);
)


(
SynthDef("lfo-click-2d-out", {
	arg pitch = 0.8, amp=0.8, dur = 0.5, suswidth = 0, suspan = 0,
	decaystart = 0.001 , decayend = 0.0035, lfofreq = 10, xpos = 0.5, ypos = 0.5, ioffs = 0, wet = 1, filtfreq = 22000;
	
	var lfo, innerphase, innerenv, lfoenv, sig, outerenv;
	 
	outerenv = EnvGen.ar(Env([0, 1,1,0], [suspan*(1-suswidth),suswidth, (1-suspan)*(1-suswidth) ], curve: 'cub')
		, timeScale:dur, doneAction:2);
	lfo = Impulse.ar(lfofreq);
	innerphase = Phasor.ar(lfo, 1, 0, 2000000);
	innerenv = Env([0, 1,1,0], [ioffs, decaystart-ioffs, (decayend-decaystart-ioffs)] , [30,0,-30]);
	lfoenv = EnvGen.ar(innerenv,lfo);
	sig = 	SinOsc.ar(0, ((innerphase**pitch)+(0.5*pi)).mod(2pi), wet);
	Out.ar(0, Pan2.ar(LPF.ar((sig*lfoenv)+SinOsc.ar(lfofreq,0,(1-wet))*amp*outerenv, filtfreq), xpos));
};).load(s);
)

(
SynthDef("lfo-click-2d-bpf-out", {
	arg pitch = 0.8, amp=0.8, dur = 0.5, suswidth = 0, suspan = 0,
	decaystart = 0.001 , decayend = 0.0035, lfofreq = 10, xpos = 0.5, ypos = 0.5, ioffs = 0, wet = 1,
	filtfreq = 22000 , bpfreq = 10000, bprq = 100;
	
	var lfo, innerphase, innerenv, lfoenv, sig, outerenv;
	 
	outerenv = EnvGen.ar(Env([0, 1,1,0], [suspan*(1-suswidth),suswidth, (1-suspan)*(1-suswidth) ], curve: 'cub')
		, timeScale:dur, doneAction:2);
	lfo = Impulse.ar(lfofreq);
	innerphase = Phasor.ar(lfo, 1, 0, 2000000);
	innerenv = Env([0, 1,1,0], [ioffs, decaystart-ioffs, (decayend-decaystart-ioffs)] , [30,0,-30]);
	lfoenv = EnvGen.ar(innerenv,lfo);
	sig = 	SinOsc.ar(0, ((innerphase**pitch)+(0.5*pi)).mod(2pi), wet);
	sig = BPF.ar((sig*lfoenv)+SinOsc.ar(lfofreq,0,(1-wet))*amp*outerenv, bpfreq, bprq);
	Out.ar(0, Pan2.ar(LPF.ar(sig, filtfreq), xpos));
};).load(s);
)



Synth("lfo-click-2d-out", [dur: 4] );
// s.quit;
(
Synth("lfo-click-2d-out", [
 pitch: 0.6,
   amp: 2,
   dur: 0.2,
   suswidth: 1,
   suspan: 0,
   decaystart: 0.1,
   decayend: 0.2,
   lfofreq: 1,
   xpos: 0.5,
   ypos: 0.6,
	ioffs: 0.001,
	wet: 1
] );
)