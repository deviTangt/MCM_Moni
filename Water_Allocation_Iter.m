% output :
% v_ijt: iteration_num(行数) x 10（列数）   （列1至5为v_1jt, 列6至10为v_2jt）（行数列数下面表示方法同） 
% u_ijt: iteration_num x 10                 （列1至5为u_1jt, 列6至10为u_2jt）  
% V_it: (iteration_num + 1) x 2             存放2个湖的水位的时序变化（列1为V_1t, 列6至10为V_2t）
% t_mark: iteration_num x 1                 时间标志
%
% input : 
% V0_i: 2 x 1               初始化两湖的储水量
% h0_i: 2 x 1               初始两湖水位
% alpha_ij: 2 x 5           供水传输系数（湖1）
% gamma_ij: 2 x 5           供水传输系数（湖2）
% vf : 1 x 1                上流注水速率
% S_i: 2 x 1                两湖面积
% beta_i: 2 x 1             水利发电机械系数
% power_water: 1 x 1        水利发电功率
% gravity: 1 x 1            重力加速度
% h_lowest_i: 2 x 1         最低发电水位高度
% d_j: 5 x 2                5个州各自对水的需求（列1为对农业，工业，居民用水需求，列2为对水利发电用水需求）
% t_end: 1 x 1              持续时间
% iteration_num: 1 x 1      迭代次数上限
function [v_ijt, u_ijt, V_it, t_mark] = ...
                Water_Allocation_Iter(V0_i, h0_i, alpha_ij, gamma_ij, vf, ...
                S_i, beta_i, power_water, gravity,...
                h_lowest_i, d_j, t_end, iteration_num)

h_i_cur = [h0_i(1), h0_i(2)];       % 当前水位高度
t_cur = 0;                          % 当前时间
v_ijt = zeros(iteration_num, 10);   
u_ijt = zeros(iteration_num, 10);
t_mark = zeros(iteration_num, 1);   % 时间标识
V_it = zeros(iteration_num + 1, 2); V_it(1, :) = V0_i;  % 湖水总存水量

delta_t = t_end / iteration_num;    % 单次迭代时间间隔
iteration_count = 0;                % 迭代次数计数

while (h_i_cur(1) > 0 && h_i_cur(2) > 0 && iteration_count < iteration_num)
    iteration_count = iteration_count + 1;
    t_cur = t_cur + delta_t;
    t_mark(iteration_count, 1) = t_cur;
    
    if (V_it(iteration_count, 1) > 0 && V_it(iteration_count, 2) > 0) % 情况1
        % 线性方程求解
        C = zeros(1, 20);   
        C(1, :) = 1;
        Aeq = zeros(10, 20);            % 10 x 20矩阵
        v_u = zeros(20, 1);             % 20 x 1矩阵 方程的解
        beq = [d_j(:, 1); d_j(:, 2)];   % 10 x 1矩阵
        for j = 1 : 5
            Aeq(j, j) = alpha_ij(1, j);                 % v_1j
            Aeq(j, j + 5) = alpha_ij(2, j);             % v_2j
            
            Aeq(j + 5, j + 10) = gamma_ij(1, j);        % u_1j
            Aeq(j + 5, j + 15) = gamma_ij(2, j);        % u_2j
        end
        lb = zeros(20, 1);
        ub = zeros(20, 1); ub(:, 1) = inf;
        [v_u, ~] = linprog(C, [], [], Aeq, beq, lb, ub);
        Aeq;
        beq;
        v_u; 
        v_ijt(iteration_count, :) = v_u(1 : 10, 1)';
        u_ijt(iteration_count, :) = v_u(11 : 20, 1)';
    elseif (V_it(iteration_count, 1) <= 0 && V_it(iteration_count, 2) > 0) % 情况2
        % 线性方程求解
        C = zeros(1, 20);   
        C(1, :) = 1;
        Aeq = zeros(10, 20);            % 10 x 20矩阵
        v_u = zeros(20, 1);             % 20 x 1矩阵 方程的解
        beq = [d_j(:, 1); d_j(:, 2)];   % 10 x 1矩阵
        for j = 1 : 5
            Aeq(j, j) = alpha_ij(1, j);                 % v_1j
            Aeq(j, j + 5) = alpha_ij(2, j);             % v_2j
            
            Aeq(j + 5, j + 10) = gamma_ij(1, j);        % u_1j
            Aeq(j + 5, j + 15) = gamma_ij(2, j);        % u_2j
        end
        lb = zeros(20, 1);
        ub = zeros(20, 1); ub(:, 1) = inf; ub(1 : 5, 1) = 0; % v_1j 恒= 0 仅此一处与情况一不同
        Aeq;
        C;
        [v_u, ~] = linprog(C, [], [], Aeq, beq, lb, ub);
        v_u;
        v_ijt(iteration_count, :) = v_u(1 : 10, 1)';
        u_ijt(iteration_count, :) = v_u(11 : 20, 1)';
    elseif (V_it(iteration_count, 1) > 0 && V_it(iteration_count, 2) <= 0) % 情况3
        % 线性方程求解
        C = zeros(1, 20);   
        C(1, :) = 1;
        Aeq = zeros(10, 20);            % 10 x 20矩阵
        v_u = zeros(20, 1);             % 20 x 1矩阵 方程的解
        beq = [d_j(:, 1); d_j(:, 2)];   % 10 x 1矩阵
        for j = 1 : 5
            Aeq(j, j) = alpha_ij(1, j);                 % v_1j
            Aeq(j, j + 5) = alpha_ij(2, j);             % v_2j
            
            Aeq(j + 5, j + 10) = gamma_ij(1, j);        % u_1j
            Aeq(j + 5, j + 15) = gamma_ij(2, j);        % u_2j
        end
        lb = zeros(20, 1);
        ub = zeros(20, 1); ub(:, 1) = inf; ub(6 : 10, 1) = 0; % v_2j 恒= 0 仅此一处与情况一不同
        Aeq;
        C;
        [v_u, ~] = linprog(C, [], [], Aeq, beq, lb, ub);
        v_u;
        v_ijt(iteration_count, :) = v_u(1 : 10, 1)';
        u_ijt(iteration_count, :) = v_u(11 : 20, 1)';
    else  % 情况4
        v_ijt(iteration_count, :) = 0;
        u_ijt(iteration_count, :) = 0;
    end
    
    % 求大坝水力发电量
    w_ij = (beta_i .* power_water .* h_i_cur)' .* [u_ijt(iteration_count, 1 : 5); u_ijt(iteration_count, 6 : 10)] .* gravity;
    w_ij;
    if (h_i_cur(1, 1) < h_lowest_i(1, 1)) w_ij(1, :) = 0; end
    if (h_i_cur(1, 2) < h_lowest_i(1, 2)) w_ij(2, :) = 0; end
    
    % 两湖存水量进行迭代更新
    V_it(iteration_count + 1, 1) = V_it(iteration_count, 1) - sum(v_ijt(iteration_count, 1 : 5)) - sum(u_ijt(iteration_count, 1 : 5)) + vf * delta_t;
    V_it(iteration_count + 1, 2) = V_it(iteration_count, 2) - sum(v_ijt(iteration_count, 6 : 10)) - sum(u_ijt(iteration_count, 6 : 10)) + sum(u_ijt(iteration_count, 1 : 5));
    % 迭代更新当前两湖水位高度
    h_i_cur = [V_it(iteration_count + 1, 1), V_it(iteration_count + 1, 2)] ./ S_i;
    h_i_cur;
end

end