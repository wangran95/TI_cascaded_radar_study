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

%% generate hanning window for range FFT and Doppler FFT respectively

% input: 
%      params: parameter structure
%      
% output: 
%      window_1D: range FFT window
%      window_2D: Doppler FFT window


function [window_1D, window_2D] = generate_windows(params)
 nchirp_loops = params.nchirp_loops;
if params.ApplyRangeDopplerWind == 1;
   
    
    window_1D = repmat(hann_local(params.Samples_per_Chirp), ...
        1, ...
        nchirp_loops,...
        params.numRX, ...
        params.numTX);
    window_2D = repmat(...
        (hann_local(nchirp_loops))',...
        params.rangeFFTSize,...
        1,...
        params.numRX, ...
        params.numTX);
else
    window_1D = repmat(ones(params.Samples_per_Chirp,1), ...
        1, ...
        nchirp_loops,...
        params.numRX, ...
        params.numTX);
    window_2D = repmat(...
        (ones(nchirp_loops,1))',...
        params.fftsize_1D,...
        1,...
        params.numRX, ...
        params.numTX);
end

end