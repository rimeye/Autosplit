# FC 游戏 Autosplitter 说明

本文件夹是一套用于 **LiveSplit** 的自动切分脚本（ASL），针对 FC/NES 版游戏《洛克人》（Mega Man）1–6 与《赤色要塞》（Jackal）。
脚本会自动读取模拟器内存，在关卡/BOSS 节点自动切分计时。

## 文件与游戏对应

| 游戏 | 文件 | 说明 |
|---|---|---|
| 赤色要塞 | [Jackalautosplit.asl](Jackalautosplit.asl) | 在每个 STAGE CLEAR 画面切分，最终在 BOSS 击杀后切分 |
| 洛克人 1 | [lkr1ye.asl](lkr1ye.asl) |  |
| 洛克人 2 | [lkr2ye.asl](lkr2ye.asl) |  |
| 洛克人 3 | [lkr3ye.asl](lkr3ye.asl) |  |
| 洛克人 4 | [lkr4ye.asl](lkr4ye.asl) |  |
| 洛克人 5 | [lkr5ye.asl](lkr5ye.asl) | 黑屏切段 |
| 洛克人 5 | [lkr5ye_alt.asl](lkr5ye_alt.asl) | 升天计时方式 |
| 洛克人 6 | [lkr6ye.asl](lkr6ye.asl) | 仅支持美版 |

> 洛克人 5 提供两版脚本：`lkr5ye.asl` 为黑屏淡出（fade）切段版；`lkr5ye_alt.asl` 为升天计时方式版，
> 二者按你的分段习惯选用其一即可。

## 声明

- 本仓库的自动切分脚本均为独立编写的原创作品。

## 支持的模拟器

以下为当前支持的模拟器：

- **Mesen 2.1.1**
- **Mesen 0.9.9**
- **MesenRTA（0.0.7）**
- **fceux-2.6.6-y320-Win64-汉化版（Emucheat）**

脚本会在载入时自动识别模拟器版本：

- Mesen 系列：通过比对 `MesenCore.dll` 的 SHA1 自动选择对应版本；
- FCEUX：按进程模块大小识别 64 位汉化版（Emucheat）。

## 使用方法

1. 打开 LiveSplit，右键计时器 → **Edit Layout…**；
2. 点击 **＋** 号，新增 **Scriptable Auto Splitter**（位于 Control 分类下）；
3. 双击该 **Scriptable Auto Splitter** 进入 **Layout Settings**；
4. 点击 **Browse…** 找到对应游戏的 `.asl` 文件并打开；
5. 设置完成后点 **OK** 即可。

脚本会自动识别模拟器版本，开始游戏后按关卡/BOSS 自动切分。

> 各脚本的完整使用方法可参考 **ye 此前的投稿**。

## LiveSplit 官方库配置方式（备选）

LiveSplit 会从公开的自动切段注册库（LiveSplit.AutoSplitters.xml）拉取已知游戏对应的 ASL 脚本地址，
启动后下载该列表，找到与 Game Name 匹配的条目便显示在 Split Editor 中。若你的游戏名能匹配到库中条目，可走此流程：

1. 打开 LiveSplit，右键 → **Edit Splits**；
2. Game Name 输入对应游戏名（非必须，仅用于匹配里的条目，例如 **"Mega Man 5"**）；
3. 在下方设置 **16 个分段**（必须）；
4. 点击 **Activate** 启用脚本，再点击 **Settings** 进入设置；
5. 点击 **Browse…** 找到本文件夹对应的 `.asl` 文件（如 `lkr5ye.asl`）打开；
6. 勾选 **Star Split**；在 **Options** 中勾选 **"Split on black screen after Mega Man vanishes in Dark 4"**（如需 Dark 4 切段）；
7. 设置完成，点 **OK**。

> 若有不清楚的地方，可参考 ye 的投稿原文：
> [https://www.bilibili.com/opus/1224952598747938821](https://www.bilibili.com/opus/1224952598747938821)

## 备注

- 各脚本顶部均有游戏/切分规则的 Info 说明；
- 若提示“Unrecognized Mesen version”或识别失败，请检查模拟器版本是否为上述支持的版本。
