function graph = bundleAdjustment_(graph, adjustFocalLength)

% convert from Rt matrix to AngleAxis
nCam=length(graph.frames);
Mot = zeros(3,2,nCam);
for camera=1:nCam
    Mot(:,1,camera) = RotationMatrix2AngleAxis(graph.Mot(:,1:3,camera));
    Mot(:,2,camera) = graph.Mot(:,4,camera);
end



Str = graph.Str;
f  = graph.f;


px = graph.px;
py = graph.py;




% bundle adjustment using lsqnonlin in Matlab (Levenberg-Marquardt)
options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','off');


[vec,resnorm,residuals,exitflag] = lsqnonlin(@(x) reprojectionResidual(graph.ObsIdx,graph.ObsVal,x), [px;py;skew;f;Mot(:);Str(:)],[],[],options);
[px,py,skew,f,Mot,Str] = unpack(nCam,vec);
fprintf('error = %f\n', 2*sqrt(resnorm/length(residuals)));





for camera=1:nCam
    graph.Mot(:,:,camera) = [AngleAxis2RotationMatrix(Mot(:,1,camera))  Mot(:,2,camera)];    
end
graph.Str = Str;
graph.f=f;
graph.px=px;
graph.py=py;
graph.skew=skew;

