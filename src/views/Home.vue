<template>
    <div class="container_box" id="video_box">
        <div class="van_swipe">
            <!--vant van-swipe 滑动组件 -->
            <videos @showComments="showComments"> </videos>
            <!--底部操作栏-->
            <div class="container_bottom">
                <!-- <div class="border_progress" :style="'width:'+videoProcess+'%'"></div> -->
                <div class="bottom_tab" :class="tabIndex==0?'tab_active':''" @click="changeTab(0)">
                    <span class="bottom_tab_span ">首页</span>
                </div>
                <div class="bottom_tab" :class="tabIndex==1?'tab_active':''" @click="changeTab(1)">
                    <img src="http://oss.jishiyoo.com/images/file-1575427746903.png" alt="" class="bottom_tab_icon">
                </div>
                <div class="bottom_tab" :class="tabIndex==2?'tab_active':''" @click="changeTab(2)">
                    <span class="bottom_tab_span">我的</span>
                </div>
            </div>
            
            <!-- 评论 -->
            <comments :item="comment_item"></comments>
        </div>
    </div>
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
    import Videos from './Videos';
    import Comments from './Comments';
    import store from '../store';
    window.store = store;
    Vue.use(Swipe, Toast).use(SwipeItem);

    // let videoProcessInterval;
    export default {
        name: 'home',
        components: {'videos': Videos, 'comments': Comments},
        data() {
            let u = navigator.userAgent;
            return {
                current: 0,
                tabIndex: 0,
                comment_item: null,
                commentPop: false
            }
        },
        watch: {
            //监听输入变化
            comment_text(newV, oldV) {
                newV == '' ? this.canSend = false : this.canSend = true
            },
            commentPop(newVal, old) {
                // if (newVal) {
                console.log("home comment pop change: "+newVal)
                    // this.changeComment()
                // }
            },
        },
        mounted() {
        },
        methods: {
            //改变菜单
            changeTab(index) {
                this.tabIndex = index
            },
            showComments(item){
                // this.$emit('showComments', item)
                console.log("show comment : "+item.url)
                
                this.comment_item = item
                // this.commentPop = true
                store.commit('SET_COMMENT_POP', true)
                // console.log("pop: "+this.commentPop)
            },
        }
    }
</script>
<style scoped>
    @import "../static/css/home.css";
    /*评论样式*/
</style>
