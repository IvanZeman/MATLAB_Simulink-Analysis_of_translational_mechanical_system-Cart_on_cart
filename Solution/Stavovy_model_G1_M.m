% +-------------------------------------------------------+
% |         Program pre výpočet a zobrazenie TF           |
% |           pomocou stavového modelu systému            |
% |                                                       |   
% |       Znázornenie PrCh a LFCh pre TF: G1=X1/F1        |
% |                                                       |                  
% |  zadanie: 2DOF mechanický systém – vozik na voziku    |
% |                                                       |
% | Autor: Ivan Zeman                          19/11/2022 |
% +-------------------------------------------------------+

% Program pre výpočet a zobrazenie TF pomocou stavového modelu mech. syst. 
% I. Zeman, 19.11.2022
% Príklad: 2DOF – Vozík na vozíku
%
% Znázornenie PrCH a LFCH pre tf: G1=X1/F1 
% Zmeny veľkosti popisov osi, farby a hrúbky čiary
clear, clc, clf, format compact
disp('Analýza mech. systému - Vozík na vozíku')

% parametre systému
syms X1 X2 X3 X4 k1 k2 b1 b2 m1 m2 F1 F2;           %deklarácia symbolických premenných
m1x=0.5; m2x=0.1; k1x=400; k2x=80; b1x=8; b2x=1.6; F1x=10; F2x=0;
Tstep=1.5; wmin=0; wmax=1e3                    % parametre pre Step a Bode
color='r';                                          % farba grafu b,r,y,m,c,

%% Stavový model zapísaný v tvare matíc a vektorov
disp('Stavový model v symbolickom tvare:')
A=[     0              0                 1              0
        0              0                 0              1
-(k1+k2)/m1          k2/m1           -(b1+b2)/m1       b2/m1
    k2/m2           -k2/m2              b2/m2          -b2/m2]
b=[0; 0; 1/m1; 0]
cT=[1 0 0 0]  
d=[0]

% Náhrada symb.premenných hodnotami
m1=m1x; m2=m2x; k1=k1x; k2=k2x; b1=b1x; b2=b2x; F1=F1x; F2=F2x;
disp('Stavový po dosadení hodnôt parametrov:')
A=[     0              0                 1             0
        0              0                 0              1
-(k1+k2)/m1          k2/m1           -(b1+b2)/m1       b2/m1
    k2/m2           -k2/m2              b2/m2          -b2/m2]
b=[0; 0; 1/m1; 0]
cT=[1 0 0 0]
d=[0]

%% Výstupy
%výpočet tf: G1=X1/F1
disp('Výpis stavového modelu:')
printsys(A,b,cT,d)
disp('Výpis prenosovej funkcie G1:')
[num,den]=ss2tf(A,b,cT,d)
G1=tf(num/den(end),den/den(end))

disp('Vlastné hodnoty matice A:')
% format long (príkaz na zmenu formátu výsledného čísla)
eig(A)
disp('Póly prenosovej funkcie G1:')
roots(den)
format short

figure(1)   %vykreľovanie priebehov G1
color='r';  
subplot(1,2,1),step(A,b,cT,d),grid on
     title('Prechodová charakteristika G1','FontSize',16)
     xlabel('\rightarrow T','FontSize',16)
     ylabel('\rightarrow X1/F1','FontSize',14)
subplot(1,2,2),bode(A,b,cT,d),grid on
     title('Frekvenčná charakteristika G1','fontsize',16)
     xlabel('\rightarrow \omega','FontSize',16),ylabel('\rightarrow\phi','FontSize',16)
     set(findall(gcf,'type','line'),'linewidth',2) % inštrukcia pre zmenu hrúbky čiary