res=zeros(70, 3);

time=0:69;

% ����
x0p=6.125; y0p=0; z0p=4;    % ���S�d�Ɉʒu(�f�J���g���W�n)
x1p=6.125; y1p=0; z1p=4.2;    % �d��-Ch1�ʒu(�f�J���g���W�n)
% %{
for i=1:70
    res(i,1)=ColonECA(time(i), x0p, y0p, z0p);
    res(i,2)=ColonECA(time(i), x1p, y1p, z1p);
    res(i,3)=res(i,2)-res(i,1);
end

figure;
plot(res(:,3)*10^3)
set(gca, 'FontName','Times', 'FontSize',12)
xlabel('Time[s]', 'FontName','Times', 'FontSize',16)
ylabel('Amplitude[\muV]', 'FontName','Times', 'FontSize',16)
%}
%% ----- �d�ʕ��z �������� -----
 %{
onecycle=12;
tate=-15:15;
yoko=-15:15;
Base=zeros(onecycle);
map=zeros(numel(tate), numel(yoko), onecycle);   % ���ʃ}�b�v(��F������)
corr=zeros(numel(tate), numel(yoko), onecycle);  % �␳�p
map2=zeros(numel(tate), numel(yoko), onecycle);  % ���ʃ}�b�v(��F���S�d��)
map3=zeros(numel(tate), numel(yoko), onecycle);

Max=zeros(onecycle,31);
MAX=zeros(1,onecycle);

for time=1:onecycle
    for j=1:31
            for k=1:31
%                     map(j,k,time)=ColonECA(time-1, x0p, yoko(k), tate(j));
                    map(j,k,time)=ColonECA(time-1, tate(j), yoko(k), 12);
            end
    end
        
    Base(time)=map(16+z0p,16+y0p,time);
    map2(:,:,time)=map(:,:,time)-Base(time);

    Max(time,:)=max(map2(:,:,time));
    MAX(time)=max(Max(time,:));

    map3(:,:,time)=map2(:,:,time)/MAX(time);
end
% %{
% �d�ʕ��z�}�@�o��
% �P��[V]
[X2,Y2]=meshgrid(yoko,tate);
% figure;
for i=1:onecycle-1
    subplot(3,4,i); % �~��
%     figure;
    surf(X2,Y2,map2(:,:,i));
    shading('flat');
    colorbar;
%     caxis([-MAX(i) MAX(i)]);
    caxis([-2*10^-10 4*10^-10]);
    xlim([-15 15]);
    ylim([-15 15]);
    set(gca,'XTick',[-25,-20,-15,-10,-5,0,5,10,15,20,25]); set(gca,'YTick',[-25,-20,-15,-10,-5,0,5,10,15,20,25]);
    view(0,90);
    
%     name=strcat('C:\Users\m-kawano\Documents\�Q�l\CTcolonoscopy\�ꎞ/',num2str(i));
%     saveas(gcf, name, 'jpg')
end
%}

%% avi�o��
%{
obj=VideoWriter('C:\Users\m-kawano\Documents\�Q�l\CTcolonoscopy\�ꎞ/modelname');
obj.FrameRate=1;
open(obj)
for i=1:onecycle-1
    name=strcat('C:\Users\m-kawano\Documents\�Q�l\CTcolonoscopy\�ꎞ/',num2str(i),'.jpg');
    image(imread(name));
    drawnow;
    writeVideo(obj,getframe);
end
close(obj);
%}