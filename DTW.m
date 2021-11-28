function totalDistance = DTW(input_signal,template_signal)
% dynamic time warping between input and template signal

% Check signal size

signalSize=size(input_signal,1);
templateSize=size(template_signal,1);
if signalSize > 2*templateSize || templateSize > 2*signalSize
    error(' [!] The length difference between the signals is very large.');
end

% Distance Vectors Array Initialization

distances=zeros(signalSize,templateSize)+Inf;

distances(1,1)=norm(input_signal(1,:)-template_signal(1,:));

%initialize the first row.
for j = 2:templateSize
    cost = norm(input_signal(1,:)-template_signal(j,:));
    distances(1,j) = distances(1,j-1) + cost;
end

%initialize the first column.
for i = 2:signalSize
    cost = norm(input_signal(i,:)-template_signal(1,:));
    distances(i,1) = cost+ distances(i-1,1);
end

%initialize the second row.
for j = 2:templateSize
    cost = norm(input_signal(2,:)-template_signal(j,:));
     distances(2,j)=cost+min( [distances(2,j-1), distances(1,j-1)] );
end

% Dynamic Time Warping
for i=3:signalSize
    for j=2:templateSize
        cost=norm(input_signal(i,:)-template_signal(j,:));
         distances(i,j)=cost+min( [distances(i,j-1), distances(i-1,j-1), distances(i-2,j-1)] );
    end
end
totalDistance=distances(signalSize,templateSize);
end
