<template>
  <div>
    <div class="clearfix">
      <div class="internet-map">
        <span>网络图</span>
      </div>
      <ul>
          <li class="ip-item"  @click="refresh">网络总览</li>
          <li class="ip-item"  @click="refresh">无线网络01</li>
          <li class="ip-item"  @click="refresh">无线网络02</li>
          <li class="ip-item"  @click="refresh">无线网络03</li>
          <li class="ip-item"  @click="refresh">无线网络04</li>
          <li class="ip-item"  @click="refresh">无线网络05</li>
          <li class="ip-item"  @click="refresh">无线网络06</li>
          <li class="ip-item"  @click="refresh">无线网络07</li>
          <li class="ip-item"  @click="refresh">无线网络08</li>
          <li class="ip-item"  @click="refresh">无线网络09</li>
          <li class="ip-item"  @click="refresh">无线网络10</li>
      </ul>
	  <div id="main">
    </div>
	<div class="row" id="date">
	 <!-- <span>选择时间：</span>
	  <date-picker :date="startTime" :option="option" :limit="limit"></date-picker> -->
	  <el-button size="small" @click="refresh">查询</el-button>
	</div>
    </div>
  </div>
</template>

<script>
import echarts from 'echarts'
import Datepicker from 'vue-datepicker/vue-datepicker-es6.vue'
export default {
		name: "TheStatePage",
		inject: ['reload'],
        components: {
           'date-picker': Datepicker
        },


        data(a) {

            return {
				xData:this.datax(),
				yData:this.datay(),
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
            }
        },
		 mounted(){
		  this.drawLine("main",'用户终端数量',this.datay())
		},

		 methods:{
			    refresh () {
                  this.reload();
                },
			 	datax(){
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
			 	// for(var i=0;i<60;i++){
			 	// 	if(d.getMinutes()- 59 + i>=0){
			 	// 	x[i] = d.getHours() + ':' + (d.getMinutes()- 59 + i);
			 	// }else{
			 	// 	x[i] = d.getHours() - 1 + ':' + (d.getMinutes() + 1 + i);
			 	//  }
			 	// }
			 	return x;
			 	},
			 
			    datay(){
			 	var n = 96;
			 	var y = new Array(n);
			 	var ymin = 0;
			 	var ymax = 100;
			 		
			 	y[0] = Math.round(100*Math.random());
			 	
			 	for(var i = 0;i < n-1;i++){
			 		var dy =  0.1 * ymax * (Math.random()-0.5) ;
			 		y[i+1] = Math.round(y[i] + dy) ;
			 		y[i+1] = Math.max(ymin,Math.min(y[i+1],ymax)) ;
			 	}
			 	return y;
			 },
			 datay1(){
			 	var n = 60;
			 	var y = new Array(n);
			 	var ymin = 0;
			 	var ymax = 1000;
			 		
			 	y[0] = 888;
			 	
			 	for(var i = 0;i < n-1;i++){
			 		var dy =  0.2 * ymax * (Math.random()-0.5) ;
			 		y[i+1] = Math.round(y[i] + dy) ;
			 		y[i+1] = Math.max(ymin,Math.min(y[i+1],ymax)) ;
			 	}
			 	return y;
			 },
		  drawLine(id,textName,yData) {
			  
		    this.charts = echarts.init(document.getElementById(id));
		    let option = {
		      color: ['#00EE00'],
		      tooltip: {trigger: 'axis', color: '#00EE00',},
		      title: {
		        text: textName,
				textStyle: {
					 color:'#213141',
					fontSize: 26,
				},
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
		        name: '数量',
		        minInterval: 1
		      },
		      series: [{
		        name: '个数',
		        type: 'line',
		        data: yData,
					lineStyle: {        // 系列级个性化折线样式
				  width: 3.5,
				},
		        emphasis: {
		          itemStyle: {
		            // 高亮时点的颜色。
		            color: '#FF6A6A'	
		          },
			
		        },
		      }],
			  		  visualMap: [{
			    'show': false,
			    'pieces': [{
			      'gte':80,
			      'lt': 100,
			      'color': 'red'
			    }, {
			      'lt': 80,
			      'gt': 0,
			      'color': '#00EE00'
			    }]
			  }]
		    };
		    this.charts.setOption(option);
		  },

		  },
		}

</script>
<style scoped>
#date{
	width:500px;
	height:30px;
	margin:-615px auto auto 570px;
	}
  #main{
    width:900px;
    height:500px;
    margin:-600px 0 auto 300px ;
  }
  .ip-item{
    list-style-type: square;
    padding: 20px;
    color: 	#FFFFFF;
    cursor: pointer;
  }
  .ip-item:hover{
    color: white;
    background-color: #51A0DB;
  }
/* .ip-item:visited{
    color: white;
    background-color: #51A0DB;
  } */
  .clearfix{
    text-align: left;
    width: 200px;
	height: 800px;
    background-color: 	#213141;
   /* float: left; */
    border-radius:20px;
	margin: -80px 1000px auto 0;
  }

  .internet-map{
    font-family: STHeiti;
	color:#FFFFFF;
    font-size: 30px;
    padding: 20px 0 0 20px;
  }
</style>