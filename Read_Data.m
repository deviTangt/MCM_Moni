% 读取数据
clear; clc;
FiveStates_Info = ["California", "Arizona", "Colorado", "New Mexico", "Wyoming"];

% 5个州在2021年每个月于农业用水，工业用水，居民用水，水力生电4个领域各自消耗的用水量（MG）
[Water_Consumption_month, Water_Consumption_month_txt, Water_Consumption_month_raw] = xlsread("MCM_5 States' Water Consumption In 2021", "A2 : F61");
Water_Consumption_month;
Water_Consumption_year = zeros(5, 5); %年度用水 5 * 5
for states = 1 : 5
    for month = 1 : 12
        for type = 1 : 4
            Water_Consumption_year(states, type) = Water_Consumption_year(states, type) + Water_Consumption_month((states - 1) * 12 + month, type);
            Water_Consumption_year(states, 5) = Water_Consumption_year(states, 5) + Water_Consumption_month((states - 1) * 12 + month, type);
        end
    end
end
Water_Consumption_year;

% 5个州在2021年每两个州间供水管道最大值（cfs）
[Supply_Rate, Supply_Rate_txt, Supply_Rate_raw] = xlsread("MCM_Supply_Channel", "D2 : D11");
Supply_Rate;
Supply_Channel_Map_Data = zeros(5); % 输水通道矩阵 5 * 5
count = 0;
for State_1 = 1 : 5
    for State_2 = State_1 + 1 : 5
        count = count + 1;
        Supply_Channel_Map_Data(State_1, State_2) = Supply_Rate(count);
    end
end
Supply_Channel_Map_Data = Supply_Channel_Map_Data + Supply_Channel_Map_Data';

% 5个州在2021年每个月因降水端却和气候炎热于农业用水，工业用水，居民用水，水力生电4个领域各自多需要的用水量比例
External_Factor_Impact_ratio = xlsread("MCM_RainfallShortage&Hotter's Impact on Water", "C2 : D6");
External_Factor_Impact_ratio;   % 5 * 2 

% 过去25年的Glen Canyou Dam的月度的水位信息
Glen_Canyon_Dam_WaterHeight = xlsread("过去25年的Glen Canyou Dam的月度的水位信息");
Glen_Canyon_Dam_WaterHeight;    % 300 * 4

% MCM_Water of Colorado River to Gulf of Carnifornia
Water_Colorado_River2Gulf_of_Carnifornia = xlsread("MCM_Water of Colorado River to Gulf of Carnifornia", "C2 : C13");
Water_Colorado_River2Gulf_of_Carnifornia;   % 12 * 1

% MCM_Water of Glen Canyon Dam to Hoover Dam
Water_Glen_Canyon_Dam2Hoover_Dam = xlsread("MCM_Water of Glen Canyon Dam to Hoover Dam", "C2 : C13");
Water_Glen_Canyon_Dam2Hoover_Dam;   % 12 * 1
