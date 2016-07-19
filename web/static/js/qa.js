$(document).ready(function () {

  var Vue = require('vue')
  var qa_app = new Vue({
    el: '#app',
    data: {
      test: true,
      curIdxData: null,
      curIdx: 0,
      curImg: '',
      allData: null,
      qaState: null, // 问题模式、答案模式、统计模式
      qaChecking: null,
      statistics: []
    },
    created: function () {
      console.log('initData');
      this.initData()
    },
    watch: {
      // qaState: 'changeState',
      curIdx: 'changeIdx'
    },
    methods: {
      changeIdx: function () {
        this.curImg = this.curIdxData.img
      },
      initData: function () {

        let imgsrc = 'http://img.mp.itc.cn/upload/20160719/11e95ac88d1d40c78bf9c647ac4d095e_th.jpg'
        this.allData = [ {q_title: "title0", q_des: "des0", answer: true, a_des: "ades0", a_tip: "tip0", img: 'http://imgup01.qulishi.com/attachedfile/image/2016/0719/1468905694554034.png'},
                  {q_title: "title1", q_des: "des1",  answer: false, a_des: "ades1", a_tip: "tip1", img: imgsrc},
                  {q_title: "title2", q_des: "des2",  answer: true, a_des: "ades2", a_tip: "tip2", img: imgsrc},
                  {q_title: "title3", q_des: "des3",  answer: false, a_des: "ades3", a_tip: "tip3", img: 'http://imgup01.qulishi.com/attachedfile/image/2016/0719/1468905694554034.png'},
                  {q_title: "title4", q_des: "des4",  answer: true, a_des: "ades4", a_tip: "tip4", img: imgsrc}
                ]
        this.curIdxData = this.allData[0]
        this.qaState = true
        this.qaChecking = true
        this.curImg = this.curIdxData.img
        $(".progress-bar").text('' + 1 + '/' + this.allData.length)
        let tipstr = 'width: 42%;'.replace('42', (1)/(this.allData.length) * 100 )
        $(".progress-bar").attr('style', tipstr)
      },
      checkWx: function () {
        // 对浏览器的UserAgent进行正则匹配，不含有微信独有标识的则为其他浏览器
        var useragent = navigator.userAgent;
        if (useragent.match(/MicroMessenger/i) != 'MicroMessenger') {
            // 这里警告框会阻塞当前页面继续加载
            alert('已禁止本次访问：您必须使用微信内置浏览器访问本页面！');
            // 以下代码是用javascript强行关闭当前页面
            var opened = window.open('about:blank', '_self');
            opened.opener = null;
            opened.close();
        }
      },
      fetchData: function () {
        var xhr = new XMLHttpRequest()
        var self = this
        xhr.open('GET', apiURL + self.currentBranch)
        xhr.onload = function () {
          self.commits = JSON.parse(xhr.responseText)
        }
        xhr.send()
      },
      aswerFalse: function (e) {
        this.qaState = false
        this.statistics.push( false == this.curIdxData.answer )
        console.log(this.statistics);
      },
      aswerTrue: function (e) {
        this.qaState = false
        this.statistics.push( true == this.curIdxData.answer )
        console.log(this.statistics);

      },
      nextQa: function (e) {
        this.qaState = true
        if ( this.curIdx == this.allData.length - 2 ) {
          $('#nextq-btn').text('完成')
        }
        if ( this.curIdx == this.allData.length -1 ) {
          this.qaChecking = false

          $.get("http://127.0.0.1:4000/wechat/qa", { statistics: this.statistics } );
          var tmp = this.statistics.map(function(st) {
            return st ? '正确': '错误'
          })
          this.statistics = tmp
          return
        }
        this.curIdx = this.curIdx + 1
        this.curIdxData = this.allData[ this.curIdx]

        $(".progress-bar").text('' + (this.curIdx+1)+ '/' + this.allData.length)
        let tipstr = 'width: 42%;'.replace('42', (this.curIdx + 1)/(this.allData.length) * 100 )
        $(".progress-bar").attr('style', tipstr)

      }
    }
  })

})
