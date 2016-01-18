res=zeros(70, 3);

time=0:69;

% メモ
x0p=6.75; y0p=20; z0p=-20;    % 中心電極位置(デカルト座標系)
x1p=6.75; y1p=20; z1p=15;    % 電極-Ch1位置(デカルト座標系)
%{
for i=1:70
    res(i,1)=ColonicECA(time(i), x0p, y0p, z0p);
    res(i,2)=ColonicECA(time(i), x1p, y1p, z1p);
    res(i,3)=res(i,2)-res(i,1);
end

figure;
plot(res(:,3)*10^6)
set(gca, 'FontName','Times', 'FontSize',12)
xlabel('Time[s]', 'FontName','Times', 'FontSize',16)
ylabel('Amplitude[\muV]', 'FontName','Times', 'FontSize',16)
%}
%% ----- 電位分布 ここから -----
%  %{
onecycle=30;
tate=-25:25;
yoko=-25:25;
Base=zeros(onecycle);
map=zeros(numel(tate), numel(yoko), onecycle);   % 平面マップ(基準：無限遠)
corr=zeros(numel(tate), numel(yoko), onecycle);  % 補正用
map2=zeros(numel(tate), numel(yoko), onecycle);  % 平面マップ(基準：中心電極)
map3=zeros(numel(tate), numel(yoko), onecycle);

Max=zeros(onecycle,51);
MAX=zeros(1,onecycle);

for time=1:onecycle
    for j=1:51
            for k=1:51
                    map(j,k,time)=ColonicECA(time-1, x1p, yoko(k), tate(j));
            end
    end
        
    Base(time)=map(26+y0p,26+z0p,time);
    map2(:,:,time)=map(:,:,time)-Base(time);

    Max(time,:)=max(map2(:,:,time));
    MAX(time)=max(Max(time,:));

    map3(:,:,time)=map2(:,:,time)/MAX(time);
end
% %{
% 電位分布図　出力
% 単位[V]
[X2,Y2]=meshgrid(yoko,tate);
% figure;
for i=1:onecycle
    subplot(5,6,i);
%     figure;
    surf(X2,Y2,map2(:,:,i));
    shading('flat');
%     colorbar;
    caxis([-MAX(i) MAX(i)]);
    xlim([-25 25]);
    ylim([-25 25]);
    set(gca,'XTick',[-25,-20,-15,-10,-5,0,5,10,15,20,25]);
    set(gca,'YTick',[-25,-20,-15,-10,-5,0,5,10,15,20,25]);
    view(0,90);
    
%     name=strcat('C:\Users\m-kawano\Documents\参考\CTcolonoscopy\一時/',num2str(i));
%     saveas(gcf, name, 'jpg')
end
%}

%% avi出力
%{
obj=VideoWriter('C:\Users\m-kawano\Documents\参考\CTcolonoscopy\一時/modelname');
obj.FrameRate=1;
open(obj)
for i=1:onecycle
    name=strcat('C:\Users\m-kawano\Documents\参考\CTcolonoscopy\一時/',num2str(i),'.jpg');
    image(imread(name));
    drawnow;
    writeVideo(obj,getframe);
end
close(obj);
%}