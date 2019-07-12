(
s.boot;

SynthDef(\simple_osc, {
	arg midinote = 69, vol = 0.1;
	var freq, sin, env;
	sin = SinOsc.ar(midinote.midicps, mul:vol);
	env = EnvGen.ar(Env.perc, doneAction:2);
	Out.ar(0, sin * env)
}).add;

~midinote = 60;
~vol = 0.1;

Synth(\simple_osc);

OSCdef.new(\synth_1, {
	arg message, time, addr, port;
	message.postln;
	if(message[1] == 'slider_1', {~midinote = message[2].linlin(0, 100, 60, 84)});
	if(message[1] == 'slider_2', {~vol = message[2].linlin(0, 100, 0.1, 0.3)});
	Synth(\simple_osc, [\midinote, ~midinote, \vol, ~vol]);
}, '/synth_1');
)