%MATLAB 单纯形法的实现
%求解目标：max(f) 其中f=c'X
%约束条件：A*x=b ; x>=0
%x_opt：最优解；f_x_opt:最优解对应的最优函数值；inter:迭代次数
function [x_opt,f_x_opt,inter]=Simple_A(A,b,c)
%输入：A为约束条件中的系数矩阵；b为约束条件中等式右边的列向量；c为求解目标中的系数
%输出：x_opt:目标最优解；    f_x_opt：目标最优解对应的函数值；   inter:迭代次数
    [m,n] = size(A);%这里需满足m<=n;x下标从1-m为基向量；其余为非基向量
    zuhe=nchoosek(1:n,m);%nchoosek为组合数，返回从1:n的所有数里拿出m个数的所有情况
    basis_index=[];%基的索引
    for i=1:size(zuhe,1)
        if A(:,zuhe(i,:))==eye(m)%找到单位矩阵
            basis_index=zuhe(i,:);
        end
    end
%%找到非基向量索引值，这里使用setdiff()函数
nobasis_index=setdiff(1:n,basis_index);%setdiff(A，B)函数返回在向量A中但不在向量B中的元素，并升序排列
%此处用setdiff()提取索引值
inter=0;%循环迭代次数从0开始
while 1
    x0=zeros(n,1);
    x0(basis_index)=b;
    cb=c(basis_index);
    sigma=zeros(1,n);%此处sigma为检验数,当所有的检验数非正，即找到了最优解
    sigma(nobasis_index)=c(nobasis_index)'-(cb'*A(:,nobasis_index));%检验数的定义
    [~,s]=min(sigma);
    theta=b./A(:,s);%θ的计算
    theta(theta<=0)=10000;
    [~,q]=min(theta);
    q=basis_index(q);
    if ~any(sigma<0)%%判断条件
        x_opt=x0;
        f_x_opt=c'*x_opt;
        break
    end
    
    if all(A(:,s)<=0)%%判断是否有解
        x_opt=[];
        break;
    end
    %进行换基
    basis_index(basis_index==q)=s;%新的基向量索引
    nobasis_index=setdiff(1:n,basis_index);%非基的索引
    %%进行运算
    A(:,nobasis_index)=A(:,basis_index)\A(:,nobasis_index);
    b=A(:,basis_index)\b;
    A(:,basis_index)=eye(m,m);
    inter=inter+1;
end
end