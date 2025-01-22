clear; clc;
%读取数据
Read_Data;


FiveStates_Cell = cellstr(["California", "Arizona", "Colorado", "New Mexico", "Wyoming"]');

Supply_Channel_Map = graph(Supply_Channel_Map_Data, FiveStates_Cell);

[M, F] = maxflow(Supply_Channel_Map, 3, 1);
p = plot(Supply_Channel_Map, 'EdgeLabel', Supply_Channel_Map.Edges.Weight...
        );
highlight(p, F, 'EdgeColor', 'r', 'LineWidth', 1.5);

