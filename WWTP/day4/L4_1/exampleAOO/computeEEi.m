%% Compute Elementary Effects(EEi) from the Morris simulations

%% this method requires scalar outputs, y:
% hence one needs to specify a meaningful property of time-series data: Let us focus on time=0.3 hr
time=time*24;
ii = find(abs(time-1.0) < 0.01);
y1s = y1(ii,:);
y2s = y2(ii,:);
y3s = y3(ii,:);
y4s = y4(ii,:);
y5s = y5(ii,:);

%% compile an model output matrix
Sim = [y1s' y2s' y4s' y5s'];
[n k] = size(X) ;
n = n / (k+1);
[mm ll] = size(Sim) ;

%% below info needed for sigma-scaling of EEi
sig_y = std(Sim);
sig_x = std(Xval);

var = {'Ammonium','Nitrite','Oxygen','AOO'} ;

%% read in the Morris simulations, detect which parameter changed and
%% compute the corresponding EEi

[n k] = size(X) ;
n = n / (k+1);
[mm ll] = size(Sim) ;

for i=1:n
    for j=1:k
        m1 = (k+1)*(i-1);
        r1 = m1 + j ;
        ix = find (X(r1,:) - X(r1+1,:)) ; % find the non-zero value
        if length(ix) > 1
            warning('there is more than one factor changed')
            return
        end
        m2 = k*(i-1)+j; % quality check: this is to track which params changed
        idx(m2) = ix ;
        dtheta = Xval(r1+1,ix) - Xval(r1,ix) ;
        EEs(i,ix) = (Sim(r1+1,1) - Sim(r1,1))/dtheta * (sig_x(ix)/sig_y(1))  ; % SEEi = EEi* sigx/sigy where EEi = (Ytheta - Ytheta+dtheta) / dtheta *
        EEo(i,ix) = (Sim(r1+1,2) - Sim(r1,2))/dtheta * (sig_x(ix)/sig_y(2));
        EEb(i,ix) = (Sim(r1+1,3) - Sim(r1,3))/dtheta * (sig_x(ix)/sig_y(3)); %
        EEour(i,ix) = (Sim(r1+1,4) - Sim(r1,4))/dtheta * (sig_x(ix)/sig_y(4)); %
    end
end

%% Calculate mean and std from Fi = EEi
for l=1:ll
    if l==1;
        Fi = EEs ;
    elseif l == 2
        Fi = EEo ;
    elseif l == 3
        Fi = EEb ;
    else 
        Fi = EEour ;
    end
    mu(:,l)  = mean(Fi);
    sig(:,l) = std(Fi);
end

fl =strcat('ComputedEEi_r',num2str(r),'_p',num2str(p),'.mat');
save(fl,'EEs','EEo','EEb','EEour','mu','sig')

% close all
pix = 1:k;
figure
for i=1:4
    subplot(2,2,i)
    for j=1:k
        sem(j,i) = 2*sig(j,i)/sqrt(r);
        plot(mu(j,i),sig(j,i),'ko',sem(j,i),sig(j,i),'k',-sem(j,i),sig(j,i),'k')
        hold on
        text(mu(j,i),sig(j,i),[lp{j},'=',num2str(j)])
    end
    title(var{i})
    xlabel('mean, \mu')
    ylabel('stdev, \sigma')
end

figure
for i=1:4
    subplot(2,2,i)
    sem(:,i) = 2*sig(:,i)/sqrt(r);
    plot(mu(:,i),sig(:,i),'k+',sort(sem(:,i)),sort(sig(:,i)),'k',-sort(sem(:,i)),sort(sig(:,i)),'k')
    hold on
    for j=1:k;
    text(mu(j,i),sig(j,i),lp{j})
    end
    title(var{i})
    xlabel('mean, \mu_i')
    ylabel('standard deviation, \sigma_i')
end

f = 1;
if f == 1;
    for l=1:ll
        if l==1
            Fi = EEs ;
        elseif l == 2
            Fi = EEo ;
        elseif l == 3
            Fi = EEb ;
        else 
            Fi = EEour ;
        end
        figure
        subplot(2,2,1)
        hist(Fi(:,1))
        xlabel(['EEi of ',lp{1}])
        ylabel('Frequency')
        title(var(l))
        subplot(2,2,2)
        hist(Fi(:,2))
        xlabel(['EEi of ',lp{2}])
        ylabel('Frequency')
        subplot(2,2,3)
        hist(Fi(:,3))
        xlabel(['EEi of ',lp{3}])
        ylabel('Frequency')
        subplot(2,2,4)
        hist(Fi(:,4))
        xlabel(['EEi of ',lp{4}])
        ylabel('Frequency')

    end
end

