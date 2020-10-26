clear;

[voz, Fsvoz]=audioread('VozOriginal.wav');
div=Fsvoz/8000;
sec=floor(length(voz)/Fsvoz);
Fs=Fsvoz/div;
l=sec*Fs;
x=zeros(l,1);
for i=div:div:Fsvoz*sec
    x(i/div)=voz(i);
end;
max(abs(x));
highest=max(abs(x))*2;
x=x/highest;


array='{';
for i=1:16000
    array=strcat(array,num2str(x(i)));
    if i==16000
        array=strcat(array,'}');
    else
        array=strcat(array,',');
    end;
end;
archivo=fopen('voz.txt','wt');
fprintf(archivo,array);
fclose(archivo);