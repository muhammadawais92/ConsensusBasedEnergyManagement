clc;
clear;
W=[0.5 0.5 0;
    0 0.5 0.5;
    0.5 0 0.5;];
Q=W;
%发电机
a1=0.0028;b1=7.63;c1=20;B1=0.000331;P1m=12;P1M=165.10;%%卖电
a2=0.0018;b2=3.28;c2=54;B2=0.00051;P2m=29;P2M=137.19;%%卖电
%负荷
afa=0.0545;omega=18.43;P3m=50;P3M=100.34;%%买电

%% 初始化  p==price；P==power
global p;
global P;
p=zeros(1,3);
P=zeros(1,3);
xi=zeros(1,3);
tempxi=zeros(1,3);
tempp=zeros(1,3);
p(1)=(2*a1*P1m+b1)/(1-2*B1*P1m);
p(2)=(2*a2*P2m+b2)/(1-2*B2*P2m);
if(omega/(2*afa)>=P3M)
    p(3)=omega-2*afa*P3M;
    else p(3)=1;
end
P(1)=0;P(2)=0;P(3)=0;
xi(1)=0;xi(2)=0;xi(3)=0;
eta=0.00008;
%% 存储
myp=zeros(2000,3);
myP=zeros(2000,3);
myxi=zeros(2000,3);
for i=1:3
    myp(1,i)=p(i);
    myP(1,i)=P(i);
    myxi(1,i)=xi(i);
end
%%
syms P1;syms P2;syms P3;
t=2;
while 1
    %% 更新价格
    for i=1:3
        tempp(i)=p(i);
        temp=0;
        for j=1:3
            temp=temp+W(i,j)*p(j);
        end
        p(i)=temp+eta*xi(i);
        myp(t,i)=p(i);
    end
    %% 更新出力
    for i=1:1
        tempP1=P(1);
        tempP2=P(2);
        tempP3=P(3);
        [P(1),fval]=fminbnd(@(P1)fun1(P1),12,165.10);
        P(2)=fminbnd(@(P2)fun2(P2),29,137.19);
        P(3)=fminbnd(@(P3)fun3(P3),50,100.34);
        for j=1:3
            myP(t,j)=P(j);
        end
    end
    %% 更新功率差额
    tempxi=xi;
    for i=1:2
        temp=0;
        for j=1:3
            temp=temp+Q(i,j)*tempxi(j);
        end
        if(1==i)
        xi(i)=temp+(tempP1-B1*tempP1^2)-(P(i)-B1*P(i)^2);
        else if(2==i)
                xi(i)=temp+(tempP2-B2*tempP2^2)-(P(i)-B2*P(i)^2);
            end
        end
    end
    temp=0;
    for j=1:3
        temp=temp+Q(3,j)*tempxi(j);
    end
    xi(3)=temp+P(3)-tempP3;
    for i=1:3
        myxi(t,i)=xi(i);
    end
    %% 判断收敛性
    delta=0.01;
    if(abs(xi(1))<=delta&&abs(xi(2))<=delta&&abs(xi(3))<=delta&&abs(p(1)-tempp(1))<=delta&&abs(p(2)-tempp(2))<=delta&&abs(p(3)-tempp(3))<=delta)
        break;
    end
    t=t+1;
end
    %% 显示
    plot(myp(:,1),'r-^');
    hold on;
    plot(myp(:,2),'g-^');
    hold on;
    plot(myp(:,3),'m-^');
    hold on;
    figure;
    plot(myP(:,1),'r-*');
    hold on;
    plot(myP(:,2),'g-s');
    hold on;
    plot(myP(:,3),'m-p');
    hold on;
    figure;
    plot(myxi(:,1),'r-h');
    hold on;
    plot(myxi(:,2),'g-h');
    hold on;
    plot(myxi(:,3),'m-h');
    hold on;

