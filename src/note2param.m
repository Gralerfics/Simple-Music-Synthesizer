function [tone, noctave, rising, rhythm, link] = note2param(note)
    counts = containers.Map({'&', '^', 'v', '#', 'b', '.', '_', '-'}, zeros(1, 8));
    for peek = counts.keys
        counts(peek{1}) = length(strfind(note, peek{1}));
    end
    
    tone = str2double(regexp(note, '\d', 'match'));
    noctave = counts('^') - counts('v');
    rising = counts('#') - counts('b');
    rhythm = (0.25 + counts('.') * 0.125) * 0.5 ^ counts('_') + counts('-') * 0.25;
    link = counts('&') > 0;
end
