clearvars
clc

file = 'Y:\Margaret Habib\Geitlerinema\Patterned light experiments\20240409_MMH_Geit.nd2';

reader = BioformatsImage(file);

%%
vid = VideoWriter('20240409_MMH_Geit.avi');
vid.FrameRate = 7.5;
open(vid)

for iT = 1:reader.sizeT

    bf_image = getPlane(reader, 1, 2, iT);

    fluorescent_image = double(getPlane(reader, 1, 1, iT));
    fluorescent_image = (fluorescent_image - min(fluorescent_image(:)))/(max(fluorescent_image(:)) - min(fluorescent_image(:)));

    %Try and threshold to get illuminated region
    mask_dark = ~(bf_image < 10000);
    mask_dark_perim = imdilate(bwperim(mask_dark), strel('disk', 3));

    Iout = showoverlay(fluorescent_image, mask_dark_perim, 'color', [1 0 0]);

    writeVideo(vid, Iout);

end

close(vid)