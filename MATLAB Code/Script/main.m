%% Reading Audio File

% Datastore for collection of readable audio files in current MATLAB folder
ADS = audioDatastore(cd,'FileExtensions',{'.wav','.ogg','.oga','.flac','.au',...
    '.aiff','.aif','.aifc','.mp3','.m4a','.mp4'});

% Initializing 'myaudiofiles' cell array
myaudiofiles = cell(1,size(ADS.Files,1));

% Finding and displaying filenames of readable audio files and storing them in 'myaudiofiles'
fprintf('\nAudio Files:\n')
for i=1:size(ADS.Files,1)
    [~,name,ext] = fileparts(ADS.Files{i});
    myaudiofiles{i}=[name,ext];
    fprintf([num2str(i),'. ',myaudiofiles{i},'\n'])
end

% Reading audio file based on user input
infile = input('\nEnter the number corresponding to the audio file to be loaded: ');
if ismember(infile,[1:size(ADS.Files,1)])
    [in,fs] = audioread(myaudiofiles{infile});
    fprintf(['"',myaudiofiles{infile},'" successfully loaded.\n'])
else
    error('File Not Found.')
end
%% Parameter Settings
% Obtaining Potentiometer Values and error checking
sustain = input(['\nPlease enter a sustain value between 0 - 1\nSustain: ']);
if sustain > 1
    output('Invalid Sustain Value, setting to 0.5....')
    sustain = 0.5;
else if sustain < 0
    output('Invalid Sustain Value, setting to 0.5....')
    sustain = 0.5;
end
end

tone = input(['\nPlease enter a tone value between 0 - 1\nVolume: ']);
if tone > 1
    output('Invalid tone Value, setting to 0.5....')
    tone = 0.5;
else if tone < 0
    output('Invalid tone Value, setting to 0.5....')
    tone = 0.5;
end
end

gain = input(['\nPlease enter a volume value between 0 - 0.99\nVolume: ']);
if gain > 1
    output('Invalid Gain Value, setting to 0.5....')
    gain = 0.5;
else if gain < 0
        output('Invalid Gain Value, setting to 0.5....')
        gain = 0.5;
end
end

%% Distortion
% Soft Clip then Hard Clip
inCopy = sustain.*in;
g1 = 1;
g2 = 0.4;
softclip = softClip(inCopy, g1);
waverect = halfwaveRectification(softclip);
clipped = hardClip(waverect, g2);
clipOut = in+clipped;

%% Filtering
% IIR Lowpass & Highpass
lowCutoff = 1000;
highCutoff = 1000;

if tone == 0.5
       G_low = 7.5;
       G_high = 7.5;
else if tone < 0.5
       multiplier = mod(tone,.26);
       G_low =13.5 - (multiplier * 0.52);
       G_high = multiplier * 0.52;
            else
       multiplier = mod(tone,.26);
       G_high =13.5 - (multiplier * 0.52);
       G_low = multiplier * 0.52;
            end
end

[h_low,h_high,h_eq,w,b,a] = EqFunc(fs,G_low,G_high, lowCutoff, highCutoff);


%% Applying Filter
out = filter(b,a,clipOut);
out = out./max(max(abs(out)));

%% Gain Control
mgain(clipOut,gain);

%% Plotting Filter
semilogx(fs*w/(2*pi),20*log10(abs(h_eq)),'Color','k','LineWidth',2)
        grid on
        xlim([20 20000])
        title('Equalizer Amplitude Response')
        xlabel('Frequency (in Hz)')
        ylabel('Gain (in dB)')

%% Input & Output Audio Playback
fprintf('\nPlaying original audio. Press any key in command window to continue...\n')
sound(in,fs)
pause
fprintf('Playing equalized audio...\n')
sound(out,fs)

%% Saving Output Audio File

% Generating created audio filename based on user response
    out_filename = [myaudiofiles{infile}(1:find(ismember(myaudiofiles{infile},'.'),1,'last')-1),...
        '_Big_Muff_FX_','.wav'];

% Saving audio file
audiowrite(out_filename,out,fs)
fprintf(['\n"',out_filename,'" successfully saved.\n\n'])
