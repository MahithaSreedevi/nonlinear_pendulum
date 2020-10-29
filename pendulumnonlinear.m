clc
clear all
close all
m=0.3;b=0.1;L=1;g=9.81;%giving the intial conditions for the pendulum
r=g/L;
k=b/(m*L);
f = @(t,x) [x(2);-k*x(2)-r*sin(x(1))];
init = [pi/2;0]; % gives the intial conditions of x(0)=pi/2 and x'(0)=0
[x,xx] = ode45(f,[20 40],init);%here[20,40] desribes the interval of time of run
xx=xx+5;
y=length(xx);
for i=1:y
    E(i)=xx(i,1);
end
plot(x,E)
title('Non linear Pendulum wave function 18BEC1026');
xlabel('Time (sec)','FontSize',12,'FontWeight',"bold");
ylabel('Amplitude','FontSize',12,'FontWeight',"bold");
figure(2)
stem(x,E); % plot of sampled signal
title('Sampled Signal 18BEC1026');
xlabel('Displacement');
ylabel('Energy');

n1=8;%number of bits per sample
L=2^n1;%no of levels of quantization
xmax=10;
xmin=-10;
del=(xmax-xmin)/L; %defining del
partition=xmin:del:xmax; % definition of decision lines
codebook=xmin-(del/2):del:xmax+del/2; % definition of representation levels
[index,quants]=quantiz(E,partition,codebook);%quantiz is inbuilt function which is used to quantize the signal
% gives rounded off values of the samples
figure(3)
set(gca,'Fontsize',12,'Fontweight','bold')
stem(index,"color",'r');%plotting of quantized signal
title('Quantized Signal 18BEC1026');
xlabel('Displacement','FontSize',12,'FontWeight',"bold");
ylabel('Energy','FontSize',12,'FontWeight',"bold");


% NORMALIZATION
l1=length(index); % to convert 1 to n as 0 to n-1 indicies
for i=1:l1
    if (index(i)~=0)
        index(i)=index(i)-1;
    end
end
l2=length(quants);
for i=1:l2 % to convert the end representation levels within the range.
    if(quants(i)==xmin-(del/2))
        quants(i)=xmin+(del/2);
    end
    if(quants(i)==xmax+(del/2))
        quants(i)=xmax-(del/2);
    end
end
% ENCODING
code=de2bi(index,'left-msb'); % DECIMAL TO BINANRY CONV OF INDICIES
k=1;
for i=1:l1 % to convert column vector to row vector
    for j=1:n1
        Coded(k)=code(i,j);
        j=j+1;
        k=k+1;
    end
    i=i+1;
end
figure(4);
stairs(Coded);
axis([0 190 -2 2])
%plot of digital signal
title('Digital Signal 18BEC1026');
set(gca,'Fontsize',12,'Fontweight','bold')
xlabel('Displacement','FontSize',12,'FontWeight',"bold");
ylabel('Energy','FontSize',12,'FontWeight',"bold");
%Demodulation
code1=reshape(Coded,n1,(length(Coded)/n1));
index1=bi2de(code1,'left-msb'); %converting from decimal to binary
resignal=del*index+xmin+(del/2);
figure(5);%plot of demodulated signal compared to original signl
subplot(2,1,1)%plot of demodulated signal
plot(x,resignal,"color",'k'); 
title('Demodulated Signal 18BEC1026');
xlabel('Displacement','FontSize',12,'FontWeight',"bold");
ylabel('Energy','FontSize',12,'FontWeight',"bold");
subplot(2,1,2)
plot(x,E,"color",'m');%plot of original signal
title('Original Signal 18BEC1026');
xlabel('Displacement','FontSize',12,'FontWeight',"bold");
ylabel('Energy','FontSize',12,'FontWeight',"bold");