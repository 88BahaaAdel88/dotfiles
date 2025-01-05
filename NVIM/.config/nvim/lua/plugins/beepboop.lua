return {
    "EggbertFluffle/beepboop.nvim",
    opts = {
        audio_player = "paplay",
        max_sounds = 20,
        sound_map = {
            { auto_command = "InsertCharPre",                sounds = { "stone1.ogg", "stone2.ogg", "stone3.ogg" } },
            { auto_command = "VimEnter",                     sound = "chestopen.ogg" },
            { auto_command = "VimLeave",                     sound = "close.ogg" },
            { auto_command = "BufModifiedSet",               sound = "wood5.ogg" },
            { key_map = { mode = "i", key_chord = "<Esc>" }, sound = "flatten1.ogg" },
            { key_map = { mode = "v", key_chord = "dd" },    sound = "flatten2.ogg" },
        }
    }
}
