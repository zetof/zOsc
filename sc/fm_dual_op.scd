s.boot;

(
MIDIClient.init;
MIDIIn.connectAll;

~fm_mod = Bus.audio(s, 1);

MIDIdef.noteOn(\lpk25_on, {
	arg vel, nn, chan, src;
	~notes[nn] = Synth.new(\fm_mod_2,
		[\midinote, nn,
			\vol, ~vol,
			\mod_atk_time, ~adsr_1_a,
			\mod_dec_time, ~adsr_1_d,
			\mod_sus_lvl, ~adsr_1_s,
			\mod_rel_time, ~adsr_1_r,
			\mod_ratio_coarse, ~ratio_coarse_1,
			\mod_ratio_fine, ~ratio_fine_1,
			\mod_offset_coarse, ~offset_coarse_1,
			\mod_offset_fine, ~offset_fine_1,
			\feedback, ~feed_1,
			\car_atk_time, ~adsr_2_a,
			\car_dec_time, ~adsr_2_d,
			\car_sus_lvl, ~adsr_2_s,
			\car_rel_time, ~adsr_2_r,
			\car_ratio_coarse, ~ratio_coarse_2,
			\car_ratio_fine, ~ratio_fine_2,
			\car_offset_coarse, ~offset_coarse_2,
			\car_offset_fine, ~offset_fine_2,
			\mod_inx, ~mod_2,
			\output_channel, ~fm_mod
	]);
});
MIDIdef.noteOff( \lpk25_off, {
	arg vel, nn;
	~notes[nn].set(\gate, 0);
	~notes[nn] = nil;
});

~osc_freq = {
	arg mn, rc, rf, oc, of;
	mn.midicps * (rc + rf) + oc + of;
};

SynthDef.new(\fm_mod_2, {
	arg midinote,
	vol,
	mod_atk_time, mod_dec_time, mod_sus_lvl, mod_rel_time,
	mod_ratio_coarse, mod_ratio_fine, mod_offset_coarse, mod_offset_fine,
	feedback,
	car_atk_time, car_dec_time, car_sus_lvl, car_rel_time,
	car_ratio_coarse, car_ratio_fine, car_offset_coarse, car_offset_fine,
	mod_inx,
	gate = 1, output_channel = 0;

	var modulator, carrier, mod_freq, car_freq, mod_adsr, car_adsr;

	mod_freq = ~osc_freq.value(midinote, mod_ratio_coarse, mod_ratio_fine, mod_offset_coarse, mod_offset_fine);
	car_freq = ~osc_freq.value(midinote, car_ratio_coarse, car_ratio_fine, car_offset_coarse, car_offset_fine);

	mod_adsr = EnvGen.ar(Env.adsr(mod_atk_time, mod_dec_time, mod_sus_lvl, mod_rel_time), gate:gate);
	car_adsr = EnvGen.ar(Env.adsr(car_atk_time, car_dec_time, car_sus_lvl, car_rel_time), gate:gate, doneAction:2);

	modulator = SinOscFB.ar(mod_freq, feedback);
	modulator = (mod_inx / 10) * mod_freq * mod_adsr * modulator;

	carrier = SinOsc.ar(car_freq + modulator);
	carrier = (vol / 100) * car_adsr * carrier;

	Out.ar(output_channel, carrier);
}).add;

SynthDef.new(\lfo, {
	arg input_channel, freq = 10, width = 0.1;
	var input_signal, lfo;
	input_signal = In.ar(input_channel, 1);
	lfo = LFPulse.ar(freq, width:width);
	Out.ar(0, lfo * input_signal);
}).add;

l = Synth.new(\lfo,
		[\input_channel, ~fm_mod], s , \addToTail);

l.set(\freq, 5);
l.set(\width, 0.3);

~notes = Array.newClear(128);

~vol = 0.25;

~adsr_1_a = 0.05;
~adsr_1_d = 1;
~adsr_1_s = 0.8;
~adsr_1_r = 2;
~ratio_coarse_1 = 1;
~ratio_fine_1 = 0;
~offset_coarse_1 = 0;
~offset_fine_1 = 0;
~feed_1 = 0;

~adsr_2_a = 0.05;
~adsr_2_d = 1;
~adsr_2_s = 0.8;
~adsr_2_r = 2;
~ratio_coarse_2 = 1;
~ratio_fine_1 = 0;
~offset_coarse_1 = 0;
~offset_fine_1 = 0;
~mod_2 = 0;

OSCdef.new(\fm_synth, {

	arg msg, time, addr, port;
	msg.postln;
	if(msg[1] == 'vol', {~vol = msg[3].linlin(0, 100, 0, 1)});

	if(msg[1] == 'adsr_1_a', {~adsr_1_a = msg[3].linlin(0, 100, 0, 5)});
	if(msg[1] == 'adsr_1_d', {~adsr_1_d = msg[3].linlin(0, 100, 0, 5)});
	if(msg[1] == 'adsr_1_s', {~adsr_1_s = msg[3].linlin(0, 100, 0, 1)});
	if(msg[1] == 'adsr_1_r', {~adsr_1_r = msg[3].linlin(0, 100, 0, 5)});
	if(msg[1] == 'ratio_coarse_1', {~ratio_coarse_1 = msg[3].linlin(0, 100, 1, 10)});
	if(msg[1] == 'ratio_fine_1', {~ratio_fine_1 = msg[3].linlin(0, 100, -1, 1)});
	if(msg[1] == 'offset_coarse_1', {~offset_coarse_1 = msg[3].linlin(0, 100, -1000, 1000)});
	if(msg[1] == 'offset_fine_1', {~offset_fine_1 = msg[3].linlin(0, 100, -100, 100)});
	if(msg[1] == 'feed_1', {~feed_1 = msg[3].linlin(0, 100, 0, 5)});

	if(msg[1] == 'adsr_2_a', {~adsr_2_a = msg[3].linlin(0, 100, 0, 5)});
	if(msg[1] == 'adsr_2_d', {~adsr_2_d = msg[3].linlin(0, 100, 0, 5)});
	if(msg[1] == 'adsr_2_s', {~adsr_2_s = msg[3].linlin(0, 100, 0, 1)});
	if(msg[1] == 'adsr_2_r', {~adsr_2_r = msg[3].linlin(0, 100, 0, 5)});
	if(msg[1] == 'ratio_coarse_2', {~ratio_coarse_2 = msg[3].linlin(0, 100, 1, 10)});
	if(msg[1] == 'ratio_fine_2', {~ratio_fine_2 = msg[3].linlin(0, 100, -1, 1)});
	if(msg[1] == 'offset_coarse_2', {~offset_coarse_2 = msg[3].linlin(0, 100, -1000, 1000)});
	if(msg[1] == 'offset_fine_2', {~offset_fine_2 = msg[3].linlin(0, 100, -100, 100)});
	if(msg[1] == 'mod_2', {~mod_2 = msg[3]});

}, '/fm_synth');
)