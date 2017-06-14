---
--- Created by luzhuqiu.
--- DateTime: 2017/6/14 下午2:05
---

ProcessPriority =
{
    ['empty'] = 0,
    ['fight'] = 10,---开打
    ['settle'] = 20,---结算
    ['playPlot'] = 30,---播放剧情
}

ProcessState =
{
    ['ready'] = 0,
    ['running'] = 1,
    ['pause'] = 2,
    ['end'] = 3,
}