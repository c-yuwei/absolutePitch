function resKey = userSelectedKeyMapping(intX, intY)
    buttonRadiusX = 180;
    buttonRadiusY = 170;
    if intX > 58 && intX < 58+buttonRadiusX && intY < 855 && intY > 855-buttonRadiusY
        resKey = 'C';
    elseif intX > 330 && intX < 330+buttonRadiusX && intY < 855 && intY > 855-buttonRadiusY
        resKey = 'D';
    elseif intX > 595 && intX < 595+buttonRadiusX && intY < 855 && intY > 855-buttonRadiusY
        resKey = 'E';
    elseif intX > 860 && intX < 860+buttonRadiusX && intY < 855 && intY > 855-buttonRadiusY
        resKey = 'F';
    elseif intX > 1150 && intX < 1150+buttonRadiusX && intY < 855 && intY > 855-buttonRadiusY
        resKey = 'G';
    elseif intX > 1425 && intX < 1450+buttonRadiusX && intY < 855 && intY > 855-buttonRadiusY
        resKey = 'A';
    elseif intX > 1690 && intX < 1690+buttonRadiusX && intY < 855 && intY > 855-buttonRadiusY
        resKey = 'B';
    elseif intX > 190 && intX < 190+buttonRadiusX && intY < 650 && intY > 650-buttonRadiusY
        resKey = 'C#';
    elseif intX > 465 && intX < 465+buttonRadiusX && intY < 650 && intY > 650-buttonRadiusY
        resKey = 'D#';
    elseif intX > 1005 && intX < 1005+buttonRadiusX && intY < 650 && intY > 650-buttonRadiusY
        resKey = 'F#';
    elseif intX > 1280 && intX < 1280+buttonRadiusX && intY < 650 && intY > 650-buttonRadiusY
        resKey = 'G#';
    elseif intX > 1550 && intX < 1550+buttonRadiusX && intY < 650 && intY > 650-buttonRadiusY
        resKey = 'A#';
    else
        resKey = 'N';
    end
end