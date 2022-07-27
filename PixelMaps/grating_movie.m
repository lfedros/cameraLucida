
dur         = 20/10; % s, duration
tfreq	 	= 5/10;              % Hz
sfreq  		= 5/100;             % cpd
tempphase  	= 0 * (pi/180);      % radians
spatphase  	= 0 * (pi/180);      % radians
orientation 	= 0:30:330;                 % deg
angle        = 0;                %deg 

diam = 50;

CtrCol = 100;
CtrRow = 100;

cc 	= 100/100;         % between 0 and 1
mm 	= 50/100;     % between 0 and 1        

FrameRate =10; % fps

psi = 1; %sec
isi = 1; %sec

nFrames = ceil(FrameRate*dur );
nFrames_psi = ceil(FrameRate*psi );
nFrames_isi = ceil(FrameRate*isi );

%% Make the stimulus

mov = ones(nx, ny,(nFrames+nFrames_psi+nFrames_isi)*numel(orientation))*255*mm;


for iOri = 1:numel(orientation)

Orientations = repmat(orientation(iOri),[1, nFrames]);
Amplitudes = ones(1,SS.nFrames)/2; 


% CyclesPerPix = 1/myScreenInfo.Deg2Pix(1/sfreq); % sf in cycles/pix
CyclesPerPix = sfreq; % sf in cycles/pix

% Make a grid of x and y
nx = diam;
ny = diam; % if you were willing to do without the window this could be one!

[xx,yy] = meshgrid(1-nx/2:nx/2,1-ny/2:ny/2);
    
% Image of the spatial phase of the stimulus (in radians)
AngFreqs = -2*pi* CyclesPerPix * xx *cos(orientation(iOri)*pi/180) -2*pi* CyclesPerPix * yy *sin(orientation(iOri)*pi/180)+ spatphase;
    
WindowImage = double( sqrt(xx.^2+yy.^2)<=diam/2 );
 
nImages = round(FrameRate / tfreq);

% The temporal phase of the response
TemporalPhase = 2*pi*(0:(nImages-1))/nImages + tempphase;
    
    
ImageTextures = zeros(nx, ny, nImages);
for iImage = 1:nImages
    ContrastImage = sin(AngFreqs + TemporalPhase(iImage));

    ImageTextures(:,:,iImage) = ...
            uint8(255*mm*(1+cc*ContrastImage.*WindowImage));
        

end

ImageTextures =repmat(ImageTextures, [1,1,nFrames/nImages]);

these_frames = (nFrames_psi+1):nFrames+nFrames_psi;
these_frames = these_frames + (iOri-1)*(nFrames+nFrames_psi+nFrames_isi);
mov(:, :, these_frames) =  ImageTextures;

end

saveastiff(uint8(mov), 'C:\Users\Federico\Documents\GitHub\cameraLucida\PixelMaps\12gratings.tiff')



