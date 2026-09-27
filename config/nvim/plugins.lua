-- Plugins and language servers are installed by Home Manager.
vim.cmd.colorscheme("tokyonight-night")
local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
	}, { { name = "buffer" } }),
})
vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
})
vim.lsp.enable({
	"lua_ls",
	"nixd",
	"pyright",
	"gopls",
	"rust_analyzer",
	"phpactor",
	"jdtls",
	"ts_ls",
	"html",
	"cssls",
	"jsonls",
	"taplo",
})
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local function map(key, action, desc)
			vim.keymap.set("n", key, action, { buffer = event.buf, desc = desc })
		end
		map("gd", vim.lsp.buf.definition, "Go to definition")
		map("gr", vim.lsp.buf.references, "References")
		map("gI", vim.lsp.buf.implementation, "Implementation")
		map("K", vim.lsp.buf.hover, "Documentation")
		map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action")
	end,
})
require("telescope").setup({
	defaults = {
		layout_strategy = "horizontal",
		sorting_strategy = "ascending",
		prompt_prefix = " > ",
		selection_caret = " > ",
	},
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search text" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
-- Use bundled parsers; no downloads or compilation at editor startup.
vim.api.nvim_create_autocmd("FileType", {
	callback = function(event)
		pcall(vim.treesitter.start, event.buf)
	end,
})
