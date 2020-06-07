classdef LocError
    properties
        M %Conductivity matrix
        vert %3D position of sources
        y %EEG
        pos_x %True position of source activity 
        x_est %Estimated activity
        T_mne % Inverse operator for MNE
        T_sLOR % Inverse operator for sLORETA
    end
    
    methods
        function obj = LocError(M,vert,y,pos_x)
            obj.M = M;
            obj.vert = vert;
            obj.y = y;
            obj.pos_x = pos_x;
            %MNE Inverse operator calculation
            alpha = 0.2*trace(M*M');
            [Ne, Nv] = size(M);
            obj.T_mne = M'/(M*M' + alpha*eye(Ne)); 
            %sLORETA Inverse operator calculation
            T_sLOR = M'/(M*M' + alpha*eye(Ne));
            S = sparse(Nv, Nv);
                for k=1:Nv
                    S(k,k) = sqrt(1./(T_sLOR(k,:)*M(:,k)));
                end
            obj.T_sLOR = S*T_sLOR;
        end 
        
        function error = localization_error(obj,electrodes)
            %Defining the electrodes to use
            data = obj.y.*electrodes;
            %MNE estimation
%             obj.x_est = obj.T_mne*data;
            %sLOR estimation
            obj.x_est = obj.T_sLOR*data;
            %Source position estimation 
            xk = obj.x_est.^2; 
            [~, pos_xmax] =  max(sum(xk'));
            %Localization error calculation
            error = norm(obj.pos_x-obj.vert(pos_xmax,:));
        end
        
    end
end