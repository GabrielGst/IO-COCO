function [ r ] = get_RMS_Spot_Size( args )
 
if ~exist('args', 'var')
    args = [];
end
 
% Initialize the OpticStudio connection
TheApplication = InitConnection();
if isempty(TheApplication)
    % failed to initialize a connection
    r = [];
else
    try
        r = BeginApplication(TheApplication, args);
        CleanupConnection(TheApplication);
    catch err
        CleanupConnection(TheApplication);
        rethrow(err);
    end
end
end
 
 
function [r] = BeginApplication(TheApplication, args)
 
import ZOSAPI.*;
 
    % Set up primary optical system
    TheSystem = TheApplication.CreateNewSystem(ZOSAPI.SystemType.Sequential);
    sampleDir = TheApplication.SamplesDir;
    
    %% changes allowed starting from here, do not change above

    % change file path 
    testFile =  'S:\Co-conception\TP2-2023\add-on-zemax.zmx';
    
    t=TheSystem.LoadFile(testFile, false);
    
    if t==1
        display('Loading of zemax file succeeded')

    else
        display('Error while loading zemax file - please check the file name and path')
    end

    % Get a pointer to first and last surface of the system

    TheLDE = TheSystem.LDE;
    Surf_0 = TheLDE.GetSurfaceAt(0);
    Surf_2 = TheLDE.GetSurfaceAt(2);   

    % Spot Diagram Analysis Results
    spot = TheSystem.Analyses.New_Analysis(ZOSAPI.Analysis.AnalysisIDM.StandardSpot);
    spot_setting = spot.GetSettings();
    spot_setting.Field.SetFieldNumber(0);

     % Value of the radius of curvature
     Surf_2.Radius=25;

    % focus of the green channel at a given depth
    spot_setting.Wavelength.SetWavelengthNumber(2);
    Surf_0.Thickness = 2000;
    QuickFocus = TheSystem.Tools.OpenQuickFocus();
    QuickFocus.RunAndWaitForCompletion();
    QuickFocus.Close(); 

    % change here the value of the wavelength either 1,2 or 3 (0 is for
    % panchromatic analysis)

    spot_setting.Wavelength.SetWavelengthNumber(1);
    spot_setting.ReferTo = ZOSAPI.Analysis.Settings.Spot.Reference.Centroid;
  
    % extract RMS spot size for field point
    spot.ApplyAndWaitForCompletion();
    spot_results = spot.GetResults();
    fprintf('RMS radius: %6.3f  \n',spot_results.SpotData.GetRMSSpotSizeFor(1,1))
  
 
    r = [];

    %%  do not change below
end
 
function app = InitConnection()
 
import System.Reflection.*;
 
% Find the installed version of OpticStudio.
zemaxData = winqueryreg('HKEY_CURRENT_USER', 'Software\Zemax', 'ZemaxRoot');
NetHelper = strcat(zemaxData, '\ZOS-API\Libraries\ZOSAPI_NetHelper.dll');
% Note -- uncomment the following line to use a custom NetHelper path
% NetHelper = 'C:\Users\Documents\Zemax\ZOS-API\Libraries\ZOSAPI_NetHelper.dll';
NET.addAssembly(NetHelper);
 
success = ZOSAPI_NetHelper.ZOSAPI_Initializer.Initialize();
% Note -- uncomment the following line to use a custom initialization path
success = ZOSAPI_NetHelper.ZOSAPI_Initializer.Initialize('C:\Program Files\Ansys Zemax OpticStudio 2023 R1.03\');
if success == 1
    LogMessage(strcat('Found OpticStudio at: ', char(ZOSAPI_NetHelper.ZOSAPI_Initializer.GetZemaxDirectory())));
else
    app = [];
    return;
end
 
% Now load the ZOS-API assemblies
NET.addAssembly(AssemblyName('ZOSAPI_Interfaces'));
NET.addAssembly(AssemblyName('ZOSAPI'));
 
% Create the initial connection class
TheConnection = ZOSAPI.ZOSAPI_Connection();
 
% Attempt to create a Standalone connection
 
% NOTE - if this fails with a message like 'Unable to load one or more of
% the requested types', it is usually caused by try to connect to a 32-bit
% version of OpticStudio from a 64-bit version of MATLAB (or vice-versa).
% This is an issue with how MATLAB interfaces with .NET, and the only
% current workaround is to use 32- or 64-bit versions of both applications.
app = TheConnection.CreateNewApplication();
if isempty(app)
   HandleError('An unknown connection error occurred!');
end
if ~app.IsValidLicenseForAPI
    HandleError('License check failed!');
    app = [];
end
 
end
 
function LogMessage(msg)
disp(msg);
end
 
function HandleError(error)
ME = MXException(error);
throw(ME);
end
 
function  CleanupConnection(TheApplication)
% Note - this will close down the connection.
 
% If you want to keep the application open, you should skip this step
% and store the instance somewhere instead.
TheApplication.CloseApplication();
end
 
 
