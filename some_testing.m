
N = 1000;
pCon = 0.2;
test_n = build_exponential(N, pCon);
test_G = graph(test_n);
mean(degree(test_G))

m = mean(degree(test_G))/(2 - (0.9*pCon));

if m > 1
    m = round(m);
end
%n0 = ceil(m);
n0 = 4;
test_n2 = build_scaleFree(N, n0,m);
test_G2 = graph(test_n2);
mean(degree(test_G2))
