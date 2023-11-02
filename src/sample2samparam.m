function sample_param = sample2samparam(audio_waves, audio_fs, downsampling_factor, manual_basef)
    audio_waves = audio_waves(:, 1); % channel
    
    % downsample to decrease the size of config files
    audio_waves = interp1(1 : length(audio_waves), audio_waves, 1 : downsampling_factor : length(audio_waves), 'linear');
    audio_fs = audio_fs / downsampling_factor;

    audio_waves = audio_waves / max(audio_waves);
    audio_len = length(audio_waves);
    
    pts_len = 2 ^ nextpow2(audio_len);
    spec = abs(fft(audio_waves, pts_len) / audio_len);
    spec = spec / max(spec);
    spec = spec(1 : ceil(pts_len / 2));
    
    f_step = audio_fs / pts_len;
    f_range = audio_fs / 2 - f_step;
    pts_range = length(spec);
    
    if manual_basef
        basef = manual_basef;
    else
        [~, pts_basef] = max(spec);
        basef = f_step * pts_basef;
    end

    f_search_radius = basef / 2;
    pts_search_radius = floor(f_search_radius / f_step);
    
    harmonics = 1;
    for f_key = 2 * basef : basef : f_range
        pts_cur = floor(f_key / f_step);
        pts_left = max(1, pts_cur - pts_search_radius);
        pts_right = min(pts_cur + pts_search_radius, pts_range);
        harmonics = [harmonics, max(spec(pts_left : pts_right))];
    end
    weights_effective_idx = find(harmonics > 0.02);
    harmonics = harmonics(1 : weights_effective_idx(end));
    
    % Envelope
    % audio_envelope = abs(hilbert(audio_waves));
    audio_envelope = movmax(abs(audio_waves), 2 / basef * audio_fs);

    sample_param = struct( ...
        "basef", basef, ...
        "harmonics", harmonics, ...
        "envelope", struct( ...
            "data", audio_envelope, ...
            "fs", audio_fs ...
        ) ...
    );
end
