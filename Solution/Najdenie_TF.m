% +-------------------------------------------------------+
% |       Program pre výpočet prenosových funkcií         |
% |            pomocou sysbolického MATLABu               |
% |                                                       |
% |              Znázornenie PrCh a LFCh                  |
% |                                                       |
% |  zadanie: 2DOF mechanický systém – vozik na voziku    |
% |                                                       |
% | Autor: Ivan Zeman                          02/11/2022 |
% +-------------------------------------------------------+

clear, clc, clf, format compact
syms s k1 k2 b1 b2 m1 m2 F1 F2 %deklarácia symbolických premenných

% Zadanie vstupných hodnôt
disp('Analýza mech. systému - Vozík na vozíku')
m1x=0.5; m2x=0.1; k1x=400; k2x=80; b1x=8; b2x=1.6; F1x=10; F2x=0;
Tstep=1.5; wmin=0; wmax=1e3;                     % parametre pre Step a Bode
color='r';                                       % farba grafu b,r,y,m,c,

% Záspis systému a výpočet TF v symbolickom tvare
M=[k1+k2+s*b1+s*b2+m1*s*s       -k2-s*b2               %matica mechanických impedancií 
   -k2-s*b2                  k2+s*b2+m2*s*s];

f=[F1; F2];                                      %vektor budiacich síl systému
MX1=[f M(:,2)];                                  %submatica pre X1
X1=det(MX1)/det(M);                              %výpočet posunutia dráhy X1 Cramerovým pravidlom 
MX2=[M(:,1) f ];                                 %submatica pre X2
X2=det(MX2)/det(M);                              %výpočet posunutia dráhy X2 Cramerovým pravidlom 

G1=X1/F1                                         %nájdenie TF G1(s) v sysmbolickom tvare
G2=X2/F1                                         %nájdenie TF G2(s) v sysmbolickom tvare
G3=(X2-X1)/F1                                    %nájdenie TF G3(s) v sysmbolickom tvare

% Spracovanie údajov TF v symbolickom tvare pre prechod do num. MATLABu - G1
[cit,men]=numden(G1);
cit=subs(cit,{k1,k2,b1,b2,m1,m2,F1,F2},{k1x,k2x,b1x,b2x,m1x,m2x,F1x,F2x});        % dosadenie hodnôt do polynómu čitateľa
men=subs(men,{k1,k2,b1,b2,m1,m2,F1,F2},{k1x,k2x,b1x,b2x,m1x,m2x,F1x,F2x});        % dosadenie do polynómu menovateľa
b=sym2poly(cit);                                 % b - koeficienty polynómu čitateľa b(s)
a=sym2poly(men);                                 % a - koeficienty polynómu menovateľa a(s)
b=double(b);                                     % Prechod do numerickeho MATLABu
a=double(a);
G1=tf(b,a)                                       % Výsledná TF v numerickom MATLABe - G1
G1=tf(b/a(end),a/a(end))                         % TF upravená pre a0=1 (normovanie TF)
        
% Spracovanie údajov TF v symbolickom tvare pre prechod do num. MATLABu - G2
[cit,men]=numden(G2);
cit=subs(cit,{k1,k2,b1,b2,m1,m2,F1,F2},{k1x,k2x,b1x,b2x,m1x,m2x,F1x,F2x});        % dosadenie hodnôt do polynómu čitateľa
men=subs(men,{k1,k2,b1,b2,m1,m2,F1,F2},{k1x,k2x,b1x,b2x,m1x,m2x,F1x,F2x});        % dosadenie do polynómu menovateľa
b=sym2poly(cit);                                 % b - koeficienty polynómu čitateľa b(s)
a=sym2poly(men);                                 % a - koeficienty polynómu menovateľa a(s)
b=double(b);                                     % Prechod do numerickeho MATLABu
a=double(a);
G2=tf(b,a)                                       % Výsledná TF v numerickom MATLABe - G2
G2=tf(b/a(end),a/a(end))                         % TF upravená pre a0=1 (normovanie TF)

% Spracovanie údajov TF v symbolickom tvare pre prechod do num. MATLABu - G3
[cit,men]=numden(G3);
cit=subs(cit,{k1,k2,b1,b2,m1,m2,F1,F2},{k1x,k2x,b1x,b2x,m1x,m2x,F1x,F2x});        % dosadenie hodnôt do polynómu čitateľa
men=subs(men,{k1,k2,b1,b2,m1,m2,F1,F2},{k1x,k2x,b1x,b2x,m1x,m2x,F1x,F2x});        % dosadenie do polynómu menovateľa
b=sym2poly(cit);                         % b - koeficienty polynómu čitateľa b(s)
a=sym2poly(men);                         % a - koeficienty polynómu menovateľa a(s)
b=double(b);                             % Prechod do numerickeho MATLABu
a=double(a);
G3=tf(b,a)                               % Výsledná TF v numerickom MATLABe - G3
G3=tf(b/a(end),a/a(end))                 % TF upravená pre a0=1 (normovanie TF)

figure(1)   % Vykresľovanie a popis priebehov PrCh a LFCh - G1
subplot(121); step(G1,Tstep,color), grid on,
     title('Prechodová charakteristika pre G_1','FontSize',16)
     xlabel('\rightarrow T','FontSize',16)                      %popis osi X
     ylabel('\rightarrow X_1/F_1','FontSize',16)                  %popis osi Y
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';

subplot(122); bode(G1,{wmin,wmax},color), grid on
     title('Frekvenčná charakteristika pre G_1','fontsize',16)
     xlabel('\rightarrow \omega','FontSize',16),ylabel('\rightarrow\phi','FontSize',16)
     set(findall(gcf,'type','line'),'linewidth',2) % inštrukcia pre zmenu hrúbky čiary 
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';

figure(2)   % Vykresľovanie a popis priebehov PrCh a LFCh - G1
subplot(121); step(G2,Tstep,color), grid on,
    title('Prechodová charakteristika pre G_2','FontSize',16)
     xlabel('\rightarrow T','FontSize',16)                      %popis osi X
     ylabel('\rightarrow X_2/F_1','FontSize',16)                  %popis osi Y
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';

subplot(122); bode(G2,{wmin,wmax},color), grid on
     title('Frekvenčná charakteristika pre G_2','fontsize',16)
     xlabel('\rightarrow \omega','FontSize',16),ylabel('\rightarrow\phi','FontSize',16)
     set(findall(gcf,'type','line'),'linewidth',2) % inštrukcia pre zmenu hrúbky čiary 
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';

figure(3)   % Vykresľovanie a popis priebehov PrCh a LFCh - G1
subplot(121); step(G3,Tstep,color), grid on,
    title('Prechodová charakteristika pre G_3','FontSize',16)
     xlabel('\rightarrow T','FontSize',16)                      %popis osi X
     ylabel('\rightarrow (X_2-X_1)/F_1','FontSize',16)                  %popis osi Y
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';

subplot(122); bode(G3,{wmin,wmax},color), grid on
     title('Frekvenčná charakteristika pre G_3','fontsize',16)
     xlabel('\rightarrow \omega','FontSize',16),ylabel('\rightarrow\phi','FontSize',16)
     set(findall(gcf,'type','line'),'linewidth',2) % inštrukcia pre zmenu hrúbky čiary 
     ax = gca        %úprava popisu osí - farba, veľkosť, bold 
     ax.YColor = 'k'; ax.XColor = 'k'; ax.FontSize = 12; ax.FontWeight = 'bold';

%výpočet núl a pólov pre TF - G1
disp('G1 - nuly a poly')
roots([0.0008 0 0.02])                     %výpočet koreňov čitateľa
roots([0.0004 0 0.07 0 1])

%výpočet núl a pólov pre TF - G2
disp('G2 - nuly a poly')
roots([0.02])                             %výpočet koreňov čitateľa
roots([0.0004 0 0.07 0 1])

%výpočet núl a pólov pre TF - G3
disp('G3 - nuly a poly')
roots([-0.0008 0 0])                               %výpočet koreňov čitateľa
roots([0.0004 0 0.07 0 1])