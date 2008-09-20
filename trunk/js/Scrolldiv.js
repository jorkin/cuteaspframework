/*
�ļ��� ScrollDiv.js
��;   �޷����ָ������
�汾   2.0.2
����   IE6.0 Firefox2.0
����   songguowei@snda.com
����޸� 2006/11/03
*/
//��������
var PInstanceCreatedNums=0;  //������ʵ������
var PInstanceMaxCreateNums=100;  //���ǵ�Ч�����⣬ҳ��ʵ������Ϊ100,���Ը���ʵ��Ӳ�����ý����޸�
//����[Marquee]����
function Marquee()
{
	var mStoptime=0;
	var offsetcount=0;
	var thisObj=this;
	var speed=0;			//�ƶ��ٶ�
	var parentdiv ="";		//ָ����������������
	var maindiv = "";		//ָ��������
	var copydiv = "";		//�ղ㣬��Ҫ
	var speed = 0;			//�����ٶ� ��λ�Ǻ��� 1000��1��
	var direction = "";		//�����ķ��� "left":���� "right":���� "up":���� "down":���� 
	var pauseDistance = 0;	//��ͣ���룬ÿ�����پ�����ͣ����
	var pauseTime = 0;		//��ͣʱ�� ��λ������
	var startStatus =0;		//��ʼ״̬��Ĭ��Ϊ0���ɲ����ã�0:��ʾ�������ݣ�1:��ʼ״̬Ϊ�հף�
	var parentdivWidth=0;	//��ʾ���
	var parentdivHeight=0;  //��ʾ�߶�
	PInstanceCreatedNums++;
	//���� start() ����:��ʼ��
	thisObj.start=function()
	{
		try
		{
			if(PInstanceCreatedNums>=PInstanceMaxCreateNums)
			{
				alert("����ʵ������������ƣ�");
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
				//����ƶ��¼��ĵ��÷���
				parentdiv.onmouseover=Pause;
				parentdiv.onmouseout=Begin;
				//����ƶ��¼��ĵ��÷���
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
			alert('�������󣡴�������:['+e.message+']');
		}
	}
	//���� divCopy() ����:���Ʋ�����
	thisObj.divCopy=function()
	{
		with(thisObj)
		{
			//��̬�������ڸ��Ƶ� copydiv
			copydiv=document.createElement("div");
			copydiv.id='copy'+maindiv.id;
			parentdiv.appendChild(copydiv);			
			copydiv.innerHTML=maindiv.innerHTML;
		}
	}
	//���� doPause() ����:������϶��ͣ����
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
	//���� iMarquee() ����:�޷��������
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
	thisObj.Begin=function() //����:Begin() ����:��ʼ����
	{
		thisObj.timer=setInterval(thisObj.iMarquee,thisObj.speed);
	}
	thisObj.Pause=function() //���� Pause() ����:��ͣ����
	{
		clearInterval(thisObj.timer);
	}
}