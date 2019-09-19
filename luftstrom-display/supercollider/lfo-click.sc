s=Server(\myServer,NetAddr("localhost",57110));
;;Server.supernova;
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
SynthDef("lfo-click-2d-bpf-4ch-out", {
	arg pitch = 0.8, amp=0.8, dur = 0.5, suswidth = 0, suspan = 0,
	decaystart = 0.001 , decayend = 0.0035, lfofreq = 10, xpos = 0.5, ypos = 0.5, ioffs = 0, wet = 1,
	filtfreq = 22000 , bpfreq = 500, bprq = 100;
	
	var lfo, innerphase, innerenv, lfoenv, sig, outerenv, front, rear;
	 
	outerenv = EnvGen.ar(Env([0, 1,1,0], [suspan*(1-suswidth),suswidth, (1-suspan)*(1-suswidth) ], curve: 'cub')
		, timeScale:dur, doneAction:2);
	lfo = Impulse.ar(lfofreq);
	innerphase = Phasor.ar(lfo, 1, 0, 2000000);
	innerenv = Env([0, 1,1,0], [ioffs, decaystart-ioffs, (decayend-decaystart-ioffs)] , [30,0,-30]);
	lfoenv = EnvGen.ar(innerenv,lfo);
	sig = 	SinOsc.ar(0, ((innerphase**pitch)+(0.5*pi)).mod(2pi), wet);
	sig = BPF.ar((sig*lfoenv)+SinOsc.ar(lfofreq,0,(1-wet))*amp*outerenv, bpfreq, bprq);
	sig=LPF.ar(sig, filtfreq);
	front=SinOsc.ar(0, (0.5*ypos)*pi,sig);
	rear=SinOsc.ar(0, ((0.5*ypos)+0.5)*pi,sig);
	Out.ar(0, Pan2.ar(front, (xpos*2)-1));
	Out.ar(2, Pan2.ar(rear, (-2*xpos)+1));
};).load(s);
)

(
SynthDef("lfo-click-2d-bpf-out", {
	arg pitch = 0.8, amp=0.8, dur = 0.5, suswidth = 0, suspan = 0,
	decaystart = 0.001 , decayend = 0.0035, lfofreq = 10, xpos = 0.5, ypos = 0.5, ioffs = 0, wet = 1,
	filtfreq = 22000 , bpfreq = 500, bprq = 100;
	
	var lfo, innerphase, innerenv, lfoenv, sig, outerenv;
	 
	outerenv = EnvGen.ar(Env([0, 1,1,0], [suspan*(1-suswidth),suswidth, (1-suspan)*(1-suswidth) ], curve: 'cub')
		, timeScale:dur, doneAction:2);
	lfo = Impulse.ar(lfofreq);
	innerphase = Phasor.ar(lfo, 1, 0, 2000000);
	innerenv = Env([0, 1,1,0], [ioffs, decaystart-ioffs, (decayend-decaystart-ioffs)] , [30,0,-30]);
	lfoenv = EnvGen.ar(innerenv,lfo);
	sig = SinOsc.ar(0, ((innerphase**pitch)+(0.5*pi)).mod(2pi), wet);
	sig = BPF.ar((sig*lfoenv)+SinOsc.ar(lfofreq,0,(1-wet))*amp*outerenv, bpfreq, bprq);
	Out.ar(0, Pan2.ar(LPF.ar(sig, filtfreq), (xpos*2)-1));
};).load(s);
)

(
SynthDef("lfo-click-2d-bpf-out", {
	arg pitch = 0.8, amp=0.8, dur = 0.5, suswidth = 0, suspan = 0,
	decaystart = 0.001 , decayend = 0.0035, lfofreq = 100, xpos = 0.5, ypos = 0.5, ioffs = 0, wet = 1,
	filtfreq = 22000 , bpfreq = 500, bprq = 100;
	
	var lfo, innerphase, innerenv, lfoenv, sig, outerenv;
	 
	outerenv = EnvGen.ar(Env([0, 1,1,0], [suspan*(1-suswidth),suswidth, (1-suspan)*(1-suswidth) ], curve: 'cub')
		, timeScale:dur, doneAction:2);
	lfo = Impulse.ar(lfofreq);
	innerphase = Phasor.ar(lfo, 1, 0, 2000000);
	innerenv = Env([0, 1,1,0], [ioffs, decaystart-ioffs, (decayend-decaystart-ioffs)] , [30,0,-30]);
	lfoenv = EnvGen.ar(innerenv,lfo);
	sig = SinOsc.ar(0, ((innerphase**pitch)+(0.5*pi)).mod(2pi), wet);
	Out.ar(0, Pan2.ar(LPF.ar(BPF.ar((sig*lfoenv)+SinOsc.ar(lfofreq,0,(1-wet))*amp*outerenv, bpfreq, bprq), filtfreq), (xpos*2)-1));
};).load(s);
)



2.get(0).postln;
Buffer(0).postln;

(
SynthDef("lfo-click-2d-bpf-vow-out", {
	arg pitch = 0.8, amp=0.8, dur = 0.5, suswidth = 0, suspan = 0,
	decaystart = 0.001 , decayend = 0.0035, lfofreq = 10, xpos = 0.5, ypos = 0.5, ioffs = 0, wet = 1,
	filtfreq = 22000 , bpfreq = 10000, bprq = 100, voicetype = 0, voicepan = 0, vowel = 0, vowelbuf = 0;

	var lfo, innerphase, innerenv, lfoenv, sig, sig1, sig2, sig3, sig4, sig5, outerenv;
	//	IndexL freq= IndexL
	outerenv = EnvGen.ar(Env([0, 1,1,0], [suspan*(1-suswidth),suswidth, (1-suspan)*(1-suswidth) ], curve: 'cub')
		, timeScale:dur, doneAction:2);
	lfo = Impulse.ar(lfofreq);
	innerphase = Phasor.ar(lfo, 1, 0, 2000000);
	innerenv = Env([0, 1,1,0], [ioffs, decaystart-ioffs, (decayend-decaystart-ioffs)] , [30,0,-30]);
	lfoenv = EnvGen.ar(innerenv,lfo);
	voicetype=Clip.kr(voicetype)*4;
	vowel=Clip.kr(vowel)*4;
	sig = 	SinOsc.ar(0, ((innerphase**pitch)+(0.5*pi)).mod(2pi), wet);
	sig= ((sig*lfoenv)+Saw.ar(lfofreq,(1-wet)));
	sig1 = ((1-voicepan) * BPF.ar(sig, IndexL.kr(vowelbuf,75*voicetype+vowel),
	 	IndexL.kr(vowelbuf,75*voicetype+5+vowel),
	 	IndexL.kr(vowelbuf,75*voicetype+10+vowel)) +
		(voicepan *  BPF.ar(sig, IndexL.kr(vowelbuf,(75*(1+voicetype)+vowel)),
			IndexL.kr(vowelbuf,(75*(1+voicetype))+5+vowel),
			IndexL.kr(vowelbuf,(75*(1+voicetype))+10+vowel))));	
	sig2 = ((1-voicepan) * BPF.ar(sig, IndexL.kr(vowelbuf,75*voicetype+15+vowel),
		IndexL.kr(vowelbuf,75*voicetype+20+vowel),
		IndexL.kr(vowelbuf,75*voicetype+25+vowel))) +
	(voicepan *  BPF.ar(sig, IndexL.kr(vowelbuf,(75*(1+voicetype))+15+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+20+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+25+vowel)));

	sig3 = ((1-voicepan) * BPF.ar(sig, IndexL.kr(vowelbuf,75*voicetype+30+vowel),
		IndexL.kr(vowelbuf,75*voicetype+35+vowel),
		IndexL.kr(vowelbuf,75*voicetype+40+vowel))) +
	(voicepan *  BPF.ar(sig, IndexL.kr(vowelbuf,(75*(1+voicetype))+30+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+35+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+40+vowel)));

	sig4 = ((1-voicepan) * BPF.ar(sig, IndexL.kr(vowelbuf,75*voicetype+45+vowel),
		IndexL.kr(vowelbuf,75*voicetype+50+vowel),
		IndexL.kr(vowelbuf,75*voicetype+55+vowel))) +
	(voicepan *  BPF.ar(sig, IndexL.kr(vowelbuf,(75*(1+voicetype))+45+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+50+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+55+vowel)));

	sig5 = ((1-voicepan) * BPF.ar(sig, IndexL.kr(vowelbuf,75*voicetype+60+vowel),
		IndexL.kr(vowelbuf,75*voicetype+65+vowel),
		IndexL.kr(vowelbuf,75*voicetype+70+vowel))) +
	(voicepan *  BPF.ar(sig, IndexL.kr(vowelbuf,(75*(1+voicetype))+60+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+65+vowel),
		IndexL.kr(vowelbuf,(75*(1+voicetype))+70+vowel)));

	//	sig = BPF.ar(((sig1+sig2+sig3+sig4+sig5)*lfoenv)+SinOsc.ar(lfofreq,0,(1-wet))*amp*outerenv, bpfreq, bprq);
	//	sig = BPF.ar(((sig)*lfoenv)+SinOsc.ar(lfofreq,0,(1-wet))*amp*outerenv, bpfreq, bprq);
	sig = (sig1+sig2+sig3+sig4+sig5)*amp*outerenv;
	Out.ar(0, Pan2.ar(LPF.ar(sig, filtfreq), (xpos*2)-1));
};).load(s);
)

Synth("lfo-click-2d-out", [dur: 4, amp: 1] );
Synth("lfo-click-2d-bpf-out", [dur: 4, amp: 2] );
Synth("lfo-click-2d-bpf-out", [dur: 4, bprq: 1000, amp: 2, lfofreq: 30] );

Synth("lfo-click-2d-bpf-vow-out", [dur: 0.5, lfofreq: 1, voicetype: 0.4, amp: 2, voicepan: 0, vowel: -0.2, vowelbuf: 0, wet: 1] );


Synth("lfo-click-2d-bpf-vow-out", [dur: 0.5, lfofreq: 1, voicetype: 0.4, amp: 2, voicepan: 0, vowel: 3, vowelbuf: 0, wet: 1] );


Synth("lfo-click-2d-bpf-out", [dur: 4, amp: 1] );


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