//Mega Man 3 Autosplitter by ye
//split on boss kill
//Emulators: Mesen2.1.1, Mesen0.9.9, MesenRTA, fceux-2.6.6-y320-Win64-汉化版 (Emucheat)

// ---- 状态定义（仅不同模拟器版本的基址不同，偏移一致）----

// Mesen 0.9.9
state("Mesen", "0.9.9")
{
	byte enemyhp       : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x4FF;
	byte secondenemyhp : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x4FE; // Gemini 用
	byte enemyid       : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x4DF; // 255 表示已消失
	byte secondenemyid : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x4DE;
	byte myhp          : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0xA2;  // 128 为阵亡（忽略高位）
	byte soundfx       : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x702; // 58 为传送
	byte stage         : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x22;
	byte screen        : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0xCB;  // 1 为开头画面
}

// MesenRTA 0.0.7
state("Mesen", "0.0.7")
{
	byte enemyhp       : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x4FF;
	byte secondenemyhp : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x4FE;
	byte enemyid       : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x4DF;
	byte secondenemyid : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x4DE;
	byte myhp          : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0xA2;
	byte soundfx       : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x702;
	byte stage         : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x22;
	byte screen        : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0xCB;
}

// Mesen 2.1.1
state("Mesen", "2.1.1")
{
	byte enemyhp       : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x4FF;
	byte secondenemyhp : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x4FE;
	byte enemyid       : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x4DF;
	byte secondenemyid : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x4DE;
	byte myhp          : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0xA2;
	byte soundfx       : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x702;
	byte stage         : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x22;
	byte screen        : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0xCB;
}

// fceux-2.6.6-y320-Win64-汉化版 (Emucheat)
state("fceux64", "2.6.6")
{
	byte enemyhp       : "fceux64.exe", 0x6c75d0, 0x4FF;
	byte secondenemyhp : "fceux64.exe", 0x6c75d0, 0x4FE;
	byte enemyid       : "fceux64.exe", 0x6c75d0, 0x4DF;
	byte secondenemyid : "fceux64.exe", 0x6c75d0, 0x4DE;
	byte myhp          : "fceux64.exe", 0x6c75d0, 0xA2;
	byte soundfx       : "fceux64.exe", 0x6c75d0, 0x702;
	byte stage         : "fceux64.exe", 0x6c75d0, 0x22;
	byte screen        : "fceux64.exe", 0x6c75d0, 0xCB;
}

startup
{
	settings.Add("optionsection", true, "---Options---");
	settings.Add("breakman", true, "Split after Break Man fight", "optionsection");

	settings.Add("infosection", true, "---Info---");
	settings.Add("info", true, "Mega Man 3 Autosplitter by ye", "infosection");
	settings.Add("info0", true, "- Emulators: Mesen2.1.1, Mesen0.9.9, MesenRTA, fceux-2.6.6-y320-Win64-汉化版 (Emucheat)", "infosection");
}

init
{
	refreshRate = 60;
	vars.waiting = false;    // 击破 BOSS 后等待声音提示
	vars.splitBoss = false;  // 当前目标是否为正式 BOSS

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
	if (current.screen == 3 && old.screen == 1)
		return true;
}

reset {
	if (current.screen == 1)
		return true;
}

update {
	// 回到开头画面 / 阵亡 / BOSS 触血时,取消等待状态
	if (current.screen == 1 || current.myhp == 128 || current.enemyhp == 31)
		vars.waiting = false;

	// 判定当前是否为正式 BOSS：由 (stage, enemyid) 组合决定
	vars.splitBoss =
		(current.enemyid == 35 && current.stage == 1)  || (current.enemyid == 39 && current.stage == 3) ||
		(current.enemyid == 45 && current.stage == 4)  || (current.enemyid == 45 && current.stage == 7) ||
		(current.enemyid == 30 && current.stage == 0)  || (current.enemyid == 74 && current.stage == 5) ||
		(current.enemyid == 40 && current.stage == 6)  || (current.enemyid == 53 && current.stage == 11)||
		(current.enemyid == 61 && current.stage == 9)  || (current.enemyid == 62 && current.stage == 8) ||
		(current.enemyid == 36 && current.stage == 10) || (current.enemyid == 35 && current.stage == 13)||
		(current.enemyid == 44 && current.stage == 14) || (current.enemyid == 4  && current.stage == 16);

	// 击破 BOSS（enemyhp==0）且尚未等待时,标记等待声音提示
	if (!vars.waiting && vars.splitBoss && current.myhp > 128 && current.enemyhp == 0 && old.soundfx != 58)
		vars.waiting = true;

	// Gemini Man(BOSS 消失后还有分身存活)特例
	if (!vars.waiting && current.enemyid == 60 && current.stage == 2 && current.myhp > 128 &&
	    ((current.enemyhp == 0 && current.secondenemyhp == 14) || (current.enemyhp == 14 && current.secondenemyhp == 0)))
		vars.waiting = true;

	// 乌龟列车(第二敌人消失)特例
	if (!vars.waiting && current.stage == 12 && old.secondenemyid == 33 && current.secondenemyid == 255 &&
	    current.myhp > 128 && old.soundfx != 58)
		vars.waiting = true;

	// Gamma(最终决战)特例
	if (!vars.waiting && current.stage == 17 && current.enemyid == 7 && old.enemyhp == 0 && current.enemyhp == 28)
		vars.waiting = true;
}

split
{
	// 前 8 个机器人：击杀后声音 42 -> 58 时切分
	if (vars.waiting && current.stage < 8 && old.soundfx == 42 && current.soundfx == 58) {
		vars.waiting = false;
		return true;
	}

	// 第 8 个机器人之后：击杀后声音 43 -> 58 时切分
	if (vars.waiting && current.stage >= 8 && old.soundfx == 43 && current.soundfx == 58) {
		vars.waiting = false;
		return true;
	}

	// Breakman 对决(或重战)后进入 stage 22 时切分
	if ((old.stage == 15 || (settings["breakman"] && old.stage == 3)) && current.stage == 22)
		return true;

	// 最终决战：Gamma 击破后切分
	if (vars.waiting && current.stage == 17 && current.enemyid == 7 && current.myhp > 128 && current.enemyhp == 0) {
		vars.waiting = false;
		return true;
	}
}
