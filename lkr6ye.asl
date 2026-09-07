//Mega Man 6 Autosplitter by ye (US version only)
//split on boss kill (or on teleport if enabled)
//Emulators: Mesen2.1.1, Mesen0.9.9, MesenRTA, fceux-2.6.6-y320-Win64-汉化版 (Emucheat)

// ---- 状态定义（仅不同模拟器版本的基址不同，偏移一致）----

// Mesen 0.9.9
state("Mesen", "0.9.9")
{
	byte myhp          : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x3E5;
	byte bosshp        : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x3ED;
	byte stage         : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x51;
	byte currentscreen : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x92;
	byte mymenuselection : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x5B1;
	byte soundfx       : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x702;
}

// MesenRTA 0.0.7
state("Mesen", "0.0.7")
{
	byte myhp          : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x3E5;
	byte bosshp        : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x3ED;
	byte stage         : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x51;
	byte currentscreen : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x92;
	byte mymenuselection : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x5B1;
	byte soundfx       : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x702;
}

// Mesen 2.1.1
state("Mesen", "2.1.1")
{
	byte myhp          : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x3E5;
	byte bosshp        : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x3ED;
	byte stage         : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x51;
	byte currentscreen : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x92;
	byte mymenuselection : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x5B1;
	byte soundfx       : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x702;
}

// fceux-2.6.6-y320-Win64-汉化版 (Emucheat)
state("fceux64", "2.6.6")
{
	byte myhp          : "fceux64.exe", 0x6c75d0, 0x3E5;
	byte bosshp        : "fceux64.exe", 0x6c75d0, 0x3ED;
	byte stage         : "fceux64.exe", 0x6c75d0, 0x51;
	byte currentscreen : "fceux64.exe", 0x6c75d0, 0x92;
	byte mymenuselection : "fceux64.exe", 0x6c75d0, 0x5B1;
	byte soundfx       : "fceux64.exe", 0x6c75d0, 0x702;
}

startup
{
	settings.Add("optionsection", true, "---选项---");
	settings.Add("onteleport", true, "改为在传送后切分（而非击杀BOSS时）", "optionsection");

	settings.Add("infosection", true, "---信息---");
	settings.Add("info", true, "《洛克人6》自动切分（仅支持美版）：默认击杀BOSS切分，可在设置中改为传送后切分", "infosection");
	settings.Add("info0", true, "- 支持模拟器：Mesen2.1.1、Mesen0.9.9、MesenRTA、fceux-2.6.6-y320-Win64-汉化版（Emucheat）", "infosection");
}

init
{
	refreshRate = 60;
	vars.bossFight = 0;  // 是否处于 BOSS 战
	vars.bossRush  = 0;  // 最终 BOSS 已击杀的阶段数（Wily 共 3 阶段）
	vars.knewDead  = 0;  // 是否刚阵亡
	vars.frames    = 0;  // 阵亡后的宽限帧计数

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
	if (current.mymenuselection == 0 && current.currentscreen == 163 && current.soundfx == 63) {
		vars.bossFight = 0;
		vars.bossRush  = 0;
		vars.knewDead  = 0;
		vars.frames    = 0;
		return true;
	}
}

split
{
	if (!settings["onteleport"]) // 切分时机一：击杀 BOSS
	{
		// 处理同归于尽（DKO）与读回状态
		if (current.myhp > 127 && current.bosshp != 255 && vars.knewDead == 0 && vars.frames <= 8) {
			vars.frames++;
		} else if (current.myhp > 127 && current.bosshp != 255 && vars.knewDead == 0 && vars.frames > 8) {
			vars.bossFight = 0;
			vars.knewDead  = 1;
			vars.frames    = 0;
			if (current.stage == 15)
				vars.bossRush = 0;
		} else if (current.myhp <= 27) {
			vars.knewDead = 0;
		}

		// 普通关卡：击杀 BOSS（bosshp 28->27 进入战斗，归 255 判定击杀）
		if (current.stage < 14) {
			if (vars.bossFight == 0) {
				if (current.bosshp == 27 && old.bosshp == 26)
					vars.bossFight = 1;
			} else {
				if (current.bosshp == 255) {
					vars.bossFight = 0;
					vars.frames    = 0;
					return true;
				}
			}
		}
	}
	else // 切分时机二：传送后
	{
		if (current.stage > 7 && current.stage != 14 && old.soundfx == 68 && current.soundfx == 66)
			return true;
		if (current.stage <= 7 && old.soundfx == 65 && current.soundfx == 68)
			return true;
	}

	// 最终 BOSS（Wily 机器，stage 15）共 3 阶段,始终按击杀切分
	if (current.stage == 15)
	{
		if (settings["onteleport"] && current.myhp > 127 && vars.bossFight == 1) {
			vars.bossFight = 0;
			vars.bossRush  = 0;
		}
		if (vars.bossFight == 0) {
			// BOSS 血量 22->21 进入阶段；或从 255 进入下一阶段
			if ((current.bosshp == 22 && old.bosshp == 21) ||
			    (vars.bossRush == 2 && current.bosshp == 0 && old.bosshp == 255))
				vars.bossFight = 1;
		} else {
			if (current.bosshp == 255) {
				vars.bossFight = 0;
				vars.frames    = 0;
				vars.bossRush++;
			}
		}
		if (vars.bossRush == 3) {
			vars.bossRush = 0;
			return true;
		}
	}

	// 传送模式下：Mr X 4 结束进入 stage 12 时切分
	if (settings["onteleport"] && old.stage == 11 && current.stage == 12)
		return true;

	// 重战后进入最终关(stage 15)时始终切分
	if (old.stage == 14 && current.stage == 15)
		return true;
	return;
}
