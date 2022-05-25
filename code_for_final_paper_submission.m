%#################################Load%data#####################################
%% 
%load final data
path="E:\back up2\Google Drive2\Large Files\Datasets\ECGI_datasets\processed_data3\";
load(path+"auckland_insitu_data_final.mat")

%################################Part I%method####################################
%% plot heart and torso together
pig=1;
% patch('Faces',registration_3D{4,pig},'Vertices',registration_3D{2,pig},'FaceColor','r',...
%     'FaceAlpha',0.1,'EdgeColor','black','EdgeAlpha',0.2,'Marker','o','MarkerSize',4,'MarkerFaceColor','r','MarkerEdgeColor','none')
% hold on
patch('Faces',registration_3D{3,pig},'Vertices',registration_3D{1,pig},'FaceColor','b',...
    'FaceAlpha',0.1,'EdgeColor','black','EdgeAlpha',0.2,'Marker','o','MarkerSize',4,'MarkerFaceColor','b','MarkerEdgeColor','none')
view(45,45)
for i=1:158
    text(registration_3D{1,pig}(i,1),registration_3D{1,pig}(i,2),registration_3D{1,pig}(i,3),num2str(i));
    hold on
end
axis equal
axis off
%% plot heart and torso 3D
for pig=1:5
    figure(pig)
    patch('Faces',registration_3D{3,pig},'Vertices',registration_3D{1,pig},'FaceColor','b',...
    'FaceAlpha',0.1,'EdgeColor','black','EdgeAlpha',0.2,'Marker','o','MarkerSize',4,'MarkerFaceColor','b','MarkerEdgeColor','none')
    view(45,45)
    axis equal
    axis off
end

%% 
for pig=1:5
    figure(pig)
    patch('Faces',registration_3D{4,pig},'Vertices',registration_3D{2,pig},'FaceColor','r',...
    'FaceAlpha',0.1,'EdgeColor','black','EdgeAlpha',0.2,'Marker','o','MarkerSize',4,'MarkerFaceColor','r','MarkerEdgeColor','none')
hold on
       view(45,45)
    axis equal
    axis off
end

%% plot 2D torso node scatter
m=1;
ID=48;
for pig=1:5
        figure(pig)
        m=m+1;
        scatter(torso_registration{1,pig}(:,2),torso_registration{1,pig}(:,1),'filled')
%         hold on
%         scatter(torso_registration{1,pig}(ID,2),torso_registration{1,pig}(ID,1),'filled')
        axis equal
        axis off

end


%% plot cs registration demonstration
figure(2)
pig=1;
patch('Faces',registration_3D{4,pig},'Vertices',registration_3D{2,pig},'FaceColor','r',...
    'FaceAlpha',0.1,'EdgeColor','black','EdgeAlpha',0.2,'Marker','o','MarkerSize',4,'MarkerFaceColor','r','MarkerEdgeColor','none')
hold on
%plot xy plane
scale=50;
tip=234;
x=[registration_3D{2,pig}(tip,1)+1*scale,registration_3D{2,pig}(tip,1)-1*scale,registration_3D{2,pig}(tip,1)-1*scale,registration_3D{2,pig}(tip,1)+1*scale];
y=[registration_3D{2,pig}(tip,2)+1*scale,registration_3D{2,pig}(tip,2)+1*scale,registration_3D{2,pig}(tip,2)-1*scale,registration_3D{2,pig}(tip,2)-1*scale];
z=[registration_3D{2,pig}(tip,3),registration_3D{2,pig}(tip,3),registration_3D{2,pig}(tip,3),registration_3D{2,pig}(tip,3)];
patch(x,y,z,'k',...
    'FaceAlpha',0.1,'EdgeColor','black','EdgeAlpha',0.1)

%plot z axis
line=zeros(3,2);
line(1,:)=[registration_3D{2,pig}(tip,1),registration_3D{2,pig}(tip,1)];
line(2,:)=[registration_3D{2,pig}(tip,2),registration_3D{2,pig}(tip,2)];
line(3,:)=[registration_3D{2,pig}(tip,3),registration_3D{2,pig}(tip,3)+100];
plot3(line(1,:),line(2,:),line(3,:),'LineWidth',1.5,'Color','#4d94ff')
hold on
% plot line from z axis to surface node
% node=100;
% line2(1,:)=[geo_cs(tip,1),geo_cs(node,1)];
% line2(2,:)=[geo_cs(tip,2),geo_cs(node,2)];
% line2(3,:)=[geo_cs(node,3),geo_cs(node,3)];
% plot3(line2(1,:),line2(2,:),line2(3,:),'LineWidth',1.5,'Color','#4d94ff')
% hold on

% plot line from y axis 
line2(1,:)=[registration_3D{2,pig}(tip,1),registration_3D{2,pig}(tip,1)];
line2(2,:)=[registration_3D{2,pig}(tip,2),registration_3D{2,pig}(tip,2)-50];
line2(3,:)=[registration_3D{2,pig}(tip,3),registration_3D{2,pig}(tip,3)];
plot3(line2(1,:),line2(2,:),line2(3,:),'LineWidth',1.5,'Color','#4d94ff')
%plot node
scatter3(registration_3D{2,pig}(node,1),registration_3D{2,pig}(node,2),registration_3D{2,pig}(node,3),50,'filled','MarkerEdgeColor','none','MarkerFaceColor','#009933')

axis equal
set(gca,'visible','off')
view(30,30)
%% plot cs registration normalized
pig=1;
node=100;
scatter(cs_registration_normalized{1,pig}(:,1),cs_registration_normalized{1,pig}(:,2),'r','filled')
hold on
scatter(cs_registration_normalized{1,pig}(node,1),cs_registration_normalized{1,pig}(node,2),'g','filled')
hold on
axis equal
axis off
%% plot cs registration, normalized and raw
pig=1;
scatter(cs_registration_raw{1,pig}(:,1),cs_registration_raw{1,pig}(:,2),'filled','MarkerFaceColor','#ff6666');
hold on
index_30=find(cs_registration_normalized{1,pig}(:,3)<pi/6);
scatter(4*cs_registration_normalized{1,pig}(index_30,1),4*cs_registration_normalized{1,pig}(index_30,2),'r','filled');
hold on
node=100;
scatter(4*cs_registration_normalized{1,pig}(node,1),4*cs_registration_normalized{1,pig}(node,2),'g','filled')
hold on
scatter(cs_registration_raw{1,pig}(node,1),cs_registration_raw{1,pig}(node,2),'filled','MarkerFaceColor','#66ff66')
hold on
axis equal
axis off
%% plot cs registration and color as potential
pig=1;
t=620;
cmap=colormap(jet);
exp=1;
ecg=ecg_final{2,pig}{1,exp};
ecg=fix(256*(ecg+15)/30);
ecg_new=ecg_final{4,pig}{1,exp};
ecg_new=fix(256*(ecg_new+15)/30);
subplot(1,2,1)
caxis([-15,15])
scatter(cs_registration_normalized{1,pig}(:,1),cs_registration_normalized{1,pig}(:,2),180,cmap(ecg(:,t),:),'filled')
hold on
axis equal
set(gca,'visible','off')
colorbar

subplot(1,2,2)
scatter(registration_cs_template(:,1),registration_cs_template(:,2),180,cmap(ecg_new(:,t),:),'filled')
axis equal
set(gca,'visible','off')
colorbar
%% from 1D to 2D sampling
y=linspace(1,10,10);
x=zeros(1,10);
pig=1;
t=180;
cmap=colormap(jet);
exp=1;
ecg=ecg_final{2,pig}{1,exp};
ecg=fix(256*(ecg+15)/30);
ecg_new=ecg_final{4,pig}{1,exp};
ecg_new=fix(256*(ecg_new+15)/30);
figure(1)
scatter(x,y,50,cmap(ecg(1:10,t),:),'filled');
axis off
figure(2)
scatter(cs_registration_normalized{1,pig}(:,1),cs_registration_normalized{1,pig}(:,2),50,cmap(ecg(:,t),:),'filled')
hold on
scatter(cs_registration_normalized{1,pig}(1:10,1),cs_registration_normalized{1,pig}(1:10,2),160,cmap(ecg(1:10,t),:),'filled')
hold on
scatter(registration_cs_template(:,1),registration_cs_template(:,2),20,'filled','MarkerFaceColor','#7E2F8E')
axis equal
axis off

figure(3)
scatter(registration_cs_template(:,1),registration_cs_template(:,2),50,cmap(ecg_new(:,t),:),'filled')
hold on
scatter(registration_cs_template(1:10,1),registration_cs_template(1:10,2),160,cmap(ecg_new(1:10,t),:),'filled')
axis equal
axis off

figure(5)
y=linspace(1,10,10);
x=zeros(1,10);
scatter(x,y,50,cmap(ecg_new(1:10,t),:),'filled');
axis equal
axis off
%% 
m=1;
for pig=1:5
        figure(pig)
        scatter(cs_registration_normalized{1,pig}(:,1),cs_registration_normalized{1,pig}(:,2),'filled')
        axis equal
        axis off
end
%% 
m=1;
for pig=1:5

        figure(pig)
        scatter(cs_registration_raw{1,pig}(:,1),cs_registration_raw{1,pig}(:,2),'filled')
        axis equal
        axis off
end
%% 
pig=4;
scatter(cs_registration_normalized{1,pig}(:,1),cs_registration_normalized{1,pig}(:,2),'filled')
axis equal
%% 
m=1;
for pig=1:5
    if pig~=3
        subplot(2,2,m)
        m=m+1;
        scatter(torso_registration{1,pig}(:,2),torso_registration{1,pig}(:,1),'filled')
        axis equal
        axis off
    end
end
%################################Part II %result####################################
%% show predicted result example
node=175;
pig=2;
exp=5;
x=ecg_final{1,pig}(1,exp);
y=ecg_final{2,pig}(1,exp);

% y_predict_FCN=predict(FCN_model,x);
% y_predict_LSTM=predict(LSTM_model,x);
x_CNN=ecg_final{3,pig}(1,exp);
y_raw=predict(net,x_CNN);
y_predict_CNN=ecg_registration(double(y_raw{1,1}),registration_cs_template, cs_registration_normalized{1,pig});
t=linspace(0,819*0.5,819);

p1=plot(t,y{1,1}(node,:),'LineWidth',4);
p1.Color(4)=0.5;
hold on
plot(t,y_predict_CNN(node,:),'LineWidth',2);
t=300;
plot([t,t],[-8,8],'r')
% hold on
% plot(t,y_predict_LSTM{1,1}(show_list(i),:),'LineWidth',1);
% hold on
xticks(0:100:819*0.5);
xlim([0 819*0.5])
yticks(-8:4:8);
ylim([-8 8])
ax=gca;
ax.YAxis.FontSize=15;
ax.XAxis.FontSize=15;
c=corrcoef(y{1,1}(node,:),y_predict_CNN(node,:));
cc=c(2,1);
legend("-",num2str(cc));
% legend("Recorded",'FCN model predicted','FontSize',15)
%% cross validation over same pigs , draw mean CC
path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\20210217 cross validation results FCN LSTM\";
cc_all=cell(1,5);
m=1;
for pig=1:5
    num_exp=length(ecg_final{1,pig});
    cc_set=zeros(239,num_exp);
    
    for exp=1:num_exp
%         ID="1D_FCN_same_pig"+num2str(pig)+"_exp_"+num2str(exp);
        ID="1D_LSTM_same_pig"+num2str(pig)+"_exp_"+num2str(exp);
        load(path+ID);
        x=ecg_final{1,pig}(1,exp);
        y=ecg_final{2,pig}(1,exp);
        y_predict=predict(net,x);
        for node=1:239
           cc=corrcoef(y{1,1}(node,:),y_predict{1,1}(node,:));
           cc_set(node,exp)=cc(2,1);
        end
    end
    cc_all{1,m}=cc_set;
    m=m+1;

end
%% 
for pig=1:4
    dim=size(cc_all{1,pig});
    num_exp=dim(2);
    x=zeros(1,num_exp);    
    scatter(x+pig,mean(cc_all{1,pig},1),'filled')
    hold on
    xlim([0,5])
    ylim([0,1])
    set(gca,'xtick',[])
end
%% draw median CC
subplot(1,3,1)
for pig=1:5
    dim=size(cc_all_FCN{1,pig});
    num_exp=dim(2);
    x=zeros(1,num_exp);
    scatter(x+pig,median(cc_all_FCN{1,pig},1),'filled')
    hold on
    xlim([0 6]);
    ylim([-0.2 1])
    set(gca,'xtick',[])
end
subplot(1,3,2)
for pig=1:5
   dim=size(cc_all_FCN{1,pig});
    num_exp=dim(2);
    x=zeros(1,num_exp);
    scatter(x+pig,median(cc_all_LSTM{1,pig},1),'filled')
    hold on
    xlim([0 6]);
    ylim([-0.2 1])
     set(gca,'xtick',[])
end
subplot(1,3,3)
for pig=1:5
    dim=size(cc_all_FCN{1,pig});
    num_exp=dim(2);
    x=zeros(1,num_exp);
    scatter(x+pig,median(cc_all_CNN{1,pig},1),'filled')
    hold on
    xlim([0 6]);
    ylim([-0.2 1])
     set(gca,'xtick',[])
%     axis off
end
%% index for endo, epi, sinus, 1 as endo, 2 as epi, 3 as sinus
index_pace_type=cell(1,5);
index_pace_type{1,1}=[1,1,1,1,2,2,2,2,2,2,2,2,3];
index_pace_type{1,2}=[1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3];
index_pace_type{1,3}=[1,1,1,1,3];
index_pace_type{1,4}=[1,1,1,1,1,1,1,1,1,1,1,1,3];
index_pace_type{1,5}=[1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3];
%% draw median CC , seperate endo, epi, sinus
subplot(1,3,1)
for pig=1:5
    dim=size(cc_all_FCN{1,pig});
    num_exp=dim(2);
    
    for exp=1:num_exp
        if index_pace_type{pig}(exp)==1
            scatter(pig,median(cc_all_FCN{1,pig}(:,exp)),36,[0 0.4470 0.7410],'O','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==2
            scatter(pig,median(cc_all_FCN{1,pig}(:,exp)),36,[0.4660 0.6740 0.1880],'^','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==3
            scatter(pig,median(cc_all_FCN{1,pig}(:,exp)),36,[0.4940 0.1840 0.5560],'d','filled');
            hold on
        end
    end
    xlim([0 6]);
    ylim([-0.2 1])
    set(gca,'xtick',[])
end
subplot(1,3,2)
for pig=1:5
   dim=size(cc_all_FCN{1,pig});
    num_exp=dim(2);
    for exp=1:num_exp
        if index_pace_type{pig}(exp)==1
            scatter(pig,median(cc_all_LSTM{1,pig}(:,exp)),36,[0 0.4470 0.7410],'O','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==2
            scatter(pig,median(cc_all_LSTM{1,pig}(:,exp)),36,[0.4660 0.6740 0.1880],'^','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==3
            scatter(pig,median(cc_all_LSTM{1,pig}(:,exp)),36,[0.4940 0.1840 0.5560],'d','filled');
            hold on
        end
    end
    xlim([0 6]);
    ylim([-0.2 1])
     set(gca,'xtick',[])
end
subplot(1,3,3)
for pig=1:5
    dim=size(cc_all_FCN{1,pig});
    num_exp=dim(2);
    for exp=1:num_exp
        if index_pace_type{pig}(exp)==1
            scatter(pig,median(cc_all_CNN{1,pig}(:,exp)),36,[0 0.4470 0.7410],'O','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==2
            scatter(pig,median(cc_all_CNN{1,pig}(:,exp)),36,[0.4660 0.6740 0.1880],'^','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==3
            scatter(pig,median(cc_all_CNN{1,pig}(:,exp)),36,[0.4940 0.1840 0.5560],'d','filled');
            hold on
        end
    end
    hold on
    xlim([0 6]);
    ylim([-0.2 1])
     set(gca,'xtick',[])
%     axis off
end
legend
%% 
total_exp=0;
for pig=1:5
    if pig~=3
        total_exp=total_exp+length(ecg_final{1,pig});
    end
end
mean_cc=zeros(1,total_exp);
group_ID=zeros(1,total_exp);
m=1;
n=1;
for pig=1:5
    if pig~=3
        num_exp=length(ecg_final{1,pig});
        for exp=1:num_exp
            mean_cc(1,n)=mean(cc_all_CNN{1,m}(:,exp));        
            group_ID(1,n)=pig;
            n=n+1;
        end
        m=m+1;
    end
end
%% 
[p,tbl,stats]= anova1(mean_cc,group_ID);
%% CC across node

path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\20210217 cross validation results FCN LSTM\";
cc_all=cell(1,5);
m=1;
for pig=1:5
    num_exp=length(ecg_final{1,pig});
    if pig~=3
        cc_set=cell(1,num_exp);
        for exp=1:num_exp
            ID="1D_FCN_same_pig"+num2str(pig)+"_exp_"+num2str(exp);
%             ID="1D_LSTM_same_pig"+num2str(pig)+"_exp_"+num2str(exp);
            load(path+ID);
            x=ecg_final{1,pig}(1,exp);
            y=ecg_final{2,pig}(1,exp);
            y_predict=predict(net,x);
            num_t=length(y{1,1});
            cc_t=zeros(1,num_t);
            for t=1:num_t
               cc=corrcoef(y{1,1}(:,t),y_predict{1,1}(:,t));
               cc_t(1,t)=cc(2,1);
            end
         cc_set{1,exp}=cc_t;   
        end
        cc_all{1,m}=cc_set;
        m=m+1;
    end
end
%% CNN across node
load("registration/registration_ts_template165.mat");
load("registration/cs_registration_normalized_16.mat");
load("registration/registration_cs_template165.mat");
% path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\20210217 cross validation results FCN LSTM\";
path="training_records/";
cc_all_CNN=cell(1,5);
m=1;
for pig=1:5
        ID="CNN_different_pig_cross_val_model_pig"+num2str(pig);
        load(path+ID);
        num_exp=length(ecg_final{1,pig});
        cc_set=cell(1,num_exp);       
        for exp=1:num_exp
          x=ecg_final{3,pig}(1,exp);
          y=ecg_final{2,pig}(1,exp);
          num_t=length(y{1,1});
          y_raw=predict(net,x);
          y_predict=ecg_registration(double(y_raw{1,1}),registration_cs_template, cs_registration_normalized{1,pig});
          cc_t=zeros(1,num_t);
          for t=1:num_t
              cc=corrcoef(y{1,1}(:,t),y_predict(:,t));
              cc_t(1,t)=cc(2,1);
          end
          cc_set{1,exp}=cc_t;
        end
        cc_all{1,m}=cc_set;
        m=m+1;
     
end
%% plot median
for pig=1:5
        cc_set=cc_all_CNN{1,pig};
        dim=size(cc_set);
        for i=1:dim(2)
            scatter(pig,median(cc_set(:,i),1))
            hold on
        end

end
%% 
pig=1;
exp=1;
stem(cc_all{1,pig}{1,exp})

%% 

t=linspace(0.5,409.5,819);
for i=1:3
    cc_all=cc_total{1,i};
    subplot(3,1,i)
    for pig=1:4
        num_exp=length(ecg_final{1,pig});
        cc_acumulate=zeros(1,819);
        for exp=1:num_exp
    %         plot(cc_all{1,pig}{1,exp}(1:819));
    %         hold on
            cc_acumulate=cc_acumulate+cc_all{1,pig}{1,exp}(1:819);
        end
        cc_accumulate=cc_acumulate/num_exp;
        plot(t,cc_accumulate);
        hold on
        axis tight
        ylim([0,1]);
    end
end


%% 
cc_total=cell(1,3);
cc_total{1,1}=cc_all_FCN;
cc_total{1,2}=cc_all_LSTM;
cc_total{1,3}=cc_all_CNN;

%% load CNN, cross different pig model  , draw median CC
load("registration/registration_ts_template165.mat");
load("registration/cs_registration_normalized_16.mat");
load("registration/registration_cs_template165.mat");
% path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\20210217 cross validation results FCN LSTM\";
path="training_records/";
cc_all_CNN=cell(1,5);
for pig=2:2
   
        ID="CNN_different_pig_cross_val_model_pig"+num2str(pig);
        load(path+ID);
        num_exp=length(ecg_final{1,pig});
        cc_set=zeros(239,num_exp);

        for exp=5:5
          x=ecg_final{3,pig}(1,exp);
          y=ecg_final{2,pig}(1,exp);
          y_raw=predict(net,x);
          y_predict=ecg_registration(double(y_raw{1,1}),registration_cs_template, cs_registration_normalized{1,pig});
          
            for node=175:175
               cc=corrcoef(y{1,1}(node,:),y_predict(node,:));
               cc_set(node,exp)=cc(2,1);
            end
        end
        cc_all_CNN{1,pig}=cc_set;
       
end
%% 

for pig=1:5
    dim=size(cc_all_CNN{1,pig});
    num_exp=dim(2);
    x=zeros(1,num_exp);    
    scatter(x+pig,median(cc_all_CNN{1,pig},1),'filled')
    hold on
    xlim([0,6])
    ylim([-0.5,1])
    set(gca,'xtick',[])
end

%% 
figure(1)
pig=2;
exp=10;
stem(cc_all_LSTM{1,pig}(:,exp),'filled')
%% localization error
%pig 1, start from 5th
pig1_epinodes=[133,159,189,2,214,223,29,30];
%pig 2, start from 6th
pig2_epinodes=[112,12,131,147,149,15,156,158,189,191,2,219,3,34,57,65,85,92];
%pig 5, start from 11th
pig5_epinodes=[101,140,158,166,18,184,209,229,23,68];


%% geometry data visualization
geometry_data_path="E:\back up2\Google Drive2\Project\electrocardiac imaging\The Experimental Data and Geometric Analysis Repository (EDGAR) dataset\InSitu Animal\Auckland-2012-06-05\20200326send_by_laura\";
load(geometry_data_path+"pig2\pig2.mat");
geo_cs=meshes.sock.verts;
figure(2)
% scatter3(geo_cs(:,1),geo_cs(:,2),geo_cs(:,3),'filled');
show_list=[205,211,175,165,110,150,53,16];
for i=1:239
    text(geo_cs(i,1),geo_cs(i,2),geo_cs(i,3),num2str(i));
    hold on
end
for i=1:8
    scatter3(geo_cs(show_list(i),1),geo_cs(show_list(i),2),geo_cs(show_list(i),3),'filled','r')
    hold on
end
patch('Faces',meshes.sock.faces,'Vertices',geo_cs,'FaceColor','#ffb3b3',...
    'FaceAlpha',1,'EdgeColor','black','EdgeAlpha',0.2,'Marker','none','MarkerSize',4,'MarkerFaceColor','r','MarkerEdgeColor','none')
hold on
view(180,0)
axis equal
set(gca,'visible','off')
%% load model
%use pig 2, exp 11 as example
path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\20210217 cross validation results FCN LSTM\";
load(path+"1D_FCN_same_pig2_exp_1")
FCN_model=net;
path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\20210217 cross validation results FCN LSTM\";
load(path+"1D_LSTM_same_pig2_exp_10")
LSTM_model=net;
path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\20210217 cross validation results FCN LSTM\";
load(path+"CNN_different_pig_cross_val_model_pig2")
CNN_model=net;
%% draw example of tracing result
pig=2;
exp=5;
for i=1:8
    figure(i)
    x=ecg_final{1,pig}(1,exp);
    y=ecg_final{2,pig}(1,exp);
    y_predict_FCN=predict(FCN_model,x);
    y_predict_LSTM=predict(LSTM_model,x);
    x_CNN=ecg_final{3,pig}(1,exp);
    y_raw=predict(CNN_model,x_CNN);
    y_predict_CNN=ecg_registration(double(y_raw{1,1}),registration_cs_template, cs_registration_normalized{1,pig});
    t=linspace(0,819*0.5,819);
    p1=plot(t,y{1,1}(show_list(i),:),'LineWidth',2);
    p1.Color(4)=0.5;
    hold on
    plot(t,y_predict_FCN{1,1}(show_list(i),:),'LineWidth',1);
    hold on
    plot(t,y_predict_LSTM{1,1}(show_list(i),:),'LineWidth',1);
    hold on
    plot(t,y_predict_CNN(show_list(i),:),'LineWidth',1);
    xticks(0:100:819*0.5);
    xlim([0 819*0.5])
    yticks(-8:4:8);
    ylim([-10 10])
    legend("-",num2str(round(cc_all_FCN{1,pig}(show_list(i),exp),2)),num2str(round(cc_all_LSTM{1,pig}(show_list(i),exp),2)),num2str(round(cc_all_CNN{1,pig}(show_list(i),exp),2)),'FontSize',15)
%       legend("-",num2str(round(cc_all_CNN{1,pig}(show_list(i),exp),2)),'FontSize',15)
  
    legend boxoff    
    ax=gca;
    ax.YAxis.FontSize=15;
    ax.XAxis.FontSize=15;
    title("node="+num2str(show_list(i)))
%     saveas(gcf,num2str(show_list(i))+".jpeg")
end
%####################################### AT map#########################

%% load model
path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\20210217 cross validation results FCN LSTM\";
load(path+"1D_FCN_same_pig2_exp_10")
FCN_model=net;
path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\20210217 cross validation results FCN LSTM\";
load(path+"1D_LSTM_same_pig2_exp_10")
LSTM_model=net;
path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\20210217 cross validation results FCN LSTM\";
load(path+"CNN_different_pig_cross_val_model_pig2")
CNN_model=net;
%% draw example of tracing result
%load cs node registration data
load("registration\registration_3D.mat");
pig=2;
exp=10;
clf
x=ecg_final{1,pig}(1,exp);
y=ecg_final{2,pig}(1,exp);
y_predict_FCN=predict(FCN_model,x);
y_predict_LSTM=predict(LSTM_model,x);
x_CNN=ecg_final{3,pig}(1,exp);
y_raw=predict(CNN_model,x_CNN);
y_predict_CNN=ecg_registration(double(y_raw{1,1}),registration_cs_template, cs_registration_normalized{1,pig});
t=linspace(0,819*0.5,819);
AT_recorded=fun_get_smoothed_AT(y{1,1},registration_3D{2,pig},pig);
AT_FCN=fun_get_smoothed_AT(y_predict_FCN{1,1},registration_3D{2,pig},pig);
AT_LSTM=fun_get_smoothed_AT(y_predict_LSTM{1,1},registration_3D{2,pig},pig);
AT_CNN=fun_get_smoothed_AT(y_predict_CNN,registration_3D{2,pig},pig);
%% 
stem(AT_recorded,'filled')
hold on
stem(AT_FCN,'filled')
hold on
stem(AT_LSTM,'filled')
hold on
stem(AT_CNN,'filled')
%% use scatter plot
pace_ID=149;
[~,min_ID]=min(AT_recorded);
[~,min_ID_FCN]=min(AT_FCN);
[~,min_ID_LSTM]=min(AT_LSTM);
[~,min_ID_CNN]=min(AT_CNN);
cmap=colormap(hot);
range=[35 110];
subplot(2,2,1)
scatter(cs_registration_raw{1,pig}(:,1),cs_registration_raw{1,pig}(:,2),100,AT_recorded/2,'filled')
hold on
scatter(cs_registration_raw{1,pig}(pace_ID,1),cs_registration_raw{1,pig}(pace_ID,2),150,'g','filled','^')
hold on
scatter(cs_registration_raw{1,pig}(min_ID,1),cs_registration_raw{1,pig}(min_ID,2),150,'filled','^','MarkerFaceColor','#66ffff')
caxis(range);
axis equal
axis off
legend(" "," "," "," ")

subplot(2,2,2)
scatter(cs_registration_raw{1,pig}(:,1),cs_registration_raw{1,pig}(:,2),100,AT_FCN/2,'filled')
hold on
scatter(cs_registration_raw{1,pig}(pace_ID,1),cs_registration_raw{1,pig}(pace_ID,2),150,'g','filled','^')
hold on
scatter(cs_registration_raw{1,pig}(min_ID_FCN,1),cs_registration_raw{1,pig}(min_ID_FCN,2),150,'filled','^','MarkerFaceColor','#66ffff')
caxis(range);
axis equal
axis off

subplot(2,2,3)
scatter(cs_registration_raw{1,pig}(:,1),cs_registration_raw{1,pig}(:,2),100,AT_LSTM/2,'filled')
hold on
scatter(cs_registration_raw{1,pig}(pace_ID,1),cs_registration_raw{1,pig}(pace_ID,2),150,'g','filled','^')
hold on
scatter(cs_registration_raw{1,pig}(min_ID_LSTM,1),cs_registration_raw{1,pig}(min_ID_LSTM,2),150,'filled','^','MarkerFaceColor','#66ffff')

caxis(range);
caxis(range);
axis equal
axis off

subplot(2,2,4)
scatter(cs_registration_raw{1,pig}(:,1),cs_registration_raw{1,pig}(:,2),100,AT_CNN/2,'filled')
hold on
scatter4=scatter(cs_registration_raw{1,pig}(pace_ID,1),cs_registration_raw{1,pig}(pace_ID,2),150,'g','filled','^');
hold on
scatter(cs_registration_raw{1,pig}(min_ID_CNN,1),cs_registration_raw{1,pig}(min_ID_CNN,2),150,'filled','^','MarkerFaceColor','#66ffff')

caxis(range);
axis equal
axis off
colorbar
%% use 3D patch
cmap=colormap(hot);
patch('Faces',registration_3D{4,pig},'Vertices',registration_3D{2,pig},'FaceVertexCData',AT_CNN,'Facecolor','interp','CDataMapping','scaled')
caxis([130 250]);
axis equal
axis off
colorbar
%% mean cc
total_exp=0;
for i=1:5   
        dim=size(cc_all_FCN{1,i});
        num_exp=dim(2);
        total_exp=total_exp+num_exp;
end
cc_all_FCN_1D=zeros(1,239*total_exp);
cc_all_LSTM_1D=zeros(1,239*total_exp);
cc_all_CNN_1D=zeros(1,239*total_exp);
m=1;
for i=1:5
        dim=size(cc_all_FCN{1,i});
        num_exp=dim(2);
        for exp=1:num_exp
            for node=1:239
                cc_all_FCN_1D(m)=cc_all_FCN{1,i}(node,exp);
                cc_all_LSTM_1D(m)=cc_all_LSTM{1,i}(node,exp);
                cc_all_CNN_1D(m)=cc_all_CNN{1,i}(node,exp);
                m=m+1;
            end
        end
end
%% 
median(cc_all_FCN_1D)
quantile(cc_all_FCN_1D,0.25)
quantile(cc_all_FCN_1D,0.75)
%% 
median(cc_all_LSTM_1D)
quantile(cc_all_LSTM_1D,0.25)
quantile(cc_all_LSTM_1D,0.75)
%% 
median(cc_all_CNN_1D)
quantile(cc_all_CNN_1D,0.25)
quantile(cc_all_CNN_1D,0.75)
%% 
median(all_AT_map_cc_FCN)
quantile(all_AT_map_cc_FCN,0.25)
quantile(all_AT_map_cc_FCN,0.75)
%% 
median(all_AT_map_cc_LSTM)
quantile(all_AT_map_cc_LSTM,0.25)
quantile(all_AT_map_cc_LSTM,0.75)
%% 
median(all_AT_map_cc_CNN)
quantile(all_AT_map_cc_CNN,0.25)
quantile(all_AT_map_cc_CNN,0.75)
%% calculate CC for AT map
cc_AT_map=cell(1,5);
AT_map=cell(1,5);
load("registration\registration_3D.mat");
m=1;
for pig=1:5
num_exp=length(ecg_final{1,pig});
cc_set=zeros(3,num_exp);
AT_set=cell(4,num_exp);
    % load CNN model
    path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\20210217 cross validation results FCN LSTM\";
    load(path+"CNN_different_pig_cross_val_model_pig"+num2str(pig));
    CNN_model=net;
    % draw example of tracing result
    %load cs node registration data
    
    for exp=1:num_exp
    %load FCN, LSTM models
    path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\20210217 cross validation results FCN LSTM\";
    load(path+"1D_FCN_same_pig"+num2str(pig)+"_exp_"+num2str(exp))
    FCN_model=net;
    path="E:\back up2\Google Drive2\Large Files\ECGSIM\Auckland_insitu_final\20210217 cross validation results FCN LSTM\";
    load(path+"1D_LSTM_same_pig"+num2str(pig)+"_exp_"+num2str(exp))
    LSTM_model=net;
    
    x=ecg_final{1,pig}(1,exp);
    y=ecg_final{2,pig}(1,exp);
    y_predict_FCN=predict(FCN_model,x);
    y_predict_LSTM=predict(LSTM_model,x);
    x_CNN=ecg_final{3,pig}(1,exp);
    y_raw=predict(CNN_model,x_CNN);
    y_predict_CNN=ecg_registration(double(y_raw{1,1}),registration_cs_template, cs_registration_normalized{1,pig});
    t=linspace(0,819*0.5,819);
    AT_recorded=fun_get_smoothed_AT(y{1,1},registration_3D{2,pig},pig);
    AT_FCN=fun_get_smoothed_AT(y_predict_FCN{1,1},registration_3D{2,pig},pig);
    AT_LSTM=fun_get_smoothed_AT(y_predict_LSTM{1,1},registration_3D{2,pig},pig);
    AT_CNN=fun_get_smoothed_AT(y_predict_CNN,registration_3D{2,pig},pig);
    AT_set{1,exp}=AT_recorded;
    AT_set{2,exp}=AT_FCN;
    AT_set{3,exp}=AT_LSTM;
    AT_set{4,exp}=AT_CNN;
    c_FCN= corrcoef(AT_recorded,AT_FCN);
    c_LSTM= corrcoef(AT_recorded,AT_LSTM);
    c_CNN= corrcoef(AT_recorded,AT_CNN);
    cc_set(1,exp)=c_FCN(1,2);
    cc_set(2,exp)=c_LSTM(1,2);
    cc_set(3,exp)=c_CNN(1,2);
    end
    cc_AT_map{1,m}=cc_set;
    AT_map{1,m}=AT_set;
    m=m+1;
end

%% localization error
initial_nodes=cell(1,5);
for i=1:5
    dim=size(AT_map{1,i});
    ID_nodes=zeros(4,dim(2));
    for exp=1:dim(2)
         [~,ID_nodes(1,exp)]=min(AT_map{1,i}{1,exp},[],1);
         [~,ID_nodes(2,exp)]=min(AT_map{1,i}{2,exp},[],1);
         [~,ID_nodes(3,exp)]=min(AT_map{1,i}{3,exp},[],1);
         [~,ID_nodes(4,exp)]=min(AT_map{1,i}{4,exp},[],1);
    end
    initial_nodes{1,i}=ID_nodes;
end
Localization_error=cell(1,5);
i=1;
for pig=1:5
    
     dim=size(AT_map{1,i});
     LE=zeros(3,dim(2));
     for exp=1:dim(2)
         ID_original=initial_nodes{1,i}(1,exp);
         ID_FCN=initial_nodes{1,i}(2,exp);
         ID_LSTM=initial_nodes{1,i}(3,exp);
         ID_CNN=initial_nodes{1,i}(4,exp);
         LE(1,exp)=(sum((registration_3D{2,pig}(ID_original)-registration_3D{2,pig}(ID_FCN)).^2))^0.5;
         LE(2,exp)=(sum((registration_3D{2,pig}(ID_original)-registration_3D{2,pig}(ID_LSTM)).^2))^0.5;
         LE(3,exp)=(sum((registration_3D{2,pig}(ID_original)-registration_3D{2,pig}(ID_CNN)).^2))^0.5;
     end
     Localization_error{1,i}=LE;
     i=i+1;
    
end
%% 
total_exp=0;
for i=1:4
   num_exp=length(Localization_error{1,i});
   total_exp=total_exp+num_exp;
end
n=1;
all_LE_FCN=zeros(1,total_exp);
all_LE_LSTM=zeros(1,total_exp);
all_LE_CNN=zeros(1,total_exp);
for i=1:4
   num_exp=length(Localization_error{1,i});
   for exp=1:num_exp
       all_LE_FCN(n)=Localization_error{1,i}(1,exp);
       all_LE_LSTM(n)=Localization_error{1,i}(2,exp);
       all_LE_CNN(n)=Localization_error{1,i}(3,exp);
       n=n+1;
   end
end
%% 
median(all_LE_FCN)
quantile(all_LE_FCN,0.25)
quantile(all_LE_FCN,0.75)
%% 
median(all_LE_LSTM)
quantile(all_LE_LSTM,0.25)
quantile(all_LE_LSTM,0.75)
%% 
median(all_LE_CNN)
quantile(all_LE_CNN,0.25)
quantile(all_LE_CNN,0.75)
%% activation time map correlation
total_exp=0;
for i=1:4
   num_exp=length(cc_AT_map{1,i});
   total_exp=total_exp+num_exp;
end
n=1;
all_AT_map_cc_FCN=zeros(1,total_exp);
all_AT_map_cc_LSTM=zeros(1,total_exp);
all_AT_map_cc_CNN=zeros(1,total_exp);
for i=1:4
   num_exp=length(cc_AT_map{1,i});
   for exp=1:num_exp
       all_AT_map_cc_FCN(n)=cc_AT_map{1,i}(1,exp);
       all_AT_map_cc_LSTM(n)=cc_AT_map{1,i}(2,exp);
       all_AT_map_cc_CNN(n)=cc_AT_map{1,i}(3,exp);
       n=n+1;
   end
end
%% 
x=zeros(1,71);
scatter(x,all_LE_CNN)
%% plot localiation error
subplot(1,3,1);
for i=1:5
    dim=size(Localization_error{1,i});
    x=zeros(1,dim(2));
    scatter(x+i,Localization_error{1,i}(1,:),'filled')
    x=x+1;
    hold on
    ylim([0 65]);
    xlim([0 6]);
    set(gca,'xtick',[])
end
subplot(1,3,2);
for i=1:5
    dim=size(Localization_error{1,i});
    x=zeros(1,dim(2));
    scatter(x+i,Localization_error{1,i}(2,:),'filled')
    x=x+1;
    hold on
    ylim([0 65]);
    xlim([0 6]);
    set(gca,'xtick',[])
end
subplot(1,3,3);
for i=1:5
    dim=size(Localization_error{1,i});
    x=zeros(1,dim(2));
    scatter(x+i,Localization_error{1,i}(3,:),'filled')
    x=x+1;
    hold on
    ylim([0 65]);
    xlim([0 6]);
    set(gca,'xtick',[])
end
%% draw localization error , seperate endo, epi, sinus
subplot(1,3,1)
for pig=1:5
    dim=size(cc_AT_map{1,pig});
    num_exp=dim(2);
    
    for exp=1:num_exp
        if index_pace_type{pig}(exp)==1
            scatter(pig,Localization_error{1,pig}(1,exp),36,[0 0.4470 0.7410],'O','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==2
            scatter(pig,Localization_error{1,pig}(1,exp),36,[0.4660 0.6740 0.1880],'^','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==3
            scatter(pig,Localization_error{1,pig}(1,exp),36,[0.4940 0.1840 0.5560],'d','filled');
            hold on
        end
    end
    xlim([0 6]);
    ylim([0 65])
    set(gca,'xtick',[])
end
subplot(1,3,2)
for pig=1:5
   dim=size(cc_all_FCN{1,pig});
    num_exp=dim(2);
    for exp=1:num_exp
         if index_pace_type{pig}(exp)==1
            scatter(pig,Localization_error{1,pig}(2,exp),36,[0 0.4470 0.7410],'O','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==2
            scatter(pig,Localization_error{1,pig}(2,exp),36,[0.4660 0.6740 0.1880],'^','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==3
            scatter(pig,Localization_error{1,pig}(2,exp),36,[0.4940 0.1840 0.5560],'d','filled');
            hold on
        end
    end
    xlim([0 6]);
    ylim([0 65])
     set(gca,'xtick',[])
end
subplot(1,3,3)
for pig=1:5
    dim=size(cc_all_FCN{1,pig});
    num_exp=dim(2);
    for exp=1:num_exp
        if index_pace_type{pig}(exp)==1
            scatter(pig,Localization_error{1,pig}(3,exp),36,[0 0.4470 0.7410],'O','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==2
            scatter(pig,Localization_error{1,pig}(3,exp),36,[0.4660 0.6740 0.1880],'^','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==3
            scatter(pig,Localization_error{1,pig}(3,exp),36,[0.4940 0.1840 0.5560],'d','filled');
            hold on
        end
    end
    hold on
    xlim([0 6]);
    ylim([0 65])
     set(gca,'xtick',[])
%     axis off
end

%% 
LE_all=0;
count=0;
for i=1:5
    dim=size(Localization_error{1,i});
    count=count+dim(2);
    for exp=1:dim(2)
        LE_all=LE_all+Localization_error{1,i}(1,exp);
    end
end
LE_all/count
%% 
count=0;
for i=1:4
    dim=size(cc_all_CNN{1,i});
    count=count+dim(2);
end
total_cc=zeros(3,count*239);
n=1;
for i=1:4
    dim=size(cc_all_CNN{1,i});
    for exp=1:dim(2)
        for node=1:239
            total_cc(1,n)=cc_all_FCN{1,i}(node,exp);
            total_cc(2,n)=cc_all_LSTM{1,i}(node,exp);
            total_cc(3,n)=cc_all_CNN{1,i}(node,exp);
            n=n+1;
        end
    end
end
%% 

%% 
subplot(1,3,1)
for pig=1:5
    num_exp=length(cc_AT_map{1,pig});
    x=zeros(1,num_exp);
    scatter(x+pig,cc_AT_map{1,pig}(1,:),'filled')
    hold on
    xlim([0 5]);
    ylim([-1 1])
    set(gca,'xtick',[])
end
subplot(1,3,2)
for pig=1:5
    num_exp=length(cc_AT_map{1,pig});
    x=zeros(1,num_exp);
    scatter(x+pig,cc_AT_map{1,pig}(2,:),'filled')
    hold on
    xlim([0 5]);
    ylim([-1 1])
    set(gca,'xtick',[])
   
end
subplot(1,3,3)
for pig=1:5
    num_exp=length(cc_AT_map{1,pig});
    x=zeros(1,num_exp);
    scatter(x+pig,cc_AT_map{1,pig}(3,:),'filled')
    hold on
    xlim([0 5]);
    ylim([-1 1])
    set(gca,'xtick',[])
   
end

%% index for endo, epi, sinus, 1 as endo, 2 as epi, 3 as sinus
index_pace_type=cell(1,5);
index_pace_type{1,1}=[1,1,1,1,2,2,2,2,2,2,2,2,3];
index_pace_type{1,2}=[1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3];
index_pace_type{1,3}=[1,1,1,1,3];
index_pace_type{1,4}=[1,1,1,1,1,1,1,1,1,1,1,1,3];
index_pace_type{1,5}=[1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3];
%% draw median AT map CC , seperate endo, epi, sinus
subplot(1,3,1)
for pig=1:5
    dim=size(cc_AT_map{1,pig});
    num_exp=dim(2);
    
    for exp=1:num_exp
        if index_pace_type{pig}(exp)==1
            scatter(pig,cc_AT_map{1,pig}(1,exp),36,[0 0.4470 0.7410],'O','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==2
            scatter(pig,cc_AT_map{1,pig}(1,exp),36,[0.4660 0.6740 0.1880],'^','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==3
            scatter(pig,cc_AT_map{1,pig}(1,exp),36,[0.4940 0.1840 0.5560],'d','filled');
            hold on
        end
    end
    xlim([0 6]);
    ylim([-1 1])
    set(gca,'xtick',[])
end
subplot(1,3,2)
for pig=1:5
   dim=size(cc_all_FCN{1,pig});
    num_exp=dim(2);
    for exp=1:num_exp
         if index_pace_type{pig}(exp)==1
            scatter(pig,cc_AT_map{1,pig}(2,exp),36,[0 0.4470 0.7410],'O','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==2
            scatter(pig,cc_AT_map{1,pig}(2,exp),36,[0.4660 0.6740 0.1880],'^','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==3
            scatter(pig,cc_AT_map{1,pig}(2,exp),36,[0.4940 0.1840 0.5560],'d','filled');
            hold on
        end
    end
    xlim([0 6]);
    ylim([-1 1])
     set(gca,'xtick',[])
end
subplot(1,3,3)
for pig=1:5
    dim=size(cc_all_FCN{1,pig});
    num_exp=dim(2);
    for exp=1:num_exp
        if index_pace_type{pig}(exp)==1
            scatter(pig,cc_AT_map{1,pig}(3,exp),36,[0 0.4470 0.7410],'O','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==2
            scatter(pig,cc_AT_map{1,pig}(3,exp),36,[0.4660 0.6740 0.1880],'^','filled');
            hold on
        elseif  index_pace_type{pig}(exp)==3
            scatter(pig,cc_AT_map{1,pig}(3,exp),36,[0.4940 0.1840 0.5560],'d','filled');
            hold on
        end
    end
    hold on
    xlim([0 6]);
    ylim([-1 1])
     set(gca,'xtick',[])
%     axis off
end
