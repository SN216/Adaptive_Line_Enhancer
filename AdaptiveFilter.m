A=2;
mu = 1e-4; 
err_max = 1e-3; 

F0 = 10e3;
Fs = 20e3;

p = 256;
t = 0:1/Fs:(p/Fs);
m = A*sin(2*pi*1000*t);

figure
subplot(2,2,1)
plot(t,m); 
xlabel('time'); 
ylabel('x(t)'); 
title('Original Signal (F_0=10kHz)');

n=randn(1,p+1);
n=n-mean(n);
X = m + n;

subplot(2,2,2)
plot(t,X); xlabel('time'); ylabel('x(t)'); 
title('Input Signal with Gaussian noise');

w = zeros(p,1); 
error = 1; 
x = zeros(p,1);
x_new = zeros(p,1);

i = 1;
while(error > err_max) 
    y = w'*x;
    e = X(i) - y; 
    w_new = w + mu*x*e; 
    if(i == 1) 
        error = 1;
    else
        error = (sumsqr(w_new-w))/(sumsqr(w));
    end
    w = w_new; 
    x(1) = X(i);
    for k = 2:p 
        x_new(k) = x(k-1); 
    end
    x = x_new; 
    i = i+1;
end

f = (Fs/2)*linspace(-1,1,512);
subplot(2,2,3)
plot(f,(abs(fftshift(fft(w,512)))).^2);
xlabel('Frequency');
ylabel('Amplitude');
title('Adaptive filter response');


subplot(2,2,4)
plot(t,filter(w,1,X)); xlabel('t'); ylabel('y(t)'); 
title('Filter output');