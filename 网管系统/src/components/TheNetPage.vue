<template>
  <div>
  <!-- <div class="row" id="date"> -->
 <!--   <span>选择时间：</span>
    <date-picker :date="startTime" :option="option" :limit="limit"></date-picker>
    <el-button size="small" @click="refresh">查询</el-button> -->
 
 <div class="row" id="date">
  <!-- <span>选择时间：</span>
   <date-picker :date="startTime" :option="option" :limit="limit"></date-picker> -->
   <el-button size="small" @click="refresh">查询</el-button>
 </div>
 <div id="main"></div>
  </div>
<!--  </div> -->
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
                    format: 'YYYY-MM-DD 00:00',
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
                    format: 'YYYY-MM-DD 00:00'
                  },
                  multiOption: {
                    type: 'multi-day',
                    week: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
                    month: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
                    format: 'YYYY-MM-DD 00:00'
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
      this.drawLine("main")
    },
    methods: {
		refresh () {
		  this.reload()
		},
      drawLine(id) {
        let myChart = echarts.init(document.getElementById(id));
		var a = new Array(10);
		for(var i = 0;i < 10;i++){
		 	a[i] = Math.round(100*Math.random()) ;
		 }
        let data = [
          [0, 0, 6, a[0]],
          [1, 0, 7, a[1]],
          [2, 0, 8, a[2]],
          [3, 0, 9, a[3]],
          [4, 0, 10, a[4]],
          [0, 1, 1, a[5]],
          [1, 1, 2, a[6]],
          [2, 1, 3, a[7]],
          [3, 1, 4, a[8]],
		  [4, 1, 5, a[9]],
        ];
		
        let option = {
          title: {
            text: '用户热点图',
			textStyle: {
				 color:'#213141',
				fontSize: 26,
			},
			left: 'center',
          },
          backgroundColor: '#fff',
          tooltip: {},
          xAxis: {
            type: 'category',
            data: ['1', '2', '3','4','5'],
            axisLine: {          //坐标轴轴线相关设置。
              show: true,         //是否显示坐标轴轴线。
              symbol: ['none', 'none'],  //轴线两边的箭头。
              // symbolSize: [10, 10],     //轴线两边的箭头的大小
              // symbolOffset: [0, 5]      //轴线两边的箭头的偏移
            },
            axisTick: {      //坐标轴刻度相关设置。
              show: false      //是否显示坐标轴刻度。
            },
            axisLabel: {      //坐标轴刻度标签的相关设置。
              show: false,
              rotate: 0      //刻度标签旋转的角度
            },
            splitLine: {
              show: true,      //坐标轴在 grid 区域中的分隔线。
              interval: '4',    //坐标轴分隔线的显示间隔
              lineStyle: {     //分隔线样式，
                color: ['#333'],
                width: 1,
                type: 'solid'
              }
            },
            splitArea: {    //坐标轴在 grid 区域中的分隔区域，默认不显示
              show: true
            }
          },
          yAxis: {
            type: 'category',
            data: ['下',  '上'],
            axisLine: {
              show: true,
              symbol: ['none', 'none'],
              // symbolSize: [10, 10],
              // symbolOffset: [0, 5]
            },
            axisTick: {
              show: false
            },
            axisLabel: {
              show: false,
              margin: 10,
              rotate: -89.99,
              verticalAlign: 'top'
            },
            splitLine: {
              show: true,
              interval: '4',
              lineStyle: {
                color: ['#333'],
                width: 1,
                type: 'solid'
              }
            },
            splitArea: {
              show: false
            }
          },
          visualMap: [{
            min: 0,
            max: 100,
            calculable: true,  //是否显示拖拽用的手柄（手柄能拖拽调整选中范围）
            orient: 'vertical',  //如何放置 visualMap 组件，水平（'horizontal'）或者竖直（'vertical'）
            seriesIndex: 1,
            // left: '91%',
            bottom: 50,
          }],
          series: [{
            type: 'heatmap',
            data: data,
            tooltip: {
              formatter: function(o) {
                console.log(o);
				
                let arr = [
                  '无线网名称：T1-' + o.value[2] + '<br/>',
                  '用户数量：' + o.value[3]
                ];
                return arr.join('');
              }
            },
            itemStyle: {
              color: '#fff',
              borderColor: '#000',
              borderWidth: 2,
              emphasis: {
                shadowBlur: 10,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
              }
            }
          },{
            type: 'effectScatter',
            data: data,
            symbolSize: function(value){
              return value[3]/2.5 
            },
            rippleEffect:{
              scale:6,
            },
            tooltip: {
              formatter: function(o) {
                console.log(o);
                let arr = [
                  '无线网名称：TI-' + o.value[2] + '<br/>',
                  '用户数量：' + o.value[3]
                ];
                return arr.join('');
              }
            },
          }]
        };
        myChart.setOption(option)
      }
    }
  }
</script>

<style scoped>
#date{
	width:500px;
	height:30px;
	margin:-30px auto auto 570px; 
	}
  #main{
    width:1000px;
    height:500px;
    padding:0 40px;
    margin-left: 150px;
	margin-top: 50px;
	
  }
</style>
