%%
%average = zeros(epoch,3,nRepeats,19);
%avg = {}%;
counter = 1;
for k = 1:6%1:6%size(DMAT.names,2)
%     baseline_pre = DMAT.durations_round{1,7};
%     baseline_post =  DMAT.durations_round{1,7}
%baseline = 100;
%     onsets = DMAT.onsets{1,k}*10;
%     min_event = min(DMAT.durations_round{1,k})*10;
%     min_epoch = (min_event + baseline + (baseline/2)) + 1;% + 50;
    tS = SerialCapture(end-2,2);
 
    if tS == 42
        m=1;
    elseif tS == 44
        m=2;
    elseif tS == 24
        m=3;
    elseif tS == 22
        m=4;
    elseif tS == 32
        m=5;
    elseif tS == 34
        m=6;
    end
    
    
   if m==k
    nRepeats = size(DMAT.onsets{1,k},1)-1;
   else
    nRepeats = size(DMAT.onsets{1,k},1);
   end
    baseline = 9;
    for i = 1:19
      for j = 1:nRepeats
          
 %            baseline = (DMAT.durations_round{1,7}(counter))*10;
              onsets = DMAT.onsets{1,k};%*10;
              min_event = min(DMAT.durations_round{1,k});%*10;
              min_epoch = (min_event + baseline + (baseline/2)) + 1+10;%5;% + 50;
              %min_epoch = (min_event + baseline + 2) + 1;% + 50;
              
           baseline = 20;
          % event = ((DMAT.durations_round{1,k}(j)));%*10);% + 50;
          AVG(k).averageNEST{1,j}(:,:,i)=((EXPfiltdata((onsets(j) - (baseline/2)):(onsets(j)+ event + baseline+10),:,i)));
              
          counter = counter + 1;
      end
     
    end
end
 AVG_LT = AVG;
%%
for i=1:19%size(acc_ch,1)
    chan = i;%acc_ch(i);
    corr_mat(i) = (corr(EXPfiltdata(:,1,chan),EXPfiltdata(:,2,chan)))';
end

[corr_chans] = find(corr_mat>0.5);

%%
for ii = 1:6
f=figure(ii);  
clear avgtot average_data event min_epoch2 min_epoch3 ev

nRepeats = size(AVG_LT(ii).averageNEST,2);
    for i = 1:nRepeats %average over trials 
            
         event = min((DMAT.durations_round{1,ii}));%;*10);
         min_epoch2 = event + baseline + (baseline/2) +10;%5; %;+ 5;% + 50;
         %min_epoch2 = event + baseline + 2; %;+ 5;% + 50;
         min_epoch3 = min_epoch2 + 1;
         %min_epoch3 = round(min_epoch2); 
         
         Avg(ii).avgtot(:,:,:,i) = AVG_LT(ii).averageNEST{1,i}(1:min_epoch3,:,:);
        
         Avg(ii).average_data = squeeze(nanmean(Avg(ii).avgtot,4)); 
    end

       for j = 1:19
       chnum1 = j; 
            subplot(2,11,j); 
       
            plot(Avg(ii).average_data(:,1,chnum1),'r','LineWidth',2);hold on;
            plot(Avg(ii).average_data(:,2,chnum1),'b','LineWidth',2);hold on;
            %plot((A2vg(ii).average_data(:,3,chnum1))*3,'g','LineWidth',2);hold on;
            title(['Ch', num2str(chnum1),DMAT.names{1,ii},num2str((corr_mat(chnum1)))]);
            line([(baseline/2) (baseline/2)],[-1 1],'LineWidth',3,'Color','m')
            line([(event+5) (event+5)],[-0.8 0.8],'LineWidth',3,'Color','k')
            line([(event+5+10) (event+5+10)],[-0.8 0.8],'LineWidth',3,'Color','m')
            xlim([0 min_epoch3]);
          %  xticks(0:5:min_epoch3);
         %   yticks(-1.2:0.5:1.2);
            ylim([-1.5 1.5]);
             set(gca,'FontSize',16)
        end


end
%%
 Avg = Avg_NEST2;
% Baseline correction
    for j=1:3
        for k=1:6
            for i=1:19
            Avg(k).avg_bl_corrected(:,j,i) = squeeze(Avg(k).average_data(:,j,i)) - squeeze(mean(Avg(k).average_data(4:5,j,i)));
             Avg(k).avg_bl_corrected_detrend(:,j,i) = detrend(Avg(k).avg_bl_corrected(:,j,i));
             %squeeze(Avg(k).average_data(:,j,i)) - squeeze(mean(Avg(k).average_data(4:5,j,i)));
            
            end
        end
    end
    
 %%  
ch = [1 2 3 4 5 7 9 11 12 13 14 15 17 18];
for ii =1
f=figure(ii); 
   for j = 1:14%18%size(acc_ch)
       %f=figure(j); 
       %grid = acc_ch;
       chnum1 = ch(j);%j;%grid(j);
            subplot(2,8,j);
            plot(Avg(ii).avg_bl_corrected(:,1,chnum1),'r','LineWidth',2);hold on;
            plot(Avg(ii).avg_bl_corrected(:,2,chnum1),'b','LineWidth',2);hold on;
            plot((Avg(ii).avg_bl_corrected(:,3,chnum1))*3,'g','LineWidth',2);hold on;
            title(['Ch', num2str(chnum1),DMAT.names{1,ii}]);%,num2str(ch_counts_max(chnum1))]);
            line([(baseline/2) (baseline/2)],[-1 1],'LineWidth',3,'Color','m')
            line([(event+5) (event+5)],[-2 2],'LineWidth',3,'Color','k')
            line([(event+5+10) (event+5+10)],[-0.8 1],'LineWidth',3,'Color','m')
            xlim([0 min_epoch3]);
            ylim([-1.2 1.2]);
            set(gca,'FontSize',16)
   end
    
   
   

end

%%
figure; 
for i=11:18
    j=i-10;
    chnum = i;
  subplot(2,4,j);
            plot(Avg(1).average_data(:,1,i),'r','LineWidth',2);hold on;
            plot(Avg(1).average_data(:,2,i),'b','LineWidth',2);hold on;
            plot((Avg(1).average_data(:,3,i)) ,'g','LineWidth',2);hold on;
            title(['Ch', num2str(j),DMAT.names{1,1}]);%,num2str(ch_counts_max(chnum1))]);
            line([(baseline/2) (baseline/2)],[-1 1],'LineWidth',3,'Color','m')
            line([(event+5) (event+5)],[-2 2],'LineWidth',3,'Color','k')
            line([(event+5+10) (event+5+10)],[-0.8 1],'LineWidth',3,'Color','m')
            xlim([0 min_epoch3]);
            ylim([-1.2 1.2]);
            set(gca,'FontSize',16)
end

%%
figure; 
for i=1:10
    %j=i-10;
    chnum = i;
  subplot(2,5,i);
            plot(Avg_NEST8(3).average_data(:,1,i),'r','LineWidth',2);hold on;
            plot(Avg_NEST8(3).average_data(:,2,i),'b','LineWidth',2);hold on;
            plot((Avg_NEST8(3).average_data(:,3,i)) ,'g','LineWidth',2);hold on;
            title(['Ch', num2str(i),DMAT.names{1,1}]);%,num2str(ch_counts_max(chnum1))]);
            line([(baseline/2) (baseline/2)],[-1 1],'LineWidth',3,'Color','m')
            line([(event+5) (event+5)],[-2 2],'LineWidth',3,'Color','k')
            line([(event+5+10) (event+5+10)],[-0.8 1],'LineWidth',3,'Color','m')
            xlim([0 min_epoch3]);
            ylim([-1.2 1.2]);
            set(gca,'FontSize',16)
end