%SDG_15 -->LifeOnLand indicators -->Rob Dunford
clear all; clc;
%Rob's excel file
RobFile='ProcessDataSDG15_v5_RobD3.xlsx';
%Read file names (files to be processed)
[~,species]=xlsread(RobFile,'SL','A:A');
habitat=xlsread(RobFile,'SL','B:B');
%Read set aside values
setaside=xlsread(RobFile,'Setaside','B2:AK2');
SET=repmat(setaside,23871,1);

%path of batch runs
%bpath='C:\Impressions_Work\1.5_degree_paper\Batch_runs\';
bpath='N:\LANDUSE';
% %Needed data - Grid-box land area (ha)
% LD='C:\Impressions_Work\1.5_degree_paper\Batch_runs\NUTS2010 grid and land areas _v3_IAP.xlsx';
% LandArea=xlsread(LD,'F:F'); clear LD;
% EU_Area=sum(LandArea);
% LAND=repmat(LandArea,1,36);
%Needed data - Subregions
load('IAP_regions.mat'); RR=unique(IAP_regions);
region_names={'Alpine','Northern','Atlantic','Continental','Southern'};
              %-->10     %-->20      %-->30    %-->40        %-->50];
%Read baseline values
BL_spec=xlsread(RobFile,'BL','B3:CN23873');
BL=xlsread(RobFile,'BL','CO:CO'); %sum of species in each gridbox
BL_EU=sum(BL); %sum number of present species in baseline for Europe
for r=1:length(RR)
    a=find(IAP_regions==RR(r));
    BL_reg(r,1) = sum(BL(a,1));
end
%Loop for strategy needed here
counter=0;
Strategy=10:12;
%% Loop for species needed here
%Read species file
for S=1:length(Strategy)
    
file_ext=['_batchRun_Adaptation_Strat',num2str(Strategy(S)),'.csv'];
for i=1:length(species)
    %SFile=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',species{i},file_ext];
    SFile='EuropeBaseline2050s_1_outputsAllSpecies.csv'
    %temp=csvread(SFile,1,3);
    temp=csvread(SFile,2,0,[2,0,50,356]);
    %temp(1:6,1:10)
    SP=temp(:,1:end-1); clear temp;
    %Climate appropriate only (change indicator 2 to 1)
    SP(SP==2)=1;
    SP=SP.*BL_spec(:,i); %mutliply with baseline
       
    if habitat(i)==1 %Arable
        Name_1='Arable crops'; % [%]
        File_1=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_1,file_ext];
        temp=csvread(File_1,1,3);
        Arable_crops=temp(:,1:end-1); clear temp Name_1 File_1;
        %Set value to 1 if there is >= 5% of the habitat in the cell (100% setaside removed from arable %)
        thres=Arable_crops-(Arable_crops.*SET);
        a=thres>=5;
        %thres(a)=1; thres(~a)=0;
        %Binary output
        C=SP.*a;
        
    elseif habitat(i)==2 %Forest
        Name_1='Managed forest'; % [%]
        File_1=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_1,file_ext];
        temp=csvread(File_1,1,3);
        Managed_forest=temp(:,1:end-1); clear temp Name_1 File_1;
        
        Name_2='Unmanaged forest'; % [%]
        File_2=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_2,file_ext];
        temp=csvread(File_2,1,3);
        Unmanaged_forest=temp(:,1:end-1); clear temp Name_2 File_2;
        
        Name_3='Arable crops'; % [%]
        File_3=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_3,file_ext];
        temp=csvread(File_3,1,3);
        Arable_crops=temp(:,1:end-1); clear temp Name_3 File_3;
        %Set value to 1 if there is >= 5% of the habitat in the cell (setaside as 50% grassland/abandoned, 50% forest)
        thres=Managed_forest+Unmanaged_forest+(Arable_crops.*SET.*0.5);
        a=thres>=5;
        %Binary output
        C=SP.*a;
        
    elseif habitat(i)==3 %Wetland
        Name_1='Areas of coastal grazing marsh'; % [ha]
        File_1=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_1,file_ext];
        temp=csvread(File_1,1,3);
        Areas_cgm=temp(:,1:end-1); clear temp Name_1 File_1;
        
        Name_2='Areas of inland marsh'; % [ha]
        File_2=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_2,file_ext];
        temp=csvread(File_2,1,3);
        Areas_marsh=temp(:,1:end-1); clear temp Name_2 File_2;
        
        Name_3='Areas of intertidal flats'; % [ha]
        File_3=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_3,file_ext];
        temp=csvread(File_3,1,3);
        Areas_intfl=temp(:,1:end-1); clear temp Name_3 File_3;
        
        Name_4='Areas of saltmarsh'; % [ha]
        File_4=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_4,file_ext];
        temp=csvread(File_4,1,3);
        Areas_saltm=temp(:,1:end-1); clear temp Name_4 File_4;
        %Set value to 1 if there is >= 5 ha of the habitat in the cell (setaside plays no role)
        %[Argument is that wetland areas modelled are often small and so the 5% threshold is not fair on them)
        thres=Areas_cgm+Areas_marsh+Areas_intfl+Areas_saltm;
        %condition is >5 ha
        a=thres>=5;
        %Binary output
        C=SP.*a;
        
    elseif habitat(i)==4 %Saltmarsh
        Name_1='Areas of saltmarsh'; % [ha]
        File_1=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_1,file_ext];
        temp=csvread(File_1,1,3);
        Areas_saltm=temp(:,1:end-1); clear temp Name_1 File_1;
        %Set value to 1 if >=5ha(set aside plays no role)
        %condition
        a=Areas_saltm>=5; %[ha]
        %Binary output
        C=SP.*a;
        
    elseif habitat(i)==5 %Coastal grazing marsh
        Name_1='Areas of coastal grazing marsh'; % [ha]
        File_1=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_1,file_ext];
        temp=csvread(File_1,1,3);
        Areas_cgm=temp(:,1:end-1); clear temp Name_1 File_1;
        %Set value to 1 if >=5ha(set aside plays no role)
        %condition
        a=Areas_cgm>=5; %[ha]
        %Binary output
        C=SP.*a;
        
    elseif habitat(i)==6 %Heath
        Name_1='Extensively grass'; % [%]
        File_1=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_1,file_ext];
        temp=csvread(File_1,1,3);
        Ext_grass=temp(:,1:end-1); clear temp Name_1 File_1;
        
        Name_2='Very Extensively grass'; % [%]
        File_2=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_2,file_ext];
        temp=csvread(File_2,1,3);
        Very_Ext_grass=temp(:,1:end-1); clear temp Name_2 File_2
        
        Name_3='Arable crops'; % [%]
        File_3=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_3,file_ext];
        temp=csvread(File_3,1,3);
        Arable_crops=temp(:,1:end-1); clear temp Name_3 File_3;
        
        Name_4='Unmanaged land'; % [%]
        File_4=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_4,file_ext];
        temp=csvread(File_4,1,3);
        Unman_land=temp(:,1:end-1); clear temp Name_4 File_4;
        
        Name_5='Heath potential habitat'; %[0 1 2 3]
        File_5=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_5,file_ext];
        temp=csvread(File_5,1,3);
        Heath_potential=temp(:,1:end-1); clear temp Name_5 File_5;
        
        %Set value to 1 if there is >=5% of the habitat in the cell (set-aside as
        %50% grassland/abandoned, 50% forest) and there is climatically and soil-ly
        %available "Heath potential habitat" --> value>=2;
        thres=Ext_grass+Very_Ext_grass+Unman_land+(Arable_crops.*SET.*0.5);
        %condition 1
        a=thres>=5;
        %condition 2
        b=Heath_potential>=2;
        %Binary output
        C=SP.*a.*b;
        
    elseif habitat(i)==7 %Grassland (not just heath)
        
        Name_1='Extensively grass'; % [%]
        File_1=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_1,file_ext];
        temp=csvread(File_1,1,3);
        Ext_grass=temp(:,1:end-1); clear temp Name_1 File_1;
        
        Name_2='Very Extensively grass'; % [%]
        File_2=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_2,file_ext];
        temp=csvread(File_2,1,3);
        Very_Ext_grass=temp(:,1:end-1); clear temp Name_2 File_2
        
        Name_3='Arable crops'; % [%]
        File_3=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_3,file_ext];
        temp=csvread(File_3,1,3);
        Arable_crops=temp(:,1:end-1); clear temp Name_3 File_3;
        
        Name_4='Unmanaged land'; % [%]
        File_4=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_4,file_ext];
        temp=csvread(File_4,1,3);
        Unman_land=temp(:,1:end-1); clear temp Name_4 File_4;
        %Set value to 1 if there is >=5% of the habitat in the cell (set-aside as
        %50% grassland/abandoned,50% forest
        
        thres=Ext_grass+Very_Ext_grass+Unman_land+(Arable_crops.*SET.*0.5);
        %condition
        a=thres>=5;
        %Binary output
        C=SP.*a;
        
    elseif habitat(i)==8 %Forest and grassland
        
        Name_1='Extensively grass'; % [%]
        File_1=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_1,file_ext];
        temp=csvread(File_1,1,3);
        Ext_grass=temp(:,1:end-1); clear temp Name_1 File_1;
        
        Name_2='Very Extensively grass'; % [%]
        File_2=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_2,file_ext];
        temp=csvread(File_2,1,3);
        Very_Ext_grass=temp(:,1:end-1); clear temp Name_2 File_2
        
        Name_3='Arable crops'; % [%]
        File_3=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_3,file_ext];
        temp=csvread(File_3,1,3);
        Arable_crops=temp(:,1:end-1); clear temp Name_3 File_3;
        
        Name_4='Unmanaged land'; % [%]
        File_4=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_4,file_ext];
        temp=csvread(File_4,1,3);
        Unman_land=temp(:,1:end-1); clear temp Name_4 File_4;
        
        Name_5='Managed forest'; % [%]
        File_5=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_5,file_ext];
        temp=csvread(File_5,1,3);
        Man_forest=temp(:,1:end-1); clear temp Name_5 File_5;
        
        Name_6='Unmanaged forest'; % [%]
        File_6=[bpath,'batchRun_Adaptation_Strat',num2str(Strategy(S)),'\',Name_6,file_ext];
        temp=csvread(File_6,1,3);
        Unman_forest=temp(:,1:end-1); clear temp Name_6 File_6;
        
        %Set value to 1 if there >05% of the habitat in the cell (set aside as 50%
        %grassland/abandoned, 50% forest - both of which contribute here), grass
        %and forest both included
        
        thres=Ext_grass+Very_Ext_grass+Man_forest+Unman_forest+Unman_land+(Arable_crops.*SET.*1);
        %condition
        a=thres>=5;
        %Binary output
        C=SP.*a;
        
    end %if habitat
    
    ALL_C(:,:,i)=C; %keep results for all species
    
end % loop species
LifeOnLand=sum(ALL_C,3); %sum across species

%Regional calculation
b=size(LifeOnLand,2);

for r=1:length(RR)
    a=find(IAP_regions==RR(r));
    LifeOnLand_reg=sum(LifeOnLand(a,:),1);
    SDG15_reg(r,counter+1:counter+b)=LifeOnLand_reg./BL_reg(r);
end

%Europe calculation
LifeOnLand_EU=sum(LifeOnLand,1); %sum number of present species for strategy for Europe
SDG15_EU(1,counter+1:counter+b)=LifeOnLand_EU/BL_EU;

counter=counter+b; %update with each strategy
end


