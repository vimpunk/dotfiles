-- disable default lightspeed mappings
lvim.keys.normal_mode["s"] = "s"
lvim.keys.normal_mode["S"] = "S"
lvim.keys.visual_mode["s"] = "s"
lvim.keys.visual_mode["S"] = "S"

lvim.builtin.which_key.mappings["j"] = { "<Plug>Lightspeed_s", "Lightjump" }
lvim.builtin.which_key.mappings["J"] = { "<Plug>Lightspeed_S", "Lightjump" }
