% German Concert D
clear;
clc;

resource_path = "resources/German Concert D/";
downsampling_factor = 10;
auto_basef_estimation = false;

jsondata.name = 'German Concert D';
jsondata.index = [];
jsondata.list = [];

waitbar_obj = waitbar(0, 'Generating ...');
range = 21 : 108;
for idx = range
    audio_filename = "German Concert D " + sprintf('%03d', idx) + " 083.wav";
    [audio_waves, audio_fs] = audioread(resource_path + audio_filename);
    
    if auto_basef_estimation
        manual_basef = false;
    else
        manual_basef = 440 * (2 ^ ((idx - 69) / 12));
    end
    samparam = sample2samparam(audio_waves, audio_fs, downsampling_factor, manual_basef);
    
    jsondata.index = [jsondata.index, samparam.basef];
    jsondata.list = [jsondata.list, samparam];

    progress = (idx - range(1)) / length(range);
    waitbar(progress, waitbar_obj, sprintf('Generating... No. %d%', idx));
end

file = fopen('configs/piano_' + string(range(1)) + '_' + string(range(end)) + '_ds' + string(downsampling_factor) + '_abe=' + string(auto_basef_estimation) + '.json', 'w');
fprintf(file, '%s', jsonencode(jsondata));
fclose(file);

close(waitbar_obj);
