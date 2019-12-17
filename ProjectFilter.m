%% Comment
%Filipus Samuel - Bryan Alexis Simon - Filbert Wijaya
%File di import dengan format range sumbu x saja (Range = A dataawal : A dataakhir)
%Output Typenya menggunakan Numeric Matrix

%Line 9 (Full Version)


 %% Filtered Version 
 % Analisa segala Data (Filip-Bryan-Filbert) ganti file aja klo mw coba2
 subplot(5,1,1);            %Untuk bikin plot2 kecil dalam 1 figure sebanyak 5 baris, 1 kolom, data ke 1
 plot(FilipVariation);       %Untuk ngeliat grafik data mentah dari data HyperIMU di HP
 title('FilipVariation');    %Title plot = nama data
 
 FV_Scalar = sqrt(sum(FilipVariation.^2, 2)); %akar kuadrat dari penjumlahan data dikali
 subplot(5,1,2);            %5 baris, 1 kolom, data ke-2
 plot(FV_Scalar);           %Untuk ngeliat grafik data setelah di lakukan proses scalar
 title('Scalar');           %Title plot = Scalar
 
 FV_ScalarNoGravity = FV_Scalar - 9.8;
 subplot(5,1,3);            %5 baris, 1 kolom, data ke-3
 plot(FV_ScalarNoGravity)   %Untuk ngeliat grafik setelah dihilangkan gravitynya
 title('Scalar No Gravity');%Title plot = Scalar + No Gravity

 
 %(Mengusir Noise) 
 Fs = 50;                   %sampling rate dari HyperIMU 20 ms = 50 Hz
 z = FV_ScalarNoGravity;    %memudahkan memanggil untuk plot ataupun digunakan di hal lain
 subplot(5,1,4);            %5 baris, 1 kolom, data ke-4
 plot(z);                   %memperlihatkan sinyal yg ada noise untuk dihilangkan nantinya di proses setelah
 title('Noised Signal');    %Juduls plot = Noised Signal
 
 % Spectral analysis of the signal
 % buat frequency axis
 L = length(z);             %Panjang sinyal
                            %suppose our signal length is 638
 NFFT = 2^nextpow2(L);      %Mendefinisikan Number of FFT (next of 2 to the power 2 the length of the signal)
                            %512 point yang beberapainfonya kita hilang
 z_fft = abs(fft(z, NFFT)); %ambil nilai fft ke z_fft untuk di absolutkan nilainya yang ada di z, dan number of point seperti NFFT)
    %spectrum di x-axis ada frequency dan di y-axis ada magnitude dr
    %by z_fft, kita bakal magnitude the spectrum, tp kita butuh membuat
    %frequency axisnya
 freq = Fs/2*linspace(0,1,NFFT/2+1); %untuk convert ke hertz, 
 subplot(5,1,5); %5 baris, 1 kolom, data ke 5
 plot(freq, z_fft(1:length(freq))); %ini adalah sinyal FFT kita
 %kita mw pass sinyal yang peak / filter out sinyal tersebut atau hilangin
 %sinyal lainnya
 title('Single-Sided Amplitude Spectrum of y(t)');
 
 o = 5; %order dari filter = 5
 wn = [1 2]*2/Fs; %frequency range dari filter 1 sampai 2 (cutoff frequency)
 [b, a] = butter(o,wn,'bandpass'); %define filter band pass butterworth 

 figure; %untuk cek frequency respon dari filter untuk melihat apakah frequency responsenya benar atau salah
 freqz(b,a,1024,Fs);
 [h, w] = freqz(b,a,1024,Fs);
 title('Magnitude Response of the Filter');
 
 %Kita Filter sinyal kita, kita tau kita punya spectral, 
 %ini range dari sinyal kita dimana kita mau ekstrak dari noisy signal, lalu kita defined
 %filternya atau buat filternya dengan range yang spesifik, apakah range kita atau desain filter kita itu 
 %benar atau salah dengan cara mengambil respon frekuensi dan
 %menvisualisasikan respon frekuensinya jg.
 %Sekarang saatnya mendapatkan output dr filter
 
 %(Hasil Filtering)  (biar tampilan bagus di figure)
 z_filt = filter(b,a,z); %filter sinyal ada di z_filt
 figure;
 plot(z_filt); %ini desain filter kita
 title('Filtered Signal');
 
 %(Melakukan AboveOne instead of Zeros(AboveZero)) 
 % Perhitungan Count Step
 aboveOne = z_filt > 1;
 zeroCrossing = diff(aboveOne) == 1;
 zeroCrossingIndex = find(zeroCrossing);
 hold on;
 plot(zeroCrossingIndex, zeros(size(zeroCrossingIndex)), 'r', 'Marker', 'v', 'LineStyle', 'none');
 hold off;
 title('15 Step Variasi - Filip');
 
 numberOfSteps = numel(zeroCrossingIndex);
 