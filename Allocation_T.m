clear; clc;

% 读取数据
Read_Data;

Square = [658*(10^2), 640*(10^2)];  % 两湖面积
height_lowest = [110, 119];         % 大坝发电最低水位
height_initial = [142, 158];        % 两湖水位高度初始值
Volum_initial = height_initial .* Square;   % 两湖存水量初始值

% 5个州各自对水的需求（AIR为对农业，工业，居民用水需求，Elec为对水利发电用水需求）
Demands_AIR = (Water_Consumption_year(:, 5) - Water_Consumption_year(:, 4))';
Demands_Elec = (Water_Consumption_year(:, 4))';

alpha = zeros(2,5);     % 供水传输系数（湖1）
alpha(1, :) = Demands_AIR ./ sum(Demands_AIR);
alpha(2, :) = alpha(1, 5);
gamma = zeros(2, 5);    % 供水传输系数（湖2）
gamma(1, :) = Demands_Elec ./ sum(Demands_Elec);
gamma(2, :) = gamma(1, 5);

Velocity_InFlow = 500;  % 上流注水速率

beta = [0.2, 0.2];      % 水利发电机械系数
power_water = [1, 1];   % 水利发电功率
gravity = 9.7979;       % 重力加速度

[v_ijt, u_ijt, V_it, t_mark] = Water_Allocation_Iter(Volum_initial, height_initial, alpha, gamma,...
                                Velocity_InFlow, Square, beta, power_water, gravity,...
                                height_lowest, [Demands_AIR', Demands_Elec'], 10, 10);
clc;                            
[t_mark, v_ijt, u_ijt];
V_it;
if 1
    plot([0, t_mark'], V_it(:, 1)', '-r', [0, t_mark'], V_it(:, 2)', '-.b');
    xlabel("迭代时间t"), ylabel("湖面水位存水量"), legend("Lake Powell", "Lake Mead");
    grid on;
end
if 0
    subplot(2, 1, 1);
    plot(t_mark', v_ijt(:, 1)', 'r', t_mark', v_ijt(:, 2)', 'y', t_mark', v_ijt(:, 3)', 'k', ...
        t_mark', v_ijt(:, 4)', 'b', t_mark', v_ijt(:, 5)', 'c');
    xlabel("迭代时间t"), ylabel("v_1j"), legend("California", "Arizona", "Colorado", "New Mexico", "Wyoming");
    grid on;
    
    subplot(2, 1, 2);
    plot(t_mark', v_ijt(:, 6)', 'r', t_mark', v_ijt(:, 7)', 'y', t_mark', v_ijt(:, 8)', 'k', ...
        t_mark', v_ijt(:, 9)', 'b', t_mark', v_ijt(:, 10)', 'c');
    xlabel("迭代时间t"), ylabel("v_2j"), legend("California", "Arizona", "Colorado", "New Mexico", "Wyoming");
    grid on;
end
