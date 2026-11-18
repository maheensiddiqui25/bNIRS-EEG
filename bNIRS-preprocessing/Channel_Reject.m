for i=1:size(s1_c1d1.IntensityBDetector,1)

    %occipital channels 
    ch_count1(i) = max(s1_c1d1.IntensityBDetector(i,:));
    ch_count2(i) = max(s1_c2d7.IntensityBDetector(i,:));
    ch_count3(i) = max(s1_c1d3.IntensityBDetector(i,:));
    ch_count4(i) = max(s1_c1d5.IntensityBDetector(i,:));
    ch_count5(i) = max(s1_c1d6.IntensityBDetector(i,:));
    ch_count6(i) = max(s2_c1d3.IntensityBDetector(i,:));
    ch_count7(i) = max(s2_c1d4.IntensityBDetector(i,:));
    ch_count8(i) = max(s2_c1d6.IntensityBDetector(i,:)); 
    ch_count9(i) = max(s2_c1d7.IntensityBDetector(i,:));
    ch_count10(i) = max(s2_c2d1.IntensityBDetector(i,:));
    
    ch_count1_min(i) = min(s1_c1d1.IntensityBDetector(i,:));
    ch_count2_min(i) = min(s1_c2d7.IntensityBDetector(i,:));
    ch_count3_min(i) = min(s1_c1d3.IntensityBDetector(i,:));
    ch_count4_min(i) = min(s1_c1d5.IntensityBDetector(i,:));
    ch_count5_min(i) = min(s1_c1d6.IntensityBDetector(i,:));
    ch_count6_min(i) = min(s2_c1d3.IntensityBDetector(i,:));
    ch_count7_min(i) = min(s2_c1d4.IntensityBDetector(i,:));
    ch_count8_min(i) = min(s2_c1d6.IntensityBDetector(i,:)); 
    ch_count9_min(i) = min(s2_c1d7.IntensityBDetector(i,:));
    ch_count10_min(i) = min(s2_c2d1.IntensityBDetector(i,:));
    
    %temporal channels 
    ch_count11(i) = max(s3_c2d1.IntensityBDetector(i,:));
    ch_count12(i) = max(s3_c2d2.IntensityBDetector(i,:));
    ch_count13(i) = max(s3_c2d3.IntensityBDetector(i,:));
    ch_count14(i) = max(s3_c2d5.IntensityBDetector(i,:));
    ch_count15(i) = max(s3_c2d6.IntensityBDetector(i,:));
    ch_count16(i) = max(s4_c2d3.IntensityBDetector(i,:));
    ch_count17(i) = max(s4_c2d4.IntensityBDetector(i,:));
    ch_count18(i) = max(s4_c2d6.IntensityBDetector(i,:)); 
    ch_count19(i) = max(s4_c1d2.IntensityBDetector(i,:));
    
    ch_count11_min(i) = min(s3_c2d1.IntensityBDetector(i,:));
    ch_count12_min(i) = min(s3_c2d2.IntensityBDetector(i,:));
    ch_count13_min(i) = min(s3_c2d3.IntensityBDetector(i,:));
    ch_count14_min(i) = min(s3_c2d5.IntensityBDetector(i,:));
    ch_count15_min(i) = min(s3_c2d6.IntensityBDetector(i,:));
    ch_count16_min(i) = min(s4_c2d3.IntensityBDetector(i,:));
    ch_count17_min(i) = min(s4_c2d4.IntensityBDetector(i,:));
    ch_count18_min(i) = min(s4_c2d6.IntensityBDetector(i,:)); 
    ch_count19_min(i) = min(s4_c1d2.IntensityBDetector(i,:));

end

ch_count1_max = max(ch_count1);
ch_count2_max = max(ch_count2);
ch_count3_max = max(ch_count3);
ch_count4_max = max(ch_count4);
ch_count5_max = max(ch_count5);
ch_count6_max = max(ch_count6);
ch_count7_max = max(ch_count7);
ch_count8_max = max(ch_count8);
ch_count9_max = max(ch_count9);
ch_count10_max = max(ch_count10);
ch_count11_max = max(ch_count11);
ch_count12_max = max(ch_count12);
ch_count13_max = max(ch_count13);
ch_count14_max = max(ch_count14);
ch_count15_max = max(ch_count15);
ch_count16_max = max(ch_count16);
ch_count17_max = max(ch_count17);
ch_count18_max = max(ch_count18);
ch_count19_max = max(ch_count19);

ch_count1_min1 = min(ch_count1_min);
ch_count2_min1 = min(ch_count2_min);
ch_count3_min1 = min(ch_count3_min);
ch_count4_min1 = min(ch_count4_min);
ch_count5_min1 = min(ch_count5_min);
ch_count6_min1 = min(ch_count6_min);
ch_count7_min1 = min(ch_count7_min);
ch_count8_min1 = min(ch_count8_min);
ch_count9_min1 = min(ch_count9_min);
ch_count10_min1 = min(ch_count10_min);
ch_count11_min1 = min(ch_count11_min);
ch_count12_min1 = min(ch_count12_min);
ch_count13_min1 = min(ch_count13_min);
ch_count14_min1 = min(ch_count14_min);
ch_count15_min1 = min(ch_count15_min);
ch_count16_min1 = min(ch_count16_min);
ch_count17_min1 = min(ch_count17_min);
ch_count18_min1 = min(ch_count18_min);
ch_count19_min1 = min(ch_count19_min);

ch_counts_max = [ch_count1_max; ch_count2_max; ch_count3_max; ch_count4_max; ch_count5_max;...
    ch_count6_max; ch_count7_max; ch_count8_max; ch_count9_max; ch_count10_max;...
    ch_count11_max; ch_count12_max; ch_count13_max; ch_count14_max; ch_count15_max;...
    ch_count16_max; ch_count17_max; ch_count18_max; ch_count19_max];


% ch_counts_min = [ch_count1_min1; ch_count2_min1; ch_count3_min1; ch_count4_min1; ch_count5_min1;...
%     ch_count6_min1; ch_count7_min1; ch_count8_min1; ch_count9_min1; ch_count10_min1;...
%     ch_count11_min1; ch_count12_min1; ch_count13_min1; ch_count14_min1; ch_count15_min1;...
%     ch_count16_min1; ch_count17_min1; ch_count18_min1; ch_count19_min1];
% 


ch_ind = find(ch_counts_max<2000);
ch_ind_accept = (find(ch_counts_max>2000)); %& (~find(ch_counts_min<1000));

rej_ch = ch_ind; 
acc_ch = ch_ind_accept;


%% check if the "accepted channels" have correlated oxy and deoxy haemoglobin, i.e. light piping and reject those channels too

for i=1:size(acc_ch,1)
    chan = acc_ch(i);
    corr_mat(i) = (corr(EXPfiltdata(:,1,chan),EXPfiltdata(:,2,chan)))';
end

[corr_chans] = find(corr_mat>0.5);

acc_ch(corr_chans) = [];