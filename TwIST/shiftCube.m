function shiftedcube = shiftCube(unshiftedcube)

shiftedcube = zeros(size(unshiftedcube));

for i = size(unshiftedcube,3):-1:1
    shiftedcube(:,:,i) = circshift(unshiftedcube(:,:,i),[0 i]);
end