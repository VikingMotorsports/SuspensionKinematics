clear;
clc;
close all;

%% Set Up
datamode = LongOrLat(); % Choose longetudinal or lateral mode

q=0;                    % Validation State

% Data Validation
while q == 0            
    
    % Import Data
    [fileid, pathname] = uigetfile({'*.mat;*.dat'},'File Selector');

    if( isa(fileid, 'double') && isequal(fileid, 0) )
        % No file was chosen, so we return
        return
    end
    
    [AT, ET, FX, FY, FZ, IA, MX, MZ, N, NFX, NFY, P, RE, RL, RST, SA, SR, TSTC, TSTI, TSTO, V]...
    = ImportRawData( fullfile(pathname, fileid) );
    alldata = [AT, ET, FX, FY, FZ, IA, MX, MZ, N, NFX, NFY, P, ...
               RE, RL, RST, SA, SR, TSTC, TSTI, TSTO, V];
    alldata_str = {'AT', 'ET', 'FX', 'FY', 'FZ', 'IA', 'MX', 'MZ', 'N', 'NFX', 'NFY', 'P', ...
               'RE', 'RL', 'RST', 'SA', 'SR', 'TSTC', 'TSTI', 'TSTO', 'V'};
    
    % Trim Warmup Data
    trim_state = 0;
    while trim_state == 0
    plot(ET,SA) % Sample Plot
    xlabel('Seconds')
    ylabel('Steering angle')
    warmup_end = inputdlg('At what time do uniform sweeps'); % Trim Prompt
    trim_state = str2double(warmup_end);
    time_index = ET > str2double(warmup_end); % Trim Index
    AT   = AT (time_index);
    ET   = ET (time_index);
    FX   = FX (time_index);
    FY   = FY (time_index);
    FZ   = FZ (time_index);
    IA   = IA (time_index);
    MX   = MX (time_index);
    MZ   = MZ (time_index);
    N    = N (time_index);
    NFY  = NFY (time_index);
    P    = P (time_index);
    RE   = RE (time_index);
    RL   = RL (time_index);
    RST  = RST (time_index);
    SA   = SA (time_index);
    SR   = SR (time_index);
    TSTC = TSTC (time_index);
    TSTI = TSTI (time_index);
    TSTO = TSTO (time_index);
    end
    

    
    % Conversion Formulas
    lbf2N = @(lbf)lbf*4.4482216152605;
    N2lbf = @(N)N/4.4482216152605;

    psi2kPa = @(psi)psi/0.145037737730217;
    kPa2psi = @(kPa)kPa*0.145037737730217;

    % Binning
    figure
    plot(ET,FZ/4.448,'.'); 
    grid on
    xlabel('Elapsed Time (s)');
    ylabel('FZ (N)');
    title('Variation of FZ','FontSize',10);
    [countsFZ,edgesFZ] = histcounts(N2lbf(FZ));
    fz_noise_index = countsFZ < 2200;
    countsFZ(fz_noise_index) = 0;
    [~,locsFZ] = findpeaks([countsFZ(2), countsFZ, countsFZ(end-1)]);

    figure 
    plot(ET,0.145*P);
    xlabel('Elapsed Time (s)');
    ylabel('P (psi)');
    grid on
    title('Variation of Pressure','FontSize',10);
    [countsP,edgesP] = histcounts(kPa2psi(P));
    P_noise_index = countsP < 1000;
    countsP(P_noise_index) = 0;
    [~,locsP] = findpeaks([countsP(2), countsP, countsP(end-1)]);

    figure 
    plot(ET,IA);
    xlabel('Elapsed Time (s)');
    ylabel('IA ({\circ}''s)');
    grid on
    title('Variation of IA','FontSize',10);
    [countsIA,edgesIA] = histcounts(IA);
    [~,locsIA] = findpeaks([countsIA(2), countsIA, countsIA(end-1)]);

    FZ_binvalues = lbf2N(unique(round(abs(edgesFZ(locsFZ)))));
    P_binvalues  = unique(round(edgesP(locsP)));
    IA_binvalues = unique(round(edgesIA(locsIA)));

    if( isempty(FZ_binvalues) || isempty(P_binvalues) || isempty(IA_binvalues) )
        error('One or more of the *_binValues arrays was empty.')
    end

    P_eps = 0.8;  % Pressure tolerance (psi)
    P_bin = kPa2psi(P)>(P_binvalues-P_eps-0.3)&kPa2psi(P)<(P_binvalues+P_eps); %(psi)

    IA_eps = 0.2; % Inclination angle tolerance (deg)
    IA_bin = (IA>IA_binvalues-IA_eps)&(IA<IA_binvalues+IA_eps); %(deg)

    FZ_eps1 = lbf2N(35); % Normal force tolerance (N)
    FZ_bin = abs(FZ)>((FZ_binvalues-FZ_eps1))&abs(FZ)<((FZ_binvalues+FZ_eps1)); %(N)

    if datamode == 1
        S_0 = (-1<SA)&(SA<1);
    else
        S_0 = (-1<SR)&(SR<1);
    end

    close all

    subplot(3,1,1)
    plot(ET,FZ,'.');
    yline(-FZ_binvalues);
    title('Variation of FZ','FontSize',10);
    xlabel('Elapsed Time (s)');
    ylabel('FZ (N)');

    subplot(3,1,2)
    plot(ET,kPa2psi(P));
    yline((P_binvalues));
    title('Variation of Pressure','FontSize',10);
    xlabel('Elapsed Time (s)');
    ylabel('P (psi)');

    subplot(3,1,3)
    plot(ET,IA);
    yline((IA_binvalues));
    xlabel('Elapsed Time (s)');
    ylabel('IA ({\circ}''s)');
    title('Variation of IA','FontSize',10);
    
    data_validity = questdlg('Is the data suitable? (i.e. binned properly, multiple settings)', ...
     'Data Validation', 'Yes','No','No');
    switch data_validity
        case 'Yes'
            q = 1
        case 'No'
            q = 0
            end
    close all
    clc;
    [IA_mat,FZ_mat] = meshgrid(IA_binvalues,FZ_binvalues);
end

% Preallocate Memory for Magic Formula
A = cell(length(P_binvalues),length(IA_binvalues),length(FZ_binvalues));
[S_binfzia, F_binfzia, NF_binfzia, ET_binfzia, FZ_binfzia, IA_binfzia, ...
    MX_binfzia, MZ_binfzia, CS_fzia, mu_fzia, S_H_fzia, S_V_fzia, S_bar_fzia, ...
    F_bar_fzia, B_fzia, C_fzia, D_fzia, E_fzia, F_M, S_M] = deal(A);
B = cell(length(P_binvalues), 1);
[B_P, C_P, D_P, E_P, S_S_P, S_V_P, mu_P, S_H_P, CS_P, S_H_surf_IA_P, ...
    S_V_surf_IA_P, Mu_surf_IA_P, CS_surf_IA_P, B_surf_IA_P, C_surf_IA_P, ...
    D_surf_IA_P, E_surf_IA_P] = deal(B);

close all

%% Magic Formula Computation
for i=1:length(P_binvalues) % P Bin Indexing
    for m=1:size(FZ_bin,2)  % FZ Bin Indexing
        for n=1:size(IA_bin,2)                   % IA Bin Indexing
            validIdx = FZ_bin(:,m) & P_bin(:,i) & IA_bin(:,n) & S_0;
            ET_binfzia{i,n,m}  =  ET(validIdx);  % Time Bins
            FZ_binfzia{i,n,m}  =  FZ(validIdx);  % Vertical Load bins
            IA_binfzia{i,n,m}  =  IA(validIdx);  % Inclination Angle bins
            MX_binfzia{i,n,m}  =  MX(validIdx);  % Overturning Moment bins
            MZ_binfzia{i,n,m}  =  MZ(validIdx);  % Aligning Moment bins
            
            if datamode == 1 % Lat vs Long Indexing
                F_binfzia{i,n,m}  =  FX(validIdx);  % Logitudinal Force Bins
                NF_binfzia{i,n,m} =  NFX(validIdx); % Force Coefficient bins
                S_binfzia{i,n,m}  =  SR(validIdx);  % Slip Ratio Bins
            else
                F_binfzia{i,n,m}  =  FY(validIdx);  % Lateral Force Bins
                NF_binfzia{i,n,m} =  NFY(validIdx); % Force Coefficient bins
                S_binfzia{i,n,m}  =  SA(validIdx);  % Slip Angle Bins
            end
            [CS_fzia{i,n,m}, mu_fzia{i,n,m}, S_H_fzia{i,n,m}, ...
            S_V_fzia{i,n,m}, S_bar_fzia{i,n,m}, F_bar_fzia{i,n,m}] = ...
            NonDimTrans( F_binfzia{i,n,m}, NF_binfzia{i,n,m}, ...
                    S_binfzia{i,n,m}, ET_binfzia{i,n,m}, FZ_binfzia{i,n,m});  
            [B_fzia{i,n,m}, C_fzia{i,n,m}, D_fzia{i,n,m}, E_fzia{i,n,m}] = ...
                MagicFit(F_bar_fzia{i,n,m}, S_bar_fzia{i,n,m}); 
        end
    end
        B_P{i}   = permute(cell2mat(B_fzia(i,:,:)),[3,2,1])';
        C_P{i}   = permute(cell2mat(C_fzia(i,:,:)),[3,2,1])';
        D_P{i}   = permute(cell2mat(D_fzia(i,:,:)),[3,2,1])';
        E_P{i}   = permute(cell2mat(E_fzia(i,:,:)),[3,2,1])';
        S_S_P{i} = permute(cell2mat(CS_fzia(i,:,:)),[3,2,1])' ./FZ_binvalues;
        S_V_P{i} = permute(cell2mat(S_V_fzia(i,:,:)),[3,2,1])'./FZ_binvalues;
        mu_P{i}  = permute(cell2mat(mu_fzia(i,:,:)),[3,2,1])';
        S_H_P{i} = permute(cell2mat(S_H_fzia(i,:,:)),[3,2,1])'./FZ_binvalues;
        CS_P{i}  = permute(cell2mat(CS_fzia(i,:,:)),[3,2,1])';
        clc
        x = IA_binvalues;
        y = FZ_binvalues;

        S_H_surf_IA_P{i} = ResponseSurf(S_H_P{i},y,x,2);
        S_V_surf_IA_P{i} = ResponseSurf(S_V_P{i},y,x,2);
        Mu_surf_IA_P{i}  = ResponseSurf(mu_P{i},y,x,2);
        CS_surf_IA_P{i}  = ResponseSurf(CS_P{i},y,x,2);
        B_surf_IA_P{i}   = ResponseSurf(B_P{i},y,x,2);
        C_surf_IA_P{i}   = ResponseSurf(C_P{i},y,x,2);
        D_surf_IA_P{i}   = ResponseSurf(D_P{i},y,x,2);
        E_surf_IA_P{i}   = ResponseSurf(E_P{i},y,x,2);

        Slip_fit = -3:0.01:3;

    %% Plot All Slip Plots
    for m=1:length(FZ_binvalues)
        for n=1:length(IA_binvalues)        
            [F_M{i,n,m},S_M{i,n,m}] = MagicOutput(MagicFormula([B_surf_IA_P{i}(IA_binvalues(n),FZ_binvalues(m)),...
            	E_surf_IA_P{i}(IA_binvalues(n),FZ_binvalues(m))],Slip_fit),...
                Slip_fit,Mu_surf_IA_P{i}(IA_binvalues(n),FZ_binvalues(m)),...
                FZ_binvalues(m),CS_surf_IA_P{i}(IA_binvalues(n),FZ_binvalues(m)),datamode);
    
            if(i==1)
                if(m==1 && n==1)
                    figure
                    ax1 = axes;
                    hold on
                    if datamode == 1
                        FvsS_Title = 'F_x vs. SR';
                        yLab = 'F_x (N)'; xLab = 'SR(-)';
                    else
                        FvsS_Title = 'F_y vs. SA';
                        yLab = 'F_y (N)'; xLab = 'SA(-)';
                    end
                    title(FvsS_Title);
                    xlabel(xLab);
                    ylabel(yLab);
                    grid on
                end
                if(n==1)
                    [Ft,SRt]= MagicOutput(F_bar_fzia{i,n,m},S_bar_fzia{i,n,m},...
                        Mu_surf_IA_P{i}(IA_binvalues(n),FZ_binvalues(m)),...
                        FZ_binvalues(m),CS_surf_IA_P{i}(IA_binvalues(n),FZ_binvalues(m)),datamode);
                    
                    % Plotting the Line fit and the Raw Data Points
                        color = [(linspace(0,1,length(FZ_binvalues)))' (linspace(1,0,length(FZ_binvalues)))' (linspace(1,0,length(FZ_binvalues)))'];
                    % Matrix was created to have the same color betweeen data and fit line. Change the amount of values if more colors are needed.
                    plot(ax1,SRt,Ft,'.','Color',[color(m,1) (color(m,2)) color(m,3)],'HandleVisibility','off');
                    FZ_binvalues_r = round(FZ_binvalues,2);
                    plot(S_M{i,n,m}',F_M{i,n,m}','Color',[color(m,1) color(m,2) color(m,3)],'LineWidth',1,...
                       'DisplayName',[mat2str(FZ_binvalues_r(m)) ' N']);  
                end     
            end
        end
    end                      
    
    %% Surface Plotting
    
    % Creating the legend for figure. 
    h = legend(ax1,'show');
    set(h,'Location','eastoutside');
    htitle = get(h,'Title');
    set(htitle,'String','F_z (N)','FontSize',10);
 
    if(i==1)
        % Defining figures:
        [x_plot,y_plot] = meshgrid(0:0.25:4,linspace(FZ_binvalues(1),FZ_binvalues(end),11));      
                figure
            ax2 = axes;
            hold on
            grid on
            title('B vs. FZ vs. IA');
            xlabel('Inclination Angle ({\circ}''s)','Rotation',20);
            ylabel('F_Z (N)','Rotation',-30);
            zlabel('B (-)');
            view([-37.5 30]);
        figure
            ax3 = axes;
            hold on
            grid on 
            title('C vs. FZ vs. IA');
            xlabel('Inclination Angle ({\circ}''s)');
            ylabel('F_Z (N)','FontSize',10,'Rotation',-30);
            zlabel('C (-)');
            view([-37.5 30]);
        figure
            ax5 = axes;
            hold on
            grid on 
            title('E vs. FZ vs. IA','FontSize',10);
            xlabel('Inclination Angle ({\circ}''s)','FontSize',10,'Rotation',20);
            ylabel('F_Z (N)','Rotation',-30);
            zlabel('E (-)');
            view([-37.5 30]);
    end
    
    plot3(ax2,IA_mat,FZ_mat,B_surf_IA_P{i}(IA_mat,FZ_mat),'.','MarkerSize',25,...
        'MarkerEdgeColor',[i==1 i==2 i==3],'HandleVisibility','off');
    mesh(ax2,x_plot,y_plot,(B_surf_IA_P{i}(x_plot,y_plot)),'EdgeColor','none','LineWidth',2,...
        'FaceAlpha',0.4,'FaceColor',[i==1 i==2 i==3],'DisplayName',[mat2str(P_binvalues(i)) ' lbs']);
    plot3(ax3,IA_mat,FZ_mat,C_surf_IA_P{i}(IA_mat,FZ_mat),'.','MarkerSize',25,...
        'MarkerEdgeColor',[i==1 i==2 i==3],'HandleVisibility','off');
    mesh(ax3,x_plot,y_plot,(C_surf_IA_P{i}(x_plot,y_plot)),'EdgeColor','none','LineWidth',2,...
        'FaceAlpha',0.4,'FaceColor',[i==1 i==2 i==3],'DisplayName',[mat2str(P_binvalues(i)) ' lbs']);
    plot3(ax5,IA_mat,FZ_mat,E_surf_IA_P{i}(IA_mat,FZ_mat),'.','MarkerSize',25,...
        'MarkerEdgeColor',[i==1 i==2 i==3],'HandleVisibility','off');
    mesh(ax5,x_plot,y_plot,(E_surf_IA_P{i}(x_plot,y_plot)),'EdgeColor','none','LineWidth',2,...
        'FaceAlpha',0.4,'FaceColor',[i==1 i==2 i==3],'DisplayName',[mat2str(P_binvalues(i)) ' lbs']);
end
clc;

%% User Plotting 

A = cell(length(P_binvalues),length(IA_binvalues),length(FZ_binvalues));

for i=1:length(P_binvalues);
         for m=1:length(FZ_binvalues);
             for n=1:length(IA_binvalues);
                slip =  S_M(i,n,m);
                slip = cell2mat(slip)';
                grip_force = F_M(i,n,m);
                grip_force = cell2mat(grip_force)';
                new_mat = [slip grip_force];         
                A{i,n,m} = new_mat;       
          
             end 
         end 
end  
format bank

% Single Plots
FZ_binvalues_r = round(FZ_binvalues,2);
singleplot_mode = questdlg('Would you like individual SA plots?',...
                           'Individual Slip Angle Plot', 'Yes','No','No');
switch singleplot_mode
    case 'Yes'
        singleplot_mode = 1;
    case 'No'
        singleplot_mode = 0;
end

if singleplot_mode == 1

    
    singlep_prompt = "Choose your pressure bin";
    [i,tf] = listdlg('PromptString', {singlep_prompt},...
                                    'Name', 'Choose Bins',...
                                    'SelectionMode','single',...
                                    'ListString',num2str(P_binvalues'),...
                                    'ListSize', [300 300]);
    singlep = num2str(P_binvalues');

    singleIA_prompt = "Choose your inclination angle bin";
    [n,tf] = listdlg('PromptString', {singleIA_prompt},...
                                    'Name', 'Choose Bins',...
                                    'SelectionMode','single',...
                                    'ListString',num2str(IA_binvalues'),...
                                    'ListSize', [300 300]);
    singleia = num2str(IA_binvalues');

    singleFZ_prompt = "Choose your normal force bin";
    [m,tf] = listdlg('PromptString', {singleFZ_prompt},...
                                    'Name', 'Choose Bins',...
                                    'SelectionMode','single',...
                                    'ListString',num2str(FZ_binvalues'),...
                                    'ListSize', [300 300]);
    singlefz = num2str(FZ_binvalues');
    
    mat_one = cell2mat(A(i,n,m));

    % Plot Individual Slip Angle Plot
    if datamode == 1    
         figure
         plot(mat_one(:,1),mat_one(:,2));
         xlabel('Slip Ratio (-)');
         ylabel('Normal Force (N)');
         single_title = 'Bin:  PSI  DEG  N';
         single_title = insertAfter(single_title,"Bin: ", singlep(i));      % Gets Pressure Bin Value
         single_title = insertAfter(single_title,"PSI ", singleia(n));      % Gets Inclination Angle Bin Value
         single_title = insertAfter(single_title,"DEG ", singlefz(m));      
         title(single_title);
         SR_ind = mat_one(:,1);
         Tire_FZ = mat_one(:,2);
         table = table(SR_ind,Tire_FZ);    
    else          
         figure
         plot(mat_one(:,1),mat_one(:,2));
         xlabel('Slip Ratio (-)');
         ylabel('Normal Force (N)');
         single_title = 'Bin:  PSI  DEG  N';
         single_title = insertAfter(single_title,"Bin: ", singlep(i));      % Gets Pressure Bin Value
         single_title = insertAfter(single_title,"PSI ", singleia(n));      % Gets Inclination Angle Bin Value
         single_title = insertAfter(single_title,"DEG ", singlefz(m));  
         title(single_title);
         SA_ind = mat_one(:,1);
         Tire_FZ = mat_one(:,2);
         table = table(SA_ind,Tire_FZ);     
    end
    
    % Save Data to Spreadsheet
    plot_raw_data = questdlg('Would you like to plot other data relationships?',...
    'Other Data Plotting', 'Yes','No ','No ');
    if plot_raw_data == 'Yes'
          run_name = string(fileid);
          run_name = erase(run_name,".mat");
          run_name = insertAfter(run_name,run_name,"_psi_deg_N");
          run_name = insertBefore(run_name,"psi",string(P_binvalues(i)));
          run_name = insertBefore(run_name,"deg",string(IA_binvalues(n)));
          run_name = insertBefore(run_name,"N",string(FZ_binvalues(m)));
          run_name = strrep(run_name,".","_");
          run_name = insertAfter(run_name,run_name,".xls");
          writetable(table,run_name)
    end
    
else
    clc;
end

% Other Data Plots
plot_raw_data = questdlg('Would you like to plot other data relationships?',...
    'Other Data Plotting', 'Yes','No','No');
switch plot_raw_data
    case 'Yes'
        rawplot_mode = 1;
    case 'No'
        rawplot_mode = 2;
end
i=1;
m=1;
n=1;
plot_count = length(P_binvalues) * length(IA_binvalues)  * length(FZ_binvalues); 
if rawplot_mode == 1
    
    % Had to rerun these values from an earlier section, since
    % they were changed between then and now but the initial
    % value is desired
    for i=1:length(P_binvalues)                                     % P  Bin Indexing
        for m=1:size(FZ_bin,2)                       % FZ Bin Indexing
            for n=1:size(IA_bin,2)                   % IA Bin Indexing
                % Had to rerun these values from an earlier section, since
                % they were changed between then and now but the initial
                % value is desired
                %validIdx = FZ_bin(:,m) & P_bin(:,i) & IA_bin(:,n) & S_0;
                %validIdx = validIdx(time_index)
                ET_binfzia_plot{i,n,m}  =  ET(validIdx);  % Time Bins
                FZ_binfzia_plot{i,n,m}  =  FZ(validIdx);  % Vertical Load bins
                IA_binfzia_plot{i,n,m}  =  IA(validIdx);  % Inclination Angle bins
                MX_binfzia_plot{i,n,m}  =  MX(validIdx);  % Overturning Moment bins
                MZ_binfzia_plot{i,n,m}  =  MZ(validIdx);  % Aligning Moment bins

                if datamode == 1 % Lat vs Long Indexing
                    F_binfzia_plot{i,n,m}  =  FX(validIdx);  % Logitudinal Force Bins
                    NF_binfzia_plot{i,n,m} =  NFX(validIdx); % Force Coefficient bins
                    S_binfzia_plot{i,n,m}  =  SR(validIdx);  % Slip Ratio Bins
                else
                     F_binfzia_plot{i,n,m}  =  FY(validIdx);  % Lateral Force Bins
                    NF_binfzia_plot{i,n,m} =  NFY(validIdx); % Force Coefficient bins
                    S_binfzia_plot{i,n,m}  =  SA(validIdx);  % Slip Angle Bins
                end
            end
        end
    end
    rawplotcell = {ET_binfzia_plot; FZ_binfzia_plot; IA_binfzia_plot; MX_binfzia_plot; MZ_binfzia_plot; ...
                    F_binfzia_plot; NF_binfzia_plot; S_binfzia_plot}; % format for calling is {var,p,ia,fz}
    
    % Arrays to mange binned variable selection
    binned_cnst = ["P"; "IA"; "FZ"];
    binned_units = ["PSI";"deg";"lbs"];
    binned_mat = {P_binvalues,IA_binvalues,FZ_binvalues}';
    
    binned_call_idx = [1;1;1];
    binned_list = ["ET";"FZ";"IA";"MX";"MZ";"F";"NF";"S"];
    
    % User Prompt: Choose Binned Variable
    [raw_const,tf] = listdlg('PromptString', {'Choose one of the three primary binned variables',' to hold constant'},...
                                'Name', 'Choose Constant Variable',...
                                'SelectionMode','single',...
                                'ListString',binned_cnst,...
                                'ListSize', [300 300]);
    
    excl_bin_idx = find(binned_cnst ~= binned_cnst(raw_const));     % Excluded bin
    
    % User Prompt: Choose Bin
    bin_prompt = insertAfter("Choose your  bin","your ",binned_cnst(raw_const));
    [raw_const_bin,tf] = listdlg('PromptString', {bin_prompt},...
                                    'Name', 'Choose Constant Variable',...
                                    'SelectionMode','single',...
                                    'ListString',num2str(binned_mat{raw_const}'),...
                                    'ListSize', [300 300]);
    binned_call_idx(raw_const) = raw_const_bin;
    plot_count = length(binned_mat{excl_bin_idx(1)})*length(binned_mat{excl_bin_idx(2)});                        
    
    % User Prompt: Choose Ind Variable
    [raw_xvar,tf] = listdlg('PromptString', {'Choose the independent variable (x-axis)'},...
                                'Name', 'Choose Constant Variable',...
                                'SelectionMode','single',...
                                'ListString',binned_list,...
                                'ListSize', [300 300]);
    
    % User Prompt: Choose Dep Variable
    [raw_yvar,tf] = listdlg('PromptString', {'Choose the dependent variable (y-axis)'},...
                                'Name', 'Choose Constant Variable',...
                                'SelectionMode','single',...
                                'ListString',binned_list,...
                                'ListSize', [300 300]);
    
    % Plot Color(RGB) Matrix
    colormat = distinguishable_colors(length(binned_mat{excl_bin_idx(2)}));
    
    % tile plots
    tiledlayout('flow')
    
    % Loop through Ind Var Bins
    for raw_i = 1:length(binned_mat{excl_bin_idx(1)})
        
        % Match selected variable index to it's variable
        if binned_cnst(excl_bin_idx(1)) == 'P'
                binned_call_idx(1) = raw_i;
                
        elseif binned_cnst(excl_bin_idx(1)) == 'FZ'
                binned_call_idx(3) = raw_i;
                
        elseif binned_cnst(excl_bin_idx(1)) == 'IA'
                binned_call_idx(2) = raw_i;
        end
        
        nexttile
        for raw_n = 1:length(binned_mat{excl_bin_idx(2)})
            % Loop through Dep Var Bins    
            % Match selected variable index to it's variable
            if binned_cnst(excl_bin_idx(2)) == 'P'
                binned_call_idx(1) = raw_n;
                raw_p_bin = raw_n;
                legend_bin = 1;
            elseif binned_cnst(excl_bin_idx(2)) == 'FZ'
                binned_call_idx(3) = raw_n;
                raw_fz_bin = raw_n;
                legend_bin = 3;
            elseif binned_cnst(excl_bin_idx(2)) == 'IA'
                binned_call_idx(2) = raw_n;
                raw_ia_bin = raw_n;
                legend_bin = 2;
            end
            
            % Automatic Plot Titles
            graph_iteration = 'Iteration: P(kPa) IA(deg) FZ(N)';
            graph_iteration = insertAfter(graph_iteration,": ", num2str(binned_mat{1}(binned_call_idx(1))));      % Gets Pressure Bin Value
            graph_iteration = insertAfter(graph_iteration,"(kPa) ", num2str(binned_mat{2}(binned_call_idx(2))));  % Gets Inclination Angle Bin Value
            graph_iteration = insertAfter(graph_iteration,"(deg) ", num2str(binned_mat{3}(binned_call_idx(3))));  % Gets Normal Force Bin Value
            
            % Plot
            scatter(cell2mat(rawplotcell{raw_xvar}(binned_call_idx(1),binned_call_idx(2),binned_call_idx(3))),... 
                cell2mat(rawplotcell{raw_yvar}(binned_call_idx(1),binned_call_idx(2),binned_call_idx(3))),...     
                'MarkerEdgeColor',colormat(raw_n,:))
            grid on
            hold on
            title(graph_iteration)
            laba = binned_list{raw_xvar}; % More Detailed Axis Labels
            xlabel(laba)
            labb = binned_list{raw_yvar};
            ylabel(labb)
            legend_vars = insertAfter(strcat(num2str(binned_mat{legend_bin}(:)), " ")," ", binned_units(legend_bin));
            legend(legend_vars)
        end
    end
clc;    
end