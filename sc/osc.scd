(
s.boot;

MIDIClient.init;
MIDIIn.connectAll;

MIDIdef.noteOn(\lpk25_on, {
	arg vel, nn, chan, src;
	~notes[nn] = Synth.new(\simple_osc,
		[\midinote, nn,
			\vol, ~vol,
			\main_type, ~main_type,
			\atk, ~atk,
			\dec, ~dec,
			\sus, ~sus,
			\rls, ~rls,
			\on_1, ~on_1,
			\on_2, ~on_2,
			\on_3, ~on_3,
			\on_4, ~on_4,
			\vol_1, ~vol_1,
			\vol_2, ~vol_2,
			\vol_3, ~vol_3,
			\vol_4, ~vol_4,
			\sub_type_1, ~sub_type_1,
			\sub_type_2, ~sub_type_2,
			\sub_type_3, ~sub_type_3,
			\sub_type_4, ~sub_type_4,
			\mul_coarse_1, ~mul_coarse_1,
			\mul_coarse_2, ~mul_coarse_2,
			\mul_coarse_3, ~mul_coarse_3,
			\mul_coarse_4, ~mul_coarse_4,
			\mul_fine_1, ~mul_fine_1,
			\mul_fine_2, ~mul_fine_2,
			\mul_fine_3, ~mul_fine_3,
			\mul_fine_4, ~mul_fine_4,
			\off_coarse_1, ~off_coarse_1,
			\off_coarse_2, ~off_coarse_2,
			\off_coarse_3, ~off_coarse_3,
			\off_coarse_4, ~off_coarse_4,
			\off_fine_1, ~off_fine_1,
			\off_fine_2, ~off_fine_2,
			\off_fine_3, ~off_fine_3,
			\off_fine_4, ~off_fine_4,
	]);
});
MIDIdef.noteOff( \lpk25_off, {
	arg vel, nn;
	~notes[nn].set(\gate, 0);
	~notes[nn] = nil;
});

SynthDef(\simple_osc, {
	arg midinote = 69, gate = 1,
	vol = 0.5, main_type,
	atk = 0.1, dec = 1, sus = 0.5, rls = 3,
	on_1 = 0, on_2 = 0, on_3 = 0, on_4 = 0,
	vol_1 = 0, vol_2 = 0, vol_3 = 0, vol_4 = 0,
	sub_type_1 = 0, sub_type_2 = 0, sub_type_3 = 0, sub_type_4 = 0,
	mul_coarse_1 = 1, mul_coarse_2 = 1, mul_coarse_3 = 1, mul_coarse_4 = 1,
	mul_fine_1 = 0, mul_fine_2 = 0, mul_fine_3 = 0, mul_fine_4 = 0,
	off_coarse_1 = 1, off_coarse_2 = 1, off_coarse_3 = 1, off_coarse_4 = 1,
	off_fine_1 = 0, off_fine_2 = 0, off_fine_3 = 0, off_fine_4 = 0;

	var freq, osc, env,
	freq_1, freq_2, freq_3, freq_4,
	main_synth, sub_synth_1, sub_synth_2, sub_synth_3, sub_synth_4,
	osc_1 = 0, osc_2 = 0, osc_3 = 0, osc_4 = 0;

	freq = midinote.midicps;
	freq_1 = (mul_coarse_1 + mul_fine_1) * freq + off_coarse_1 + off_fine_1;
	freq_2 = (mul_coarse_2 + mul_fine_2) * freq + off_coarse_2 + off_fine_2;
	freq_3 = (mul_coarse_3 + mul_fine_3) * freq + off_coarse_3 + off_fine_3;
	freq_4 = (mul_coarse_4 + mul_fine_4) * freq + off_coarse_4 + off_fine_4;

	main_synth = [SinOsc.ar(freq), Saw.ar(freq), Pulse.ar(freq), WhiteNoise.ar()];
	sub_synth_1 = [SinOsc.ar(freq_1), Saw.ar(freq_1), Pulse.ar(freq_1), WhiteNoise.ar()];
	sub_synth_2 = [SinOsc.ar(freq_2), Saw.ar(freq_2), Pulse.ar(freq_2), WhiteNoise.ar()];
	sub_synth_3 = [SinOsc.ar(freq_3), Saw.ar(freq_3), Pulse.ar(freq_3), WhiteNoise.ar()];
	sub_synth_4 = [SinOsc.ar(freq_4), Saw.ar(freq_4), Pulse.ar(freq_4), WhiteNoise.ar()];

	osc = Select.ar(main_type, main_synth);
	osc_1 = on_1 * vol_1 * Select.ar(sub_type_1, sub_synth_1);
	osc_2 = on_2 * vol_2 * Select.ar(sub_type_2, sub_synth_2);
	osc_3 = on_3 * vol_3 * Select.ar(sub_type_3, sub_synth_3);
	osc_4 = on_4 * vol_4 * Select.ar(sub_type_4, sub_synth_4);

	env = EnvGen.ar(Env.adsr(atk, dec, sus, rls), gate:gate, doneAction:2);

	Out.ar(0, (osc + osc_1 + osc_2 + osc_3 + osc_4) * env * vol / 5)
}).add;

~notes = Array.newClear(128);

~vol = 0.1;
~main_type = 0;
~atk = 0.1;
~dec = 1;
~sus = 0.8;
~rls = 3;
~on_1 = 0;
~on_2 = 0;
~on_3 = 0;
~on_4 = 0;
~vol_1 = 0.25;
~vol_2 = 0.25;
~vol_3 = 0.25;
~vol_4 = 0.25;
~sub_type_1 = 0;
~sub_type_2 = 0;
~sub_type_3 = 0;
~sub_type_4 = 0;
~mul_coarse_1 = 1;
~mul_coarse_2 = 1;
~mul_coarse_3 = 1;
~mul_coarse_4 = 1;
~mul_fine_1 = 0;
~mul_fine_2 = 0;
~mul_fine_3 = 0;
~mul_fine_4 = 0;
~off_coarse_1 = 0;
~off_coarse_2 = 0;
~off_coarse_3 = 0;
~off_coarse_4 = 0;
~off_fine_1 = 0;
~off_fine_2 = 0;
~off_fine_3 = 0;
~off_fine_4 = 0;

OSCdef.new(\synth_1, {
	arg msg, time, addr, port;
	msg.postln;
	if(msg[1] == 'vol', {~vol = msg[2].linlin(0, 100, 0, 1)});
	if(msg[1] == 'main_type', {~main_type = msg[2]});
	if(msg[1] == 'synth_1_a_slider', {~atk = msg[2].linlin(0, 100, 0, 5)});
	if(msg[1] == 'synth_1_d_slider', {~dec = msg[2].linlin(0, 100, 0, 5)});
	if(msg[1] == 'synth_1_s_slider', {~sus = msg[2].linlin(0, 100, 0, 1)});
	if(msg[1] == 'synth_1_r_slider', {~rls = msg[2].linlin(0, 100, 0, 5)});
	if(msg[1] == 'on_1', {~on_1 = msg[2]});
	if(msg[1] == 'on_2', {~on_2 = msg[2]});
	if(msg[1] == 'on_3', {~on_3 = msg[2]});
	if(msg[1] == 'on_4', {~on_4 = msg[2]});
	if(msg[1] == 'vol_1', {~vol_1 = msg[2].linlin(0, 100, 0, 1)});
	if(msg[1] == 'vol_2', {~vol_2 = msg[2].linlin(0, 100, 0, 1)});
	if(msg[1] == 'vol_3', {~vol_3 = msg[2].linlin(0, 100, 0, 1)});
	if(msg[1] == 'vol_4', {~vol_4 = msg[2].linlin(0, 100, 0, 1)});
	if(msg[1] == 'oscillator_1', {~sub_type_1 = msg[2]});
	if(msg[1] == 'oscillator_2', {~sub_type_1 = msg[2]});
	if(msg[1] == 'oscillator_3', {~sub_type_1 = msg[2]});
	if(msg[1] == 'oscillator_4', {~sub_type_1 = msg[2]});
	if(msg[1] == 'mul_coarse_1', {~mul_coarse_1 = msg[2].linlin(0, 100, 1, 10)});
	if(msg[1] == 'mul_coarse_2', {~mul_coarse_2 = msg[2].linlin(0, 100, 1, 10)});
	if(msg[1] == 'mul_coarse_3', {~mul_coarse_3 = msg[2].linlin(0, 100, 1, 10)});
	if(msg[1] == 'mul_coarse_4', {~mul_coarse_4 = msg[2].linlin(0, 100, 1, 10)});
	if(msg[1] == 'mul_fine_1', {~mul_fine_1 = msg[2].linlin(0, 100, -0.9, 0.9)});
	if(msg[1] == 'mul_fine_2', {~mul_fine_2 = msg[2].linlin(0, 100, -0.9, 0.9)});
	if(msg[1] == 'mul_fine_3', {~mul_fine_3 = msg[2].linlin(0, 100, -0.9, 0.9)});
	if(msg[1] == 'mul_fine_4', {~mul_fine_4 = msg[2].linlin(0, 100, -0.9, 0.9)});
	if(msg[1] == 'off_coarse_1', {~off_coarse_1 = msg[2].linlin(0, 100, 0, 1000)});
	if(msg[1] == 'off_coarse_2', {~off_coarse_2 = msg[2].linlin(0, 100, 0, 1000)});
	if(msg[1] == 'off_coarse_3', {~off_coarse_3 = msg[2].linlin(0, 100, 0, 1000)});
	if(msg[1] == 'off_coarse_4', {~off_coarse_4 = msg[2].linlin(0, 100, 0, 1000)});
	if(msg[1] == 'off_fine_1', {~off_fine_1 = msg[2].linlin(0, 100, -10, 10)});
	if(msg[1] == 'off_fine_2', {~off_fine_2 = msg[2].linlin(0, 100, -10, 10)});
	if(msg[1] == 'off_fine_3', {~off_fine_3 = msg[2].linlin(0, 100, -10, 10)});
	if(msg[1] == 'off_fine_4', {~off_fine_4 = msg[2].linlin(0, 100, -10, 10)});
}, '/synth_1');
)