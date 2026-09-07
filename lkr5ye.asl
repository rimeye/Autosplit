//Mega Man 5 Autosplitter by ye 2026-07-14
//added Mesen0.9.9 support

state("Mesen", "0.0.7")
{
	byte enemyhp : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x458;
	byte enemyid : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x440;
	byte myhp : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0xB0;
	byte soundfx : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x702;
	byte stage : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x26;
	byte screenassets : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x611;
	byte otherscreenassets : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x18B;
	byte levelscreen : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0xF9;
	byte controller : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x16;
	byte fade : "MesenCore.dll", 0x42F99D0, 0xB8, 0x58, 0x612;
}

//Mesen0.9.9
state("Mesen", "0.9.9")
{
	byte enemyhp : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x458;
	byte enemyid : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x440;
	byte myhp : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0xB0;
	byte soundfx : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x702;
	byte stage : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x26;
	byte screenassets : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x611;
	byte otherscreenassets : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x18B;
	byte levelscreen : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0xF9;
	byte controller : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x16;
	byte fade : "MesenCore.dll", 0x42E0F30, 0xB8, 0x58, 0x612;
}

state("Mesen", "2.1.1")
{
	byte enemyhp : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x458;
	byte enemyid : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x440;
	byte myhp : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0xB0;
	byte soundfx : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x702;
	byte stage : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x26;
	byte screenassets : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x611;
	byte otherscreenassets : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x18B;
	byte levelscreen : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0xF9;
	byte controller : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x16;
	byte fade : "MesenCore.dll", 0x046C95B8, 0x18, 0x40, 0x28, 0x612;
}

//fceux-2.6.6-y320-Win64-汉化版 (Emucheat)
state("fceux64", "2.6.6")
{
	byte enemyhp : "fceux64.exe", 0x6c75d0, 0x458;
	byte enemyid : "fceux64.exe", 0x6c75d0, 0x440;
	byte myhp : "fceux64.exe", 0x6c75d0, 0xB0;
	byte soundfx : "fceux64.exe", 0x6c75d0, 0x702;
	byte stage : "fceux64.exe", 0x6c75d0, 0x26;
	byte screenassets : "fceux64.exe", 0x6c75d0, 0x611;
	byte otherscreenassets : "fceux64.exe", 0x6c75d0, 0x18B;
	byte levelscreen : "fceux64.exe", 0x6c75d0, 0xF9;
	byte controller : "fceux64.exe", 0x6c75d0, 0x16;
	byte fade : "fceux64.exe", 0x6c75d0, 0x612;
}

startup
{
	settings.Add("optionsection", true, "---选项---");
	settings.Add("darkfade", true, "在洛克人于Dark 4消失后的黑屏处切分", "optionsection");

	settings.Add("infosection", true, "---信息---");
	settings.Add("info", true, "《洛克人5》自动切分（黑屏淡出版）：在关卡切换的黑屏时切分，可在设置中开启Dark 4淡出切分", "infosection");
	settings.Add("info0", true, "- 支持模拟器：Mesen2.1.1、Mesen0.9.9、MesenRTA、fceux-2.6.6-y320-Win64-汉化版（Emucheat）", "infosection");
	settings.Add("info1", true, "- Bilibili：https://space.bilibili.com/388291446", "infosection");
}

init
{
	refreshRate = 60;
	vars.waitingForBlack = false;
	vars.waitingForDark4 = false;

	if (modules.First().ModuleMemorySize == 0x934000)
		version = "2.6.6";

	if(game.ProcessName == "Mesen")
	{
		var coreDLL = Array.Find(modules, x => x.ModuleName == "MesenCore.dll");
		if (coreDLL == null)
			throw new Exception("Couldn't find MesenCore.dll");

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
				version = "";
				break;
		}
	}
}

start {
	if (old.screenassets == 0 && current.screenassets == 15 && old.otherscreenassets == 255 && current.otherscreenassets <= 4 && current.controller > 0)
		return true;
}

update {
	if (current.soundfx == 68) vars.waitingForBlack = true;
	if (current.stage == 11 && old.levelscreen == 3 && current.levelscreen == 0) vars.waitingForDark4 = true;
}

split
{
	if (settings["darkfade"] && vars.waitingForDark4 && current.stage == 16 && current.fade == 15) {
		vars.waitingForDark4 = false;
		return true;
	}

	if (current.stage == 15 && current.levelscreen == 7 && old.enemyid == 255 && old.enemyhp > 0 && current.enemyhp == 0 && current.myhp > 128)
		return true;

	if (vars.waitingForBlack && old.stage != 16 && current.stage == 16 && old.stage != 11 && old.stage != 15) {
		vars.waitingForBlack = false;
		return true;
	}
}
