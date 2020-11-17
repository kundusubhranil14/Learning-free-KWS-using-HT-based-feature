my_image = imread('C:\Users\Subhranil\Dropbox\Summer 2019\WordSearching\Papers\Self\BW_37.jpg');
my_image = 255 - my_image;
imwrite(my_image,'C:\Users\Subhranil\Dropbox\Summer 2019\WordSearching\Papers\Self\BWRect_37.jpg','JPG');