A = [1 -5 11 1 0 0;
    17 -16 -11 0 1 0;
    -1 31 9 0 0 1];
b = [12 15 91]';
c = [41 -2 14 10 42 20]';
[x_opt, f_x_opt, inter] = Simple_A(A, b, c);
disp("最优解为：");disp(x_opt);
disp("最优函数值为：");disp(f_x_opt);
disp("迭代次数为：");disp(inter);