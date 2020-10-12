function visualizeReprojection(graph,frames)
nCam=length(graph.frames);
Mot = zeros(3,2,nCam);
for camera=1:nCam
    Mot(:,1,camera) = RotationMatrix2AngleAxis(graph.Mot(:,1:3,camera));
    Mot(:,2,camera) = graph.Mot(:,4,camera);
end
Str = graph.Str;
f  = graph.f;
s=frames.imsize;


% assume px, py=0
px = 0;
py = 0;

ObsIdx=graph.ObsIdx;
ObsVal=graph.ObsVal;

Mot = reshape(Mot,3,2,[]);
Str = reshape(Str,3,[]);

for c=1:nCam
    validPts = ObsIdx(c,:)~=0;
    validIdx = ObsIdx(c,validPts);
    nonvalidIdx = [];
    for i=1:size(ObsVal,2)
        if ismember(i,validIdx)==false
            nonvalidIdx=[nonvalidIdx,i];
        end
    end
    RP = AngleAxisRotatePts(Mot(:,1,c), Str(:,validPts));
    
    TRX = RP(1,:) + Mot(1,2,c);
    TRY = RP(2,:) + Mot(2,2,c);
    TRZ = RP(3,:) + Mot(3,2,c);
    
    TRXoZ = TRX./TRZ;
    TRYoZ = TRY./TRZ;
    
    x = -(f*TRXoZ + px)+s(2)/2;
    y = -(f*TRYoZ + py)+s(1)/2;
    ox = -ObsVal(1,validIdx)+s(2)/2;
    oy = -ObsVal(2,validIdx)+s(1)/2;
    im=imread(frames.images{graph.frames(c)});
    figure;
    imshow(im);
    %image(im)
    hold on;
    scatter(x,y,15,'g','+');
    hold on;
    scatter(ox,oy,15,'r','x');
    for i=1:size(x,2)
        hold on;
        plot([x(1,i),ox(1,i)],[y(1,i),oy(1,i)],'Color','blue')
        hold on;
    end
    ox = -ObsVal(1,nonvalidIdx)+s(2)/2;
    oy = -ObsVal(2,nonvalidIdx)+s(1)/2;
    hold on;
    scatter(ox,oy,6,'y','o'); 
    %print(gcf,strcat('im/test1',num2str(c),'.png'),'-dpng','-r400');  
end