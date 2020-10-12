function a=mergeGraphs(Graph,frames)
lis=[];
for i=1:size(Graph,2)
    lis=[lis,[i;size(Graph{1,i}.matches,2)]];
end

[temp, order] = sort(lis(2,:),'descend');
lis=lis(:,order);
a=Graph{lis(1,1)};
for i=2:size(Graph,2)
    a=merge2graphs(a,Graph{lis(1,i)});
    a=triangulate(a,frames);
    a=bundleAdjustment(a);
    
    % outlier rejection
    a=removeOutlierPts(a,10);
    
    % bundle adjustment
    a=bundleAdjustment(a); 
end
