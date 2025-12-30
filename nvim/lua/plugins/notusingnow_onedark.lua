return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({ style = "dark" }) -- try: "darker", "cool", "deep", "warm"
      require("onedark").load()
    end,
  },
}
