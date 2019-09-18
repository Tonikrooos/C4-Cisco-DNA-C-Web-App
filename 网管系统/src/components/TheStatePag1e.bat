<template>
  <div>
    <div class="clearfix">
      <div class="internet-map">
        <span>网络图</span>
      </div>
      <ul>
        <li class="ip-item" @click="drawAll">网络总览</li>
        <li class="ip-item" @click="updateData0">10.10.20.241</li>
        <li class="ip-item" @click="updateData1">10.10.20.242</li>
        <li class="ip-item" @click="updateData2">10.10.20.243</li>
        <li class="ip-item" @click="updateData3">10.10.20.244</li>
        <li class="ip-item" @click="updateData4">10.10.20.245</li>
        <li class="ip-item" @click="updateData5">10.10.20.246</li>
        <li class="ip-item" @click="updateData6">10.10.20.247</li>
        <li class="ip-item" @click="updateData7">10.10.20.248</li>
        <li class="ip-item" @click="updateData8">10.10.20.249</li>
        <li class="ip-item" @click="updateData9">10.10.20.250</li>
      </ul>
    </div>
	    <div class="row" id="date">
	  <span>选择时间：</span>
	  <date-picker :date="startTime" :option="option" :limit="limit"></date-picker>
	  <el-button size="small" @click="changeData">查询</el-button>
	</div>
    <div>
      <div id="main1"></div>
      <div id="main2"></div>
      <div id="main3"></div>
    </div>
  </div>
</template>


<script>
import echarts from 'echarts'
import Datepicker from 'vue-datepicker/vue-datepicker-es6.vue'
export default {
  name: "TheStatePage",
  components: {
     'date-picker': Datepicker
  },
  data() {
    return {
      pickerOptions: {
        shortcuts: [
          {
            text: '一小时内',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000);
              picker.$emit('pick', [start, end]);
            }
          },
        ]
      },
      datePicker: true,
      value1: [],
      xData1: [],
      yData1: [],
      xxData1: [],
      yyData1: [],
      xxData2: [],
      yyData2: [],
      xxData3: [],
      yyData3: [],
      title: '',
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
	      format: 'YYYY-MM-DD HH:mm',
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
	      format: 'YYYY-MM-DD HH:mm'
	    },
	    multiOption: {
	      type: 'multi-day',
	      week: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
	      month: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
	      format: 'YYYY-MM-DD HH:mm'
	    },
		limit: [{
                      type: Array,
                      default:function _default(){
                        return [];
                      }
                    }]
    }
  },
  mounted(){
    this.setDate();
    for(let i=0;i<=59;i++){
      this.xData1.push(i)
    }
    for(let i=0;i<=9;i++){
      this.randomData1();
      this.randomData2();
      this.randomData3();
    }
    this.drawAll();
  },
  methods:{
    changeData(){
      this.yyData1 = [];
      this.yyData2 = [];
      this.yyData3 = [];
      this.xxData1 = [];
      this.xxData2 = [];
      this.xxData3 = [];
      for(let i=0;i<=59;i++){
        this.xData1.push(i)
      }
      for(let i=0;i<=9;i++){
        this.randomData1();
        this.randomData2();
        this.randomData3();
      }
      this.drawAll();
    },
    drawAll(){
      this.datePicker = true;
      this.xData1 = this.xxData1[0];
      this.yData1 = [];
      let sum1 = 0;
      for(let i=0;i<=59;i++){
        for(let arr in this.yyData1){
          sum1 += this.yyData1[arr][i];
        }
        this.yData1.push(sum1);
        sum1 = 0;
      }
      this.title = '网络整体健康度';
      this.drawLine("main1");
      this.yData1 = [];
      let sum2 = 0;
      for(let i=0;i<=59;i++){
        for(let arr in this.yyData2){
          sum2 += this.yyData2[arr][i];
        }
        this.yData1.push(sum2);
        sum2 = 0;
      }
      this.title = '站点健康度';
      this.drawLine("main2");
      this.yData1 = [];
      let sum3 = 0;
      for(let i=0;i<=59;i++){
        for(let arr in this.yyData3){
          sum3 += this.yyData3[arr][i];
        }
        this.yData1.push(sum3);
        sum3 = 0;
      }
      this.title = '用户网络健康度';
      this.drawLine("main3")
    },
    updateData0(){
      this.datePicker = false;
      this.title = '网络整体健康度';
      this.yData1 = this.yyData1[0]
      this.drawLine("main1");
      this.title = '站点健康度';
      this.yData1 = this.yyData2[0]
      this.drawLine("main2");
      this.title = '用户网络健康度';
      this.yData1 = this.yyData3[0]
      this.drawLine("main3")
    },
    updateData1(){
      this.datePicker = false;
      this.title = '网络整体健康度';
      this.yData1 = this.yyData1[1]
      this.drawLine("main1");
      this.title = '站点健康度';
      this.yData1 = this.yyData2[1]
      this.drawLine("main2");
      this.title = '用户网络健康度';
      this.yData1 = this.yyData3[1]
      this.drawLine("main3")
    },
    updateData2(){
      this.datePicker = false;
      this.title = '网络整体健康度';
      this.yData1 = this.yyData1[2]
      this.drawLine("main1");
      this.title = '站点健康度';
      this.yData1 = this.yyData2[2]
      this.drawLine("main2");
      this.title = '用户网络健康度';
      this.yData1 = this.yyData3[2]
      this.drawLine("main3")
    },
    updateData3(){
      this.datePicker = false;
      this.title = '网络整体健康度';
      this.yData1 = this.yyData1[9]
      this.drawLine("main1");
      this.title = '站点健康度';
      this.yData1 = this.yyData2[9]
      this.drawLine("main2");
      this.title = '用户网络健康度';
      this.yData1 = this.yyData3[9]
      this.drawLine("main3")
    },
    updateData4(){
      this.datePicker = false;
      this.title = '网络整体健康度';
      this.yData1 = this.yyData1[3]
      this.drawLine("main1");
      this.title = '站点健康度';
      this.yData1 = this.yyData2[3]
      this.drawLine("main2");
      this.title = '用户网络健康度';
      this.yData1 = this.yyData3[3]
      this.drawLine("main3")
    },
    updateData5(){
      this.datePicker = false;
      this.title = '网络整体健康度';
      this.yData1 = this.yyData1[4]
      this.drawLine("main1");
      this.title = '站点健康度';
      this.yData1 = this.yyData2[4]
      this.drawLine("main2");
      this.title = '用户网络健康度';
      this.yData1 = this.yyData3[4]
      this.drawLine("main3")
    },
    updateData6(){
      this.datePicker = false;
      this.title = '网络整体健康度';
      this.yData1 = this.yyData1[5]
      this.drawLine("main1");
      this.title = '站点健康度';
      this.yData1 = this.yyData2[5]
      this.drawLine("main2");
      this.title = '用户网络健康度';
      this.yData1 = this.yyData3[5]
      this.drawLine("main3")
    },
    updateData7(){
      this.datePicker = false;
      this.title = '网络整体健康度';
      this.yData1 = this.yyData1[6]
      this.drawLine("main1");
      this.title = '站点健康度';
      this.yData1 = this.yyData2[6]
      this.drawLine("main2");
      this.title = '用户网络健康度';
      this.yData1 = this.yyData3[6]
      this.drawLine("main3")
    },
    updateData8(){
      this.datePicker = false;
      this.title = '网络整体健康度';
      this.yData1 = this.yyData1[7]
      this.drawLine("main1");
      this.title = '站点健康度';
      this.yData1 = this.yyData2[7]
      this.drawLine("main2");
      this.title = '用户网络健康度';
      this.yData1 = this.yyData3[7]
      this.drawLine("main3")
    },
    updateData9(){
      this.datePicker = false;
      this.title = '网络整体健康度';
      this.yData1 = this.yyData1[8]
      this.drawLine("main1");
      this.title = '站点健康度';
      this.yData1 = this.yyData2[8]
      this.drawLine("main2");
      this.title = '用户网络健康度';
      this.yData1 = this.yyData3[8]
      this.drawLine("main3")
    },
    setDate(){
      const end = new Date();
      const start = new Date();
      start.setTime(start.getTime() - 60 * 1000 * 60);
      this.value1 = [start, end];
    },
    randomData1(){
      var x = new Array(97);
      var d = new Date();
      x[x.length-1] = d.getHours() + ':00' ;
      for(var i=0;i<24;i++){
      	x[95-4*i] = d.getHours() - i + ':00' ;
      	if(d.getHours() - i < 0){
      		x[95-4*i] = d.getHours() + 24 - i + ':00' ;
      	}
      }
      for(var i=0;i<24;i++){
      	x[94-4*i] = d.getHours() - i + ':45' ;
      	if(d.getHours() - i < 0){
      		x[94-4*i] = d.getHours() + 24 - i + ':45' ;
      	}
      }
      for(var i=0;i<24;i++){
      	x[93-4*i] = d.getHours() - i + ':30' ;
      	if(d.getHours() - i < 0){
      		x[93-4*i] = d.getHours() + 24 - i + ':30' ;
      	}
      }
      for(var i=0;i<24;i++){
      	x[92-4*i] = d.getHours() - i + ':15' ;
      	if(d.getHours() - i < 0){
      		x[92-4*i] = d.getHours() + 24 - i + ':15' ;
      	}
      }

     var n = 96;
     var y = new Array(n);
     var ymin = 0;
     var ymax = 10;
     	
     y[0] = 9;
     
     for(var i = 0;i < n-1;i++){
     	var dy =  0.1 * ymax * (Math.random()-0.5) ;
     	y[i+1] = Math.round(y[i] + dy) ;
     	y[i+1] = Math.max(ymin,Math.min(y[i+1],ymax)) ;
     }
      
      if(this.xxData1.length <= 10) {
        this.xxData1.push(x);
        this.yyData1.push(y);
      }
    },
    randomData2(){
      var x = new Array(97);
      var d = new Date();
      x[x.length-1] = d.getHours() + ':00' ;
      for(var i=0;i<24;i++){
      	x[95-4*i] = d.getHours() - i + ':00' ;
      	if(d.getHours() - i < 0){
      		x[95-4*i] = d.getHours() + 24 - i + ':00' ;
      	}
      }
      for(var i=0;i<24;i++){
      	x[94-4*i] = d.getHours() - i + ':45' ;
      	if(d.getHours() - i < 0){
      		x[94-4*i] = d.getHours() + 24 - i + ':45' ;
      	}
      }
      for(var i=0;i<24;i++){
      	x[93-4*i] = d.getHours() - i + ':30' ;
      	if(d.getHours() - i < 0){
      		x[93-4*i] = d.getHours() + 24 - i + ':30' ;
      	}
      }
      for(var i=0;i<24;i++){
      	x[92-4*i] = d.getHours() - i + ':15' ;
      	if(d.getHours() - i < 0){
      		x[92-4*i] = d.getHours() + 24 - i + ':15' ;
      	}
      }

     var n = 96;
     var y = new Array(n);
     var ymin = 0;
     var ymax = 10;
     	
     y[0] = 9;
     
     for(var i = 0;i < n-1;i++){
     	var dy =  0.1 * ymax * (Math.random()-0.5) ;
     	y[i+1] = Math.round(y[i] + dy) ;
     	y[i+1] = Math.max(ymin,Math.min(y[i+1],ymax)) ;
     }
      
      if(this.xxData2.length <= 10) {
        this.xxData2.push(x);
        this.yyData2.push(y);
      }
    },
    randomData3(){
      var x = new Array(97);
      var d = new Date();
      x[x.length-1] = d.getHours() + ':00' ;
      for(var i=0;i<24;i++){
      	x[95-4*i] = d.getHours() - i + ':00' ;
      	if(d.getHours() - i < 0){
      		x[95-4*i] = d.getHours() + 24 - i + ':00' ;
      	}
      }
      for(var i=0;i<24;i++){
      	x[94-4*i] = d.getHours() - i + ':45' ;
      	if(d.getHours() - i < 0){
      		x[94-4*i] = d.getHours() + 24 - i + ':45' ;
      	}
      }
      for(var i=0;i<24;i++){
      	x[93-4*i] = d.getHours() - i + ':30' ;
      	if(d.getHours() - i < 0){
      		x[93-4*i] = d.getHours() + 24 - i + ':30' ;
      	}
      }
      for(var i=0;i<24;i++){
      	x[92-4*i] = d.getHours() - i + ':15' ;
      	if(d.getHours() - i < 0){
      		x[92-4*i] = d.getHours() + 24 - i + ':15' ;
      	}
      }

     var n = 96;
     var y = new Array(n);
     var ymin = 0;
     var ymax = 10;
     	
     y[0] = 9;
     
     for(var i = 0;i < n-1;i++){
     	var dy =  0.1 * ymax * (Math.random()-0.5) ;
     	y[i+1] = Math.round(y[i] + dy) ;
     	y[i+1] = Math.max(ymin,Math.min(y[i+1],ymax)) ;
     }
      
      if(this.xxData3.length <= 10) {
        this.xxData3.push(x);
        this.yyData3.push(y);
      }
    },
    drawLine(id) {
      this.charts = echarts.init(document.getElementById(id));
      let option = {
        color: ['#00EE00'],
        tooltip: {trigger: 'axis', color: '#00EE00',},
		 formatter: function(o) {
		    let arr = [
		      '最近1小时第' + o[0].dataIndex + '分钟<br/>',
		      '用户数量：' + o[0].data
		    ];
		    return arr.join('');
		  },
		
        title: {
          text:this.title,
          left: 'center',
        },
        grid: {
          left: '10%',
          right: '10%',
          bottom: '10%',
          top: '20%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          name: '时间',
          boundaryGap: false,
          data: this.xData,
        },
        yAxis: {
          type: 'value',
          name: '分数',
          minInterval: 1
        },
        series: [{
          name: '分数',
          type: 'line',
          data: this.yData1,
      		lineStyle: {        // 系列级个性化折线样式
      	width: 2.5,
      	},
          emphasis: {
            itemStyle: {
              // 高亮时点的颜色。
              color: '#FF6A6A'
            }
          },
        }],
        	visualMap: [{
        	  'show': false,
        	  'pieces': [{
        	    'gte':80,
        	    'lt': 100,
        	    'color': '#00EE00'
        	  }, {
        	    'gte':60,
        	    'lt': 80,
        	    'color': 'blue'
        	  },{
        	    'lt': 60,
        	    'gt': 0,
        	    'color': 'red'
        	 },{
        	    'lt': 1000,
        	    'gt': 800,
        	    'color': '#00EE00'
        	  },{
        	    'lt': 800,
        	    'gt': 600,
        	    'color': 'blue'
        	  },{
        	    'lt': 600,
        	    'gt': 100,
        	    'color': 'red'
        	  }]
        	}],
      };
      this.charts.setOption(option);
    },
  }
}
</script>
<style scoped>
	#date{
	width:500px;
	height:30px;
	margin-left: 400px;	
	margin-top:40px;
	}
  #main1{
    width:850px;
    height:250px;
    margin: 15px auto;
	margin-top: 50px;
  }
    #main2{
    width:850px;
    height:250px;
    margin: 15px auto;
  }
    #main3{
    width:850px;
    height:250px;
    margin: 15px auto;
  }
  .ip-item{
    list-style-type: square;
    padding: 20px;
    color: 	#FFFFFF;
    cursor: pointer;
  }
  .ip-item:hover{
    color: #912CEE;
    background-color: #CCFFFF;
  }
  .clearfix{
    text-align: left;
    width: 200px;
    background-color: #A4D3EE;
    float: left;
    border-radius:20px
  }
  .internet-map{
	  font-family: STHeiti;
    color: #436EEE;
    font-size: 30px;
    padding: 20px 0 0 20px;
  }
</style>

