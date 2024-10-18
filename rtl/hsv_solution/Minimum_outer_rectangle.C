//scan 192*128 left_top=>0,0
//coordinate => int min_x , min_y , width of the rectangle , height of rectangle
//global variable => width=128  , height=192
int width=128,height=192;
min_outer_rectan(char* data,int* coordinate){
	int max_x=0,max_y=0,min_x=width-1,min_y=height-1;
	for(i=0;i<width*height;i++){
		if(data[i]==1){
			if(i/width<min_y) min_y=i/width;
			if(i/width>max_y) max_y=i/width;
			if(i%width<min_x) min_x=i%width;
			if(i%width>max_x) max_x=i%width;
		}
		else break;
	}
	coordinate[0]=min_x;
	coordinate[1]=min_y;
	coordinate[2]=max_x-min_x;
	coordinate[3]=max_y-min_y;
}

//left top coordinate : (max_)