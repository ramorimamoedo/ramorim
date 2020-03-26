%%Plot measurements versus Morris simulations


% Note that performing a simulation with default options of the ODEsolver
% is obtained by writing empty square brackets [] in the options field
fs=12;
 % Create a new figure window

t =[1;2;3;4;5;6;7;8;9;10;11;12];

values1= y1.Var1; 
values2= y2.Var2; 
values3= y3.Var3; 
figure(1) % Create a new figure window
subplot(1,3,1);
plot(values1);
ylabel('Electricity generation','FontSize',fs,'FontWeight','bold') 
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold') 
subplot(1,3,2)
plot(values2)
ylabel('SNG production','FontSize',fs,'FontWeight','bold') 
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold') 
subplot(1,3,3)
plot(values3)
ylabel('Cooling cost','FontSize',fs,'FontWeight','bold') 
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold') 
