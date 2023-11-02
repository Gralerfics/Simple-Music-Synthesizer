function wave = samparam2wave(samparam, sec, stop_sec, fs)
    basef = samparam.basef;
    harmonics = samparam.harmonics;

    wave_t = linspace(0, sec, fs * sec);
    wave = zeros(size(wave_t));

    for i = 1 : length(harmonics)
        wave = wave + harmonics(i) * sin(2 * pi * (i * basef) * wave_t);
    end

    sample_envelope = samparam.envelope.data;
    sample_fs = samparam.envelope.fs;
    sample_t = (1 : length(sample_envelope)) / sample_fs;

%     if basef >= 20
%         cutoff_frequency = 20 * basef;
%         [b, a] = butter(5, cutoff_frequency / (0.5 * length(sample_envelope)), 'low');
%         sample_envelope = filter(b, a, sample_envelope);
%     end

    envelope = interp1(sample_t, sample_envelope, wave_t, 'linear');
    envelope(isnan(envelope)) = 0;
    wave = wave .* envelope;
    wave = wave / max(wave);

    stop_pts = floor(stop_sec * fs);
    wave(end - stop_pts : end) = wave(end - stop_pts : end) .* linspace(1, 0, stop_pts + 1);
end
