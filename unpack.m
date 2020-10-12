function [px,py,f,Mot,Str] = unpack(nCam,vec)
cut = 3+3*2*nCam;
px  = vec(1);
py  = vec(2);
f   = vec(3);
Mot = reshape(vec(4:cut),3,2,[]);
Str = reshape(vec(cut+1:end),3,[]);
end