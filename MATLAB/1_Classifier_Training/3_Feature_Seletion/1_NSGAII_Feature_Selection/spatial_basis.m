%Spatial dictionary
function [Mp,Qp,M]=spatial_basis(M,QG,vert)
%Mp:M*Qp Reduced leadfield matrix
%Qp:Spatial basis

Np = 256;
Ns = size(vert,1);
Qp    = [];
Ip    = ceil((1:Np)*Ns/Np);	% "random" selection of patches
for i = 1:Np
    % First set (Not left hemisphere)
    %--------------------------------------------------------------
    q               = QG(:,Ip(i));
    Qp              = [Qp q];
    % Extended set (add 256 priors)
    %--------------------------------------------------------------    
    [~,j] = min(sum([vert(:,1) + vert(Ip(i),1), ...
        vert(:,2) - vert(Ip(i),2), ...
        vert(:,3) - vert(Ip(i),3)].^2,2));
    q               = QG(:,j);
    Qp              = [Qp q];
    % bilateral (add another 256 priors)
    %--------------------------------------------------------------
end
Mp = M*Qp;
