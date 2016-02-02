function Voltage=ColonECA(time, xp, yp, zp)

% ����
% ���g���F5.4cpm
% �~�����F10cm
% �~�����a R0�F1.25cm
% ���ǁF3cm
% �_�C�|�[�����[�����g 0.45*10^(-9)Cm
% �o���h�� Delta�F0.011cm
% �U�d�� Eps�F2.213545*10^(-4)C^2/(Nm^2)

Frequency=5.4;
Length=10;
Radius0=1.25;
% Delta=0.011;
Delta=0.9;
% �_�C�|�[�����[�����g���x P/S
D=0.45*10.^(-9)/(2*Radius0*pi*Delta);
Eps=2.213545*10.^(-4);

Voltage=-D/(4*pi*Eps)*Int2(time, Frequency, Length, Radius0, Delta, xp, yp, zp);
end

function Out=Int2(time, Frequency, Length, Radius0, Delta, xp, yp, zp)
h=sqrt(xp.^2+yp.^2);
% ��xy���x���Ɠd�ɂ̂Ȃ��p�x[rad]
theta=asin(yp/h);

Int2=@(Theta, z) Radius0.*z.*(Radius0-h*cos(Theta-theta))./(((z.^2+zp^2+Radius0^2+h^2-2.*(z.*zp+Radius0.*h.*cos(Theta-theta))).^(3/2)).*((Radius0^2+z.^2).^(1/2)));
Out=integral2(Int2, 0, 2.*pi, z(time, Frequency, Length), z(time, Frequency, Length)+Delta);
end

function height=z(time, Frequency, Length)
% �E���Ƀo���h�̈ʒu(����)
% velocity=length*frequency
v=Length*Frequency/60;

% �~����-���x�~����(���݂̎���/���� �̂��܂�)
height=v*rem(time, 60/Frequency);
end