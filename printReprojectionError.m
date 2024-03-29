function error=printReprojectionError(graph)
nCam=length(graph.frames);
Mot = zeros(3,2,nCam);
for camera=1:nCam
    Mot(:,1,camera) = RotationMatrix2AngleAxis(graph.Mot(:,1:3,camera));
    Mot(:,2,camera) = graph.Mot(:,4,camera);
end



Str = graph.Str;
f  = graph.f;


% assume px, py=0
px = 0;
py = 0;



residuals = reprojectionResidual(graph.ObsIdx,graph.ObsVal,px,py,f,Mot,Str);
error=2*sqrt(sum(residuals.^2)/length(residuals));
fprintf('reprojection error = %f\n',error)
end