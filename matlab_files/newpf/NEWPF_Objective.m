
function f = NEWPF_Objective(x,A2t,A3t,Delta,eff_K,eff_L,K0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_en,gZd_y,gZBGP,gamma,kappa1,kappa2,kappa3,phi,phi0,phiL,rho,sigma,ypsilon) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 3: Objective function                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%OLD OBJECTIVE FUNCTION INCLUDING At and v
%function f = NEWPF_Objective(x,A2t,A3t,At,Delta,K0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_en,gZd_y,gZBGP,gamma,kappa1,kappa2,kappa3,phi,phi0,phiL,rho,sigma,v,ypsilon)

%%Compute consumption based on x = [{Kt+1},{Rt+1},{pi0t},{pi2t}]:
%Step 1: Compute implied energy inputs
%Step 2: Compute carbon emissions and concentrations
%Step 3: Compute output and consumption

%%Step 4: Evaluate objective function at {Ct}

%%%%%%%%%%%%%%%%%%%%%%%%%
%%Step 1: Energy Inputs%%
%%%%%%%%%%%%%%%%%%%%%%%%%

oil = zeros(T,1);
    oil(1) = R0-x(T);
for i = 1:1:T-2;
    oil(1+i) = x(T+i-1)-x(T+i);
end
    ex_Oil = (x(T-1+T-2)-x(T-1+T-1))/(x(T-1+T-2));    %Fraction of oil left extracted in period T-1
    oil(T) = x(T-1+T-1)*ex_Oil;
ex_rates = zeros(T-1,1);
for i = 1:1:T-1;
    ex_rates(i) = oil(i)/x(T+i-1);
end
coal = zeros(T,1);
for i = 1:1:T;
    coal(i) = x(2*(T-1)+i)*A2t(i)*N;
end
wind = zeros(T,1);
for i = 1:1:T;
    wind(i) = x(2*(T-1)+T+i)*(A3t(i)*N);
end
energy = zeros(T,1);
for i = 1:1:T; 
    energy(i) = ((kappa1*oil(i)^rho)+(kappa2*coal(i)^rho)+(kappa3*wind(i)^rho))^(1/rho);
end

%% SELF ADDED FOR EXERGY LABOUR AND CAPITAL
exergy_K = zeros(T,1);
for i = 1:1:T;
    exergy_K(i) = energy(i)*x(2*(T-1)+2*T+i)*eff_K;
end
exergy_L = zeros(T,1);
for i = 1:1:T;
    exergy_L(i) = energy(i)*(1-(x(2*(T-1)+2*T+i)))*eff_L;
end

%% compute fossil fuel use
fossil_fuel = zeros(T,1);
for i = 1:1:T;
    fossil_fuel(i) = oil(i) + coal(i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Step 2: Carbon Emissions and Concentrations%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

emiss = zeros(T,1);
for i = 1:1:T;
    emiss(i) = oil(i)+ypsilon(i)*coal(i);
end

S1t = zeros(T,1);        %Non-depreciating stock
S2t_Sbar = zeros(T,1);   %Depreciating stock (S2t-Sbar)
St = zeros(T,1);         %Total carbon concentrations

S1t(1) = S1_2000+phiL*emiss(1);
S2t_Sbar(1) = (1-phi)*(S2_2000-Sbar)+phi0*(1-phiL)*emiss(1);
St(1) = Sbar+S1t(1)+S2t_Sbar(1);

for i = 1:1:T-1;
    S1t(1+i) = S1t(i)+phiL*emiss(1+i);
    S2t_Sbar(1+i) = (1-phi)*S2t_Sbar(i)+phi0*(1-phiL)*emiss(1+i);
    St(1+i) = Sbar+S1t(1+i)+S2t_Sbar(1+i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Step 3: Output and Consumption%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Yt = zeros(T,1);
Ct = zeros(T,1);
Kt1 = zeros(T,1);
%Yt(1) = At(1)*(exp((-gamma(1))*(St(1)-Sbar)))*(K0^alpha)*(((1-x(2*(T-1)+1)-x(2*(T-1)+T+1))*N)^(1-alpha-v))*(energy(1)^v);
Yt(1) = (exp((-gamma(1))*(St(1)-Sbar)))*((K0*exergy_K(1))^alpha)*((((1-x(2*(T-1)+1)-x(2*(T-1)+T+1))*N)*exergy_L(1))^(1-alpha));
Ct(1) = (1-x(1))*Yt(1);
Kt1(1) = x(1)*Yt(1)+(1-Delta)*K0;
for i = 1:1:T-2;
    %Yt(1+i) = At(1+i)*(exp((-gamma(1+i))*(St(1+i)-Sbar)))*(Kt1(i)^alpha)*(((1-x(2*(T-1)+1+i)-x(2*(T-1)+T+1+i))*N)^(1-alpha-v))*(energy(1+i)^v);
    Yt(1+i) = (exp((-gamma(1+i))*(St(1+i)-Sbar)))*((Kt1(i)*exergy_K(i))^alpha)*(((1-x(2*(T-1)+1+i)-x(2*(T-1)+T+1+i))*N)*exergy_L(i)^(1-alpha));
    Kt1(1+i) = x(1+i)*Yt(1+i)+(1-Delta)*Kt1(i);
    Ct(1+i) = (1-x(i+1))*Yt(1+i); 
end

%Yt(T) = At(T)*(exp((-gamma(T))*(St(T)-Sbar)))*(Kt1(T-1)^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha-v))*(energy(T)^v);
Yt(T) = (exp((-gamma(T))*(St(T)-Sbar)))*((Kt1(T-1)*exergy_K(T))^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)*exergy_L(T)^(1-alpha));
theta = x(T-1);
Ct(T) = Yt(T)*(1-theta);
Kt1(T) = theta*Yt(T)+(1-Delta)*Kt1(T-1);


%%%%%%%%
%%BGP%%%
%%%%%%%%
n = 100;
Ktn = zeros(n+1,1);
Ytn = zeros(n,1);
Ktn(1) = Kt1(T); 
oiln = zeros(n,1);
En = zeros(n,1);

for i = 1:1:n;
    %At(T+i) = At(T+i-1)*(1+gZd_y(T+i-1))^(1-alpha-v);
    oiln(i) = ex_Oil*x(2*(T-1))*((1-ex_Oil)^i);
    En(i) = ((kappa1*oiln(i)^rho)+(kappa2*(coal(T)*(1+gZ_en)^i)^rho)+(kappa3*(wind(T)*(1+gZ_en)^i)^rho))^(1/rho);
    %Ytn(i) = At(T+i)*(exp((-gamma(T))*(St(T)-Sbar)))*(Ktn(i)^alpha)*(((1-x(2*(T-1)+2*T)-x(2*(T-1)+T))*N)^(1-alpha-v))*(En(i)^v);
    Ytn(i) = (exp((-gamma(T))*(St(T)-Sbar)))*(Ktn(i)*exergy_K(T)^alpha)*(((1-x(2*(T-1)+2*T)-x(2*(T-1)+T))*N)*exergy_L(T)^(1-alpha));
    Ct(T+i) = (1-theta)*Ytn(i);
    Ktn(i+1) = theta*Ytn(i)+(1-Delta)*Ktn(i);
    Yt(T+i) = Ytn(i);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Step 4: Compute Utility%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ct = zeros(T+n,1);
for i = 1:1:T+n;
    ct(i) = Ct(i)/1000000;  %Re-scale units
end

U = zeros(T+n,1);

for i = 1:1:T+n-1;
    if Ct(i)<0
        U(i) = -99;
    else
        if sigma~=1
             U(i) =(beta^(i-1))*(((ct(i))^(1-sigma))-1)/(1-sigma);
        else
            U(i) = (beta^(i-1))*log(ct(i));
        end
    end
end

   if Ct(T+n)<0
       Ucont = -99;
   else
       if sigma~=1
            Ucont = (beta^(T+n-1))*(((ct(T+n)^(1-sigma))-1)/(1-sigma))*(1/(1-beta*((1+gZBGP)^(1-sigma))));
       else
            Ucont = (beta^(T+n-1))*log(ct(T+n))*(1/(1-beta*((1+gZBGP)^(1-sigma))));
       end
   end
  

 f = (-1)*(sum(U)+Ucont);
end