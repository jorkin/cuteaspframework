/*
文件名 ScrollDiv.js
用途   无缝滚动指定内容
版本   2.0.2
兼容   IE6.0 Firefox2.0
作者   songguowei@snda.com
最后修改 2006/11/03
*/
//公共变量
var PInstanceCreatedNums=0;  //创建的实例数量
var PInstanceMaxCreateNums=100;  //考虑到效率问题，页面实例限制为100,可以根据实际硬件配置进行修改
//创建[Marquee]对象
function Marquee()
{
	var mStoptime=0;
	var offsetcount=0;
	var thisObj=this;
	var speed=0;			//移动速度
	var parentdiv ="";		//指定滚动父级包含层
	var maindiv = "";		//指定滚动层
	var copydiv = "";		//空层，必要
	var speed = 0;			//滚动速度 单位是毫秒 1000＝1秒
	var direction = "";		//滚动的方向 "left":向左 "right":向右 "up":向上 "down":向下 
	var pauseDistance = 0;	//暂停距离，每隔多少距离暂停滚动
	var pauseTime = 0;		//暂停时间 单位：毫秒
	var startStatus =0;		//初始状态，默认为0，可不设置；0:显示滚动内容；1:初始状态为空白；
	var parentdivWidth=0;	//显示宽度
	var parentdivHeight=0;  //显示高度
	PInstanceCreatedNums++;
	//方法 start() 作用:初始化
	thisObj.start=function()
	{
		try
		{
			if(PInstanceCreatedNums>=PInstanceMaxCreateNums)
			{
				alert("创建实例超过最大限制！");
				return false;
			}
			with(thisObj)
			{
				parentdiv=document.getElementById(parentDiv);
				maindiv=document.getElementById(mainDiv);
				divCopy();
				if(parentdiv.style)
				{
					parentdiv.style.overflow='hidden';
					parentdiv.style.width=parentdivWidth;
					parentdiv.style.height=parentdivHeight;
				}
				//鼠标移动事件的调用方法
				parentdiv.onmouseover=Pause;
				parentdiv.onmouseout=Begin;
				//鼠标移动事件的调用方法
				switch(direction)
				{
				case "up":
					maindiv.style.display='block';
					copydiv.style.display='block';
					parentdiv.scrollTop=0;
					break;
				case "down":
					maindiv.style.display='block';
					copydiv.style.display='block';
					parentdiv.scrollTop=maindiv.offsetHeight*2-parentdivHeight;
					break;
				case "left":
					parentdiv.style.whiteSpace='nowrap';
					maindiv.style.display='inline';
					copydiv.style.display='inline';
					parentdiv.scrollLeft=0;
					break;
				case "right":
					parentdiv.style.whiteSpace='nowrap';
					maindiv.style.display='inline';
					copydiv.style.display='inline';
					parentdiv.scrollLeft=maindiv.offsetWidth*2-parentdivWidth;
					break;				
				}
				offsetcount=pauseDistance;
				Begin();
			}
		}
		catch(e)
		{
			alert('发生错误！错误内容:['+e.message+']');
		}
	}
	//方法 divCopy() 作用:复制层内容
	thisObj.divCopy=function()
	{
		with(thisObj)
		{
			//动态创建用于复制的 copydiv
			copydiv=document.createElement("div");
			copydiv.id='copy'+maindiv.id;
			parentdiv.appendChild(copydiv);			
			copydiv.innerHTML=maindiv.innerHTML;
		}
	}
	//方法 doPause() 作用:滚动间隙暂停函数
	thisObj.doPause=function()
	{
		mStoptime+=1;
		if(mStoptime==thisObj.pauseTime)
		{
			mStoptime=0;
			offsetcount=0;
			return true;
		}
		return false;
	}
	//方法 iMarquee() 作用:无缝滚动控制
	thisObj.iMarquee=function()
	{
		with(thisObj)
		{	
			switch(direction)
			{
			case "up":
				if(offsetcount>=pauseDistance)
				{
					if(parentdiv.scrollTop>=copydiv.offsetTop) 
					{
						if(doPause())
						{
							parentdiv.scrollTop-=maindiv.offsetHeight; 
						}
					}
					else
					{
						doPause();
					}
				}
				else
				{
					parentdiv.scrollTop++;
					offsetcount++;
				}			
				break;
			case "down":
				if(offsetcount>=pauseDistance) 
				{
					if(parentdiv.scrollTop<=maindiv.offsetHeight-parentdivHeight) 
					{
						if(doPause())
						{
							parentdiv.scrollTop=maindiv.offsetHeight*2-parentdivHeight;
						}
					}
					else
					{
						doPause();
					}
				}
				else
				{
					parentdiv.scrollTop--;
					offsetcount++;
				}			
				break;
			case "left":
				if(offsetcount>=pauseDistance)
				{
						
					if(parentdiv.scrollLeft>=copydiv.offsetWidth)
					{
						if(doPause())
						{
							parentdiv.scrollLeft-=maindiv.offsetWidth;
						}
					 }
					 else
					 {
						doPause();
					 }
				 }
				else
				{
					parentdiv.scrollLeft++;
					offsetcount++;
				}
				break;
			case "right":
				if(offsetcount>=pauseDistance)
				{
					if(parentdiv.scrollLeft<=0)
					{
						if(doPause())
						{
							parentdiv.scrollLeft+=maindiv.offsetWidth;
						}					
					 }
					 else
					 {
						doPause();
					 }
				 }
				else
				{
					parentdiv.scrollLeft--;
					offsetcount++;
				}			
				break;
			}
		}
	}
	thisObj.Begin=function() //方法:Begin() 作用:开始滚动
	{
		thisObj.timer=setInterval(thisObj.iMarquee,thisObj.speed);
	}
	thisObj.Pause=function() //方法 Pause() 作用:暂停滚动
	{
		clearInterval(thisObj.timer);
	}
}