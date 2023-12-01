A=2;
F0=1e3;
p=256;
mu=1e-4;
errbound=1e-3;
Fs=16e3;

t=0:1/Fs:p/Fs;
m=A*sin(2*pi*F0*t);
n=randn(1,p+1);
n=n-mean(n);
x=m+n;

wprev=zeros(1,p+1);


for i=1:p
    b = wprev;
    a = 1;
    y = filter(b,a,x);
   % y=wprev*x';
    wcurr=wprev+mu*x.*(x(i)-y);
  %  if((rms(wcurr-wprev)/rms(wprev))^2<errbound)
   %     break
  %  else
        wprev=wcurr;
  %  end  
  
end

b0 = wcurr;
a1 = 1;
[h,w]=freqz(b0,a1,p+1,'whole');
freq=-Fs/2:Fs/(p+1):Fs/2-Fs/(p+1);
figure(1)

plot(freq,fftshift(abs(fft(h)).^2));
%plot(freq,fftshift(abs(h).^2));
title(['Transfer function plot with frequency'])
xlabel('frequency')
ylabel('H(z)')