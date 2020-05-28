%  Copyright (C) 2018 Texas Instruments Incorporated - http://www.ti.com/ 
%  
%  
%   Redistribution and use in source and binary forms, with or without 
%   modification, are permitted provided that the following conditions 
%   are met:
%  
%     Redistributions of source code must retain the above copyright 
%     notice, this list of conditions and the following disclaimer.
%  
%     Redistributions in binary form must reproduce the above copyright
%     notice, this list of conditions and the following disclaimer in the 
%     documentation and/or other materials provided with the   
%     distribution.
%  
%     Neither the name of Texas Instruments Incorporated nor the names of
%     its contributors may be used to endorse or promote products derived
%     from this software without specific prior written permission.
%  
%   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
%   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
%   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
%   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
%   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
%   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
%   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
%   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
%   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
%   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%  
% 

%read adc data for advanced frame configuration

% input: 
%      adc_file_name: data file path to be read
%      params:  configuration parameters
%      frameId: frame ID to be read
% output: 
%      ErrStatus: error status
%      radar_data_realorimag_sub1: raw ADC data after reading from the
%      binary file


function [ErrStatus,radar_data_realorimag_sub1] = Parse_Datafile_advFrm_BF(adc_file_name,params,frameId)


Samples_per_Chirp = params.Samples_per_Chirp;
nchirp_loops = params.nchirp_loops;
NumAnglesToSweep = params.NumAnglesToSweep;
numBurst_sub1 = NumAnglesToSweep;

Expected_Num_Real_Samples_sub1 = Samples_per_Chirp*nchirp_loops*(NumAnglesToSweep);
Expected_Num_Real_Samples =  Expected_Num_Real_Samples_sub1;

fileID = fopen(adc_file_name,'r');
if fileID < 0
    if isdeployed()
        exit(-1);
    else
        ErrStatus = -1;
        return
    end
end
%each integer is 2 bytes
fseek(fileID,(frameId-1)*Expected_Num_Real_Samples*2, 'bof');
radar_data_realorimag = fread(fileID,Expected_Num_Real_Samples,'uint16');
radar_data_realorimag = radar_data_realorimag - 2^15;
fclose(fileID);

if numel(radar_data_realorimag) ~= Expected_Num_Real_Samples
    disp('Number of samples in data file not matchig expected');
    ErrStatus = -2;
    return;
end
radar_data_realorimag_sub1 = radar_data_realorimag(1:Expected_Num_Real_Samples_sub1);
% Rearrange the data into a 4D matrix with dimensions  : channels x samples x chirps x Frames
radar_data_realorimag_sub1 = reshape(radar_data_realorimag_sub1, Samples_per_Chirp, nchirp_loops*numBurst_sub1);


ErrStatus = 0; %No Err
end