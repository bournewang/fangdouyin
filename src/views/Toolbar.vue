<template>
    <div>
        <!-- 右侧头像、点赞、评论、分享功能 -->
        <div class="tools_right"> 
            <div class="tools_r_li">
                <img :src="item.tag_image" class="tag_image" @click="checkSubscribe(item,index)">
                <i :class="'iconfont ' + (item.tagFollow ? 'icon-duihao tag_dui' : 'icon-jiahao tag_add') "></i>
            </div>
            <div class="tools_r_li" @click="changeFabulous(item,index)">
                <i class="iconfont icon-shoucang icon_right"
                   :class="item.fabulous?'fabulous_active':''"></i>
                <div class="tools_r_num">52.1w</div>
            </div>
            <div class="tools_r_li" @click="changeComment">
                <i class="iconfont icon-liuyan icon_right icon_right_change"></i>
                <div class="tools_r_num">12.5w</div>
            </div>
            <!-- <div class="tools_r_li" @click="changeShare">
                <i class="iconfont icon-iconfontforward icon_right"></i>
                <div class="tools_r_num">22.2w</div>
            </div> -->
        </div>
        <!--分享弹框-->
        <!-- <div class="share_box share_active" v-if="showShareBox">
            <div class="share_tips">分享到</div>
            <ul class="share_ul">
                <li class="share_li pengyouquan_li">
                    <i class="iconfont icon-pengyouquan pengyouquan"></i>
                </li>
                <li class="share_li">
                    <i class="iconfont icon-weixin weixin"></i>
                </li>
                <li class="share_li" @click="copyUrl">
                    <i class="iconfont icon-lianjie lianjie"></i>
                </li>
                <div class="clear"></div>
            </ul>
            <div class="share_cancel" @click="cancelShare">取消</div>
        </div> -->
        
        <!--留言输入-->
        <div class="comment_input_box_hover"></div>
        <div class="comment_input_box" v-show="commentPop">
            <!--<form action="#" class="comment_form">-->
            <input :placeholder="commentPlaceholder" class="comment_input" v-model="comment_text" ref="content"
                   @keyup.enter="checkComment"/>
            <!--</form>-->
            <div class="comment_input_right" @click="checkComment">
                <i class="iconfont icon-fasong comment_i" :class="canSend?'comment_i_active':''"></i>
            </div>
        </div>
    </div>
</template>

<script>
    import Vue from "vue";
    import {
        Toast,
    } from 'vant';

    export default {
        name: 'toolbar',
        props: {
            item: {},
            index: null
            // ,
            // videoList: []
        },
        // components: {'video-panel': VideoPanel},
        data() {
            let u = navigator.userAgent;
            return {
                showShareBox: false,//展示分享框
                commentPop: true,//是否展示评论弹框
                // 评论相关
                comment_text: '',//评论输入内容
                canSend: false,//是否可以发送
                videoComment: [{
                    "comment_id": 297,
                    "p_id": 0,
                    "comment_content": "你好，我叫蓝湛",
                    "love_count": 0,
                    "create_time": "1月前",
                    "user_id": 78634,
                    "nickname": "蓝忘机\uD83C\uDF1F",
                    "avatar": "http://npjy.oss-cn-beijing.aliyuncs.com/images/file-1575449277018pF3XL.jpg",
                    "be_commented_user_id": 0,
                    "be_commented_nickname": "",
                    "be_commented_avatar": "",
                    "child_comment": [{
                        "comment_id": 298,
                        "p_id": 296,
                        "comment_content": "蓝二公子，今天天气不错",
                        "love_count": 1,
                        "create_time": "7天前",
                        "user_id": 55163,
                        "nickname": "魏婴",
                        "avatar": "http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKPJb1k8zia02PjVibdaDJ83JIDGm0hIsY34kAlXyZMT6FMBibdw6rhdPPjpxtp6d8B75x5Kpicxp2gqw/132",
                        "be_commented_user_id": 78480,
                        "be_commented_nickname": "chenchen",
                        "be_commented_avatar": "http://thirdwx.qlogo.cn/mmopen/vi_32/icxHc0Ym1p4hQAFAUnjpxDPMkEUyojnibBj9wUSS2OmibiazdBAicSLpoicricVYP6QG6XicjTzQPx9koMPqcGfhTOy5qA/132",
                        "love_comment": true
                    },],
                    "love_comment": false
                }, {
                    "comment_id": 281,
                    "p_id": 0,
                    "comment_content": "楼主好帅，我要嫁给你！！",
                    "love_count": 0,
                    "create_time": "1月前",
                    "user_id": 74164,
                    "nickname": "冰雪奇缘2",
                    "avatar": "http://npjy.oss-cn-beijing.aliyuncs.com/images/file-1575449298299M3V50.jpg",
                    "be_commented_user_id": 0,
                    "be_commented_nickname": "",
                    "be_commented_avatar": "",
                    "child_comment": [],
                    "love_comment": false
                }],
                commentPlaceholder: '留下你精彩的评论吧',//评论Placeholder
                replayUserData: '',
                to_comment_id: '',
                // videoProcess: 0,//视频播放进度
            }
        },
        watch: {
            //监听输入变化
            comment_text(newV, oldV) {
                newV == '' ? this.canSend = false : this.canSend = true
            }
        },
        mounted() {
            // this.changeComment()
        },
        methods: {
            //获取评论
            getComment() {
                //setTimeout模拟Ajax请求
                setTimeout(() => {
                    let data = [{
                        "comment_id": 297,
                        "p_id": 0,
                        "comment_content": "你好，我叫蓝湛",
                        "love_count": 0,
                        "create_time": "1月前",
                        "user_id": 78634,
                        "nickname": "蓝忘机\uD83C\uDF1F",
                        "avatar": "http://npjy.oss-cn-beijing.aliyuncs.com/images/file-1575449277018pF3XL.jpg",
                        "be_commented_user_id": 0,
                        "be_commented_nickname": "",
                        "be_commented_avatar": "",
                        "child_comment": [{
                            "comment_id": 298,
                            "p_id": 296,
                            "comment_content": "蓝二公子，今天天气不错",
                            "love_count": 1,
                            "create_time": "7天前",
                            "user_id": 55163,
                            "nickname": "魏婴",
                            "avatar": "http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKPJb1k8zia02PjVibdaDJ83JIDGm0hIsY34kAlXyZMT6FMBibdw6rhdPPjpxtp6d8B75x5Kpicxp2gqw/132",
                            "be_commented_user_id": 78480,
                            "be_commented_nickname": "chenchen",
                            "be_commented_avatar": "http://thirdwx.qlogo.cn/mmopen/vi_32/icxHc0Ym1p4hQAFAUnjpxDPMkEUyojnibBj9wUSS2OmibiazdBAicSLpoicricVYP6QG6XicjTzQPx9koMPqcGfhTOy5qA/132",
                            "love_comment": true
                        },],
                        "love_comment": false
                    }, {
                        "comment_id": 281,
                        "p_id": 0,
                        "comment_content": "楼主好帅，我要嫁给你！！",
                        "love_count": 0,
                        "create_time": "1月前",
                        "user_id": 74164,
                        "nickname": "冰雪奇缘2",
                        "avatar": "http://npjy.oss-cn-beijing.aliyuncs.com/images/file-1575449298299M3V50.jpg",
                        "be_commented_user_id": 0,
                        "be_commented_nickname": "",
                        "be_commented_avatar": "",
                        "child_comment": [],
                        "love_comment": false
                    }];//获取评论数据
                    this.videoComment = data;//[...this.videoComment, ...data];
                    let to_comment_id = this.to_comment_id;
                    if (to_comment_id != 0) {
                        //从评论列表进来回复
                        this.getCommentDetail(to_comment_id);
                    }
                }, 500)
            },
            //获取单个评论
            getCommentDetail(to_comment_id) {
                let obj = {
                    action: 'show_comment_info',
                    comment_id: to_comment_id
                };
                setTimeout(() => {
                    let index;
                    let item = res.data;
                    this.videoComment.map((v, i) => {
                        v.child_comment.map((v2, i2) => {
                            if (v2.comment_id == to_comment_id) {
                                index = i;
                            }
                        });
                    });
                    setTimeout(() => {
                        //对评论重新排序，存在to_comment_id的时候排至第一个
                        let firstComment = this.videoComment.splice(index, 1);
                        this.videoComment.unshift(firstComment[0]);
                        //重设回复人
                        item.index = 0;
                        item.index2 = 0;
                        this.replayUserData = item;
                        this.commentPlaceholder = `回复 @${item.nickname}：`;
                        this.$refs.content.focus();
                    }, 10)
                }, 500)
            },
            //检测评论内容
            checkComment() {
                if (this.comment_text == '') {
                    Toast('评论内容不能为空')
                } else {
                    let comment_id = 0, p_id = '', p_user_id = '', content = this.comment_text;
                    if (this.replayUserData != '') {
                        comment_id = this.replayUserData.comment_id;
                        p_id = this.replayUserData.p_id;
                        p_user_id = this.replayUserData.user_id;
                    }
                    this.sendComment(comment_id, p_id, p_user_id, content)
                }
            },
            //发送评论
            sendComment(comment_id, p_id, p_user_id, content) {
                this.comment_text = '';
                this.isSending = true;
                setTimeout(() => {
                    let newData = {
                        "comment_id": comment_id,
                        "p_id": p_id,
                        "comment_content": content,
                        "love_count": 0,
                        "create_time": "刚刚",
                        "user_id": p_user_id,
                        "nickname": "游客",//当前用户
                        "avatar": 'https://profile.csdnimg.cn/B/1/E/3_ridingfish',//当前用户头像
                        "be_commented_user_id": this.replayUserData.user_id,
                        "be_commented_nickname": this.replayUserData.nickname,
                    }
                    if (this.replayUserData == '') {
                        //回复作品
                        this.videoComment.splice(0, 0, newData)
                    } else {
                        let index = this.replayUserData.index;
                        let index2 = this.replayUserData.index2;
                        if (this.replayUserData.index2 == -1) {
                            //回复一级人
                            this.videoComment[index].child_comment.splice(0, 0, newData)
                        } else {
                            //回复二级人
                            this.videoComment[index].child_comment.splice(index2, 0, newData)
                        }
                    }
                    this.replayUserData = '';
                    this.isSending = false;
                }, 500)
            },
            //评论点赞
            commentLove(item, index, index2) {
                let comment_id = item.comment_id,
                    user_id = item.user_id,
                    love_comment = item.love_comment,
                    love_flag = 0;//0:取消点赞；1：点赞
                if (love_comment) {
                    //取消点赞
                    love_flag = 0
                } else {
                    //添加点赞
                    love_flag = 1
                }
                //setTimeout模拟Ajax请求
                setTimeout(() => {
                    if (index2 == -1) {
                        //点赞一级评论
                        this.videoComment[index].love_comment = !this.videoComment[index].love_comment;
                        if (love_flag == 1) {
                            this.videoComment[index].love_count++
                        } else {
                            this.videoComment[index].love_count--
                        }
                    } else {
                        //点赞二级评论
                        this.videoComment[index].child_comment[index2].love_comment = !this.videoComment[index].child_comment[index2].love_comment
                        if (love_flag == 1) {
                            this.videoComment[index].child_comment[index2].love_count++
                        } else {
                            this.videoComment[index].child_comment[index2].love_count--
                        }
                    }
                }, 500)
            },
            //点击回复
            replayUser(item, index, index2) {
                item.index = index;
                item.index2 = index2;
                this.replayUserData = item;
                this.commentPlaceholder = `回复 @${item.nickname}：`;
                this.$refs.content.focus();
            },
            //弹出评论窗口
            changeComment() {
                // this.commentPop = true;
                // this.videoComment = [];
                // this.getComment()
                this.$emit('showComments', this.item)
            },
            //关闭评论弹窗
            closeComment() {
                this.commentPop = false;
                this.commentPlaceholder = '留下你精彩的评论吧';
                this.replayUserData = '';
            },
            //关注该作者
            checkSubscribe(item, index) {
                // this.videoList.map(v => {
                //     v.author_id == item.author_id ? v.tagFollow = true : '';
                // })
                item.tagFollow = !item.tagFollow
            },
            //改变菜单
            // changeTab(index) {
            //     this.tabIndex = index
            // },
            //改变收藏状态
            changeFabulous(item, index) {
                // this.videoList[index].fabulous = !this.videoList[index].fabulous
                item.fabulous = !item.fabulous
            },
            //展示分享弹窗
            changeShare() {
                this.showShareBox = true
            },
            //取消分享
            cancelShare() {
                this.showShareBox = false
            },
            //复制当前链接
            copyUrl() {
                let httpUrl = window.location.href;
                var oInput = document.createElement('input');
                oInput.value = httpUrl;
                document.body.appendChild(oInput);
                oInput.select(); // 选择对象
                document.execCommand("Copy"); // 执行浏览器复制命令
                oInput.className = 'oInput';
                oInput.style.display = 'none';
                alert("链接复制成功")
            }
        }
    }
</script>
<style scoped>
    @import "../static/css/home.css";
    /*评论样式*/
</style>