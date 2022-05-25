%% data loading
path="E:\back up2\Google Drive2\Large Files\Datasets\ECGI_datasets\processed_data3\";
load(path+"auckland_insitu_data_1230.mat")
%% data visualization, 
figure(1)
pig=3;
exp=1;
ecg_cs=ecg_all{2,pig}{1,exp};
ecg_ts=ecg_all{3,pig}{1,exp};
for t=1:40
    subplot(4,10,t)
    ax=gca;
    set(ax,'visible','off')
    imshow(ecg_ts(:,:,1,t*20),'Colormap',jet)
    ax.CLim=[-1,1];
end
%% cross validation over same pig
% parallel.gpu.enableCUDAForwardCompatibility(0)
for pig=1:1
    num_exp=length(ecg_final{1,pig});
    for exp=1:1 % training in this loop
        m=1;
        train_ts=cell(1,num_exp-1);%croos validate with leave one out
        train_cs=cell(1,num_exp-1);
        val_ts=ecg_final{3,pig}{1,exp};
        val_cs=ecg_final{2,pig}{1,exp};
        %data allocation
        for i=1:num_exp
            if i ~= exp
                train_ts{1,m}=ecg_final{3,pig}{1,i};
                train_cs{1,m}=ecg_final{2,pig}{1,i};
                m=m+1;
            end
        end
        %re-initialized the model
        layers = [
        sequenceInputLayer([30,90,1],'Name','input')
        sequenceFoldingLayer('name','fold')
        convolution2dLayer([2 2],16,'Padding',[0 0 0 0],'Name','conv2D1')
        reluLayer('name','reluLayer1')
        sequenceUnfoldingLayer('name','unfold')    
        flattenLayer('Name','flatten')
        fullyConnectedLayer(239,'Name','fullyconnected2')
        regressionLayer('Name','regression output')];
        lgraph = layerGraph(layers);
        lgraph = connectLayers(lgraph,'fold/miniBatchSize','unfold/miniBatchSize');
         %model training
         options = trainingOptions('adam', ...
        'MaxEpochs',100, ...
        'InitialLearnRate',0.001, ...
        'Verbose',true, ...
        'Plots','training-progress',...
        'LearnRateSchedule','piecewise', ...
        'LearnRateDropFactor',0.9, ...
        'Shuffle','every-epoch', ...
        'LearnRateDropPeriod',1,...
        'ValidationData',{{val_ts},{val_cs}}, ...
        'ValidationFrequency',fix(length(train_cs)/4),...
        'OutputFcn',@(info)stopIfAccuracyNotImproving(info,20),...
        'miniBatchSize',4);
        [net,info] = trainNetwork(train_ts,train_cs',lgraph,options);
        save("same_pig_cross_val_model_pig"+num2str(pig)+"_exp_"+num2str(exp),'net','info')
    end
end
%% 
graph
%% cross validation over same pig 
% path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\Cross Validation results\";
cc=cell(1,5);
for pig=2:2
    num_exp=length(ecg_all{1,pig});
    cc_set=zeros(239,num_exp);
    for exp=1:1
%         load(path+"same_pig_cross_val_model_pig"+num2str(pig)+"_exp_"+num2str(exp));
        val_ts=ecg_all{3,pig}{1,exp};
        val_cs=ecg_all{2,pig}{1,exp};
        predict_cs=predict(net,val_ts);
        cc_nodes=zeros(1,239);
        for node=1:239
            C=corrcoef(val_cs(node,:),predict_cs(node,:));
            cc_nodes(node)=C(2,1);
        end
        cc_set(:,exp)=cc_nodes;
    end
    cc{1,pig}=cc_set;
end
%% plot the CC result
for pig=1:5
    s=size(cc{1,pig});
    x=zeros(1,s(2))+pig;
    scatter(x,mean(cc{1,pig},1),'filled')
    hold on
end
ylabel('Mean Correlation Coeficiency across all heart node');
xlabel('Different pig');
axis([0 6 0 1])

%% plot the CC result
scatter(x,mean(mean(cc{1,pig},1)),'filled')
ylabel('Mean Correlation Coeficiency across all heart node');
xlabel('Different pig');
axis([0 6 0 1])
%% 
pig=2;
exp=5;
stem(cc{1,pig}(:,exp),'filled')
ylim([-1 1])
%% cross validation over different pig
% path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\Cross Validation results\";
% cc=cell(1,5);
for pig=1:1
%     load("different_pig_cross_val_model_pig"+num2str(pig)+".mat");
    val_ts=ecg_all{3,pig};
    val_cs=ecg_all{2,pig};
    num_exp=length(ecg_all{1,pig});
    cc_set=zeros(239,num_exp);
    for exp=1:num_exp  
        predict_cs=predict(net,val_ts{1,exp});
        cs_predicted_back=ecg_registration(double(predict_cs),registration_cs_template,cs_registration_normalized{1,pig});
        cc_nodes=zeros(1,239);
        for node=1:239
            C=corrcoef(val_cs{1,exp}(node,:),cs_predicted_back(node,:));
            cc_nodes(node)=C(2,1);
        end
        cc_set(:,exp)=cc_nodes;
    end
    cc{1,pig}=cc_set;
end
%% 
pig=1;
exp=1;
load("different_pig_cross_val_model_pig"+num2str(pig)+".mat");
val_ts=ecg_all{3,pig}{1,exp};
val_cs=ecg_all{2,pig}{1,exp};
predict_cs=predict(net,val_ts);
cs_predicted_back=ecg_registration(double(predict_cs),registration_cs_template,registration_cs_all{1,pig});
cc_nodes=zeros(1,239);
for node=1:239
    C=corrcoef(val_cs(node,:),cs_predicted_back(node,:));
    cc_nodes(node)=C(2,1);
end
%% 
pig=3;
exp=1;

val_ts=ecg_all{3,pig}{1,exp};
val_cs=ecg_all{2,pig}{1,exp};
predict_cs=predict(net,val_ts);
cs_predicted_back=ecg_registration(double(predict_cs),registration_cs_template,cs_registration_normalized{1,pig});

%% 
node=20;
plot(val_cs(node,:));
hold on
plot(cs_predicted_back(node,:))
legend("original","predicted",'fontsize',15)
set(gca,'visible','off')

%% in sequence
for n=1:50
    subplot(10,5,n);
    plot(ecg_all{2,pig}{1,exp}(n*3,:));
    hold on
    plot(cs_predicted_back(n*3,:));
end
%% load the registration torso data
path="E:\back up2\Google Drive2\Project\electrocardiac imaging\Matlab and ECGSIM\20200204Auckland_pig\registration\registration120x360\";
% path="/Users/chenkewei/Google Drive/Project/electrocardiac imaging/Matlab and ECGSIM/20200204Auckland_pig/registration/"
registration_torso_all=cell(1,5);
for pig=1:5
    load(path+"torso_registration_pig"+num2str(pig));
    registration_torso_all{1,pig}=registration_torso;
end
%% 
subplot(2,2,1)
scatter(registration_torso_all{1,1}(:,2),registration_torso_all{1,1}(:,1),'filled');
title('pig 1 projection result')
axis equal;
subplot(2,2,2)
scatter(registration_torso_all{1,2}(:,2),registration_torso_all{1,2}(:,1),'filled');
title('pig 2 projection result')
axis equal;
subplot(2,2,3)
scatter(registration_torso_all{1,3}(:,2),registration_torso_all{1,3}(:,1),'filled');
title('pig 3 projection result')
axis equal;
subplot(2,2,4)
scatter(registration_torso_all{1,4}(:,2),registration_torso_all{1,4}(:,1),'filled');
title('pig 4 projection result')
axis equal;
%% show torso node and grid 
[xq,yq]=meshgrid(1:30,1:90);
zq=zeros(90,30);
mesh(xq,yq,zq)
hold on
scatter(registration_torso_all{1,1}(:,1)/4,registration_torso_all{1,1}(:,2)/4,'filled');
axis equal
%% output torso 2D interpolation result
exp=1;
ecg=ecg_all{3,1}{1,exp};
path="E:\back up2\Google Drive2\Project\electrocardiac imaging\討論slides\20201112 seminar\";
for t=1:100
imshow(ecg(:,:,1,t*8),'Colormap',jet)
ax = gca;
ax.CLim=[-1,1];
exportgraphics(ax,path+num2str(t)+".jpg",'Resolution',300)
end

%% load the registration heart data with normalized registration
path="E:\back up2\Google Drive2\Project\electrocardiac imaging\Matlab and ECGSIM\20200204Auckland_pig\registration\registration_raw\";
registration_cs_all=cell(1,5);
for pig=1:5
    load(path+"cs_2D_registration_normalized_pig"+num2str(pig)+".mat")
    registration_cs_all{1,pig}=node_registration;
end


%% set up common registration template for cs
r=10;
registration_cs_template=zeros(165,2);
m=2;
list_num=[4,16,16,32,32,32,32];
registration_cs_template(1,:)=[0,0];
for i=1:7
    for k=1:list_num(i)
        x=i*(r/7)*cos(k*2*pi/(list_num(i)));
        y=i*(r/7)*sin(k*2*pi/(list_num(i)));
        registration_cs_template(m,1)=x;
        registration_cs_template(m,2)=y;
        m=m+1;
    end
end
%% cs node registration display
for i=1:1
     scatter(registration_cs_all{1,i}(:,1),registration_cs_all{1,i}(:,2),'filled')
     hold on
     axis equal
end
scatter(registration_cs_template(:,1),registration_cs_template(:,2),'filled')
hold on
axis equal
set(gca,'visible','off')
%% ****************common cs registration across all pig************************
%% load cs_registration_normalized
load("E:\back up2\Google Drive2\Project\electrocardiac imaging\Matlab and ECGSIM\20200204Auckland_pig\registration\cs_registration_normalized_16.mat")
%% cs ecg new registration
ecg_all_new=cell(2,5);
for pig=1:5
    ecg_ts_sets=ecg_all{3,pig};
    ecg_cs_sets=ecg_all{2,pig};
    ecg_cs_new=cell(1,length(ecg_cs_sets));
    for exp=1:length(ecg_cs_sets)
        s=size(ecg_cs_sets{1,exp});
        ecg_cs_new{1,exp}=ecg_registration(ecg_cs_sets{1,exp},cs_registration_normalized{1,pig},registration_cs_template);
    end
    ecg_all_new{1,pig}=ecg_ts_sets;
    ecg_all_new{2,pig}=ecg_cs_new;
end
%% show cs normalized location
subplot(2,2,1)
pig=1;
scatter(cs_registration_normalized{1,pig}(:,1),cs_registration_normalized{1,pig}(:,2),'filled')
title('pig 1')
axis equal
subplot(2,2,2)
pig=2;
scatter(cs_registration_normalized{1,pig}(:,1),cs_registration_normalized{1,pig}(:,2),'filled')
title('pig 2')
axis equal
subplot(2,2,3)
pig=3;
scatter(cs_registration_normalized{1,pig}(:,1),cs_registration_normalized{1,pig}(:,2),'filled')
title('pig 3')
axis equal
subplot(2,2,4)
pig=4;
scatter(cs_registration_normalized{1,pig}(:,1),cs_registration_normalized{1,pig}(:,2),'filled')
title('pig 4')
axis equal
%% show cs ne registration result
path="E:\back up2\Google Drive2\Project\electrocardiac imaging\討論slides\20201112 seminar\";
exp=1;
pig=1;

ecg=ecg_all{2,pig}{1,exp};
ecg_new=ecg_all_new{2,pig}{1,exp};
for t=1:20
subplot(4,10,2*t-1)
scatter(cs_registration_normalized{1,pig}(:,1),cs_registration_normalized{1,pig}(:,2),20,ecg(:,t*40),'filled')
axis equal
ax=gca;
set(ax,'visible','off')
colormap(jet)
ax.CLim=[-4,4];

subplot(4,10,2*t)
scatter(registration_cs_template(:,1),registration_cs_template(:,2),20,ecg_new(:,t*40),'filled')
axis equal
ax=gca;
set(ax,'visible','off')
colormap(jet)
ax.CLim=[-4,4];

exportgraphics(gcf,path+"CS_"+num2str(t)+".jpg",'Resolution',300)
end

%% *******************cross validation over different pig*****************************
% parallel.gpu.enableCUDAForwardCompatibility(0)
for pig=1:1
    num_exp=0;
    for p=2:3
        if p ~= pig
            num_exp=num_exp+length(ecg_all_new{1,p});
        end
    end
    train_ts=cell(1,num_exp);
    train_cs=cell(1,num_exp);
    m=1;
    for p=2:3
        if p ~= pig
            for i=1:length(ecg_all{3,p})
                train_ts{1,m}=ecg_all_new{1,p}{1,i};
                train_cs{1,m}=ecg_all_new{2,p}{1,i};
                m=m+1;
            end
        end
    end
    val_ts=ecg_all_new{1,pig};
    val_cs=ecg_all_new{2,pig};
    %re-initialized the model
    layers = [
    sequenceInputLayer([30,90,1],'Name','input')
    sequenceFoldingLayer('name','fold')
    convolution2dLayer([2 2],8,'Padding',[0 0 0 0],'Name','conv2D1')
    tanhLayer('name','tanhLayer1')
    averagePooling2dLayer([2 2],'Name','averagePool')
    sequenceUnfoldingLayer('name','unfold')    
    flattenLayer('Name','flatten')    
    fullyConnectedLayer(256,'Name','fullyconnected1')
    tanhLayer('name','tanhLayer2')
    fullyConnectedLayer(165,'Name','fullyconnected2')
    regressionLayer('Name','regression output')];

    lgraph = layerGraph(layers);
    lgraph = connectLayers(lgraph,'fold/miniBatchSize','unfold/miniBatchSize');
    
     %model training
     options = trainingOptions('adam', ...
    'MaxEpochs',100, ...
    'InitialLearnRate',0.01, ...
    'Verbose',true, ...
    'Plots','training-progress',...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.9, ...
    'Shuffle','every-epoch', ...
    'LearnRateDropPeriod',1,...
     'ValidationData',{val_ts,val_cs'}, ...
    'ValidationFrequency',fix(length(train_cs)/4),...
    'OutputFcn',@(info)stopIfAccuracyNotImproving(info,20),...
    'miniBatchSize',4);
    [net,info] = trainNetwork(train_ts,train_cs',lgraph,options);
%     save("different_pig_cross_val_model_pig"+num2str(pig),'net','info')
end
%% 
plot(lgraph)
%% test the model
exp=4;
cs_predicted=predict(net,val_ts{1,exp});
%% 
for n=1:50
    subplot(10,5,n);
    plot(val_cs{1,exp}(n*3,:));
    hold on
    plot(cs_predicted(n*3,:));
    axis tight
end
%% back to original registraion display in scatter plot
pig=1;
cs_predicted_back=ecg_registration(double(cs_predicted),registration_cs_template,registration_cs_all{1,pig});
ecg=ecg_all{2,pig}{1,exp};
ecg_new=ecg_all_new{2,pig}{1,exp};
t=100;
subplot(1,2,1)
scatter(registration_cs_all{1,pig}(:,1),registration_cs_all{1,pig}(:,2),100,ecg_all{2,pig}{1,exp}(:,t),'filled')
axis equal
subplot(1,2,2)
scatter(registration_cs_all{1,pig}(:,1),registration_cs_all{1,pig}(:,2),100,cs_predicted_back(:,t),'filled')
axis equal
%% in sequence
for n=1:50
    subplot(10,5,n);
    plot(ecg_all{2,pig}{1,exp}(n*3,:));
    hold on
    plot(cs_predicted_back(n*3,:));
end
%% ---------------function for stop training----------------------------------

function stop = stopIfAccuracyNotImproving(info,N)

stop = false;

% Keep track of the best validation accuracy and the number of validations for which
% there has not been an improvement of the accuracy.
persistent bestValAccuracy
persistent valLag

% Clear the variables when training starts.
if info.State == "start"
    bestValAccuracy = 0;
    valLag = 0;
    
elseif ~isempty(info.ValidationLoss)
    
    % Compare the current validation accuracy to the best accuracy so far,
    % and either set the best accuracy to the current accuracy, or increase
    % the number of validations for which there has not been an improvement.
    if info.ValidationAccuracy > bestValAccuracy
        valLag = 0;
        bestValAccuracy = info.ValidationAccuracy;
    else
        valLag = valLag + 1;
    end
    
    % If the validation lag is at least N, that is, the validation accuracy
    % has not improved for at least N validations, then return true and
    % stop training.
    if valLag >= N
        stop = true;
    end
    
end

end
