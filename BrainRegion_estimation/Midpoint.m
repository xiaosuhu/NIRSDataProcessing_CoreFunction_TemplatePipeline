function [ mid_point ] = Midpoint( point1,point2 )
%MIDPOINT Summary of this function goes here
%   Detailed explanation goes here

line=FillLine([point1;point2],1000);
mid_point=line(500,:);



end

