% This script separates infants' bNIRS responses into positive and negative
% response groups based on their mean chromophore responses within the
% selected post-stimulus time window. The responses are then standardised
% across channels for each infant and transformed into relative power
% (rPWR) and relative cost (rCST) measures using a 45-degree rotation of
% the chromophore response axes.
%
% The script calculates group-average relative power and cost values and
% uses one-sample t-tests to identify channels where these measures
% significantly differ from zero. It also generates scatterplots to
% visualise the relationships between HbO2, HHb and oxCCO responses across
% channels, alongside the reference axes used to define relative power
% and relative cost.
%
% The analysis can be performed separately for positive and negative
% response groups. It can be used to reproduce Figure 10. 

%% Separate positive and negative responses for each chromophore
% Classify each infant's mean response at each channel as positive or
% negative, using the mean response within the selected time window.
% This is performed separately for HbO2, oxCCO and HHb.
%
% For HbO2 and oxCCO, positive and negative responses are classified
% according to their sign. For HHb, the sign convention is reversed:
% negative values are assigned to the positive group and positive values
% to the negative group.
%
% Missing values are excluded from the classification.

 for i=1:12
         for ch=1:13
             if ~isnan(MeanValMat_t1_all(1,ch,i))
                 if MeanValMat_t1_all(1,ch,i) > 0 
                 M_pos_t1_oxy_M_P(ch,i) = MeanValMat_t1_all(1,ch,i); 
                 end

                 if MeanValMat_t1_all(1,ch,i) < 0 
                 M_neg_t1_oxy_M_P(ch,i) = MeanValMat_t1_all(1,ch,i); 
                 end

             end
         end
  end

    for i=1:12
         for ch=1:13
             if ~isnan(MeanValMat_t1_all(3,ch,i))
                 if MeanValMat_t1_all(3,ch,i) > 0 
                 M_pos_t1_cyt_M_P(ch,i) = MeanValMat_t1_all(3,ch,i); 
                 end

                 if MeanValMat_t1_all(3,ch,i) < 0 
                 M_neg_t1_cyt_M_P(ch,i) = MeanValMat_t1_all(3,ch,i); 
                 end
             end
          end
    end



      for i=1:12
         for ch=1:13
             if ~isnan(MeanValMat_t1_all(2,ch,i))
                 if MeanValMat_t1_all(2,ch,i) < 0 
                 M_pos_t1_deoxy_M_P(ch,i) = MeanValMat_t1_all(2,ch,i); 
                 end

                 if MeanValMat_t1_all(2,ch,i) > 0 
                 M_neg_t1_deoxy_M_P(ch,i) = MeanValMat_t1_all(2,ch,i); 
                 end

             end
         end
      end

 for i=1:12
         for ch=1:13
      if isequal(M_pos_t1_oxy_M_P(ch,i),0); M_pos_t1_oxy_M_P(ch,i)=NaN; end
      if isequal(M_neg_t1_oxy_M_P(ch,i),0); M_neg_t1_oxy_M_P(ch,i)=NaN; end
      
      if isequal(M_pos_t1_deoxy_M_P(ch,i),0); M_pos_t1_deoxy_M_P(ch,i)=NaN; end
      if isequal(M_neg_t1_deoxy_M_P(ch,i),0); M_neg_t1_deoxy_M_P(ch,i)=NaN; end

      if isequal(M_pos_t1_cyt_M_P(ch,i),0); M_pos_t1_cyt_M_P(ch,i)=NaN; end
      if isequal(M_neg_t1_cyt_M_P(ch,i),0); M_neg_t1_cyt_M_P(ch,i)=NaN; end
         end
 end


%% Standardise chromophore responses across channels for each infant
% Select the positive or negative response group for analysis. The code
% below currently uses the negative response group; the positive group can
% be selected by changing the corresponding input arrays.
%
% For each infant, responses are standardised across channels by
% subtracting the mean and dividing by the standard deviation. HHb is
% subsequently multiplied by -1 to reverse its sign before calculating
% relative power and relative cost.

% Run for all participants for HBO and CCO - uncomment below to switch from looking at negative group to positive group

for pp=1:12 %no of infants

        Data_HbO2_M_P(pp,:) = M_neg_t1_oxy_M_P(:,pp); %M_pos_t1_oxy_M_P(:,pp,t,cond);
        Data_HbO2_M_P(pp,:) = bsxfun(@minus,Data_HbO2_M_P(pp,:),nanmean(Data_HbO2_M_P(pp,:)));
        Data_HbO2_M_P(pp,:) = bsxfun(@rdivide,Data_HbO2_M_P(pp,:),nanstd(Data_HbO2_M_P(pp,:))); 

        Data_HHb_M_P(pp,:) = M_neg_t1_deoxy_M_P(:,pp);%M_pos_t1_deoxy_M_P(:,pp,t,cond);%MeanValMat_t1(2,:,pp,t);
        Data_HHb_M_P(pp,:) = bsxfun(@minus,Data_HHb_M_P(pp,:),nanmean(Data_HHb_M_P(pp,:)));
        Data_HHb_M_P(pp,:) = bsxfun(@rdivide,Data_HHb_M_P(pp,:),nanstd(Data_HHb_M_P(pp,:))); 
        Data_HHb_M_P(pp,:) = Data_HHb_M_P(pp,:).*-1;
        
        Data_CCO_M_P(pp,:) = M_neg_t1_cyt_M_P(:,pp);%M_pos_t1_cyt_M_P(:,pp,t,cond);%MeanValMat_t1(3,:,pp,t);
        Data_CCO_M_P(pp,:) = bsxfun(@minus,Data_CCO_M_P(pp,:),nanmean(Data_CCO_M_P(pp,:)));
        Data_CCO_M_P(pp,:) = bsxfun(@rdivide,Data_CCO_M_P(pp,:),nanstd(Data_CCO_M_P(pp,:))); 
       
end

 %%

for i=1:12
    std1(i,cond)  = nanstd(Data_HbO2_M_P(:,i));
    std2(i,cond)  = nanstd(Data_HHb_M_P(:,i));
    std3(i,cond)  = nanstd(Data_CCO_M_P(:,i));
end


%%
% Compute PWR and CST
for pp=1:12
    data1=squeeze(Data_HbO2_M_P(pp,:));
    data2=squeeze(Data_CCO_M_P(pp,:)); 
    
    % Cartesian
    rPWR_M_P(pp,:)= cos(pi/4)*data1 + sin(pi/4)*data2;
    rCST_M_P(pp,:)= -sin(pi/4)*data1 + cos(pi/4)*data2;
end

%%
% Compute PWR and CST
for pp=1:12
    data1=squeeze(Data_HHb_M_P(pp,:));
    data2=squeeze(Data_CCO_M_P(pp,:)); 
    
    % Cartesian
    rPWR_M_P2(pp,:)= cos(pi/4)*data1 + sin(pi/4)*data2;
    rCST_M_P2(pp,:)= -sin(pi/4)*data1 + cos(pi/4)*data2;
   % end 
end


%% Scatter Plot of rPWR and rCST 
colors = prism(13);
Ch_list = [1 2 3 4 5 11:18];

figure

toplot1=nanmean(Data_HbO2_M_P,1);
toplot2=nanmean(Data_CCO_M_P,1);

hold on;
for Ch=1:13
    scatter(toplot1(Ch),toplot2(Ch),20,'b','filled')
 %   ,...'MarkerEdgeColor','blue','MarkerFaceColor','red')
    hold on
    text(toplot1((Ch))+0.03, toplot2((Ch))+0.01,[num2str((Ch))],'color','b')
end

hold on

hold on
xlim([-2 2])
ylim([-2 2])
line([0 0],[-2 2],'color','k','LineWidth',2)
line([-2 2],[0 0],'color','k','LineWidth',2)
line([-2 2],[2 -2],'color','m','LineWidth',2.5)
line([-2 2],[-2 2],'color','c','LineWidth',2.5)
xlabel('z(HbO2)');
ylabel('z(oxCCO)');


%%%% Prepare relative power and relative cost values for group-level analysis
% Retain the infant-level rPWR and rCST values calculated from HbO2 and
% oxCCO, and those calculated from HHb and oxCCO. Calculate the group
% average across infants for each channel.


ch_list = [1 2 3 4 5 11:18];
rPWR_M_P_final = rPWR_M_P;%(:,ch_list); 
rCST_M_P_final = rCST_M_P;%(:,ch_list); 
rPWR_M_P_final_avg = squeeze(nanmean(rPWR_M_P_final,1)); 
rCST_M_P_final_avg = squeeze(nanmean(rCST_M_P_final,1)); 

rPWR_M_P_final2 = rPWR_M_P2;%(:,ch_list); 
rCST_M_P_final2 = rCST_M_P2;%(:,ch_list); 
rPWR_M_P_final_avg2 = squeeze(nanmean(rPWR_M_P_final2,1)); 
rCST_M_P_final_avg2 = squeeze(nanmean(rCST_M_P_final2,1)); 

%% Test relative power and relative cost against zero
% Perform one-sample t-tests across infants at each channel to determine
% whether the rPWR and rCST values differ significantly from zero.
% The tests below use the HHb-based rPWR values and the HbO2-based rCST
% values, respectively.

[H_rpwr,P_rpwr,CI,STATS] = ttest(rPWR_M_P_final2,0,0.05); %

[H_rcst,P_rcst,CI,STATS] = ttest(rCST_M_P_final,0); %

%% Plot group-average chromophore responses and reference axes
% Display the group-average standardised responses for HbO2 and oxCCO
% (left panel), and HHb and oxCCO (right panel). Channels are labelled,
% and diagonal lines indicate the relative power and relative cost axes.


colors = prism(13);
Ch_list = [1 2 3 4 5 11:18];
figure
subplot(1,2,1)

toplot1=nanmean(Data_HbO2_M_P,1);
toplot2=nanmean(Data_CCO_M_P,1);

hold on;
for Ch=1:5%14
    scatter(toplot1(Ch_list(Ch)),toplot2(Ch_list(Ch)),400,yell,'filled','MarkerEdgeColor',purple);%,'blue','MarkerFaceColor','red')
    hold on
    text(toplot1(Ch_list(Ch))+0.03, toplot2(Ch_list(Ch))+0.01,[num2str(Ch_list(Ch))],'color','k','FontSize',40)
end
% % % % 
for Ch=6:13
    scatter(toplot1(Ch),toplot2(Ch),400,yell,'filled','MarkerEdgeColor',purple)
 %   ,...'MarkerEdgeColor','blue','MarkerFaceColor','red')
    hold on
    text(toplot1(Ch)+0.03, toplot2(Ch)+0.01,[num2str(Ch_list(Ch))],'color','k','FontSize',40)
end

xlim([-1.5 1.5])
ylim([-1.5 1.5])
purple = cm(2,:);
blue = cm(6,:);
yell = cm(9,:);
line([0 0],[-2 2],'color','k','LineWidth',2)
line([-2 2],[0 0],'color','k','LineWidth',2)
line([-2 2],[2 -2],'color',purple,'LineWidth',5)
line([-2 2],[-2 2],'color',blue,'LineWidth',5)
xlabel('z(HbO2)');
ylabel('z(oxCCO)');
set(gca,'FontSize',30)

toplot1=nanmean(Data_HHb_M_P,1);
toplot2=nanmean(Data_CCO_M_P,1);
subplot(1,2,2)
hold on;
for Ch=1:5%14
    scatter(toplot1(Ch_list(Ch)),toplot2(Ch_list(Ch)),400,yell,'filled','MarkerEdgeColor',purple)
 %   ,...'MarkerEdgeColor','blue','MarkerFaceColor','red')
    hold on
    text(toplot1(Ch_list(Ch))+0.03, toplot2(Ch_list(Ch))+0.01,[num2str(Ch_list(Ch))],'color','k','FontSize',40)
end

for Ch=6:13
    scatter(toplot1(Ch),toplot2(Ch),400,yell,'filled','MarkerEdgeColor',purple)
 %   ,...'MarkerEdgeColor','blue','MarkerFaceColor','red')
    hold on
    text(toplot1(Ch)+0.03, toplot2(Ch)+0.01,[num2str(Ch_list(Ch))],'color','k','FontSize',40)
end

hold on
xlim([-1.5 1.5])
ylim([-1.5 1.5])
line([0 0],[-2 2],'color','k','LineWidth',2)
line([-2 2],[0 0],'color','k','LineWidth',2)
line([-2 2],[2 -2],'color',purple,'LineWidth',5)
line([-2 2],[-2 2],'color',blue,'LineWidth',5)
xlabel('z(HHb)');
ylabel('z(oxCCO)');
set(gca,'FontSize',30)
%