function [clicks,x,y,whichButton] = GetClickWithinTimeout(w, interClickSecs, mouseDev)
%adapted from GetClicks
global ptb_mouseclick_timeout;

% Setup default click timeout if noone set:
if isempty(ptb_mouseclick_timeout)
    ptb_mouseclick_timeout = 0.5; % Default timeout for multi-clicks is 500 msecs.
end;

if nargin < 2
    interClickSecs = [];
end

if isempty(interClickSecs)
    interClickSecs = ptb_mouseclick_timeout;
end

if nargin < 3
    mouseDev = [];
end

% Are we in nice mode?
nice = 1;
KbName('UnifyKeyNames');
% Amount of secs to wait in nice-mode between each poll to avoid overloading
% the system. Now that WaitSecs('YieldSecs') is able to do a non-precise
% wait where it yields the cpu for at least the given amount of time, we
% can use rather strict/short wait intervals without the danger of
% overloading the system, so no need to differentiate between OS:
rtwait = 0.002; % 2 msecs yielding, ie., could take a bit longer.

% Wait for release of buttons if some already pressed:
buttons=1;
while any(buttons)
    [x,y,buttons] = GetMouse([], mouseDev);
    if (nice>0), WaitSecs('YieldSecs', rtwait); end;
end;

% Wait for first mouse button press:
% while ~any(buttons)
%     if nargin < 1
%         % Don't pass windowPtr argument if none supplied.
%         [x,y,buttons] = GetMouse;
%     else
%         % Pass windowPtr argument to GetMouse for proper remapping.
%         [x,y,buttons] = GetMouse(w, mouseDev);
%     end;
%     if (nice>0), WaitSecs('YieldSecs', rtwait); end;
% end;

% First mouse click done. (x,y) is our returned mouse position. Assign
% button number(s) of clicked button(s) as well:


% Wait for further click in the timeout interval.
clicks = 0;
tend = GetSecs + interClickSecs;

while GetSecs < tend
%     If already down, wait for release...
    while any(buttons) && GetSecs < tend
        [xd,yd,buttons] = GetMouse([], mouseDev);
        if (nice>0), WaitSecs('YieldSecs', rtwait); end;
    end;

    % Wait for a press or timeout:
    keyIsDown=0;
    while ~any(buttons) && GetSecs < tend 
        [x,y,buttons] = GetMouse([], mouseDev);
        whichButton = find(buttons);
        if (nice>0), WaitSecs('YieldSecs', rtwait); end;    
    end;

    % Mouse click or timeout?
    if any(buttons) && GetSecs < tend
        % Mouse click. Count it.
        clicks=clicks+1;
        % Extend timeout for the next mouse click:
        %tend=GetSecs + interClickSecs;
    end;
end;

% At this point, (x,y) contains the mouse-position of the first click
% and clicks should contain the total number of distinctive mouse clicks.
return;
