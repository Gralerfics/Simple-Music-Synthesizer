function freq = tone2freq(tone, scale, noctave, rising)
    if tone == 0
        freq = 0;
    else
        base_map = [0, 2, 4, 5, 7, 9, 11];
        scale_map = [-9, -7, -5, -4, -2, 0, 2];
        n_0 = base_map(tone) + rising;
        f_0 = 440 * 2 ^ ((n_0 + scale_map(scale)) / 12);
        freq = f_0 * 2 ^ noctave;
    end
end
