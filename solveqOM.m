function [d] = solveqOM(K,q,bc)
    [nd,nd]=size(K);
    fdof=[1:nd]';

    d=zeros(size(fdof));

    pdof=bc(:,1);
    dp=bc(:,2);
    fdof(pdof)=[];

    s=K(fdof,fdof)\(q(fdof)-K(fdof,pdof)*dp);

    d(pdof)=dp;
    d(fdof)=s;
end



