function fig = getHistogramFigure(answer, resp)
    corrSoundAnswer = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "N"];
    corrScore = [1 1.5 2 2.5 3 3.5 4 5 5.5 6 6.5 7 7.5 8 9]
    for i = 1:length(answer)
        index = find(corrSoundAnswer == extractBetween(string(answer(i)),1,1))
        %if(isempty(index)) continue;end
        answerScore(i) = corrScore(index);
        index = find(corrSoundAnswer == string(resp(i)))
        %if(isempty(index)) continue;end
        respScore(i) = corrScore(index);
    end
    edges = [-7 -7:0.5:7 7];
    histogram(answerScore-respScore, edges)
end