function [origch, destch] = FindCHpair(chpair, origpair, destpair)
%find source and detector pairs associated channel
%e.g. CHpair=[1,1;1,2;1,3;1,4;2,4;2,5;2,6;2,7;3,8;3,9;3,10;4,9;4,10;4,12;5,8;5,10;5,11;6,10;6,11;6,12;6,13;7,12;7,13;8,11;8,13;9,14;9,15;9,16;10,15;10,16;10,18;11,14;11,16;11,17;12,16;12,17;12,18;12,19;13,18;13,19;14,17;14,19;15,20;15,21;15,22];
%origpair = [6,11]
%destpair = [12,18]
    for i = 1:length(chpair)
       if origpair(1) ==  chpair(i,1) & origpair(2) == chpair(i,2)
           origch = i;
       end
       if destpair(1) ==  chpair(i,1) & destpair(2) == chpair(i,2)
           destch = i;
       end
    end
end

