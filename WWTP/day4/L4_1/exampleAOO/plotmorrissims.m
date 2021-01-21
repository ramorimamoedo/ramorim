%%Plot measurements versus Morris simulations


% Note that performing a simulation with default options of the ODEsolver
% is obtained by writing empty square brackets [] in the options field
fs=12;
figure(1) % Create a new figure window
subplot(2,2,1)
plot(t,y1,'b','LineWidth',1.5)
xlabel('Time (min)','FontSize',fs,'FontWeight','bold') 
ylabel('NH4 ','FontSize',fs,'FontWeight','bold') 
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold') 
subplot(2,2,2)
plot(t,y2,'b','LineWidth',1.5)
xlabel('Time (min)','FontSize',fs,'FontWeight','bold') 
ylabel('NO2','FontSize',fs,'FontWeight','bold') 
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold') 
subplot(2,2,3)
plot(t,y3,'b','LineWidth',1.5)
xlabel('Time (min)','FontSize',fs,'FontWeight','bold') 
ylabel('NO3','FontSize',fs,'FontWeight','bold') 
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold') 
subplot(2,2,4)
plot(t,y5,'b','LineWidth',1.5)
xlabel('Time (min)','FontSize',fs,'FontWeight','bold') 
ylabel('AOO','FontSize',fs,'FontWeight','bold') 
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold') 
