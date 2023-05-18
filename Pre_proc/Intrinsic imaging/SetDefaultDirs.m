% SetDefaultDirs sets the default directories
% 
% 2013-09-24 Matteo Carandini
% 2013-10-10 AS: line 44 & 47, corrected the variable name
% 2016-05-12 AP: added alternate server names (cortexlab.net)
% 2016-05-19 AP: zserver2 doesn't exist anymore, old server name was taking
% a long time to check for existance so switched default/alternative
% server names
% 2016-08-08 LFR: changed all the pointers to zserver2 to zserver, where
% the data has been moved
% 2017-03-20 AP: changed LFRs pointer from .ioo to .cortexlab

% Did I screw up anything? If so, please see the older version at
% \\zserver.ioo.ucl.ac.uk\Code\Archive\Spikes\Spikes 2013-09-24
% and let me know... Thanks 
% Matteo

% At some point we may want to use IP addresses to determine if we are at
% Rockefeller or at Bath Street. If the former, we should probably use
% zcloneX instead of zserverX. A method to determine IP address is:
% address = java.net.InetAddress.getLocalHost 
% IPaddress = char(address.getHostAddress)

global DIRS serverName server2Name server3Name

if isunix 
%     serverName    = '/mnt/zserver';
    serverName    = '/mnt/zubjects';
%     server2Name   = '/mnt/zserver2'; 
    server2Name   = '/mnt/zserver';
    server3Name   = '/mnt/zserver3';
    
    DIRS.Temp      = '/tmp';
else   
        serverName     = '\\zaru.cortexlab.net';

%     serverName     = '\\128.40.224.65';
%         serverName     = '\\znas.cortexlab.net';

% %     server2Name    = '\\128.40.224.65\Subjects';  
    server2Name    = '\\zserver.cortexlab.net\Data'; 
    server3Name    = '\\zserver.cortexlab.net';
end
    
serverName_alt     = '\\zserver.cortexlab.net';
%     serverName_alt     = '\\zserver.ioo.ucl.ac.uk';
%     server2Name_alt    = '\\zserver2.ioo.ucl.ac.uk';
server2Name_alt    = '\\zserver.cortexlab.net';
server3Name_alt    = '\\zserver3.ioo.ucl.ac.uk';

if isdir('D:\Temp')
    DIRS.Temp       = 'D:\Temp';
else
    DIRS.Temp       = 'C:\Windows\Temp';
end


if ~isdir(fullfile(serverName,'Subjects'))
    if isdir(fullfile(serverName_alt,'Data'))
        serverName = serverName_alt;
    else
        fprintf('Make sure directory %s is accessible!\n',fullfile(serverName,'Data'));
    end
end
if ~isdir(fullfile(server2Name,'Data'))
    if isdir(fullfile(server2Name_alt,'Data'))
        server2Name = server2Name_alt;
    else
        fprintf('Make sure directory %s is accessible!\n',fullfile(server2Name,'Data'));
    end
end
% if ~isdir(fullfile(server3Name,'Data'))
%     if isdir(fullfile(server3Name_alt,'Data'))
%         server3Name = server3Name_alt;
%     else
%         fprintf('Make sure directory %s is accessible!\n',fullfile(server3Name,'Data'));
%     end
% end


DIRS.data           = fullfile(serverName,'Subjects');
DIRS.spikes         = fullfile(serverName,'Data','Spikes');
DIRS.camera         = fullfile(serverName,'Data','Intrinsic');
DIRS.Intrinsic      = fullfile(serverName,'Data','Intrinsic'); % Piperico changed to zserver
DIRS.EyeCamera      = fullfile(serverName,'Data','EyeCamera'); % Piperico changed to zserver 
DIRS.EyeTrack       = fullfile(serverName,'Data','EyeTrack');

DIRS.xfiles         = fullfile(serverName_alt,'Data','xfiles');

DIRS.michigan       = fullfile(serverName,'Data','michigan');
DIRS.Cerebus        = fullfile(serverName,'Data','Cerebus');
DIRS.stimInfo       = fullfile(serverName,'Data','stimInfo');
DIRS.behavior       = fullfile(serverName,'Data','behavior');
DIRS.mouselogs      = fullfile(serverName,'Data','logs','mouse','behavior');
DIRS.multichanspikes= fullfile(serverName,'Data','multichanspikes');
DIRS.ball           = fullfile(serverName,'Subjects');
DIRS.Stacks         = fullfile(server3Name,'Data','Stacks'); % Piperico changed to zserver3
DIRS.expInfo        = fullfile(serverName,'Data','expInfo');
DIRS.oldData        = fullfile(server2Name,'Data','trodes');