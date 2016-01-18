function Voltage=ColonicECA(time, xp, yp, zp)

% メモ
% 周波数：2cpm
% 円柱長：25cm
% 円柱半径 R0：3.75cm
% 腹壁：3cm
% ダイポールモーメント 0.45*10^(-9)Cm
% バンド幅 Delta：0.011cm
% 誘電率 Eps：2.213545*10^(-4)C^2/(Nm^2)

Frequency=2;
Length=25;
Radius0=3.75;
Delta=0.011;
% ダイポールモーメント密度 P/S
D=0.45*10.^(-7)/(2*Radius0*pi*Delta);
Eps=2.213545*10.^(-8);

Voltage=-D/(4*pi*Eps)*Int2(time, Frequency, Length, Radius0, Delta, xp, yp, zp);
end

function Out=Int2(time, Frequency, Length, Radius0, Delta, xp, yp, zp)
h=sqrt(xp.^2+yp.^2);
% 面xy上でx軸と電極のなす角度[rad]
theta=asin(yp/h);

Int2=@(Theta, z) Radius0.*z.*(Radius0-h*cos(Theta-theta))./(((z.^2+zp.^2+Radius0.^2+h.^2-2.*(z.*zp+Radius0.*h.*cos(Theta-theta))).^(3/2)).*((Radius0.^2+z.^2).^(1/2)));
Out=integral2(Int2, 0, 2.*pi, z(time, Frequency, Length), z(time, Frequency, Length)+Delta);
end

function height=z(time, Frequency, Length)
% 脱分極バンドの位置(高さ)
% velocity=length*frequency
v=Length*Frequency/60;

% 円柱長-速度×時間(現在の時間/周期 のあまり)
height=v*rem(time, 60/Frequency);
end