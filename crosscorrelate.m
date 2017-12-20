function signal = crosscorrelate(Input1,Input2)
    l1 = length(Input1);
    l2 = length(Input2);
    l = abs(l1-l2);
    if l1>l2
        Input2 = [Input2 zeros(l,1)];
    elseif l2>l
        Input1 = [Input1 zeros(l,1)];
    end
    Input1 = [Input1 zeros(max(l1,l2),1)];
    for i=0:max(l1,l2)
        nx = [zeros(i,1)' Input2' (zeros(max(l1,l2),1)-i)']';
        Output(i+1,:) = sum(Input1.*nx');
    end
    signal = transpose(Output);
end