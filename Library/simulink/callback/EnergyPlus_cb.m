%% ENERGYPLUS_CB - Implements callbacks for 'EnergyPlus' block
%
% This function implements the mask callbacks for the 'EnergyPlus' block in
% the NREL Campus Energy Modeling Simulink block library. It is designed to
% be called from the block mask.
%
% SYNTAX:
%   varargout = EnergyPlus_cb(block, callback, varargin)
%
% INPUTS:
%   block =     Simulink block path
%   callback =  String specifying the callback to perform; see code
%   varargin =  Inputs which vary depending on the callback; see code
%
% OUTPUTS:
%   varargout = Outputs which vary depending on the callback
%
% COMMENTS:
% 1. This function is not intended for use outside of the NREL Campus
%    Energy Modeling Simulink library; therefore the error checking and
%    documentation are minimal. View the code to see what is going on.

function varargout = EnergyPlus_cb(block, callback, varargin)
    %% Setup
    % Default output = none
    varargout = {};

    %% Callbacks
    % Select and execute desired callback
    switch callback
        % Initialization
        case 'init'
            EnergyPlus_cb_init(block, varargin{:});
            
        case 'mlep_config'
            EnergyPlus_cb_mlep_config(block);
            
        otherwise
            warning([block ':unimplementedCallback'], ...
                ['Callback ''' callback ''' not implemented.']);
        
    end
end

%% Subfunctions
% Initialization
function EnergyPlus_cb_init(~)
    % Nothing happens here
end

% Modify mask dialog - enable/disable MLE+ local configuration
function EnergyPlus_cb_mlep_config(block)
    % Enables or disables the MLE+ configuration fields based on whether
    % the appropriate checkbox is checked
    
    % Get enables
    enab = get_param(block, 'MaskEnables');
    
    % Define the indices for parameters in the mask
    xPROGNAME = 8;
    xBCVTBDIR = 9;
    xPORT =    	10;
    xHOST =     11;
    
    % MLE+ defaults
    if strcmp( get_param(block, 'mlep_defaults'), 'on' )
        % Run MLE+ init to get MLE+ settings
        mlepInit();
        
        % Values
        set_param(block, 'progname', MLEPSETTINGS.program);
        set_param(block, 'bcvtbdir', MLEPSETTINGS.bcvtbDir);
        set_param(block, 'port', '0');
        set_param(block, 'host', '');
        
        % Enables
        enab{xPROGNAME} =	'off';
        enab{xBCVTBDIR} =	'off';
        enab{xPORT} =       'off';
        enab{xHOST} =       'off';
    
    % MLE+ user settings
    else
        % Enables
        enab{xPROGNAME} =	'on';
        enab{xBCVTBDIR} =	'on';
        enab{xPORT} =       'on';
        enab{xHOST} =       'on';
    end
    
    set_param(block, 'MaskEnables', enab);
end