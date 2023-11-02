% clear;
% clc;

%% Analysis
resource_path = "resources/German Concert D/";

% audio_filename = "German Concert D 086 083.wav";
audio_filename = "German Concert D 050 083.wav";

[audio_waves, audio_fs] = audioread(resource_path + audio_filename);
param = sample2samparam(audio_waves, audio_fs, 1, false);

%% Synth
sec = 5;
fs = 8000;

waves_syn = samparam2wave(param, sec, 0.05, fs);
sound(waves_syn, fs);
