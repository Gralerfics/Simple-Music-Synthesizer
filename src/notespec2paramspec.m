function paramspec = notespec2paramspec(notespec)
    spec_len = length(notespec);
    
    res = cell(1, spec_len * 2);
    ptr_end = 0; % increase when adding to the list
    ptr_now = 0;
    
    is_in_rept = false;
    ptr_rept_head = -1;
    ptr_rept_tail = -1;

    rhythm_count = 0;
    beat_count = 0;
    
    while true
        ptr_now = ptr_now + 1;
        if ptr_now > spec_len
            break
        end
        peek = notespec(ptr_now);

        disp(ptr_now);
        
        if peek == ""
            % TODO: Adaptive rhythm
        elseif contains(peek, '|')
            % disp([rhythm_count, beat_count]);
            rhythm_count = 0;
            beat_count = beat_count + 1;

            if peek == "||:"
                ptr_rept_head = ptr_now;
            elseif peek == "||"
                if is_in_rept
                    ptr_now = ptr_rept_tail;
                    is_in_rept = false;
                end
            elseif peek == ":||"
                if is_in_rept
                    is_in_rept = false;
                else
                    ptr_rept_tail = ptr_now;
                    ptr_now = ptr_rept_head;
                    is_in_rept = true;
                end
            end
        else
            [tone, noctave, rising, rhythm, link] = note2param(peek);

            rhythm_count = rhythm_count + rhythm;
            if link && res{ptr_end}(1) == tone && res{ptr_end}(2) == noctave && res{ptr_end}(3) == rising
                res{ptr_end}(4) = res{ptr_end}(4) + rhythm;
            else
                ptr_end = ptr_end + 1;
                res{ptr_end} = [tone, noctave, rising, rhythm, link];
            end
        end
    end
    
    paramspec = res(1 : ptr_end);
end

% notespec: ["|", "", "", "6_", "7_", ...]
% paramspec: {[tone_1, noctave_1, rising_1, rhythm_1], [...]}
