% +-------------------------------------------------------+
% |   Program pre vyšetrenie vplyvu zmeny parametrov      |
% |         jednotlivých prvkov mech. systému             |
% |                                                       |
% |               Znázornenie PrCh a LFCh                 |
% |                                                       |                  
% |  zadanie: 2DOF mechanický systém – vozik na voziku    |
% |                                                       |
% | Autor: Ivan Zeman                          11/11/2022 |
% +-------------------------------------------------------+

clear, clc, clf, format compact
syms s k1 k2 B1 B2 m1 m2 F1 F2 %deklarácia symbolických premenných

disp('Analýza mech. systému - Vozík na vozíku')
m1x=0.5; m2x=0.1; k1x=400; k2x=80; B1x=8; B2x=1.6; F1x=10; F2x=0;
m11=0.1*m1x; m12=10*m1x;
m21=0.5*m2x; m22=2*m2x;
k11=0.5*k1x; k12=2*k1x;
k21=0.5*k2x; k22=2*k2x;
B11=0.5*B1x; B12=2*B1x;
B21=0.5*B2x; B22=2*B2x;

Tstep=1.5; wmin=0; wmax=1e3
color='r';                                       % farba grafu b,r,y,m,c,

%Nájdená TF v symbolickom tvare
G3 =-((F1*k2 + F2*k2 + F1*B2*s + F2*B2*s + F1*m2*s^2)/(k1*k2 + B1*m2*s^3 + B2*m1*s^3 + B2*m2*s^3 + k1*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B1*k2*s + B2*k1*s + B1*B2*s^2) - (F1*k2 + F2*k1 + F2*k2 + F1*B2*s + F2*B1*s + F2*B2*s + F2*m1*s^2)/(k1*k2 + B1*m2*s^3 + B2*m1*s^3 + B2*m2*s^3 + k1*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B1*k2*s + B2*k1*s + B1*B2*s^2))/F1

% Spracovanie údajov TF v symbolickom tvare pre prechod do num. MATLABu - G3
[cit,men]=numden(G3);
cit=subs(cit,{k1,k2,B1,B2,m1,m2,F1,F2},{k1x,k2x,B1x,B2x,m1x,m2x,F1x,F2x});        % dosadenie hodnôt do polynómu čitateľa
men=subs(men,{k1,k2,B1,B2,m1,m2,F1,F2},{k1x,k2x,B1x,B2x,m1x,m2x,F1x,F2x});        % dosadenie do polynómu menovateľa
b=sym2poly(cit);                                 % b - koeficienty polynómu čitateľa b(s)
a=sym2poly(men);                                 % a - koeficienty polynómu menovateľa a(s)
b=double(b);                                     % Prechod do numerickeho MATLABu
a=double(a);
G3=tf(b,a)                                       % Výsledná TF v numerickom MATLABe - G1
G3=tf(b/a(end),a/a(end))                         % TF upravená pre a0=1 (normovanie TF)

%Zmena parametra m1 za m11 
%Úprava TF v symbolickom tvare
Gm11 =-((F1*k2 + F2*k2 + F1*B2*s + F2*B2*s + F1*m2*s^2)/(k1*k2 + B1*m2*s^3 + B2*m11*s^3 + B2*m2*s^3 + k1*m2*s^2 + k2*m11*s^2 + k2*m2*s^2 + m11*m2*s^4 + B1*k2*s + B2*k1*s + B1*B2*s^2) - (F1*k2 + F2*k1 + F2*k2 + F1*B2*s + F2*B1*s + F2*B2*s + F2*m11*s^2)/(k1*k2 + B1*m2*s^3 + B2*m11*s^3 + B2*m2*s^3 + k1*m2*s^2 + k2*m11*s^2 + k2*m2*s^2 + m11*m2*s^4 + B1*k2*s + B2*k1*s + B1*B2*s^2))/F1
[cit2,men2]=numden(Gm11);                     % oddelenie polynómov čitateľa a menovateľa
cit2=subs(cit2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x, B2x, F1x, F2x});        % dosadenie hodnôt do polynómu čitateľa
men2=subs(men2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x, B2x, F1x, F2x});        % dosadenie do polynómu menovateľa
b2=sym2poly(cit2);                         % b - koeficienty polynómu čitateľa b(s)
a2=sym2poly(men2);                         % a - koeficienty polynómu menovateľa a(s)
b2=double(b2);                             % Prechod do numerickeho MATLABu
a2=double(a2);  
Gm11=tf(b2,a2)                             % Výsledná TF v numerickom MATLABe
Gm11=tf(b2/a2(end),a2/a2(end))             % Výsledná TF v numerickom MATLABe

%Zmena parametra m1 za m12 
%Úprava TF v symbolickom tvare
Gm12 =-((F1*k2 + F2*k2 + F1*B2*s + F2*B2*s + F1*m2*s^2)/(k1*k2 + B1*m2*s^3 + B2*m12*s^3 + B2*m2*s^3 + k1*m2*s^2 + k2*m12*s^2 + k2*m2*s^2 + m12*m2*s^4 + B1*k2*s + B2*k1*s + B1*B2*s^2) - (F1*k2 + F2*k1 + F2*k2 + F1*B2*s + F2*B1*s + F2*B2*s + F2*m12*s^2)/(k1*k2 + B1*m2*s^3 + B2*m12*s^3 + B2*m2*s^3 + k1*m2*s^2 + k2*m12*s^2 + k2*m2*s^2 + m12*m2*s^4 + B1*k2*s + B2*k1*s + B1*B2*s^2))/F1
[cit2,men2]=numden(Gm12);                     % oddelenie polynómov čitateľa a menovateľa
cit2=subs(cit2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x,B2x,F1x,F2x});        % dosadenie hodnôt do polynómu čitateľa
men2=subs(men2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x,B2x,F1x,F2x});        % dosadenie do polynómu menovateľa
b2=sym2poly(cit2);                         % b - koeficienty polynómu čitateľa b(s)
a2=sym2poly(men2);                         % a - koeficienty polynómu menovateľa a(s)
b2=double(b2);                             % Prechod do numerickeho MATLABu
a2=double(a2);  
Gm12=tf(b2,a2)                             % Výsledná TF v numerickom MATLABe
Gm12=tf(b2/a2(end),a2/a2(end))             % Výsledná TF v numerickom MATLABe

%PrCh a LFCh pre vplyv zmeny parametra m1
figure(1)   % Vykresľovanie a popis priebehov PrCh a LFCh pre vplyv zmeny parametra m1
subplot(1,2,1), step(Gm11,Tstep,'r',G3,'g',Gm12,'b'),grid on,
   title('PrCh pri zmene m_1','FontSize',16)
     xlabel('\rightarrow T','FontSize',16)
     ylabel('(X_2-X_1)/F_1','FontSize',16)
     legend('m_{1}/10','m_1','10*m_{1}')
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';
subplot(1,2,2), bode(Gm11,{wmin,wmax},'r',G3,'g',Gm12,'b'),grid on,
     title('LFCh pri zmene m_1','fontsize',16)
     xlabel('\rightarrow \omega','FontSize',16),ylabel('\rightarrow\phi','FontSize',16)
     set(findall(gcf,'type','line'),'linewidth',1.5) % inštrukcia pre zmenu hrúbky čiary 
     legend('m_{1}/10','m_1','10*m_{1}')
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';

%Zmena parametra m2 za m21 
%Úprava TF v symbolickom tvare
Gm21 =-((F1*k2 + F2*k2 + F1*B2*s + F2*B2*s + F1*m21*s^2)/(k1*k2 + B1*m21*s^3 + B2*m1*s^3 + B2*m21*s^3 + k1*m21*s^2 + k2*m1*s^2 + k2*m21*s^2 + m1*m21*s^4 + B1*k2*s + B2*k1*s + B1*B2*s^2) - (F1*k2 + F2*k1 + F2*k2 + F1*B2*s + F2*B1*s + F2*B2*s + F2*m1*s^2)/(k1*k2 + B1*m21*s^3 + B2*m1*s^3 + B2*m21*s^3 + k1*m21*s^2 + k2*m1*s^2 + k2*m21*s^2 + m1*m21*s^4 + B1*k2*s + B2*k1*s + B1*B2*s^2))/F1
[cit2,men2]=numden(Gm21);                     % oddelenie polynómov čitateľa a menovateľa
cit2=subs(cit2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x, B2x, F1x, F2x});        % dosadenie hodnôt do polynómu čitateľa
men2=subs(men2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x, B2x, F1x, F2x});        % dosadenie do polynómu menovateľa
b2=sym2poly(cit2);                         % b - koeficienty polynómu čitateľa b(s)
a2=sym2poly(men2);                         % a - koeficienty polynómu menovateľa a(s)
b2=double(b2);                             % Prechod do numerickeho MATLABu
a2=double(a2);  
Gm21=tf(b2,a2)                             % Výsledná TF v numerickom MATLABe
Gm21=tf(b2/a2(end),a2/a2(end))             % Výsledná TF v numerickom MATLABe

%Zmena parametra m2 za m22 
%Úprava TF v symbolickom tvare
Gm22 =-((F1*k2 + F2*k2 + F1*B2*s + F2*B2*s + F1*m22*s^2)/(k1*k2 + B1*m22*s^3 + B2*m1*s^3 + B2*m22*s^3 + k1*m22*s^2 + k2*m1*s^2 + k2*m22*s^2 + m1*m22*s^4 + B1*k2*s + B2*k1*s + B1*B2*s^2) - (F1*k2 + F2*k1 + F2*k2 + F1*B2*s + F2*B1*s + F2*B2*s + F2*m1*s^2)/(k1*k2 + B1*m22*s^3 + B2*m1*s^3 + B2*m22*s^3 + k1*m22*s^2 + k2*m1*s^2 + k2*m22*s^2 + m1*m22*s^4 + B1*k2*s + B2*k1*s + B1*B2*s^2))/F1
[cit2,men2]=numden(Gm22);                     % oddelenie polynómov čitateľa a menovateľa
cit2=subs(cit2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x,B2x,F1x,F2x});        % dosadenie hodnôt do polynómu čitateľa
men2=subs(men2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x,B2x,F1x,F2x});        % dosadenie do polynómu menovateľa
b2=sym2poly(cit2);                         % b - koeficienty polynómu čitateľa b(s)
a2=sym2poly(men2);                         % a - koeficienty polynómu menovateľa a(s)
b2=double(b2);                             % Prechod do numerickeho MATLABu
a2=double(a2);  
Gm22=tf(b2,a2)                             % Výsledná TF v numerickom MATLABe
Gm22=tf(b2/a2(end),a2/a2(end))             % Výsledná TF v numerickom MATLABe

%PrCh a LFCh pre vplyv zmeny parametra m2
figure(2)   % Vykresľovanie a popis priebehov PrCh a LFCh pre vplyv zmeny parametra m2
subplot(1,2,1), step(Gm21,Tstep,'r',G3,'g',Gm22,'b'),grid on,
   title('PrCh pri zmene m_2','FontSize',16)
     xlabel('\rightarrow T','FontSize',16)
     ylabel('(X_2-X_1)/F_1','FontSize',16)
     legend('m_{2}/2','m_{2}','2*m_{2}')
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';
subplot(1,2,2), bode(Gm21,{wmin,wmax},'r',G3,'g',Gm22,'b'),grid on,
     title('LFCh pri zmene m_2','fontsize',16)
     xlabel('\rightarrow \omega','FontSize',16),ylabel('\rightarrow\phi','FontSize',16)
     set(findall(gcf,'type','line'),'linewidth',1.5) % inštrukcia pre zmenu hrúbky čiary 
     legend('m_{2}/2','m_{2}','2*m_{2}')
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';

%Zmena parametra k1 za k11 
%Úprava TF v symbolickom tvare
Gk11 =-((F1*k2 + F2*k2 + F1*B2*s + F2*B2*s + F1*m2*s^2)/(k11*k2 + B1*m2*s^3 + B2*m1*s^3 + B2*m2*s^3 + k11*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B1*k2*s + B2*k11*s + B1*B2*s^2) - (F1*k2 + F2*k11 + F2*k2 + F1*B2*s + F2*B1*s + F2*B2*s + F2*m1*s^2)/(k11*k2 + B1*m2*s^3 + B2*m1*s^3 + B2*m2*s^3 + k11*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B1*k2*s + B2*k11*s + B1*B2*s^2))/F1
[cit2,men2]=numden(Gk11);                     % oddelenie polynómov čitateľa a menovateľa
cit2=subs(cit2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x, B2x, F1x, F2x});        % dosadenie hodnôt do polynómu čitateľa
men2=subs(men2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x, B2x, F1x, F2x});        % dosadenie do polynómu menovateľa
b2=sym2poly(cit2);                         % b - koeficienty polynómu čitateľa b(s)
a2=sym2poly(men2);                         % a - koeficienty polynómu menovateľa a(s)
b2=double(b2);                             % Prechod do numerickeho MATLABu
a2=double(a2);  
Gk11=tf(b2,a2)                             % Výsledná TF v numerickom MATLABe
Gk11=tf(b2/a2(end),a2/a2(end))             % Výsledná TF v numerickom MATLABe

%Zmena parametra k1 za k12 
%Úprava TF v symbolickom tvare
Gk12 =-((F1*k2 + F2*k2 + F1*B2*s + F2*B2*s + F1*m2*s^2)/(k12*k2 + B1*m2*s^3 + B2*m1*s^3 + B2*m2*s^3 + k12*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B1*k2*s + B2*k12*s + B1*B2*s^2) - (F1*k2 + F2*k12 + F2*k2 + F1*B2*s + F2*B1*s + F2*B2*s + F2*m1*s^2)/(k12*k2 + B1*m2*s^3 + B2*m1*s^3 + B2*m2*s^3 + k12*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B1*k2*s + B2*k12*s + B1*B2*s^2))/F1
[cit2,men2]=numden(Gk12);                     % oddelenie polynómov čitateľa a menovateľa
cit2=subs(cit2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x,B2x,F1x,F2x});        % dosadenie hodnôt do polynómu čitateľa
men2=subs(men2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x,B2x,F1x,F2x});        % dosadenie do polynómu menovateľa
b2=sym2poly(cit2);                         % b - koeficienty polynómu čitateľa b(s)
a2=sym2poly(men2);                         % a - koeficienty polynómu menovateľa a(s)
b2=double(b2);                             % Prechod do numerickeho MATLABu
a2=double(a2);  
Gk12=tf(b2,a2)                             % Výsledná TF v numerickom MATLABe
Gk12=tf(b2/a2(end),a2/a2(end))             % Výsledná TF v numerickom MATLABe

%PrCh a LFCh pre vplyv zmeny parametra k1
figure(3)   % Vykresľovanie a popis priebehov PrCh a LFCh pre vplyv zmeny parametra k1
subplot(1,2,1), step(Gk11,Tstep,'r',G3,'g',Gk12,'b'),grid on,
   title('PrCh pri zmene k_1','FontSize',16)
     xlabel('\rightarrow T','FontSize',16)
     ylabel('(X_2-X_1)/F_1','FontSize',16)
     legend('k_{1}/2','k_{1}','2*k_{1}')
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';
subplot(1,2,2), bode(Gk11,{wmin,wmax},'r',G3,'g',Gk12,'b'),grid on,
     title('LFCh pri zmene k_1','fontsize',16)
     xlabel('\rightarrow \omega','FontSize',16),ylabel('\rightarrow\phi','FontSize',16)
     set(findall(gcf,'type','line'),'linewidth',1.5) % inštrukcia pre zmenu hrúbky čiary 
     legend('k_{1}/2','k_{1}','2*k_{1}')
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';

%Zmena parametra k2 za k21 
%Úprava TF v symbolickom tvare
Gk21 =-((F1*k21 + F2*k21 + F1*B2*s + F2*B2*s + F1*m2*s^2)/(k1*k21 + B1*m2*s^3 + B2*m1*s^3 + B2*m2*s^3 + k1*m2*s^2 + k21*m1*s^2 + k21*m2*s^2 + m1*m2*s^4 + B1*k21*s + B2*k1*s + B1*B2*s^2) - (F1*k21 + F2*k1 + F2*k21 + F1*B2*s + F2*B1*s + F2*B2*s + F2*m1*s^2)/(k1*k21 + B1*m2*s^3 + B2*m1*s^3 + B2*m2*s^3 + k1*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B1*k2*s + B2*k1*s + B1*B2*s^2))/F1
[cit2,men2]=numden(Gk21);                     % oddelenie polynómov čitateľa a menovateľa
cit2=subs(cit2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x, B2x, F1x, F2x});        % dosadenie hodnôt do polynómu čitateľa
men2=subs(men2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x, B2x, F1x, F2x});        % dosadenie do polynómu menovateľa
b2=sym2poly(cit2);                         % b - koeficienty polynómu čitateľa b(s)
a2=sym2poly(men2);                         % a - koeficienty polynómu menovateľa a(s)
b2=double(b2);                             % Prechod do numerickeho MATLABu
a2=double(a2);  
Gk21=tf(b2,a2)                             % Výsledná TF v numerickom MATLABe
Gk21=tf(b2/a2(end),a2/a2(end))             % Výsledná TF v numerickom MATLABe

%Zmena parametra k2 za k22 
%Úprava TF v symbolickom tvare
Gk22 =-((F1*k22 + F2*k22 + F1*B2*s + F2*B2*s + F1*m2*s^2)/(k1*k22 + B1*m2*s^3 + B2*m1*s^3 + B2*m2*s^3 + k1*m2*s^2 + k22*m1*s^2 + k22*m2*s^2 + m1*m2*s^4 + B1*k22*s + B2*k1*s + B1*B2*s^2) - (F1*k22 + F2*k1 + F2*k22 + F1*B2*s + F2*B1*s + F2*B2*s + F2*m1*s^2)/(k1*k22 + B1*m2*s^3 + B2*m1*s^3 + B2*m2*s^3 + k1*m2*s^2 + k22*m1*s^2 + k22*m2*s^2 + m1*m2*s^4 + B1*k22*s + B2*k1*s + B1*B2*s^2))/F1
[cit2,men2]=numden(Gk22);                     % oddelenie polynómov čitateľa a menovateľa
cit2=subs(cit2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x,B2x,F1x,F2x});        % dosadenie hodnôt do polynómu čitateľa
men2=subs(men2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x,B2x,F1x,F2x});        % dosadenie do polynómu menovateľa
b2=sym2poly(cit2);                         % b - koeficienty polynómu čitateľa b(s)
a2=sym2poly(men2);                         % a - koeficienty polynómu menovateľa a(s)
b2=double(b2);                             % Prechod do numerickeho MATLABu
a2=double(a2);  
Gk22=tf(b2,a2)                             % Výsledná TF v numerickom MATLABe
Gk22=tf(b2/a2(end),a2/a2(end))             % Výsledná TF v numerickom MATLABe

%PrCh a LFCh pre vplyv zmeny parametra k2
figure(4)   % Vykresľovanie a popis priebehov PrCh a LFCh pre vplyv zmeny parametra k2
subplot(1,2,1), step(Gk21,Tstep,'r',G3,'g',Gk22,'b'),grid on,
   title('PrCh pri zmene k_2','FontSize',16)
     xlabel('\rightarrow T','FontSize',16)
     ylabel('(X_2-X_1)/F_1','FontSize',16)
     legend('k_{2}/2','k_{2}','2*k_2')
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';
subplot(1,2,2), bode(Gk21,{wmin,wmax},'r',G3,'g',Gk22,'b'),grid on,
     title('LFCh pri zmene k_2','fontsize',16)
     xlabel('\rightarrow \omega','FontSize',16),ylabel('\rightarrow\phi','FontSize',16)
     set(findall(gcf,'type','line'),'linewidth',1.5) % inštrukcia pre zmenu hrúbky čiary 
     legend('k_2/2','k_2','2*k_2')
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';

%Zmena parametra b1 za b11 
%Úprava TF v symbolickom tvare
Gb11 =-((F1*k2 + F2*k2 + F1*B2*s + F2*B2*s + F1*m2*s^2)/(k1*k2 + B11*m2*s^3 + B2*m1*s^3 + B2*m2*s^3 + k1*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B11*k2*s + B2*k1*s + B11*B2*s^2) - (F1*k2 + F2*k1 + F2*k2 + F1*B2*s + F2*B11*s + F2*B2*s + F2*m1*s^2)/(k1*k2 + B11*m2*s^3 + B2*m1*s^3 + B2*m2*s^3 + k1*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B11*k2*s + B2*k1*s + B11*B2*s^2))/F1
[cit2,men2]=numden(Gb11);                     % oddelenie polynómov čitateľa a menovateľa
cit2=subs(cit2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x, B2x, F1x, F2x});        % dosadenie hodnôt do polynómu čitateľa
men2=subs(men2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x, B2x, F1x, F2x});        % dosadenie do polynómu menovateľa
b2=sym2poly(cit2);                         % b - koeficienty polynómu čitateľa b(s)
a2=sym2poly(men2);                         % a - koeficienty polynómu menovateľa a(s)
b2=double(b2);                             % Prechod do numerickeho MATLABu
a2=double(a2);  
Gb11=tf(b2,a2)                             % Výsledná TF v numerickom MATLABe
Gb11=tf(b2/a2(end),a2/a2(end))             % Výsledná TF v numerickom MATLABe

%Zmena parametra b1 za b12 
%Úprava TF v symbolickom tvare
Gb12 =-((F1*k2 + F2*k2 + F1*B2*s + F2*B2*s + F1*m2*s^2)/(k1*k2 + B12*m2*s^3 + B2*m1*s^3 + B2*m2*s^3 + k1*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B12*k2*s + B2*k1*s + B12*B2*s^2) - (F1*k2 + F2*k1 + F2*k2 + F1*B2*s + F2*B12*s + F2*B2*s + F2*m1*s^2)/(k1*k2 + B12*m2*s^3 + B2*m1*s^3 + B2*m2*s^3 + k1*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B12*k2*s + B2*k1*s + B1*B2*s^2))/F1
[cit2,men2]=numden(Gb12);                     % oddelenie polynómov čitateľa a menovateľa
cit2=subs(cit2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x,B2x,F1x,F2x});        % dosadenie hodnôt do polynómu čitateľa
men2=subs(men2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x,B2x,F1x,F2x});        % dosadenie do polynómu menovateľa
b2=sym2poly(cit2);                         % b - koeficienty polynómu čitateľa b(s)
a2=sym2poly(men2);                         % a - koeficienty polynómu menovateľa a(s)
b2=double(b2);                             % Prechod do numerickeho MATLABu
a2=double(a2);  
Gb12=tf(b2,a2)                             % Výsledná TF v numerickom MATLABe
Gb12=tf(b2/a2(end),a2/a2(end))             % Výsledná TF v numerickom MATLABe

%PrCh a LFCh pre vplyv zmeny parametra b1
figure(5)   % Vykresľovanie a popis priebehov PrCh a LFCh pre vplyv zmeny parametra b1
subplot(1,2,1), step(Gb11,Tstep,'r',G3,'g',Gb12,'b'),grid on,
   title('PrCh pri zmene b_1','FontSize',16)
     xlabel('\rightarrow T','FontSize',16)
     ylabel('(X_2-X_1)/F_1','FontSize',16)
     legend('b_1/2','b_1','2*b_1')
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';
subplot(1,2,2), bode(Gb11,{wmin,wmax},'r',G3,'g',Gb12,'b'),grid on,
     title('LFCh pri zmene b_1','fontsize',16)
     xlabel('\rightarrow \omega','FontSize',16),ylabel('\rightarrow\phi','FontSize',16)
     set(findall(gcf,'type','line'),'linewidth',1.5) % inštrukcia pre zmenu hrúbky čiary 
     legend('b_1/2','b_1','2*b_1')
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';


%Zmena parametra b2 za b21 
%Úprava TF v symbolickom tvare
Gb21 =-((F1*k2 + F2*k2 + F1*B21*s + F2*B21*s + F1*m2*s^2)/(k1*k2 + B1*m2*s^3 + B21*m1*s^3 + B21*m2*s^3 + k1*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B1*k2*s + B21*k1*s + B1*B21*s^2) - (F1*k2 + F2*k1 + F2*k2 + F1*B21*s + F2*B1*s + F2*B21*s + F2*m1*s^2)/(k1*k2 + B1*m2*s^3 + B21*m1*s^3 + B21*m2*s^3 + k1*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B1*k2*s + B21*k1*s + B1*B21*s^2))/F1
[cit2,men2]=numden(Gb21);                     % oddelenie polynómov čitateľa a menovateľa
cit2=subs(cit2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x, B2x, F1x, F2x});        % dosadenie hodnôt do polynómu čitateľa
men2=subs(men2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x, B2x, F1x, F2x});        % dosadenie do polynómu menovateľa
b2=sym2poly(cit2);                         % b - koeficienty polynómu čitateľa b(s)
a2=sym2poly(men2);                         % a - koeficienty polynómu menovateľa a(s)
b2=double(b2);                             % Prechod do numerickeho MATLABu
a2=double(a2);  
Gb21=tf(b2,a2)                             % Výsledná TF v numerickom MATLABe
Gb21=tf(b2/a2(end),a2/a2(end))             % Výsledná TF v numerickom MATLABe

%Zmena parametra b2 za b22 
%Úprava TF v symbolickom tvare
Gb22 =-((F1*k2 + F2*k2 + F1*B22*s + F2*B22*s + F1*m2*s^2)/(k1*k2 + B1*m2*s^3 + B22*m1*s^3 + B22*m2*s^3 + k1*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B1*k2*s + B22*k1*s + B1*B22*s^2) - (F1*k2 + F2*k1 + F2*k2 + F1*B22*s + F2*B1*s + F2*B22*s + F2*m1*s^2)/(k1*k2 + B1*m2*s^3 + B22*m1*s^3 + B22*m2*s^3 + k1*m2*s^2 + k2*m1*s^2 + k2*m2*s^2 + m1*m2*s^4 + B1*k2*s + B22*k1*s + B1*B22*s^2))/F1
[cit2,men2]=numden(Gb22);                     % oddelenie polynómov čitateľa a menovateľa
cit2=subs(cit2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x,B2x,F1x,F2x});        % dosadenie hodnôt do polynómu čitateľa
men2=subs(men2,{m1,m2,k1,k2,B1,B2,F1,F2},{m1x,m2x,k1x,k2x,B1x,B2x,F1x,F2x});        % dosadenie do polynómu menovateľa
b2=sym2poly(cit2);                         % b - koeficienty polynómu čitateľa b(s)
a2=sym2poly(men2);                         % a - koeficienty polynómu menovateľa a(s)
b2=double(b2);                             % Prechod do numerickeho MATLABu
a2=double(a2);  
Gb22=tf(b2,a2)                             % Výsledná TF v numerickom MATLABe
Gb22=tf(b2/a2(end),a2/a2(end))             % Výsledná TF v numerickom MATLABe

%PrCh a LFCh pre vplyv zmeny parametra b2
figure(6)   % Vykresľovanie a popis priebehov PrCh a LFCh pre vplyv zmeny parametra b2
subplot(1,2,1), step(Gb21,Tstep,'r',G3,'g',Gb22,'b'),grid on,
   title('PrCh pri zmene b_2','FontSize',16)
     xlabel('\rightarrow T','FontSize',16)
     ylabel('(X_2-X_1)/F_1','FontSize',16)
     legend('b_2/2','b_2','2*b_2')
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';
subplot(1,2,2), bode(Gb21,{wmin,wmax},'r',G3,'g',Gb22,'b'),grid on,
     title('LFCh pri zmene b_2','fontsize',16)
     xlabel('\rightarrow \omega','FontSize',16),ylabel('\rightarrow\phi','FontSize',16)
     set(findall(gcf,'type','line'),'linewidth',1.5) % inštrukcia pre zmenu hrúbky čiary 
     legend('b_2/2','b_2','2*b_2')
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';

    