//Mega Man 1 Autosplitter by ye
//split on boss kill / level clear
//Emulators: Mesen2.1.1, Mesen0.9.9, MesenRTA, fceux-2.6.6-y320-Win64-汉化版 (Emucheat)

// ---- 状态定义（仅不同模拟器版本的基址不同，偏移一致）----

// MesenRTA 0.0.7
state("Mesen", "0.0.7")
{
	byte bosshp  : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x6C1;
	byte myhp    : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x6A;
	byte stage   : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x31;
	byte orb     : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x501;
	byte timer   : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x3C;
	byte xpos    : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x22;
	byte bossid  : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0xAC;
}

// 常规 Mesen 0.9.9
state("Mesen", "0.9.9")
{
	byte bosshp  : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x6C1;
	byte myhp    : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x6A;
	byte stage   : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x31;
	byte orb     : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x501;
	byte timer   : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x3C;
	byte xpos    : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x22;
	byte bossid  : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0xAC;
}

// Mesen 2.1.1
state("Mesen", "2.1.1")
{
	byte bosshp  : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x6C1;
	byte myhp    : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x6A;
	byte stage   : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x31;
	byte orb     : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x501;
	byte timer   : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x3C;
	byte xpos    : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x22;
	byte bossid  : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0xAC;
}

// fceux-2.6.6-y320-Win64-汉化版 (Emucheat)
state("fceux64", "2.6.6")
{
	byte bosshp  : "fceux64.exe", 0x6c75d0, 0x6C1;
	byte myhp    : "fceux64.exe", 0x6c75d0, 0x6A;
	byte stage   : "fceux64.exe", 0x6c75d0, 0x31;
	byte orb     : "fceux64.exe", 0x6c75d0, 0x501;
	byte timer   : "fceux64.exe", 0x6c75d0, 0x3C;
	byte xpos    : "fceux64.exe", 0x6c75d0, 0x22;
	byte bossid  : "fceux64.exe", 0x6c75d0, 0xAC;
}

startup
{
	settings.Add("infosection", true, "---信息---");
	settings.Add("info", true, "《洛克人1》自动切分：击杀BOSS或通关时切分", "infosection");
	settings.Add("info0", true, "- 支持模拟器：Mesen2.1.1、Mesen0.9.9、MesenRTA、fceux-2.6.6-y320-Win64-汉化版（Emucheat）", "infosection");
}

init
{
	refreshRate = 60;

	// FCEUX：按模块大小识别 64 位汉化版
	if (modules.First().ModuleMemorySize == 0x934000)
		version = "2.6.6";

	// Mesen：比对 MesenCore.dll 的 SHA1 判定版本
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
	// 标题画面(10) -> 开场(Wily)动画时开始
	return current.stage == 10 && current.timer != 0;
}

reset {
	// 回到标题画面且无输入即为重置
	if (current.stage == 10 && current.timer == 0 && current.xpos == 0)
		return true;
}

split
{
	// 前 6 关：拿球(orb==158)即通过；
	// 后几关：BOSS 击杀(orb==172 或 158、bosshp 归零)；
	// 最终阶段(stage 9)：需 orb==172 且 bossid==10 才算击杀 Wily 核心。
	if ((current.stage < 6 && current.orb == 158 && old.orb != 158) ||
		(current.stage >= 6 && current.stage != 9 && (current.orb == 172 || current.orb == 158) &&
		 current.myhp > 0 && current.bosshp == 0 && old.bosshp > 0) ||
		(current.stage == 9 && current.orb == 172 && current.myhp > 0 &&
		 current.bosshp == 0 && old.bosshp > 0 && current.bossid == 10)) {
		return true;
	}
}
