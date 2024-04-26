clc;
clear all;
close all;

[data, f_s] = audioread('E:\Speech_processing_minor project\Audio-with-addedRingtones\Divya_TE_NM_EN_RT.wav');
f_size = 512;    %frame size
hop_size = 248;   % overlaping sample number
num_frames = floor((length(data) - f_size) / hop_size) + 1;
ste = zeros(num_frames, 1);


for i = 1:num_frames
    frame = data((i-1)*hop_size + 1 : (i-1)*hop_size + f_size);
    ste(i) = sum(frame.^2);
end


energy_threshold = 9.5 ; 



data_r = data;
for i = 1:num_frames
    if ste(i) > energy_threshold
        data_r((i-1)*hop_size + 1 : (i-1)*hop_size + f_size) = 0;
    end
end


audiowrite('new_filtered_audio.wav',data_r, f_s);




[data_s, f_s1] = audioread('new_filtered_audio.wav');


silence_threshold = 0.001; 


start_indices = [];
end_indices = [];
is_silent = true;
for i = 1:length(data_s)
    if abs(data_s(i)) > silence_threshold
        if is_silent
            start_indices(end+1) = i;
            is_silent = false;
        end
    else
        if ~is_silent
            end_indices(end+1) = i-1;
            is_silent = true;
        end
    end
end


if ~is_silent
    end_indices(end+1) = length(data_s);
end


trimmed_audio = [];
for i = 1:length(start_indices)
    trimmed_audio = [trimmed_audio; data_s(start_indices(i):end_indices(i))];
end


audiowrite('trimmed_audio.wav', trimmed_audio,f_s1);


subplot(3,1,1);
plot(data, 'r');
title('Audio with ringtone');

subplot(3,1,2);
plot(data_r, 'b');
title('Audio with silence zone');


subplot(3,1,3);
plot(trimmed_audio, 'k');
title('Trimmed audio signal (final output)');

