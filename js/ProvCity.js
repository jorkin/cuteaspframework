<!--
var where = new Array();

function comefrom(loca, locacity)
{
    this.loca = loca;
    this.locacity = locacity;

}

//  ---------------------------------------

where[0] = new comefrom("��ѡ��", "��ѡ��");

where[1] = new comefrom("����", "|����|����|����|����|����|��̨|ʯ��ɽ|����|��ͷ��|��ɽ|ͨ��|˳��|��ƽ|����|ƽ��|����|����|����");
where[2] = new comefrom("�Ϻ�", "|����|¬��|���|����|����|����|բ��|���|����|����|��ɽ|�ζ�|�ֶ�|��ɽ|�ɽ�|����|�ϻ�|����|����");
where[3] = new comefrom("���", "|��ƽ|����|�Ӷ�|����|����|����|�Ͽ�|����|�ӱ�|����|����|����|����|���|����|����|����|����");
where[4] = new comefrom("����", "|����|����|����|��ɿ�|����|ɳƺ��|������|�ϰ�|����|��ʢ|˫��|�山|����|ǭ��|����|�뽭|����|ͭ��|����|�ٲ�|��ɽ|��ƽ|�ǿ�|�ᶼ|�潭|��¡|����|����|����|���|��ɽ|��Ϫ|ʯ��|��ɽ|����|��ˮ|����|�ϴ�|����|�ϴ�");
where[5] = new comefrom("�ӱ�", "|ʯ��ׯ|����|��̨|����|�żҿ�|�е�|�ȷ�|��ɽ|�ػʵ�|����|��ˮ");
where[6] = new comefrom("ɽ��", "|̫ԭ|��ͬ|��Ȫ|����|����|˷��|����|����|����|�ٷ�|�˳�");
where[7] = new comefrom("���ɹ�", "|���ͺ���|��ͷ|�ں�|���|���ױ�����|��������|����ľ��|�˰���|�����첼��|���ֹ�����|�����׶���|��������");
where[8] = new comefrom("����", "|����|����|��ɽ|��˳|��Ϫ|����|����|Ӫ��|����|����|�̽�|����|����|��«��");
where[9] = new comefrom("����", "|����|����|��ƽ|��Դ|ͨ��|��ɽ|��ԭ|�׳�|�ӱ�");
where[10] = new comefrom("������", "|������|�������|ĵ����|��ľ˹|����|�绯|�׸�|����|�ں�|˫Ѽɽ|����|��̨��|���˰���");
where[11] = new comefrom("����", "|�Ͼ�|��|����|��ͨ|����|�γ�|����|���Ƹ�|����|����|��Ǩ|̩��|����");
where[12] = new comefrom("�㽭", "|����|����|����|����|����|����|��|����|��ɽ|̨��|��ˮ");
where[13] = new comefrom("����", "|�Ϸ�|�ߺ�|����|����ɽ|����|ͭ��|����|��ɽ|����|����|����|����|����|����|����|����|����");
where[14] = new comefrom("����", "|����|����|����|����|Ȫ��|����|��ƽ|����|����");
where[15] = new comefrom("����", "|�ϲ���|������|�Ž�|ӥ̶|Ƽ��|����|����|����|�˴�|����|����");
where[16] = new comefrom("ɽ��", "|����|�ൺ|�Ͳ�|��ׯ|��Ӫ|��̨|Ϋ��|����|̩��|����|����|����|����|����|�ĳ�|����|����");
where[17] = new comefrom("����", "|֣��|����|����|ƽ��ɽ|����|�ױ�|����|����|���|����|���|����Ͽ|����|����|����|�ܿ�|פ����|��Դ");
where[18] = new comefrom("����", "|�人|�˲�|����|�差|��ʯ|����|�Ƹ�|ʮ��|��ʩ|Ǳ��|����|����|����|����|Т��|����");
where[19] = new comefrom("����", "|��ɳ|����|����|��̶|����|����|����|����|¦��|����|����|����|����|�żҽ�");
where[20] = new comefrom("�㶫", "|����|����|�麣|��ͷ|��ݸ|��ɽ|��ɽ|�ع�|����|տ��|ï��|����|����|÷��|��β|��Դ|����|��Զ|����|����|�Ƹ�");
where[21] = new comefrom("����", "|����|����|����|����|����|���Ǹ�|����|���|����|��������|���ݵ���|����|��ɫ|�ӳ�");
where[22] = new comefrom("����", "|����|����");
where[23] = new comefrom("�Ĵ�", "|�ɶ�|����|����|�Թ�|��֦��|��Ԫ|�ڽ�|��ɽ|�ϳ�|�˱�|�㰲|�ﴨ|�Ű�|üɽ|����|��ɽ|����");
where[24] = new comefrom("����", "|����|����ˮ|����|��˳|ͭ��|ǭ����|�Ͻ�|ǭ����|ǭ��");
where[25] = new comefrom("����", "|����|����|����|��Ϫ|��ͨ|����|���|��ɽ|˼é|��˫����|��ɽ|�º�|����|ŭ��|����|�ٲ�");
where[26] = new comefrom("����", "|����|�տ���|ɽ��|��֥|����|����|����");
where[27] = new comefrom("����", "|����|����|����|ͭ��|μ��|�Ӱ�|����|����|����|����");
where[28] = new comefrom("����", "|����|������|���|����|��ˮ|��Ȫ|��Ҵ|����|����|¤��|ƽ��|����|����|����");
where[29] = new comefrom("����", "|����|ʯ��ɽ|����|��ԭ");
where[30] = new comefrom("�ຣ", "|����|����|����|����|����|����|����|����");
where[31] = new comefrom("�½�", "|��³ľ��|ʯ����|��������|����|��������|����|�������տ¶�����|��������|��³��|����|��ʲ|����|������");
where[32] = new comefrom("���", "|���");
where[33] = new comefrom("����", "|����");
where[34] = new comefrom("̨��", "|̨��|����|̨��|̨��|����|��Ͷ|����|����|�û�|����|����|����|��԰|����|��¡|̨��|����|����|���");


var select = function()
{
    var prov = document.getElementById("province");
    var city = document.getElementById("city");
    with(prov)
    {
        var loca2 = options[selectedIndex].value;
    }
    for(i = 0; i < where.length; i ++ )
    {
        if(where[i].loca == loca2)
        {
            loca3 = (where[i].locacity).split("|");
            for(j = 0; j < loca3.length; j ++ )
            {
                with(city)
                {
                    length = loca3.length;
                    options[j].text = loca3[j];
                    options[j].value = loca3[j];
                }
            }
            break;
        }
    }
	city.options[0].selected = true;
}

//  ---------------------------------------

var init = function(_prov, _city)
{
    var prov = document.getElementById("province");
    var city = document.getElementById("city");
    var n = 0 ;
    var m = 0 ;
    with(prov)
    {
        length = where.length;
        for(k = 0; k < where.length; k ++ )
        {
            options[k].text = where[k].loca;
            options[k].value = where[k].loca;
            if (_prov == where[k].loca)
            {
                n = k
            }
            ;
        }
        options[n].selected = true;

    }
    with(city)
    {
        loca3 = (where[n].locacity).split("|");
        length = loca3.length;
        for(l = 0; l < length; l ++ )
        {
            options[l].text = loca3[l];
            options[l].value = loca3[l];
            if (_city == loca3[l])
            {
                m = l
            }
            ;
        }
        options[m].selected = true;
    }
}

//  ---------------------------------------

// -->