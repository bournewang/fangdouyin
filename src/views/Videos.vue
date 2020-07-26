<template>
    <!--vant van-swipe 滑动组件 -->
    <van-swipe :show-indicators="false" @change="onChange" vertical :loop="false">
        <van-swipe-item v-for="(item, index) in videoList" :key="index" class="product_swiper">
            <div class="video_container">
                <!--video属性
            webkit-playsinline ios 小窗播放，使视频不脱离文本流，安卓则无效
            微信内置x5内核，
            x5-video-player-type="h5-page" 启用H5播放器,是wechat安卓版特性，添加此属性，微信浏览器会自动将视频置为全屏
            x5-video-player-fullscreen="true" 全屏设置，设置为 true 是防止横屏
            x5-video-orientation 控制横竖屏 landscape 横屏，portrain竖屏； 默认portrain
            poster：封面
            src：播放地址
            -->
                <video class="video_box" loop webkit-playsinline="true" x5-video-player-type="h5-page"
                       x5-video-player-fullscreen="true" playsinline preload="auto"
                       :poster="item.cover" :src="item.url" :playOrPause="playOrPause"
                       @click="pauseVideo" @ended="onPlayerEnded($event)"
                >
                </video>
                <!-- 封面 -->
                <img v-show="isVideoShow" class="play" @click="playvideo" :src="item.cover"/>
                <!-- 播放暂停按钮 -->
                <img v-show="iconPlayShow" class="icon_play" @click="playvideo"
                     src="http://npjy.oss-cn-beijing.aliyuncs.com/images/file-1575340653940esdHR.png"/>
            </div>
            
            <!-- 底部作品描述 -->
            <div class="production_box">
                <div class="production_name">
                    @{{item.author}}
                </div>
                <div class="production_des">
                    {{item.des}}
                </div>
            </div>
            
            <toolbar :item="item" :index="index" :videoList="videoList" @showComments="showComments(item)"></toolbar>
        </van-swipe-item>
    </van-swipe>
</template>
<script>
    import Vue from "vue";
    import {
        Swipe,
        SwipeItem,
        Toast,
    } from 'vant';
    // 引入微信分享
    import wx from "weixin-js-sdk";
    import videos_data from "../static/videos.json";
    import Toolbar from './Toolbar';
    
    Vue.use(Swipe, Toast).use(SwipeItem);

    let videoProcessInterval;
    export default {
        name: 'video-panel',
        components: {'toolbar': Toolbar},
        data() {
            let u = navigator.userAgent;
            return {
                current: 0,
                videoList: [],
                isVideoShow: true,
                playOrPause: true,
                video: null,
                iconPlayShow: true,
                isAndroid: u.indexOf('Android') > -1 || u.indexOf('Adr') > -1, // android终端
                isiOS: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), // ios终端
                tabIndex: 0,
                showShareBox: false,//展示分享框
                // commentPop: false,//是否展示评论弹框
                // 评论相关
                // comment_text: '',//评论输入内容
                // canSend: false,//是否可以发送
                // videoComment: [],
                // commentPlaceholder: '留下你精彩的评论吧',//评论Placeholder
                // replayUserData: '',
                // to_comment_id: '',
                videoProcess: 0,//视频播放进度
            }
        },
        watch: {
            //监听输入变化
            // comment_text(newV, oldV) {
            //     newV == '' ? this.canSend = false : this.canSend = true
            // }
        },
        mounted() {
            try{
                this.videoList = videos_data
                wx.config({
                    debug: false,
                    appId: '111',
                    timestamp: '111',
                    nonceStr: '111',
                    signature: '111',
                    jsApiList: []
                })
            }catch (e) {
                console.log(e)
            }

            //获取到视频资源后默认自动播放
            setTimeout(() => {
                this.playvideo()
            }, 500)
        },
        methods: {
            showComments(item){
                this.$emit('showComments', item)
            },
            //滑动改变播放的视频
            onChange(index) {
                //改变的时候 暂停当前播放的视频
                clearInterval(videoProcessInterval)
                this.videoProcess = 0;
                let video = document.querySelectorAll('video')[this.current];
                video.pause();
                this.playOrPause = false;
                this.showShareBox = false;
                this.current = index;
                //非ios切换直接自动播放下一个
                if (!this.isiOS) {
                    this.isVideoShow = false;
                    setTimeout(() => {
                        this.pauseVideo()
                    }, 100)
                } else {
                    //ios官方禁止video自动播放，未找到合适的方法，如果您发现了，麻烦告诉我一下谢谢啦
                    this.playOrPause = true;
                    this.iconPlayShow = true;
                }


            },
            // 开始播放
            playvideo(event) {
                let video = document.querySelectorAll('video')[this.current];
                console.log("playvideo：" + this.current);
                this.isVideoShow = false;
                this.iconPlayShow = false;
                this.showShareBox = false;
                video.play();

                if (this.isiOS) {
                    setTimeout(() => {
                        //处理ios宽视频
                        let documentW = (document.documentElement.clientWidth || document.body.clientWidth);
                        let docB = parseFloat(video.videoWidth / documentW);
                        console.log("获取视频宽和屏幕比：" + docB)
                        // 计算视频最适高度
                        let realH = parseInt(video.videoHeight / docB);
                        this.realH = realH + 'px'
                        console.log("视频最适高度：" + this.realH)
                        this.$forceUpdate();
                    }, 200);
                }

                videoProcessInterval = setInterval(() => {
                    this.changeProcess(video)
                }, 100)
            },
            pauseVideo() { //暂停\播放
                try {
                    let video = document.querySelectorAll('video')[this.current];
                    console.log("pauseVideo" + this.current);
                    if (this.playOrPause) {
                        video.pause();
                        this.iconPlayShow = true;
                        clearInterval(videoProcessInterval)
                    } else {
                        // wx.ready(() => {
                        //     // 在微信的ready中进行播放 不管成功配置与否 都会执行ready
                        //     video.play();
                        // })
                        video.play();
                        video.pause();
                        setTimeout(() => {
                            video.play();
                            this.iconPlayShow = false;
                            videoProcessInterval = setInterval(() => {
                                this.changeProcess(video)
                            }, 100)
                        }, 100)
                    }
                    this.playOrPause = !this.playOrPause;
                    this.showShareBox = false;
                } catch (e) {
                    alert(e)
                }


            },
            //记录播放进度
            changeProcess() {
                let video = document.querySelectorAll('video')[this.current];
                let currentTime = video.currentTime.toFixed(1);
                let duration = video.duration.toFixed(1);
                this.videoProcess = parseInt((currentTime / duration).toFixed(2) * 100)
            },
            onPlayerEnded(player) { //视频结束
                this.isVideoShow = true
                this.current += this.current
            },
            
        }
    }
</script>
<style scoped>
    @import "../static/css/home.css";
    /*评论样式*/
    
    
</style>
