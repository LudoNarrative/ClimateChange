
color(red;orange;yellow;green;blue;purple;pink;brown).
luminance(white;gray;black).

better_color(C,gray) 
    :- color(C).

better_color(C,black) 
    :- color(C).

better_color(green,red).
    
opposed_color(red,green).
%Color
opposed_color(blue,yellow).
opposed_color(white,black).

opposed_color(C,O) :- opposed_color(O,C).

connotation(red,warm).
connotation(orange,warm).
connotation(yellow,warm).

connotation(green,cool).
connotation(blue,cool).
connotation(purple,cool).

connotation(green,natural).
connotation(brown,natural).

connotation(gray,manmade).
connotation(black,manmade).
connotation(white,manmade).

connotation(red,stop).
connotation(green,go).

connotation(black,evil).
connotation(white,good).

connotation(red,danger).
connotation(orange,danger).
connotation(yellow,danger).
connotation(black,danger).

bright(white;red;yellow;green;pink).
dark(gray;black;blue;purple;brown).


%Other concepts
better_than(good,evil).
better_than(natural,manmade).
