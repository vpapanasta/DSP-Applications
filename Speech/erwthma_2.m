clear all; clc;
%% Erwthma 2.1

load('speech_signal-1.mat');
v = s5;

% ARPABET form of "Oak is strong and also gives shade"
arpa = 'OW .  IH Z . S T R AO NG . AH N D . AO L S OW . G IH V Z . SH EY D . ';

%% Erwthma 2.2.1

oa_oak = v(1300:2350, 1);

i_is = v(3430:4500, 1);

o_strong = v(6250:8600, 1);

a_and = v(9600:10200, 1);

a_also = v(10550:11850, 1);
o_also = v(12800:13350, 1);

i_gives = v(14300:15300, 1);

a_shade = v(16820:18750, 1);
%% Erwthma 2.2.1

v1 = zeros(24570, 1);
v1(1300:2350, 1) = oa_oak; v1(3430:4500, 1) = i_is; 
v1(6250:8600, 1) = o_strong; v1(9600:10200, 1) = a_and;
v1(10550:11850, 1) = a_also; v1(12800:13350, 1) = o_also;
v1(14300:15300, 1) = i_gives; v1(16820:18750, 1) = a_shade;

v2 = v - v1;
%%	
