#!/bin/sh

cd public;
for f in videos/*.mp4; 
do 
    name=`basename $f`
    echo {
    echo     url: \'/$f\',
    echo     cover: \'http://oss.jishiyoo.com/images/file-1575341210559.png\',//封面
    echo     tag_image: \'http://npjy.oss-cn-beijing.aliyuncs.com/images/file-1575449277018pF3XL.jpg\',//作者头像
    echo     fabulous: false,//是否赞过
    echo     tagFollow: false,//是否关注过该作者
    echo     author_id: 1,//作者ID
    echo     author: \'superKM\',
    echo     des: \'$name\'
    echo },
done

