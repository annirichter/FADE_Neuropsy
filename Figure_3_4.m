% FADE-npsy: Figure 3+4
% _
% written by Anni Richter <arichter@lin-magdeburg.de>, 15/08/2022
% reworked by Joram Soch <Joram.Soch@DZNE.de>, 09/02/2023, 22:57
% reworked by Anni Richter <arichter@lin-magdeburg.de>, 22/02/2023

clear
close all

%%% Step 1: load and assign data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load FADE/SAME scores
load data.mat

% specify figures
fig_labels = [3, 4];
col_labels = {'NOVELTY-BASED SCORES', 'MEMORY-BASED SCORES'};
row_labels = {'A-prime',  'global cognition';
              'VLMT 1d', 'VLMT distractor';
              'WMS 1d',  'flexibility RT [s]'};
z_limits   = [NaN, NaN;
              15,  15;
              40,  4];
sig_mar{1} = {'**', '**';
              '',   '**';
              '**', '*'};
sig_mar{2} = {'',   '*';
              '*',  '';
              '',   '*'};

% specify data
x1s        = {novelty_FADE, memory_FADE};
x2s        = {novelty_SAME,    memory_SAME};
ys         = {Aprime,  GlobalCognition;
              VLMT_1d, VLMT_Distractor;
              WMS_1d,  Flexibility_RT/1000};

% calculate counts
num_figs = numel(fig_labels);
num_cols = numel(col_labels);
num_rows = size(ys,1);


%%% Step 2: visualize regressions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for all figures
for i = 1:num_figs
    
    % open figure
    figure('Name', sprintf('Figure %d', fig_labels(i)), 'Color', [1 1 1], 'Position', [(i-1)*450 50 900 900]);
    
    % for all rows
    for j = 1:num_rows
        
        % for all columns
        for k = 1:num_cols
            
            % perform linear regression
            subplot(num_rows, num_cols, (j-1)*num_cols+k);
            x1 = x1s{k};
            x2 = x2s{k};
            y  = ys{j,i};
            X  =[x1, x2, ones(size(x1))];
            b  = regress(y,X);
            
            % prepare regression plane
            x1fit = min(x1):0.1:max(x1);
            x2fit = min(x2):0.1:max(x2);
           [x1fit, x2fit] = meshgrid(x1fit, x2fit);
            yfit  = b(1)*x1fit + b(2)*x2fit + b(3);

            % visualize data points
            hold on;
            for l = 1:numel(y)
                plot3([x1(l), x1(l)], [x2(l), x2(l)], [y(l), b(1)*x1(l)+b(2)*x2(l)+b(3)], '-k');
            end;
            scatter3(x1, x2, y, 20, [0,0.447,0.741], 'filled');
            mesh(x1fit, x2fit, yfit, 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'FaceColor', 'interp');
            xlim([min(x1), max(x1)]);
            ylim([min(x2), max(x2)]);
            if ~isnan(z_limits(j,i))
                zlim([0, z_limits(j,i)]);
            end;
            grid on;
            set(gca,'Box','On');
            xlabel('FADE score', 'FontSize', 10);
            ylabel('SAME score', 'FontSize', 10);
            zlabel(row_labels{j,i}, 'FontSize', 10);
            if j == 1
                title(sprintf('%s\n\nZ = %0.3f X + %0.3f Y + %0.3f%s', col_labels{k}, b(1), b(2), b(3), sig_mar{i}{j,k}), 'FontSize', 12);
            else
                title(sprintf('Z = %0.3f X + %0.3f Y + %0.3f%s', b(1), b(2), b(3), sig_mar{i}{j,k}), 'FontSize', 12);
            end;
            view(70,10);
            
        end;
        
    end;
    
end;