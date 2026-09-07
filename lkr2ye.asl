//Mega Man 2 Autosplitter by ye
//split on boss kill (or on teleport if enabled)
//Emulators: Mesen2.1.1, Mesen0.9.9, MesenRTA, fceux-2.6.6-y320-Win64-汉化版 (Emucheat)

// ---- 状态定义（仅不同模拟器版本的基址不同，偏移一致）----

// Mesen 0.9.9
state("Mesen", "0.9.9")
{
	byte bosshp       : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x6C1;
	byte myhp         : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x6C0;
	byte mylives      : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0xA8;
	byte mytitlescreen: "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x04B0;
	byte mycontroller : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x25;
	byte soundfx      : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0xE2; // 0xF1->0x35 为击杀后传送
	byte stage        : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x2A; // 12 为 BOSS 连战，13 为最终外星人
}

// MesenRTA 0.0.7
state("Mesen", "0.0.7")
{
	byte bosshp       : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x6C1;
	byte myhp         : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x6C0;
	byte mylives      : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0xA8;
	byte mytitlescreen: "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x04B0;
	byte mycontroller : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x25;
	byte soundfx      : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0xE2;
	byte stage        : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x2A;
}

// Mesen 2.1.1
state("Mesen", "2.1.1")
{
	byte bosshp       : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x6C1;
	byte myhp         : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x6C0;
	byte mylives      : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0xA8;
	byte mytitlescreen: "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x04B0;
	byte mycontroller : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x25;
	byte soundfx      : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0xE2;
	byte stage        : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x2A;
}

// fceux-2.6.6-y320-Win64-汉化版 (Emucheat)
state("fceux64", "2.6.6")
{
	byte bosshp       : "fceux64.exe", 0x6c75d0, 0x6C1;
	byte myhp         : "fceux64.exe", 0x6c75d0, 0x6C0;
	byte mylives      : "fceux64.exe", 0x6c75d0, 0xA8;
	byte mytitlescreen: "fceux64.exe", 0x6c75d0, 0x04B0;
	byte mycontroller : "fceux64.exe", 0x6c75d0, 0x25;
	byte soundfx      : "fceux64.exe", 0x6c75d0, 0xE2;
	byte stage        : "fceux64.exe", 0x6c75d0, 0x2A;
}

startup
{
	settings.Add("optionsection", true, "---选项---");
	settings.Add("onteleport", true, "改为在传送后切分（而非击杀BOSS时）", "optionsection");

	settings.Add("infosection", true, "---信息---");
	settings.Add("info", true, "《洛克人2》自动切分：默认击杀BOSS切分，可在设置中改为传送后切分", "infosection");
	settings.Add("info0", true, "- 支持模拟器：Mesen2.1.1、Mesen0.9.9、MesenRTA、fceux-2.6.6-y320-Win64-汉化版（Emucheat）", "infosection");
}

init
{
	refreshRate = 60;
	vars.bossFight  = 0;  // 当前是否处于 BOSS 战
	vars.bossRush   = 0;  // BOSS 连战中已击杀的 BOSS 数
	vars.splitCount = 0;  // 普通关卡已切分（击杀 BOSS）数
	vars.knewDead   = 0;  // 是否刚阵亡（用于读回状态）
	vars.frames     = 0;  // 阵亡后的宽限帧计数
	vars.rushDone   = 0;  // BOSS 连战是否全部完成

	if (modules.First().ModuleMemorySize == 0x934000)
		version = "2.6.6";

	if (game.ProcessName == "Mesen")
	{
		var coreDLL = Array.Find(modules, x => x.ModuleName == "MesenCore.dll");
		if (coreDLL == null)
			throw new Exception("找不到 MesenCore.dll");

		string hashStr;
		using (var sha1 = System.Security.Cryptography.SHA1.Create())
			using (var fs = File.OpenRead(coreDLL.FileName))
				hashStr = string.Concat(sha1.ComputeHash(fs).Select(b => b.ToString("X2")));

		switch (hashStr)
		{
			case "3D5571326AAF55B17663EE0D6C828D4D0782941A":
				version = "0.9.9";
				break;
			case "12BFF659191984F011E0F4FC5AC2900C929D5991":
				version = "0.0.7";
				break;
			case "2B03F4392B9EC26F2CAE02201A7EF23B6BFF8C30":
				version = "2.1.1";
				break;
			default:
				print("无法识别的 Mesen 版本！SHA1 = " + hashStr);
				version = "";
				break;
		}
	}
}

start {
	// 在标题画面按下开始键（控制器 8 = 开始）时开跑
	if (((old.mytitlescreen == 119 && current.mytitlescreen == 119) ||
	     (old.mytitlescreen == 103 && current.mytitlescreen == 103)) &&
	    old.mycontroller == 0 && current.mycontroller == 8) {
		vars.bossFight  = 0;
		vars.bossRush   = 0;
		vars.splitCount = 0;
		vars.knewDead   = 0;
		vars.frames     = 0;
		vars.rushDone   = 0;
		return true;
	}
}

split
{
	// 切分时机一：击杀 BOSS（默认）
	if (!settings["onteleport"])
	{
		// 处理同归于尽（DKO）：阵亡后给 8 帧宽限再判定
		if (current.myhp == 0 && current.bosshp != 0 && vars.bossFight == 1 && vars.knewDead == 0 && vars.frames <= 8) {
			vars.frames++;
		} else if (current.myhp == 0 && current.bosshp != 0 && vars.bossFight == 1 && vars.knewDead == 0 && vars.frames > 8) {
			vars.bossFight = 0;
			vars.knewDead  = 1;
			vars.frames    = 0;
			if (vars.bossRush == 9)
				vars.bossRush = 8;
			if (current.mylives == 1)
				vars.bossRush = 0;
		} else if (current.mylives < old.mylives && vars.bossFight == 1) {
			vars.bossFight = 0;
			vars.knewDead  = 1;
			vars.frames    = 0;
		} else if (current.myhp > 0 && vars.knewDead == 1) {
			vars.knewDead = 0;
		}

		if (current.stage < 12)
		{
			if (vars.bossFight == 0) {
				if (current.bosshp == 28 && old.bosshp == 27) {
					vars.bossFight = 1;
				}
			} else {
				if (current.bosshp == 0) {
					vars.bossFight = 0;
					vars.frames    = 0;
					vars.splitCount++;
					return true;
				}
			}
		}
		else if (current.stage == 12)
		{
			if (vars.bossFight == 0) {
				if (current.bosshp == 28 && old.bosshp == 27)
					vars.bossFight = 1;
			} else {
				if (current.bosshp == 0) {
					vars.bossFight = 0;
					vars.frames    = 0;
					vars.bossRush++;
				}
			}
			if (vars.bossRush == 10 && vars.rushDone == 0) {
				vars.rushDone = 1;
				return true;
			}
		}
		else if (current.stage == 13)
		{
			if (vars.bossFight == 0) {
				if (current.bosshp == 28 && old.bosshp == 27)
					vars.bossFight = 1;
			} else {
				if (current.bosshp == 0) {
					vars.bossFight = 0;
					return true;
				}
			}
		}
	}
	else // 切分时机二：传送后
	{
		if (old.soundfx == 0xF1 && current.soundfx == 0x35)
			return true;
		if (old.stage == 12 && current.stage == 13)
			return true;

		if (current.stage == 13)
		{
			if (current.myhp == 0 && current.bosshp != 0 && vars.bossFight == 1 && vars.frames <= 8) {
				vars.frames++;
			} else if (current.myhp == 0 && current.bosshp != 0 && vars.bossFight == 1 && vars.frames > 8) {
				vars.bossFight = 0;
			}
			if (vars.bossFight == 0) {
				if (current.bosshp == 28 && old.bosshp == 27)
					vars.bossFight = 1;
			} else {
				if (current.bosshp == 0) {
					vars.bossFight = 0;
					return true;
				}
			}
		}
	}
	return;
}
