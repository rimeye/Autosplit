//Mega Man 5 Autosplitter by ye (ascension timing)
//split on teleport (or Dark 4 fade if enabled)
//alternative to lkr5ye.asl (black-screen split)
//Emulators: Mesen2.1.1, Mesen0.9.9, MesenRTA, fceux-2.6.6-y320-Win64-汉化版 (Emucheat)

// ---- 状态定义（仅不同模拟器版本的基址不同，偏移一致）----

// Mesen 0.9.9
state("Mesen", "0.9.9")
{
	byte enemyhp       : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x458;
	byte enemyid       : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x440; // 255 为已消失
	byte myhp          : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0xB0;  // 128 为阵亡（忽略高位）
	byte soundfx       : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x702; // 68->66 为传送
	byte stage         : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x26;
	byte screenassets  : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x611; // 0 为开始画面
	byte otherscreenassets : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x18B;
	byte levelscreen   : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0xF9;
	byte controller    : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x16;  // 手柄 1 按键
}

// MesenRTA 0.0.7
state("Mesen", "0.0.7")
{
	byte enemyhp       : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x458;
	byte enemyid       : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x440;
	byte myhp          : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0xB0;
	byte soundfx       : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x702;
	byte stage         : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x26;
	byte screenassets  : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x611;
	byte otherscreenassets : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x18B;
	byte levelscreen   : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0xF9;
	byte controller    : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x16;
}

// Mesen 2.1.1
state("Mesen", "2.1.1")
{
	byte enemyhp       : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x458;
	byte enemyid       : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x440;
	byte myhp          : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0xB0;
	byte soundfx       : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x702;
	byte stage         : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x26;
	byte screenassets  : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x611;
	byte otherscreenassets : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x18B;
	byte levelscreen   : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0xF9;
	byte controller    : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x16;
}

// fceux-2.6.6-y320-Win64-汉化版 (Emucheat)
state("fceux64", "2.6.6")
{
	byte enemyhp       : "fceux64.exe", 0x6c75d0, 0x458;
	byte enemyid       : "fceux64.exe", 0x6c75d0, 0x440;
	byte myhp          : "fceux64.exe", 0x6c75d0, 0xB0;
	byte soundfx       : "fceux64.exe", 0x6c75d0, 0x702;
	byte stage         : "fceux64.exe", 0x6c75d0, 0x26;
	byte screenassets  : "fceux64.exe", 0x6c75d0, 0x611;
	byte otherscreenassets : "fceux64.exe", 0x6c75d0, 0x18B;
	byte levelscreen   : "fceux64.exe", 0x6c75d0, 0xF9;
	byte controller    : "fceux64.exe", 0x6c75d0, 0x16;
}

startup
{
	settings.Add("optionsection", true, "---选项---");
	settings.Add("darkfade", true, "在Dark 4首次淡出处切分", "optionsection");

	settings.Add("infosection", true, "---信息---");
	settings.Add("info", true, "《洛克人5》自动切分（升天计时方式）：默认在传送时切分，可在设置中开启Dark 4淡出切分", "infosection");
	settings.Add("info0", true, "- 支持模拟器：Mesen2.1.1、Mesen0.9.9、MesenRTA、fceux-2.6.6-y320-Win64-汉化版（Emucheat）", "infosection");
	settings.Add("info1", true, "- 另一种版本（黑屏切分）：lkr5ye.asl", "infosection");
}

init
{
	refreshRate = 60;

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
	if (old.screenassets == 0 && current.screenassets == 15 &&
	    old.otherscreenassets == 255 && current.otherscreenassets <= 4 && current.controller > 0)
		return true;
}

split
{
	// 传送音效 68 -> 66 时切分
	if (old.soundfx == 68 && current.soundfx == 66)
		return true;

	// Dark 4 结束后进入 stage 11 时按选项切分
	if (settings["darkfade"] && current.stage == 11 && old.levelscreen == 3 &&
	    current.levelscreen == 0 && current.myhp > 128)
		return true;

	// 最终 BOSS（Wily 胶囊）击破时切分
	if (current.stage == 15 && current.levelscreen == 7 && old.enemyid == 255 &&
	    old.enemyhp > 0 && current.enemyhp == 0 && current.myhp > 128)
		return true;
}
