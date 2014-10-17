function Deformator_PIL(dire2)

% Wrapper around Tatsuya Arai's 
%   Projective deformation code
% 
% USAGE
%   Deformator_PIL
% 
% Optional inputs
%   directory where you want to work/save
% 
% Outputs
%   none to the working environment
%   File saved with the selected File name
%
% Variables saved 
%   IM_def - registered images
%   IM_unreg - original images
% 
%   imageq - good/bad image (0 good, 1 bad)
%   breathold - good/bad breathold (0 good, 1 bad)
%   Area_change - Jacobian of the local transformation/ area change
%   notes - notes 
%   out - image # selected as reference
%   refIM - reference image
%   referenceROI - reference ROI
%   dire2 - directory of loaded data
%   Ig8 - Projective transformation
%
% Rui Carlos S�. Projective transformation and GUI's by Tatsuya Arai
% March 2014
% v1.0

close all

% -1 - Select UI File Name -> Saving
'Select save file name'
[saveFilename,path2save]=uiputfile('*.mat', 'Select save file name');

% 0 - Load all Files

% If no subject directory included, select it now
if (nargin == 0),
    % Select folder where data is stored
    dire0=pwd;
    'Select folder containing data to be registered'
    dire2=uigetdir(dire0,'Select folder containing DICOM data to be registered');
end

dire2

%Load all dicom images in 
[IM_unreg]=LoadAllDicomFiles(dire2);

prompt={'Subject initials:','Notes:'};
name='Input subject info';
defaultanswer={'subject Initials','Notes'};
answer=inputdlg(prompt,name,2,defaultanswer);
c_initial=char(answer(1));
c_note=char(answer(2));

master=[c_initial ' ' c_note];
clear c_initial c_note
notes=master;
%  
cd(dire2) 
cd ..

% Pick reference image 
SelectReference(IM_unreg);
'press any key when ready'
pause
load('SelectedRefIm')

refIM=IM_unreg(:,:,out);
eval(['! rm SelectedRefIm.mat'])

% Plot reference image
imshow(refIM,[0 0.3*(max(max(refIM)))])
colormap('jet');

% Draw ROI
[referenceROI,x_roi,y_roi]=roipoly;
close

% Save all data
cd(path2save)
save(saveFilename)

%keyboard
% Projective deformation 
Projective_deformation_GUI_Vol3(x_roi,y_roi,IM_unreg,[],saveFilename);