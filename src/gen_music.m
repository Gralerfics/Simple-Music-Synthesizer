function music = gen_music(notespec, instrument_config, sec_per_rhythm, fs)
    paramspec = notespec2paramspec(notespec.spec);
    music = [];
    for i = 1 : length(paramspec)
        tone = paramspec{i}(1);
        scale = mod(double(notespec.key{1}) - 60, 7) + 1;
        noctave = paramspec{i}(2);
        rising = paramspec{i}(3);
        rhythm = paramspec{i}(4);
        link = paramspec{i}(5); % TODO

        basef = tone2freq(tone, scale, noctave, rising);
        samparam = basef2samparam(basef, instrument_config);
        
        wave_gen = samparam2wave(samparam, rhythm * sec_per_rhythm, 0.05, fs);
        music = [music, wave_gen];
    end
end
