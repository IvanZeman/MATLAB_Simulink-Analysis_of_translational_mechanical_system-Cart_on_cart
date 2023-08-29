% +-------------------------------------------------------+
% |         Program pre výpočet a zobrazenie TF           |
% |           pomocou mech. modelu v Simscape             |
% |                                                       |   
% |        Nastavenie vstupov/výstupov v Simscape         |
% |                                                       |
% |  Znázornenie PrCh a LFCh pre TF: G1=X1/F1 a G2=X2/F1  |
% |                                                       |                  
% |  zadanie: 2DOF mechanický systém – vozik na voziku    |
% |                                                       |
% | Autor: Ivan Zeman                          23/11/2022 |
% +-------------------------------------------------------+

clear, clc, clf, format compact

m1=0.5; m2=0.1; k1=400; k2=80; b1=8; b2=1.6; F1=10; F2=0;
Tstep=1.5; wmin=0; wmax=1e3                              % parametre pre Step a Bode
Tsim=1.5;                                           % doba simulácie v Simulinku (experimentálne určená)
color='r';                                           % farba grafu b,r,y,m,c,

%Nastavenie vstupov/výstupov(io) v Simscape a prenos do workspace
model = 'simulink_model';
open_system(model)

%Nájdenie TF pre G1=X1/F1
io1(1) = linio('simulink_model/F1',1,'input');
io1(2) = linio('simulink_model/X1',1,'output');
linsys1 = linearize(model,io1);
G1=tf(linsys1)      %Nájdenie TF pre G1=X1/F1
%Nájdenie TF pre G2=X2/F1
io2(1) = linio('simulink_model/F1',1,'input');
io2(2) = linio('simulink_model/X2',1,'output');
linsys2 = linearize(model,io2);
G2=tf(linsys2)      %Nájdenie TF pre G2=X2/F1

%Zobrazenie PrCh    
figure(1)   % Vykresľovanie a popis priebehov PrCh a LFCh - G1
subplot(121); step(G1,Tstep,color), grid on,
    title('Prechodová charakteristika pre G1','FontSize',16)
     xlabel('\rightarrow T','FontSize',16)                      %popis osi X
     ylabel('\rightarrow X2/F1','FontSize',16)                  %popis osi Y
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';
subplot(122); bode(G1,{wmin,wmax},color), grid on
     title('Frekvenčná charakteristika pre G1','fontsize',16)
     xlabel('\rightarrow \omega','FontSize',16),ylabel('\rightarrow\phi','FontSize',16)
     set(findall(gcf,'type','line'),'linewidth',2) % inštrukcia pre zmenu hrúbky čiary 
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';

figure(2)   % Vykresľovanie a popis priebehov PrCh a LFCh - G1
subplot(121); step(G2,Tstep,color), grid on,
    title('Prechodová charakteristika pre G2','FontSize',16)
     xlabel('\rightarrow T','FontSize',16)                      %popis osi X
     ylabel('\rightarrow X2/F1','FontSize',16)                  %popis osi Y
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';
subplot(122); bode(G2,{wmin,wmax},color), grid on
     title('Frekvenčná charakteristika pre G2','fontsize',16)
     xlabel('\rightarrow \omega','FontSize',16),ylabel('\rightarrow\phi','FontSize',16)
     set(findall(gcf,'type','line'),'linewidth',2) % inštrukcia pre zmenu hrúbky čiary 
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';     
