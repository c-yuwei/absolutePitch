function resKey = userSelectedKeyMapping(intX, intY)
    buttonRadiusX = 180;
    buttonRadiusY = 160;
    if intX > 382 && intX < 382+buttonRadiusX && intY < 601 && intY > 601-buttonRadiusY
        resKey = 'C';
    elseif intX > 661 && intX < 661+buttonRadiusX && intY < 857 && intY > 857-buttonRadiusY
        resKey = 'D';
    elseif intX > 1040 && intX < 1040+buttonRadiusX && intY < 854 && intY > 854-buttonRadiusY
        resKey = 'E';
    elseif intX > 1222 && intX < 1222+buttonRadiusX && intY < 774 && intY > 774-buttonRadiusY
        resKey = 'F';
    elseif intX > 1236 && intX < 1236+buttonRadiusX && intY < 427 && intY > 427-buttonRadiusY
        resKey = 'G';
    elseif intX > 866 && intX < 866+buttonRadiusX && intY < 265 && intY > 265-buttonRadiusY
        resKey = 'A';
    elseif intX > 496 && intX < 496+buttonRadiusX && intY < 433 && intY > 433-buttonRadiusY
        resKey = 'B';
    elseif intX > 482 && intX < 482+buttonRadiusX && intY < 770 && intY > 770-buttonRadiusY
        resKey = 'C#';
    elseif intX > 849 && intX < 849+buttonRadiusX && intY < 949 && intY > 949-buttonRadiusY
        resKey = 'D#';
    elseif intX > 1341 && intX < 1341+buttonRadiusX && intY < 598 && intY > 598-buttonRadiusY
        resKey = 'F#';
    elseif intX > 1057 && intX < 1057+buttonRadiusX && intY < 346 && intY > 346-buttonRadiusY
        resKey = 'G#';
    elseif intX > 682 && intX < 682+buttonRadiusX && intY < 351 && intY > 351-buttonRadiusY
        resKey = 'A#';
    else
        resKey = 'N';
    end
end