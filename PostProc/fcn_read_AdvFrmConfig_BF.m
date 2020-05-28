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


%% read raw adc data TX beamforming from advaced configuration

% input: 
%      BF_data_dest: data file path to be read and analyzed
%      Rx_Ant_Arr: RX channel ID order to be read in sequence
%      params:  configuration parameters
% output: 
%      radar_data_frame_total_sub1: raw adc data

function [radar_data_frame_total_sub1] = fcn_read_AdvFrmConfig_BF(BF_data_dest,Rx_Ant_Arr,params)


nchirp_loops = params.nchirp_loops;
Samples_per_Chirp = params.Samples_per_Chirp;
NumAnglesToSweep = params.NumAnglesToSweep;

frameId = params.frameId;

for Rxnum=1:length(Rx_Ant_Arr)
    adc_file_name = [BF_data_dest '\ADC Temp' num2str((Rx_Ant_Arr(Rxnum)-1)*2) '.bin'];
    [ErrStatus,data_real_sub1] = Parse_Datafile_advFrm_BF(adc_file_name,params,frameId);
    if ErrStatus~=0
        disp(['Error in parsing real data file for Rxchain' num2str(Rx_Ant_Arr)]);
        return
    end
    adc_file_name = [BF_data_dest '\ADC Temp' num2str((Rx_Ant_Arr(Rxnum)-1)*2+1) '.bin'];
    [ErrStatus,data_imag_sub1] = Parse_Datafile_advFrm_BF(adc_file_name,params,frameId);
    if ErrStatus~=0
        disp(['Error in parsing imag data file for Rxchain' num2str(Rx_Ant_Arr)]);
        return
    end
    radar_data_Rxchain_sub1 =  data_real_sub1 + 1i*data_imag_sub1;  
    clear data_imag_sub1;clear data_imag_sub2; 
  
    if params.Chirp_Frame_BF == 0 %frame based TX beamforming
        radar_data_frame_sub1 = reshape(radar_data_Rxchain_sub1,Samples_per_Chirp, nchirp_loops, NumAnglesToSweep);
    elseif params.Chirp_Frame_BF == 1 %chirp based TX beamforming
        radar_data_frame_sub1 = reshape(radar_data_Rxchain_sub1,Samples_per_Chirp, NumAnglesToSweep, nchirp_loops);
        radar_data_frame_sub1 = permute(radar_data_frame_sub1, [1 3 2]);
    end
    radar_data_frame_total_sub1(:,:,Rxnum,:) = radar_data_frame_sub1;
   
end


end