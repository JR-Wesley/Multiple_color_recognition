//腐蚀运算
void erosion(unsigned char* data, int width, int height)	//data : 0 or 1 	height:192	width:128	
{
    int i, j, index, sum, flag; 		//flag:3*3 matrix all one=>1	exist 0=>0		sum:total size of the picture
    sum = height * width * sizeof(unsigned char);
    unsigned char *tmpdata = (unsigned char*)malloc(sum);
    memcpy((int*)tmpdata, (int*)data, sum);	//copy data to tmpdata
    for(i = 1;i < height - 1;i++)
    {
        for(j = 1;j < width - 1;j++)	//scan by looping
        {
            flag = 1;
            for(int m = i - 1;m < i + 2;m++)
            {
                for(int n = j - 1; n < j + 2;n++)
                {
                    //自身及领域中若有一个为0
                    //则将该点设为0
                    if(tmpdata[i * width + j] == 0
                        || tmpdata[m * width + n] == 0)
                    {
                        flag = 0;
                        break;
                    }
                }
                if(flag == 0)
                {
                    break;
                }
            }
            if(flag == 0)
            {
                data[i * width + j] = 0;
            }
            else
            {
                data[i * width + j] = 1;
            }
        }
    }
    free(tmpdata);
}

//膨胀运算
void dilation(unsigned char* data, int width, int height)
{
    int i, j, index, sum, flag;
    sum = height * width * sizeof(unsigned char);
    unsigned char *tmpdata = (unsigned char*)malloc(sum);
    memcpy((char*)tmpdata, (char*)data, sum);
    for(i = 1;i < height - 1;i++)
    {
        for(j = 1;j < width - 1;j++)
        {
            flag = 1;
            for(int m = i - 1;m < i + 2;m++)
            {
                for(int n = j - 1; n < j + 2;n++)
                {
                    //自身及领域中若有一个为1
                    //则将该点设为1
                    if(tmpdata[i * width + j] == 1
                        || tmpdata[m * width + n] == 1)
                    {
                        flag = 0;
                        break;
                    }
                }
                if(flag == 0)
                {
                    break;
                }
            }
            if(flag == 0)
            {
                data[i * width + j] = 1;
            }
            else
            {
                data[i * width + j] = 0;
            }
        }
    }
    free(tmpdata);
}