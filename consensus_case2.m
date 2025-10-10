clc,clear all
%consensus matrices
a=[ 0.5   0.25  0      0     0.25;
    0.25  0.25  0.25   0     0.25;
    0     0.25  0.5    0.25  0;
    0     0     0.25   0.5   0.25;
    0.25  0.25  0      0.25  0.25];

%%
%initalization of Pi,Power mismatch,lambda,total load,convergence
%rate,alpha,beta,gamma
pwr=[35 20 25 30 10];
delta_P=[0 0 0 0 0];
lambda=[7.8000    5.6500    8.6600    8.9400    4.6500];
total_load=120;%MW
e=[0.07 0.04 0.07 0.04 0.05];
beta = [1.22;2.53;3.41;4.02;3.17];
alpha=[0.094;0.078;0.105;0.082;0.074];
p_min=[20;20;10;12;12];
p_max=[80;60;40;45;18];


%%
t=1;
while 1
    for i=1:5
        temp=0;
        for j=1:5
            temp=temp + a(i,j)*lambda(j);
        end
        cal_lambda(i)=temp + (e(:,i)* delta_P(i));
        my_lambda(t,i)=cal_lambda(i);
        
    end
    %%
    
    for i=1:5
        
             
            if t>=5
             
            lambda_min= (2*alpha(i,:)*p_min(i,:))+beta(i,:);
            lambda_max= (2*alpha(i,:)*p_max(i,:))+beta(i,:);

             if  my_lambda(t,i)< lambda_min
                 
                  temp_my_pwr(i)= p_min(i,:);
                  
             elseif my_lambda(t,i)> lambda_max
                    
                 temp_my_pwr(i)= p_max(i,:);

             elseif lambda_min <= my_lambda(t,i)<= lambda_max
                 temp_my_pwr(i)= (my_lambda(t,i)-beta(i,:))/(2*alpha(i,:));
             end
            
            else
                temp_my_pwr(i)= (my_lambda(t,i)-beta(i,:))/(2*alpha(i,:));
            end
             my_pwr(t,i)= temp_my_pwr(i);
             
    end
    total_gen(t)= sum(my_pwr(t,:));
     %%   
       for i=1:5
        temp1=0;
        for j=1:5
            temp1=temp1 + a(i,j)*delta_P(j);
        end
        cal_delta_P(i)=temp1 - (my_pwr(t,i)-pwr(1,i));
        my_delta_P(t,i)=cal_delta_P(i);
        delta_P(i)=cal_delta_P(i);
       end 
    
    pwr=temp_my_pwr;
    lambda=cal_lambda;
    t=t+1;
    
    if t==100;
        break;
    end
    
    
end



    plot(my_lambda(:,1),'r');
    hold on;
    plot(my_lambda(:,2),'g');
    hold on;
    plot(my_lambda(:,3),'b');
    hold on;
    plot(my_lambda(:,4),'c');
    hold on;
    plot(my_lambda(:,5),'m');
    
    figure;
    
    plot(my_pwr(:,1),'r');
    hold on;
    plot(my_pwr(:,2),'g');
    hold on;
    plot(my_pwr(:,3),'b');
    hold on;
    plot(my_pwr(:,4),'c');
    hold on;
    plot(my_pwr(:,5),'m');
    legend('g1','g2','g3','g4','g5');
    
    figure;
    
    plot(my_delta_P(:,1),'r');
    hold on;
    plot(my_delta_P(:,2),'g');
    hold on;
    plot(my_delta_P(:,3),'b');
    hold on;
    plot(my_delta_P(:,4),'c');
    hold on;
    plot(my_delta_P(:,5),'m');
    
    aa=ones(1,100);
    
    x=1:t;
    figure;
    
    plot(x,(total_load.*aa),'r--','LineWidth',2);
    hold on;
    plot(total_gen,'g');
    