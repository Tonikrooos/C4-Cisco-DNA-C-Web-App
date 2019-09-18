<template>
  <div id="login-in-layout">
	
    <div class="head-line">
	  
      <!-- <img src="../assets/BUPT_logo.png" draggable="false"/> -->
<!--      <el-popover
		placement="top-end"
        width="30"
        trigger="click">
        <pre class="popovertext">用户名: {{username}}</pre>
        <pre class="popovertext">状&nbsp态: {{state}}</pre>
        <pre class="popovertext quit" @click="toLogin">&nbsp注&nbsp销</pre>
        <el-avatar slot="reference" class="user-icon" src="https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png">
        </el-avatar>
      </el-popover> -->

      <div class="system-title">场景化的网络与数据云管理系统</div>	
    </div>
    <el-menu :default-active="activeIndex" class="el-menu-demo" mode="horizontal" active-text-color="white" text-color="white" background-color="#213141">
      <el-menu-item index="1" class="nav-item" @click="toHome">首页</el-menu-item>
      <el-menu-item index="2" class="nav-item" @click="toUser">用户</el-menu-item>
      <el-menu-item index="3" class="nav-item" @click="toNet">网络热度</el-menu-item>
      <el-menu-item index="4" class="nav-item" @click="toState">网络状态</el-menu-item>
    </el-menu>
    <el-divider></el-divider>
    <div class="row" id="date">选择时间：
		<date-picker :date="startTime" :option="option" :limit="limit"></date-picker>
	</div>
	<router-view v-if = "isRouterAlive"></router-view>
  </div>

</template>
<script>
import Datepicker from 'vue-datepicker/vue-datepicker-es6.vue'
  export default {
	  components: {
	     'date-picker': Datepicker
	  },
	  provide () {
	    return {
	      reload: this.reload
	    }
	  },
    data() {
      return {
		isRouterAlive:true,
        activeIndex: '1',
        state: '在线',
        username: 'admin',
		startTime: {
		        time: ''
		},
		endTime: {
		        time: ''
		},
		option: {
		        type: 'day',
		         week: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
		        month: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
		        format: 'YYYY-MM-DD ',
		        placeholder: '请选择时间',
		        inputStyle: {
		            'display': 'inline-block',
		            'padding': '4px',
		            'line-height': '17px',
		            'font-size': '14px',
		            'width': '190px',
		            'border': '1px solid #ddd',
		            // 'box-shadow': '0 1px 3px 0 rgba(0, 0, 0, 0.2)',
		            'border-radius': '5px',
		            'color': '#5F5F5F'
		        },
		        color: {
		            header: '#ccc',
		            headerText: '#f00'
		        },
		        buttons: {
		            ok: '确定',
		            cancel: '取消'
		        },
		        overlayOpacity: 0.5, // 0.5 as default
		        dismissible: true // as true as default
		    },
		    timeoption: {
		        type: 'min',
		        week: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
		        month: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
		        format: 'YYYY-MM-DD '
		      },
		      multiOption: {
		        type: 'multi-day',
		        week: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
		        month: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
		        format: 'YYYY-MM-DD '
		      },
		       limit: [{
		          type: Array,
		          default:function _default(){
		            return [];
		          }
		        }]
      };
    },
    methods:{
      toHome(){
        this.$router.push({name:'homepage'})
      },
      toUser(){
        this.$router.push({name:'userpage'})
      },
      toNet(){
        this.$router.push({name:'netpage'})
      },
      toState(){
        this.$router.push({name:'statepage'})
      },
      toLogin(){
        this.$router.push({name:'login'})
      },
	  reload () {
	    this.isRouterAlive = false
	    this.$nextTick(function() {
	       this.isRouterAlive = true
	    })
	  }
    }
 }
</script>

<style>
  #login-in-layout{
    width:80%;
    margin: 0 auto;
  }
  #date{
	  margin:80px auto 0 270px;
  }
  .head-line{
    width:100%;
  }
  .user-icon{
    float:right;
    width: 60px;
    height: 60px;
    margin: 0px 20px 0 0;
    cursor: pointer;
  }
  .system-title{
    font-family: STXingkai ;
    font-size: 65px;
    color: 	#213141;
   /* float:right; */
    margin:50px auto 50px 0px;
    letter-spacing:15px;
  }
  .nav-item{
    font-size: 20px;
  }

  .popovertext{
    text-align: center;
  }
  .quit:hover{
    color:red;
  }

</style>
