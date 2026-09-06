//Mega Man 4 Autosplitter by ye
//split on teleport (or Cossack 4 fade if enabled)
//Emulators: Mesen2.1.1, Mesen0.9.9, MesenRTA, fceux-2.6.6-y320-Win64-汉化版 (Emucheat)

// ---- 状态定义（仅不同模拟器版本的基址不同，偏移一致）----

// Mesen 0.9.9
state("Mesen", "0.9.9")
{
	byte enemyhp    : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x467;
	byte enemyid    : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x44F; // 255 为已消失
	byte myhp       : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0xB0;  // 128 为阵亡（忽略高位）
	byte soundfx    : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x702; // 65 为传送
	byte stage      : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x22;
	byte screen     : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0xCB;  // 1 为开头画面
	byte selection  : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x200; // 151 为 Game Start
	byte levelscreen: "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0xF9;  // 关卡内实际画面号
}

// MesenRTA 0.0.7
state("Mesen", "0.0.7")
{
	byte enemyhp    : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x467;
	byte enemyid    : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x44F;
	byte myhp       : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0xB0;
	byte soundfx    : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x702;
	byte stage      : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x22;
	byte screen     : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0xCB;
	byte selection  : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x200;
	byte levelscreen: "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0xF9;
}

// Mesen 2.1.1
state("Mesen", "2.1.1")
{
	byte enemyhp    : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x467;
	byte enemyid    : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x44F;
	byte myhp       : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0xB0;
	byte soundfx    : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x702;
	byte stage      : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x22;
	byte screen     : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0xCB;
	byte selection  : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x200;
	byte levelscreen: "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0xF9;
}

// fceux-2.6.6-y320-Win64-汉化版 (Emucheat)
state("fceux64", "2.6.6")
{
	byte enemyhp    : "fceux64.exe", 0x6c75d0, 0x467;
	byte enemyid    : "fceux64.exe", 0x6c75d0, 0x44F;
	byte myhp       : "fceux64.exe", 0x6c75d0, 0xB0;
	byte soundfx    : "fceux64.exe", 0x6c75d0, 0x702;
	byte stage      : "fceux64.exe", 0x6c75d0, 0x22;
	byte screen     : "fceux64.exe", 0x6c75d0, 0xCB;
	byte selection  : "fceux64.exe", 0x6c75d0, 0x200;
	byte levelscreen: "fceux64.exe", 0x6c75d0, 0xF9;
}

startup
{
	settings.Add("optionsection", true, "---Options---");
	settings.Add("cossackfade", true, "Split on Cossack 4 fade", "optionsection");

	settings.Add("infosection", true, "---Info---");
	settings.Add("info", true, "Mega Man 4 Autosplitter by ye", "infosection");
	settings.Add("info0", true, "- Emulators: Mesen2.1.1, Mesen0.9.9, MesenRTA, fceux-2.6.6-y320-Win64-汉化版 (Emucheat)", "infosection");
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
	// 开始画面、选中 Game Start、响起 BGM(6) 时开始
	if (current.screen == 2 && current.selection == 151 && current.soundfx == 6 && old.soundfx != 6)
		return true;
}

reset {
	if (current.stage == 16 && current.screen == 0 && current.soundfx == 0 && current.enemyid == 0)
		return true;
}

split
{
	// 传送音效 67 -> 65 时切分（清除 Cossack 关卡结束画面时除外）
	if (old.soundfx == 67 && current.soundfx == 65 && !(current.levelscreen == 10 && current.stage == 3))
		return true;

	// Cossack 4 结束后进入 stage 18 时按选项切分
	if (settings["cossackfade"] && old.stage == 11 && current.stage == 18 && current.soundfx == 0)
		return true;

	// 最终 BOSS（Wily 胶囊）击破时切分
	if (current.stage == 15 && old.enemyid == 6 && current.enemyid == 255 &&
	    current.enemyhp == 0 && old.enemyhp > 0 && current.myhp > 128)
		return true;
}
