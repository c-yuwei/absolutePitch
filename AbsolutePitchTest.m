%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   AbsolutePitchTest.m   YWC     May 6, 2019 
%   This program displays a set of solfege for participants to make a
%   choice response. In blocks the respButtons is presented for participant
%   to click in response to the key signature of corresponding solfege. 
%   
%   revision history
%   June 5, 2019 - added an function to calculate histogram 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
rand('state', sum(100*clock)); 
Screen('Preference', 'SkipSyncTests', 1); % for debug only
%Screen('Preference', 'SkipSyncTests', 0); % for real study

% Experimental parameters
numBlocks = 1;
numBrownNoiseFiles = 3;
numSolfegeSoundFiles = 4; 
outputFolderName = 'subjects dataset';
E1rrorDelay=1; interTrialInterval = 1.5; 
corrSoundAnswer = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
gray = [127 127 127 ]; white = [ 255 255 255]; black = [ 0 0 0];
bgcolor = white; textcolor = black;
KbName('UnifyKeyNames');
spaceKey = KbName('space'); escKey = KbName('ESCAPE');

% Use normalized color range, ranging from 0 to 1
PsychDefaultSetup(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load sound files
AssertOpenGL;
notefilenames = [];
soundList = dir([pwd '\brownNoiseMaterials\*.mp3']);
for i=1:length(soundList)
    notefilenames{i} = [soundList(i).folder '\' soundList(i).name];
end
soundList = dir([pwd '\toneMaterials\*.wav']);
for i=1:length(soundList)
    notefilenames{end+1} = [soundList(i).folder '\' soundList(i).name];
end

nfiles = length(notefilenames);
nrchannels = 2;
device = [];
InitializePsychSound(1);
suggestedLatencySecs = [];
if IsARM
    % ARM processor, probably the RaspberryPi SoC. This can not quite handle the
    % low latency settings of a Intel PC, so be more lenient:
    suggestedLatencySecs = 0.025;
    fprintf('Choosing a high suggestedLatencySecs setting of 25 msecs to account for lower performing ARM SoC.\n');
end
% Open the audio 'device' with default mode [] (== Only playback),
% and a required latencyclass of 1 == standard low-latency mode, as well as
% default playback frequency and 'nrchannels' sound output channels.
% This returns a handle 'pahandle' to the audio device:
pahandle = PsychPortAudio('Open', device, [], 1, [], nrchannels, [], suggestedLatencySecs);

% Get what freq'uency we are actually using for playback:
s = PsychPortAudio('GetStatus', pahandle);
freq = s.SampleRate;
buffer = [];
doresample = 0
j = 0;

for i=1:nfiles
    try
        % Make sure we don't abort if we encounter an unreadable sound
        % file. This is achieved by the try-catch clauses...
        [audiodata, infreq] = psychwavread(char(notefilenames(i)));
        dontskip = 1;
    catch
        fprintf('Failed to read and add file %s. Skipped.\n', char(notefilenames(i)));
        dontskip = 0;
        psychlasterror
        psychlasterror('reset');
    end

    if dontskip
        j = j + 1;

        if doresample
            % Resampling supported. Check if needed:
            if infreq ~= freq
                % Need to resample this to target frequency 'freq':
                fprintf('Resampling from %i Hz to %i Hz... ', infreq, freq);
                audiodata = resample(audiodata, freq, infreq);
            end
        end

        [samplecount, ninchannels] = size(audiodata);
        audiodata = repmat(transpose(audiodata), nrchannels / ninchannels, 1);

        buffer(end+1) = PsychPortAudio('CreateBuffer', [], audiodata); 
        [fpath, fname] = fileparts(char(notefilenames(j)));
        fprintf('Filling audiobuffer handle %i with soundfile %s ...\n', buffer(j), fname);
    end
end
nfiles = length(buffer);
PsychPortAudio('UseSchedule', pahandle, 1);
for i=1:nfiles
    % Play buffer(i) from startSample 0.0 seconds to endSample 1.0 
    % seconds. Play one repetition of each soundbuffer...
    PsychPortAudio('AddToSchedule', pahandle, buffer(i), 1, 0.0, 1.0, 1);
end
%PsychPortAudio('Start', pahandle, [], 0, 1); % display all the sounds

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Login prompt and open file for writing data out
prompt = {'Outputfile', 'Subject''s number:', 'age', 'gender', 'phone number', 'age learning music', 'how many years learning music', 'group'};
defaults = {'Trial', '98', '18', 'F', '09', '5', '13', 'control'};
answer = inputdlg(prompt, 'ChoiceRT', 2, defaults);
[output, subid, subage, gender, subphonenumber, subagelearning, subyearslearning, group] = deal(answer{:}); % all input variables are strings
outputname = [outputFolderName '\' output gender subid group subage '.xls'];
mkdir(outputFolderName);
if exist(outputname)==2 % check to avoid overiding an existing file
    fileproblem = input('That file already exists! Append a .x (1), overwrite (2), or break (3/default)?');
    if isempty(fileproblem) | fileproblem==3
        return;
    elseif fileproblem==1
        outputname = [outputname '.x'];
    end
end
outfile = fopen(outputname,'w'); % open a file for writing data out
fprintf(outfile, 'subid\t subage\t gender\t phonenumber\t learningmucisage\t learningmusicyears\t group\t blockNumber\t trialNumber\t answer\t userResp\t accuracy\t ReactionTime\t \n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Screen parameters
screens = Screen('Screens');
screenNumber = max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
[mainwin,  screenrect] = PsychImaging('OpenWindow', screenNumber, black);
%[mainwin, screenrect] = Screen(0, 'OpenWindow');
Screen('FillRect', mainwin, bgcolor);
center = [screenrect(3)/2 screenrect(4)/2];
Screen(mainwin, 'Flip');

%   load response screen
im = imread('RespButtons.jpg'); respScreen = Screen('MakeTexture', mainwin, im);
im = imread('timer1.jpg'); timerScreen(1) = Screen('MakeTexture', mainwin, im);
im = imread('timer2.jpg'); timerScreen(2) = Screen('MakeTexture', mainwin, im);
im = imread('timer3.jpg'); timerScreen(3) = Screen('MakeTexture', mainwin, im);
im = imread('timer4.jpg'); timerScreen(4) = Screen('MakeTexture', mainwin, im);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Experimental instructions, wait for a spacebar response to start
Screen('FillRect', mainwin ,bgcolor);
Screen('TextSize', mainwin, 24);
Screen('DrawText',mainwin,['Absolute pitch test.'] ,center(1)-150,center(2)-40,textcolor);
Screen('DrawText',mainwin,['Press spacebar to start the experiment.'] ,center(1)-320,center(2)-00,textcolor);
Screen('Flip',mainwin );

keyIsDown=0;
while 1
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
         if keyCode(spaceKey)
             break ;
        elseif keyCode(escKey)
            ShowCursor;
            fclose(outfile);
            Screen('CloseAll');
            return;
        end
    end
end
WaitSecs(0.3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Block loop
answer4fig = {};
userResp4fig = {};
for a = 1:numBlocks
    Screen('FillRect', mainwin, bgcolor);
    Screen('TextSize', mainwin, 24);
    
    Screen('DrawText', mainwin, ['Mouse response: left click on the corresponding key'], center(1)-400, center(2)+130, textcolor);
    Screen('DrawText', mainwin, ['Click to start'], center(1)-150, center(2)+30, textcolor);
    Screen('Flip', mainwin);
    GetClicks;    
    WaitSecs(1);
    
    trialorder = Shuffle(1:numSolfegeSoundFiles); % randomize trial order for each block
    cellindex = [3,6,3];
    % trial loop
    for i = 1:numSolfegeSoundFiles
        Screen('FillRect', mainwin ,bgcolor);
        Screen('DrawTexture', mainwin, respScreen, [], []);
        %Screen('DrawTexture', mainwin, timerScreen, [], []);
        
        Screen('Flip', mainwin); % must flip for the stimulus to show up on the mainwin
        ShowCursor('hand');
        
        % Engine still running on a schedule?
        s = PsychPortAudio('GetStatus', pahandle);
        if s.Active == 0
            % Schedule finished, engine stopped. Before adding new
            % slots we first must delete the old ones, ie., reset the
            % schedule:
            PsychPortAudio('UseSchedule', pahandle, 2);
        end

        % Add new slot with playback request for user-selected buffer
        % to a still running or stopped and reset empty schedule. This
        % time we select one repetition of the full soundbuffer:
        
        answer = extractBetween(notefilenames(trialorder(i)+numBrownNoiseFiles),'toneMaterials\','.wav');
        PsychPortAudio('AddToSchedule', pahandle, buffer(trialorder(i)+numBrownNoiseFiles), 1, 0, [], 1);
        PsychPortAudio('AddToSchedule', pahandle, buffer(mod(i,numBrownNoiseFiles)+1), 1, 0, [], 1);
        
        if s.Active == 0
            PsychPortAudio('Start', pahandle, [], 0, 1);
            notprinted = 1;
        end
        
        % now record response
        timeStart = GetSecs;keyIsDown=0; correct=0; rt=0;
        x = 0; y = 0;
        for j = 1:5
            [clicks,x1,y1,whichButton]=GetClickWithinTimeout([],1,[]);
            if(clicks ~= 0)
                x = x1;
                y = y1;
            end
            Screen('DrawTexture', mainwin, respScreen, [], []);
            if(j ~= 5) Screen('DrawTexture', mainwin, timerScreen(j), [], [] ); end;
            Screen('Flip', mainwin); % must flip for the stimulus to show up on the mainwin
        end
        
        if (~isempty(whichButton) && whichButton == 'esc') 
            ShowCursor;
            fclose(outfile);
            Screen('CloseAll');
            return;
        end
        userRes = userSelectedKeyMapping(x,y)
        rt=1000.*(GetSecs-timeStart);
        Screen('Flip', mainwin);
        Screen('Flip', mainwin);
        Screen('FillRect', mainwin ,bgcolor); Screen('Flip', mainwin);
        % write data out
        fprintf(outfile, '%s\t %s\t %s\t %s\t %s\t %s\t %s\t %d\t %d\t %s\t %s\t %6.2f\t \n', ...,
            subid, subage, gender, subphonenumber, subagelearning, subyearslearning, group, ...,
            a, i, char(answer), userRes, rt);
        answer4fig(end+1) = answer;
        userResp4fig(end+1) = cellstr(userRes);
        WaitSecs(interTrialInterval);
    end  % end of trial loop
end % end of block loop

Screen('CloseAll');
fclose(outfile);
getHistogramFigure(answer4fig,userResp4fig);
fprintf('\n\n\n\n\nFINISHED this part! PLEASE GET THE EXPERIMENTER...\n\n');



