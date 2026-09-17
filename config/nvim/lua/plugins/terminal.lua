return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup()

      -- Scorciatoie personalizzate
      vim.keymap.set("n", "<leader>to", "<cmd>ToggleTerm<cr>", { desc = "Terminale orizzontale" })
      vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Terminale verticale" })
      vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Terminale flottante" })
    end,
  },
}
